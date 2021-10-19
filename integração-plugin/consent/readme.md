# API Consent

- [API Consent](#api-consent)
  - [Discovery de recursos no Opus Open Banking](#discovery-de-recursos-no-opus-open-banking)
    - [Momentos de discovery](#momentos-de-discovery)
    - [Consentimento e os produtos](#consentimento-e-os-produtos)
    - [Tratamento dos identificadores](#tratamento-dos-identificadores)
    - [Conectores de discovery](#conectores-de-discovery)
      - [Conector de produto selecionável](#conector-de-produto-selecionável)
      - [Conector de produto não selecionável](#conector-de-produto-não-selecionável)
    - [Tratamentos adicionais](#tratamentos-adicionais)
      - [Filtro de contas](#filtro-de-contas)
  - [Aprovação de criação de consentimento](#aprovação-de-criação-de-consentimento)

## Discovery de recursos no Opus Open Banking

O discovery de recursos no Opus Open Banking é um dos pontos de integração entre
o Opus Open Banking e os sistemas de legado da instituição, e é a integração
responsável pela descoberta dos produtos vinculados a um consentimento. O
discovery de recursos acontece em dois momentos distintos dentro do Open Banking.

### Momentos de discovery

O primeiro momento de discovery ocorre durante a fase de aceitação do
consentimento pelo cliente da instituição. Consentimentos de compartilhamento de
dados que envolvem os produtos **conta** e **cartão de crédito** e
consentimentos de pagamento precisam exibir as instâncias dos produtos durante
a etapa de autenticação e aceitação do consentimento para serem escolhidos
ativamente pelo cliente. Chamamos esses produtos de **produtos selecionáveis**.

O segundo momento de discovery ocorre durante a utilização do consentimento de
compartilhamento de dados, quando o *TPP* chama a API regulatória
[```GET /resources/v1/resources```](https://openbanking-brasil.github.io/areadesenvolvedor/#fase-2-apis-do-open-banking-brasil-api-resources).
Essa API precisa retornar todos os recursos acessíveis no consentimento, ou
seja, os produtos selecionados ativamente pelo cliente durante a aceitação do
consentimento e os demais produtos do consentimento. Chamamos esses últimos
produtos de **produtos não selecionáveis**.

A tabela a seguir compila todos os produtos tratados pelo Opus Open Banking e
seus tipos:

| Tipo do consentimento     | Produto                      | Tipo do produto  | Nome da rota Camel                               |
| ------------------------- | ---------------------------- | ---------------- | ------------------------------------------------ |
| Compartilhamento de dados | ACCOUNT                      | Selecionável     | ```direct:discoverAccounts```                    |
| Compartilhamento de dados | CREDIT_CARD_ACCOUNT          | Selecionável     | ```direct:discoverCreditCardAccounts```          |
| Compartilhamento de dados | INVOICE_FINANCING            | Não selecionável | ```direct:discoverInvoiceFinancings```           |
| Compartilhamento de dados | FINANCING                    | Não selecionável | ```direct:discoverFinancings```                  |
| Compartilhamento de dados | LOAN                         | Não selecionável | ```direct:discoverLoans```                       |
| Compartilhamento de dados | UNARRANGED_ACCOUNT_OVERDRAFT | Não selecionável | ```direct:discoverUnarrangedAccountOverdrafts``` |
| Pagamento                 | PAYMENT[^1]                  | Selecionável     | ```direct:discoverPayments```                    |

[^1]: O produto **PAYMENT** é uma forma de permitir que a seleção da origem de recursos para um pagamento seja independente do produto ACCOUNT, permitindo pagamentos através de cartão de crédito ou outra origem distinta que a instituição eventualmente possua.

### Consentimento e os produtos

Vimos no tópico anterior os momentos possíveis de discovery e a relação entre os
momentos e os produtos. Outro ponto importante é a relação entre as permissões
solicitadas no consentimento e os produtos. É essa relação que diz quais
discoveries que irão acontecer para um determinado consentimento.

| Tipo do consentimento     | Permissões                                                                                                                                                                               | Produto                      |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| Compartilhamento de dados | ACCOUNTS_READ, ACCOUNTS_BALANCES_READ, ACCOUNTS_TRANSACTIONS_READ, ACCOUNTS_OVERDRAFT_LIMITS_READ                                                                                        | ACCOUNT                      |
| Compartilhamento de dados | CREDIT_CARDS_ACCOUNTS_READ, CREDIT_CARDS_ACCOUNTS_BILLS_READ, CREDIT_CARDS_ACCOUNTS_BILLS_TRANSACTIONS_READ, CREDIT_CARDS_ACCOUNTS_LIMITS_READ, CREDIT_CARDS_ACCOUNTS_TRANSACTIONS_READ  | CREDIT_CARD_ACCOUNT          |
| Compartilhamento de dados | INVOICE_FINANCINGS_READ, INVOICE_FINANCINGS_SCHEDULED_INSTALMENTS_READ, INVOICE_FINANCINGS_PAYMENTS_READ, INVOICE_FINANCINGS_WARRANTIES_READ                                             | INVOICE_FINANCING            |
| Compartilhamento de dados | FINANCINGS_READ, FINANCINGS_SCHEDULED_INSTALMENTS_READ, FINANCINGS_PAYMENTS_READ, FINANCINGS_WARRANTIES_READ                                                                             | FINANCING                    |
| Compartilhamento de dados | LOANS_READ, LOANS_SCHEDULED_INSTALMENTS_READ, LOANS_PAYMENTS_READ, LOANS_WARRANTIES_READ                                                                                                 | LOAN                         |
| Compartilhamento de dados | UNARRANGED_ACCOUNTS_OVERDRAFT_READ, UNARRANGED_ACCOUNTS_OVERDRAFT_SCHEDULED_INSTALMENTS_READ, UNARRANGED_ACCOUNTS_OVERDRAFT_PAYMENTS_READ, UNARRANGED_ACCOUNTS_OVERDRAFT_WARRANTIES_READ | UNARRANGED_ACCOUNT_OVERDRAFT |
| Pagamento                 | N/A                                                                                                                                                                                      | PAYMENT                      |

Um consentimento de compartilhamento com as todas as permissões realizará o
discovery dos produtos ACCOUNT e CREDIT_CARD durante a etapa de confirmação do
consentimento e dos produtos INVOICE_FINANCING, FINANCING, LOAN e
UNARRANGED_ACCOUNT_OVERDRAFT quando ocorrer uma chamada no
```GET /resources/v1/resources```. O discovery é sempre efetuado de forma
paralela para minimizar o tempo de resposta das APIs.

### Tratamento dos identificadores

Um ponto importante no Open Banking é a
[formação e estabilidade do ID](https://openbanking-brasil.github.io/areadesenvolvedor/#formacao-e-estabilidade-do-id)
que exige que os identificadores trafegados no ecossistema do Open Banking sejam
desvinculados de significado.

A solução do Opus Open Banking garante a anonimização e unicidade dos
identificadores no Open Banking realizando a conversão entre os identificadores
nos sistemas de origem e os identificadores Open Banking.

As identificações dos produtos nos diversos sistemas de origem podem ser
variadas, as vezes utilizando inclusive chaves compostas. As interfaces do Opus
Open Banking utilizam uma estrutura de array de chaves (key) e valores (value)
quando referenciam um identificador de legado. É sobre essa estrutura que a
geração do identificador Open Banking é gerada.

### Conectores de discovery

Os conectores de discovery de fato são implementados em Apache Camel igual aos
demais conectores de integração entre o Opus Open Banking e os sistemas legados
do banco.

A interface do conector deve respeitar um dos dois modelos de produtos:
selecionável e não-selecionável

#### Conector de produto selecionável

Os produtos selecionáveis devem ter seus conectores respeitando os seguintes schemas:

| Tipo     | JSON Schema                                                                                                         |
| -------- | ------------------------------------------------------------------------------------------------------------------- |
| Request  | [discovery-resource-request.json](../schemas/v1/discovery/discovery-resource-request.json)                          |
| Response | [discovery-selectable-resource-response.json](../schemas/v1/discovery//discovery-selectable-resource-response.json) |

Exemplo de response para um produto selecionável:

```json
{
  "resources":[
    {
      "resourceName":[
        {
          "key":"Agencia",
          "value":"1234"
        },
        {
          "key":"Conta Corrente",
          "value":"12345-6",
        }
      ],
      "resourceLegacyId":[
        {
          "key":"pkAgencia",
          "value":"1234"
        },
        {
          "key":"pkContaCorrente",
          "value":"123456"
        }
      ],
      "resourceBalanceCurrency":"BRL",
      "resourceBalanceAmount":239.12,
      "authorizers":[
        {
          "cpf":"06672639004",
          "name":"João da Silva"
        },
        {
          "cpf":"05473670075",
          "name":"Maria da Silva"
        }
      ],
      "defaultSelected":true
    }
  ]
}
```

#### Conector de produto não selecionável

Os produtos não selecionáveis devem ter seus conectores respeitando os seguintes
schemas:

| Tipo     | JSON Schema                                                                                                              |
| -------- | ------------------------------------------------------------------------------------------------------------------------ |
| Request  | [discovery-resource-request.json](../schemas/v1/discovery/discovery-resource-request.json)                               |
| Response | [discovery-nonselectable-resource-response.json](../schemas/v1/discovery/discovery-nonselectable-resource-response.json) |

*[DRAFT: O schema do consentimento dentro do request
está em revisão]*

Exemplo de response para um produto selecionável:

```json
{
  "resources":[
    {
      "resourceLegacyId":[
        {
          "key":"pkEmprestimo",
          "value":"ABC12010"
        }
      ],
      "validUntil":"2022-06-07"
    },
    {
      "resourceLegacyId":[
        {
          "key":"pkEmprestimo",
          "value":"DEF51242"
        }
      ]
    }
  ]
}
```

### Tratamentos adicionais

#### Filtro de contas

Em algumas situações a conta utilizada para uma operação financeira é
definida pelo cliente antes da seleção de contas, na aplicação iniciadora do
pagamento. Nestes cenários o objeto debtorAccount estará preenchido no
consentimento e a lista retornada deve ser filtrada para retornar somente a
conta pré-selecionada ou uma lista vazia caso essa não seja uma opção selecionável
para o cliente. Esse tratamento deve ser feito no conector ou serviço remoto de listagem
de contas.

## Aprovação de criação de consentimento

Quando a API de criação de um consentimento é chamada por um *TPP*, a plataforma
OOB deve avaliar se este consentimento pode ou não ser criado. As validações técnicas
(formato de mensagem, limites de chamadas) e de segurança (validade das credenciais,
permissões de acesso) são feitas dentro da própria plataforma. As validações de
negócio, entretanto, são delegadas para um sistema de retaguarda da instituição
detentora da conta através de um conector.

Dentre as validações que podem ser feitas pela instituição estão:

- Verificar se o usuário logado no TPP é um cliente conhecido e ativo;
- Verificar se o tipo de operação é aceito pela instituição;
- Verificar se os valores selecionados estão de acordo com os limites definidos
  pela instituição;
- Verificar se a operação está de acordo com as políticas antifraude.

Outra função dessa integração é controlar a liberação do acesso ao Open Banking
para os clientes de forma escalonada. Dessa forma os sistemas internos da instituição
podem definir se a operação pode ser realizada levando em conta:

- Se o cliente foi selecionado para acessar a operação, enquanto o acesso ainda
  está restrito a uma porcentagem pré-selecionada;
- Se a operação está sendo realizada dendro dos horários pré-estabelecidos;
- Se os valores estão dentro dos limites pré-estabelecidos;
- Se a operação selecionada pode ser realizada através da interface de Open Banking;

A tabela a seguir lista os pontos de integração para a aceitação da criação de
um consentimento:

| Tipo do consentimento | Nome da rota Camel                         |
| --------------------- | ------------------------------------------ |
| Pagamento             | ```direct:approvePaymentConsentCreation``` |

O retorno desses pontos de integração devem ser:

- Uma mensagem de sucesso (geralmente um objeto vazio) quando o consentimento
  puder ser criado;
- Uma mensagem de erro de negócio, descrita no schema de integração com um enum
  específico no campo *code*, definindo o motivo pelo qual o consentimento foi negado;
- Uma mensagem de erro genérica, definida pelo schema
  [response-error-schema.json](../schemas/v2/common/response-error-schema.json)
  quando um erro técnico impedir que a solicitação possa ser avaliada, como um
  erro de rede ou um sistema inoperante.
