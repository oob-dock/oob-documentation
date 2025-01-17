# API Consent

- [API Consent](#api-consent)
  - [Discovery de recursos no Opus Open Banking](#discovery-de-recursos-no-opus-open-banking)
    - [Momentos de discovery](#momentos-de-discovery)
      - [Produtos selecionáveis](#produtos-selecionáveis)
      - [Produtos não selecionáveis](#produtos-não-selecionáveis)
    - [Consentimento e os produtos](#consentimento-e-os-produtos)
    - [Tratamento dos identificadores](#tratamento-dos-identificadores)
    - [Conectores de discovery](#conectores-de-discovery)
      - [Conector de produto selecionável](#conector-de-produto-selecionável)
      - [Conector de produto não selecionável](#conector-de-produto-não-selecionável)
    - [Conector de validação de dados de pagamento](#conector-de-validação-de-dados-de-pagamento)
    - [Connector de validação de Risk Signals](#connector-de-validação-de-risk-signals)
    - [Tratamentos adicionais](#tratamentos-adicionais)
      - [Filtro de contas](#filtro-de-contas)
    - [Multipla alçada](#multipla-alçada)
      - [Tratamento do status PENDING_AUTHORISATION](#tratamento-do-status-pending_authorisation)
  - [Grupos de permissões na criação do consentimento](#grupos-de-permissões-na-criação-do-consentimento)
  - [Aprovação de criação de consentimento de pagamento](#aprovação-de-criação-de-consentimento-de-pagamento)
    - [Solução provisória para rota approvePaymentConsentCreation](#solução-provisória-para-rota-approvepaymentconsentcreation)
  - [Serviços auxiliares](#serviços-auxiliares)

## Discovery de recursos no Opus Open Banking

O discovery de recursos no Opus Open Banking é um dos pontos de integração entre
o Opus Open Banking e os sistemas de legado da instituição, e é a integração
responsável pela descoberta dos produtos vinculados a um consentimento. O
discovery de recursos acontece em dois momentos distintos dentro do Open Banking.

### Momentos de discovery

#### Produtos selecionáveis

O momento de discovery ocorre durante a fase de
aceitação do consentimento pelo cliente da instituição. Consentimentos de
compartilhamento de dados que envolvem os produtos **conta** e
**cartão de crédito** e consentimentos de pagamento precisam exibir as instâncias
 dos produtos durante a etapa de autenticação e aceitação do consentimento para
 serem escolhidos ativamente pelo cliente. Chamamos esses produtos de
 **produtos selecionáveis**.

A tabela a seguir compila todos os produtos selecionáveis tratados pelo Opus Open
 Banking e seus tipos:

| Tipo do consentimento     | Produto                      | Tipo do produto  | Nome da rota Camel                               |
| ------------------------- | ---------------------------- | ---------------- | ------------------------------------------------ |
| Compartilhamento de dados | ACCOUNT                      | Selecionável     | ```direct:discoverAccounts```                    |
| Compartilhamento de dados | CREDIT_CARD_ACCOUNT          | Selecionável     | ```direct:discoverCreditCardAccounts```          |
| Pagamento                 | PAYMENT[^1]                  | Selecionável     | ```direct:discoverPayments_v2```                 |

[^1]: O produto **PAYMENT** é uma forma de permitir que a seleção da origem de recursos para um pagamento seja independente do produto ACCOUNT, permitindo pagamentos através de cartão de crédito ou outra origem distinta que a instituição eventualmente possua.

Caso a instituição forneça algum produto do tipo de compartilhamento de dados,
será preciso criar a rota camel como referenciada na tabela, respeitando o [formato
de request e response indicado pelo tipo de produto](#conectores-de-discovery).
Se não houver a disponibilização desses produtos (criação da rota camel), o retorno
padrão do discovery é nulo e a instituição não precisa colocar tais rotas.

#### Produtos não selecionáveis

O momento de discovery ocorre durante a utilização do consentimento de
compartilhamento de dados, quando o *TPP* chama a API regulatória
[```GET /resources/v1/resources```](https://openbankingbrasil.atlassian.net/wiki/spaces/OB/pages/33849604/Informa+es+T+cnicas+-+Resources+-+v1.0.2) ou [```GET /resources/v2/resources```](https://openbankingbrasil.atlassian.net/wiki/spaces/OB/pages/57409630/Informa+es+T+cnicas+-+Resources+-+v2.0.0).
Essa API precisa retornar todos os recursos acessíveis no consentimento, ou
seja, os produtos selecionados ativamente pelo cliente durante a aceitação do
consentimento e os demais produtos do consentimento. Chamamos esses últimos
produtos de **produtos não selecionáveis**.

A tabela a seguir compila todos os produtos não selecionáveis tratados pelo Opus
Open Banking e seus tipos:

| Tipo do consentimento     | Produto                      | Tipo do produto  | Nome da rota Camel                               |
| ------------------------- | ---------------------------- | ---------------- | ------------------------------------------------ |
| Compartilhamento de dados | INVOICE_FINANCING            | Não selecionável | ```direct:discoverInvoiceFinancings```           |
| Compartilhamento de dados | FINANCING                    | Não selecionável | ```direct:discoverFinancings```                  |
| Compartilhamento de dados | LOAN                         | Não selecionável | ```direct:discoverLoans```                       |
| Compartilhamento de dados | UNARRANGED_ACCOUNT_OVERDRAFT | Não selecionável | ```direct:discoverUnarrangedAccountOverdrafts``` |
| Compartilhamento de dados | BANK_FIXED_INCOMES_READ      | Não selecionável | ```direct:discoverBankFixedIncomes```            |
| Compartilhamento de dados | CREDIT_FIXED_INCOMES_READ    | Não selecionável | ```direct:discoverCreditFixedIncomes```          |
| Compartilhamento de dados | FUNDS_READ                   | Não selecionável | ```direct:discoverFunds```                       |
| Compartilhamento de dados | VARIABLE_INCOMES_READ        | Não selecionável | ```direct:discoverVariableIncomes```             |
| Compartilhamento de dados | TREASURE_TITLES_READ         | Não selecionável | ```direct:discoverTreasureTitles```              |
| Compartilhamento de dados | EXCHANGES_READ               | Não selecionável | ```direct:discoverExchanges```                   |

Caso a instituição forneça algum produto do tipo de compartilhamento de dados,
será preciso criar a rota camel como referenciada na tabela, respeitando o [formato
de request e response indicado pelo tipo de produto](#conectores-de-discovery).
Se não houver a disponibilização desses produtos (criação da rota camel), o retorno
padrão do discovery é nulo e a instituição não precisa colocar tais rotas.

Os possíveis status dos recursos não selecionáveis estão na tabela a seguir:

| Status     | Descrição                      |Transição                        |
| ------------------------- | ---------------------------- | ------------------------------------------------------------------------------------------------------|
| PENDING_AUTHORISATION     | Quando os recursos ainda exigem aprovação de múltipla alçada | Pode transacionar para todos os status |
| TEMPORARILY_UNAVAILABLE | Recursos em bloqueios temporários e indisponíveis nos canais de atendimento eletrônico para os usuários finais | Pode transacionar para AVAILABLE ou UNAVAILABLE |
| AVAILABLE | Recursos em plena utilização e disponíveis nos canais de atendimento eletrônico para os usuários finais | Pode transacionar para TEMPORARILY_UNAVAILABLE ou UNAVAILABLE |
| UNAVAILABLE | Recursos encerrados, migrados, cancelados ou que foram para perdas e que estão indisponíveis nos canais de atendimento eletrônico para os usuários finais | Não pode transacionar para nenhum status |

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
| Request  | [discovery-resource-request.json](../schemas/v2/consent/discoveryDataSharing/discovery-resource-request.json)                          |
| Response | [discovery-selectable-resource-response.json](../schemas/v2/consent/discoveryDataSharing/discovery-selectable-resource-response.json) |

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
| Request  | [discovery-resource-request.json](../schemas/v2/consent/discoveryDataSharing/discovery-resource-request.json)                               |
| Response | [discovery-nonselectable-resource-response.json](../schemas/v2/consent/discoveryDataSharing/discovery-nonselectable-resource-response.json) |

*[DRAFT: O schema do consentimento dentro do request
está em revisão]*

Exemplo de response para um produto não selecionável:

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
      ],
      "status": "TEMPORARILY_UNAVAILABLE",
      "validUntil":"2022-06-07"
    }
  ]
}
```

**IMPORTANTE**: O sistema legado do banco deve ser responsável pelo controle do
status do recurso e pela validade do recurso (validUntil).

### Conector de validação de dados de pagamento

O conector de validação de pagamento é implementado em Apache Camel igual aos
demais conectores de integração e tem função de realizar algumas validações no dados
de pagamento, como por exemplo:

- Validar dados do DICT
- Validar QRCODE (QRND/QRES)
- Validar dados de conta

A rota camel escuta chamadas realizadas em `direct:validatePaymentData` e um exemplo
de [request](../schemas/v3/consent/validatePaymentData/request-example.json).

**Importante**: A partir da versão 4 do consentimento, caso múltiplos erros sejam
identificados durante a validação, deve-se retornar o erro de maior prioridade.
A tabela de prioridade pode ser encontrada nas *Informações Técnicas* da
[API de Pagamentos](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17375943/SV+API+-+Pagamentos).

### Conector de descoberta de correntista

Devido à uma resolução regulatória, o PCM (Plataforma de Coleta de Métricas)
deve enviar a informação se a pessoa (PF/PJ) que pediu consentimento é correntista
na instituição ou não.

Para isso um conector de correntistas foi criado com a seguinte funcionalidade,
receber um CPF/CNPJ e validar contra a instituição se o mesmo pertence a um correntista.

A resposta deve ser:
- Positiva (CPF/CNPJ pertence a um correntista);
- Negativa (CPF/CNPJ não pertence a um correntista);

A tabela a seguir lista os pontos de integração para a verificação de correntista:

| Tipo do consentimento | Nome da rota Camel                            |
| --------------------- | --------------------------------------------- |
| Todos                 | ```direct:checkAccountHolderStatus```         |

Definições:
- [request-schema](../schemas/v3/consent/checkAccountHolderStatus/request-schema.json)
- [response-schema](../schemas/v3/consent/checkAccountHolderStatus/response-schema.json)

Exemplos:
- [request-example](../schemas/v3/consent/checkAccountHolderStatus/request-example.json)
- [response-example](../schemas/v3/consent/checkAccountHolderStatus/response-example.json)

**Observação**

O conector padrão implementado deverá chamar o conector de correntista,
caso o mesmo não exista então será chamado o conector discovery de contas
e se este não atender, deve ser implementado o novo conector.

### Connector de validação de Risk Signals

Durante dois momentos da jornada sem redirecionamento (JSR), o usuário deverá
enviar diversas informações relacionadas a seu dispositivo como, por exemplo,
geolocalização, versão do sistema operacional, idioma, etc.

Caso a instituição deseje realizar validações nesses dados, ela deverá implementar
a rota `direct:validateRiskSignals`.

**Importante**: A implementação da rota não é obrigatória, mas é recomendada.

Definições:
- [request-schema](../schemas/v3/consent/validateRiskSignals/request-schema.json)
- [response-schema](../schemas/v3/consent/validateRiskSignals/response-schema.json)

Cenários nos quais a implementação seria recomendada:

- análise de risco caso o cliente esteja em uma área considerada de risco, podendo diminuir temporariamente o limite, ou
adicionando alguma validação para realizar o pagamento;
- caso o dispositivo tenha sido "rooteado", pode-se adicionar validações de análise de risco da operação, pois haveria
possibiilidade do dispositito estar comprometido.

### Tratamentos adicionais

#### Filtro de contas

Em algumas situações a conta utilizada para uma operação financeira é
definida pelo cliente antes da seleção de contas, na aplicação iniciadora do
pagamento. Nestes cenários o objeto debtorAccount estará preenchido no
consentimento e a lista retornada deve ser filtrada para retornar somente a
conta pré-selecionada ou uma lista vazia caso essa não seja uma opção selecionável
para o cliente. Esse tratamento deve ser feito no conector ou serviço remoto de listagem
de contas.

### Multipla alçada

#### Tratamento do status PENDING_AUTHORISATION

Os conectores de discovery de compartilhamento de dados devem tratar o status
`PENDING_AUTHORISATION`. Será de responsabilidade da instituição tratar o
status dos produtos (e dados cadastrais se a instituição exigir tratamento de
múltipla alçada para isso). O produto armazenará a situação de cada recurso da
transmissão de dados e fará a validação da situação nas chamadas dos produtos,
impedindo chamadas de acontecer em caso de pendência (erro 403 conforme a
documentação de todos tipos de recurso na documentação do Open Finance Brasil).

O tratamento do retorno dos conectores de discovery deve aceitar o status
`PENDING_AUTHORISATION` quando o consentimento for de múltipla alçada, listando
o recurso na API `GET /resources` adequadamente e impedindo a chamada da instância
quando essa for nominada.

As futuras chamadas dos conectores de discovery poderão retornar o status `AVAILABLE`,
fazendo com que o OOB mude o status desse recurso para `AVAILABLE` e passe a aceitar
as chamadas específicas a determinada instância de produto.

Importante lembrar que o discovery de contas e cartão, os chamados produtos selecionáveis,
acontece exclusivamente no momento da criação do consentimento, então a transição
nesse caso deverá acontecer através de API de listagem da categoria do produto,
que é então uma segunda forma de transição de status. Os conectores de listagem
de produtos devem então aceitar o status (a ser removido da resposta
final) do item. Esse status sensibilizará os recursos no OOB da mesma forma que
o conector de discovery de produtos, alterando eventualmente a situação de um
recurso de `PENDING_AUTHORISATION` para `AVAILABLE`. Instâncias de produtos que retornam
como `PENDING_AUTHORISATION` na listagem de produtos são removidas do
resultado da API regulatória até serem atualizados para o estado `AVAILABLE`.

Qualquer tentativa de mudança do status de `AVAILABLE` para `PENDING_AUTHORISATION`
será impedida pelo produto para garantir o diagrama de estado possível de dados
cadastrais definido pelo Open Finance Brasil.

## Grupos de permissões na criação do consentimento

No momento da criação do consentimento todas as permissões dos agrupamentos
de dados aos quais se deseja consentimento devem ser enviadas. Esse conjunto
de permissões necessárias, chamado de grupos de permissões, são designados
conforme tabela abaixo ([link](https://openbanking-brasil.github.io/openapi/swagger-apis/consents/1.0.3.yml)
para documentação oficial):

| Categoria de Dados   | Agrupamento                   |  Permissões                                                                                                                                                                                              |
| -------------------- | ----------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Cadastro             | Dados cadastrais PF           | CUSTOMERS_PERSONAL_IDENTIFICATIONS_READ, RESOURCES_READ                                                                                                                                                  |
| Cadastro             | Informações complementares PF | CUSTOMERS_PERSONAL_ADITTIONALINFO_READ, RESOURCES_READ                                                                                                                                                   |
| Cadastro             | Dados cadastrais PJ           | CUSTOMERS_BUSINESS_IDENTIFICATIONS_READ, RESOURCES_READ                                                                                                                                                  |
| Cadastro             | Informações complementares PJ | CUSTOMERS_BUSINESS_ADITTIONALINFO_READ, RESOURCES_READ                                                                                                                                                   |
| Contas               | Saldos                        | ACCOUNTS_READ, ACCOUNTS_BALANCES_READ, RESOURCES_READ                                                                                                                                                    |
| Contas               | Limites                       | ACCOUNTS_READ, ACCOUNTS_OVERDRAFT_LIMITS_READ, RESOURCES_READ                                                                                                                                            |
| Contas               | Extratos                      | ACCOUNTS_READ, ACCOUNTS_TRANSACTIONS_READ, RESOURCES_READ                                                                                                                                                |
| Cartão de Crédito    | Limites                       | CREDIT_CARDS_ACCOUNTS_READ, CREDIT_CARDS_ACCOUNTS_LIMITS_READ, RESOURCES_READ                                                                                                                            |
| Cartão de Crédito    | Transações                    | CREDIT_CARDS_ACCOUNTS_READ, CREDIT_CARDS_ACCOUNTS_TRANSACTIONS_READ, RESOURCES_READ                                                                                                                      |
| Cartão de Crédito    | Faturas                       | CREDIT_CARDS_ACCOUNTS_READ, CREDIT_CARDS_ACCOUNTS_BILLS_READ, CREDIT_CARDS_ACCOUNTS_BILLS_TRANSACTIONS_READ, RESOURCES_READ                                                                              |
| Operações de Crédito | Dados do Contrato             | LOANS_READ, LOANS_WARRANTIES_READ, LOANS_SCHEDULED_INSTALMENTS_READ, LOANS_PAYMENTS_READ, FINANCINGS_READ, FINANCINGS_WARRANTIES_READ, FINANCINGS_SCHEDULED_INSTALMENTS_READ, FINANCINGS_PAYMENTS_READ, UNARRANGED_ACCOUNTS_OVERDRAFT_READ, UNARRANGED_ACCOUNTS_OVERDRAFT_WARRANTIES_READ, UNARRANGED_ACCOUNTS_OVERDRAFT_SCHEDULED_INSTALMENTS_READ, UNARRANGED_ACCOUNTS_OVERDRAFT_PAYMENTS_READ, INVOICE_FINANCINGS_READ, INVOICE_FINANCINGS_WARRANTIES_READ, INVOICE_FINANCINGS_SCHEDULED_INSTALMENTS_READ, INVOICE_FINANCINGS_PAYMENTS_READ, RESOURCES_READ                                                                                                                                                                   |
| Operações de Crédito | Antecipação de recebíveis     | INVOICE_FINANCINGS_READ, INVOICE_FINANCINGS_WARRANTIES_READ, INVOICE_FINANCINGS_SCHEDULED_INSTALMENTS_READ, INVOICE_FINANCINGS_PAYMENTS_READ, RESOURCES_READ                                             |
| Operações de Crédito | Financiamentos                | FINANCINGS_READ, FINANCINGS_WARRANTIES_READ, FINANCINGS_SCHEDULED_INSTALMENTS_READ, FINANCINGS_PAYMENTS_READ, RESOURCES_READ                                                                             |
| Operações de Crédito | Empréstimos                   | LOANS_READ, LOANS_WARRANTIES_READ, LOANS_SCHEDULED_INSTALMENTS_READ, LOANS_PAYMENTS_READ, RESOURCES_READ                                                                                                 |
| Operações de Crédito | Adiantamento a depositantes   | UNARRANGED_ACCOUNTS_OVERDRAFT_READ, UNARRANGED_ACCOUNTS_OVERDRAFT_WARRANTIES_READ, UNARRANGED_ACCOUNTS_OVERDRAFT_SCHEDULED_INSTALMENTS_READ, UNARRANGED_ACCOUNTS_OVERDRAFT_PAYMENTS_READ, RESOURCES_READ |
| Operações de Crédito | Investimentos                 | BANK_FIXED_INCOMES_READ,CREDIT_FIXED_INCOMES_READ,FUNDS_READ,VARIABLE_INCOMES_READ,TREASURE_TITLES_READ,RESOURCES_READ                                                                                   |
| Operações de Crédito | Câmbio                        | EXCHANGES_READ,RESOURCES_READ                                                                                                                                                                            |

## Aprovação de criação de consentimento de pagamento

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
- Verificar se as características da criação de consentimento estão de
acordo com suas regras para os pagamentos do tipo **TED** e **TEF** - dia da semana,
feriado, horário, valor máximo de transferência, etc..

A tabela a seguir lista os pontos de integração para a aceitação da criação de
um consentimento:

| Tipo do consentimento | Nome da rota Camel                            |
| --------------------- | --------------------------------------------- |
| Pagamento             | ```direct:approvePaymentConsentCreation_v3``` |

O retorno desses pontos de integração devem ser:

- Uma mensagem de sucesso (geralmente um objeto vazio) quando o consentimento
  puder ser criado;
- Uma mensagem de erro de negócio, descrita no schema de integração com um enum
  específico no campo *code*, definindo o motivo pelo qual o consentimento foi
  negado. Essa mensagem possui também o campo opcional *restrictionType* informando
  o tipo de restrição que reprovou o consentimento;
- Uma mensagem de erro genérica, definida pelo schema
  [response-error-schema.json](../schemas/v2/common/response-error-schema.json)
  quando um erro técnico impedir que a solicitação possa ser avaliada, como um
  erro de rede ou um sistema inoperante.

A tabela a seguir corresponde aos schemas do Request e do Response do conector:

| Tipo     | JSON Schema                                                                                                        |
| -------- | ------------------------------------------------------------------------------------------------------------------ |
| Request  | [approvePaymentConsent-request.json](../schemas/v3/consent/approvePaymentConsentCreation_v3/request-schema.json)   |
| Response | [approvePaymentConsent-response.json](../schemas/v3/consent/approvePaymentConsentCreation_v3/response-schema.json) |

Exemplo de Request:

```json
{
    "requestBody": {
        "data": {
            "tpp": {
                "name": "GuiaBolsa"
            },
            "loggedUser": {
                "document": {
                    "identification": "11111111111",
                    "rel": "CPF"
                }
            },
            "creditor": {
                "personType": "PESSOA_NATURAL",
                "cpfCnpj": "11111111111",
                "name": "Marco Antonio de Brito"
            },
            "payment": {
                "type": "PIX",
                "date": "2021-01-01",
                "currency": "BRL",
                "amount": "100000.04",
                "details": {
                    "localInstrument": "DICT",
                    "proxy": "12345678901",
                    "creditorAccount": {
                        "ispb": "12345678",
                        "number": "1234567890",
                        "accountType": "CACC",
                        "issuer": "1774"
                    }
                },
                "ibgeTownCode": "5300108"
            },
            "debtorAccount": {
                "ispb": "87654321",
                "number": "0987654321",
                "accountType": "CACC",
                "issuer": "1774"
            }
        }
    },
    "requestMeta": {
        "correlationId": "700dd46b-b2a6-2e28-41ef-f5c597640af3",
        "brandId": "cbanco"
    }
}
```

Mais exemplos de request e de response para a rota "approvePaymentConsentCreation"
podem ser encontradas [aqui](../schemas/v3/consent/approvePaymentConsentCreation_v3).

Exemplo de comando utilizado no `Dockerfile` para adicionar o arquivo das rotas
`approvePaymentConsentCreation`, `approvePaymentConsentCreation_v2` e `approvePaymentConsentCreation_v3`:

```dockerfile
ARG approvePaymentRoute=file:/specs/custom-approvePaymentConsentCreation-routes.xml
ENV camel.main.routes-include-pattern=$approvePaymentRoute
```

### Solução provisória para rota approvePaymentConsentCreation

A fim de facilitar o desenvolvimento da solução das entidades parceiras, a Opus
Software fornece um arquivo .xml (approvePaymentConsentCreation-routes.xml) com
uma **solução temporária** da rota "approvePaymentConsentCreation".
Ela aprova qualquer consentimento, sem aplicar nenhuma regra de verificação, e
deve ser utilizada **apenas** para desenvolvimento e enquanto os serviços de
aprovação dos consentimentos de pagamentos do sistema legado não estiverem
adaptados para os pagamentos do tipo TED e TEF.

Exemplo de comando utilizado no `Dockerfile` para utilizar a solução temporária
para a rota `approvePaymentConsentCreation`, `approvePaymentConsentCreation_v2`e
`approvePaymentConsentCreation_v3`:

```dockerfile
ARG approvePaymentRoute=file:/specs/approvePaymentConsentCreation-routes.xml
ENV camel.main.routes-include-pattern=$approvePaymentRoute
```

## Serviços auxiliares

Serviços auxiliares foram criados em Java a fim de facilitar a implementação dos
conectores.

Os serviços e suas respectivas funcionalidades são:

| Nome do serviço                  | Descrição                                                                                            | Comando de chamada no arquivo .xml                                                                             |
| -------------------------------- | ---------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| getDayOfTheWeek                  | Obter o dia da semana atual em inglês no padrão `EEE` (ex: "Fri" - sexta-feira)                      | `${bean:camelUtils.getDayOfTheWeek}`                                                                           |
| concatenateStrings               | Obter uma string que é a concatenação das duas strings passadas como parâmetros                      | `${bean:camelUtils.concatenateStrings("ab", "cd")}`                                                            |
| hmacCalculator                   | Obter o cálculo de hash de um data com base num algoritmo específico com uma chave secreta fornecida | `${bean:camelUtils.hmacCalculator("HmacSHA256", "abcd", "bc19bec7-339f-452f-8548-3daa889e6f79)}`               |
| makePostCall                     | Utilizado para chamadas post com mtls                                                                | `${bean:camelUtils.makePostCall(${authorization}, ${transactionHash}, ${contentType},  ${endpoint}, ${body})}` |
| makeGetCall                      | Utilizado para chamadas get com mtls                                                                 | `${bean:camelUtils.makeGetCall(${authorization}, ${transactionHash}, ${contentType}, ${endpoint})}`            |
| generateUrlEncodedOrDecodedValue | Utilizado para codificar/decodificar uma string de/para o formato URL                                | `${bean:camelUtils.generateUrlEncodedOrDecodedValue("testl!encode*sf13", "ENCODE"}`                            |

**Exemplo de chamada do serviço getDayOfTheWeek:**

```xml
<setProperty name="currentWeekday">
  <simple>${bean:camelUtils.getDayOfTheWeek}</simple>
</setProperty>
```

**Exemplo de chamada do serviço concatenateStrings:**

```xml
<setProperty name="concatenatedString">
    <simple>${bean:camelHelper.concatenateStrings("ab", "cd")}</simple>
</setProperty>
```

O resultado desta chamada seria: abcd

**Exemplo de chamada do serviço hmacCalculator:**

```xml
<setProperty name="hmacCalculatated">
    <simple>${bean:camelHelper.hmacCalculator("HmacSHA256", "abcd", "bc19bec7-339f-452f-8548-3daa889e6f79)}</simple>
</setProperty>
```

Algorimos suportados:

```text
HmacMD5
HmacSHA1
HmacSHA224
HmacSHA256
HmacSHA384
HmacSHA512
```

**Exemplo de chamada do serviço generateUrlEncodedOrDecodedValue:**

```xml
<setProperty name="encodedString">
  <simple>${bean:camelUtils.generateUrlEncodedOrDecodedValue("testl!encode*sf1", "ENCODE")}</simple>
</setProperty>
```