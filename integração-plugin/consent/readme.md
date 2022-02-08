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
    - [Arquivo de rota implementado pela OPUS](#arquivo-de-rota-implementado-pela-opus)
    - [Alteração dos valores padrões das variáveis de ambiente](#alteração-dos-valores-padrões-das-variáveis-de-ambiente)
      - [Regras de preenchimento para a alteração do validador de dia de início do ciclo](#regras-de-preenchimento-para-a-alteração-do-validador-de-dia-de-início-do-ciclo)
      - [Regras de preenchimento para a alteração do validador de valor máximo de pagamento](#regras-de-preenchimento-para-a-alteração-do-validador-de-valor-máximo-de-pagamento)
      - [Regras de preenchimento para a alteração do validador de lista de CPF/CNPJ dos usuários autorizados](#regras-de-preenchimento-para-a-alteração-do-validador-de-lista-de-cpfcnpj-dos-usuários-autorizados)
      - [Regras de preenchimento para a alteração do validador de dia da semana e horário de funcionamento](#regras-de-preenchimento-para-a-alteração-do-validador-de-dia-da-semana-e-horário-de-funcionamento)
      - [Regras de preenchimento para a alteração do validador de iniciação de transação de pagamentos do arranjo PIX do ciclo](#regras-de-preenchimento-para-a-alteração-do-validador-de-iniciação-de-transação-de-pagamentos-do-arranjo-pix-do-ciclo)
    - [Serviços auxiliares](#serviços-auxiliares)
    - [Criação de arquivo de rota customizada](#criação-de-arquivo-de-rota-customizada)

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
  específico no campo *code*, definindo o motivo pelo qual o consentimento foi
  negado. Essa mensagem possui também o campo opcional *restrictionType* informando
  o tipo de restrição que reprovou o consentimento;
- Uma mensagem de erro genérica, definida pelo schema
  [response-error-schema.json](../schemas/v2/common/response-error-schema.json)
  quando um erro técnico impedir que a solicitação possa ser avaliada, como um
  erro de rede ou um sistema inoperante.

A tabela a seguir corresponde aos schemas do Request e do Response do conector:

| Tipo     | JSON Schema                                                                                                     |
| -------- | --------------------------------------------------------------------------------------------------------------- |
| Request  | [approvePaymentConsent-request.json](../schemas/v2/consent/approvePaymentConsentCreation/request-schema.json)   |
| Response | [approvePaymentConsent-response.json](../schemas/v2/consent/approvePaymentConsentCreation/response-schema.json) |

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

### Arquivo de rota implementado pela OPUS

A OPUS já fornece um arquivo da rota approvePaymentConsentCreation com as regras
padrões definidas pelo próprio [Open Banking Brasil - OBB](https://www.bcb.gov.br/estabilidadefinanceira/exibenormativo?tipo=Instru%C3%A7%C3%A3o%20Normativa%20BCB&numero=171).
Para utilizá-lo, basta configurar a variável de ambiente `camel.main.routes-include-pattern`
durante a criação do container, indicando o diretório onde o arquivo arquivo se
encontra: `specs/approvePaymentConsentCreation-routes.xml`.

Exemplo de comando utilizado no `Dockerfile` para adicionar o arquivo da rota
`approvePaymentConsentCreation` criado pela OPUS:

```dockerfile
ARG approvePaymentRoute=file:/specs/approvePaymentConsentCreation-routes.xml
ENV camel.main.routes-include-pattern=$approvePaymentRoute
```

Para definir os parâmetros pré-estabelecidos pelo OBB, são utilizadas variáveis
de ambiente cujos valores padrões foram definidos de acordo com as regras
estabelecidas pelo OBB.

| Nome da variável                          | Definição                                                                                             | Valor default                    |
| ----------------------------------------- | ----------------------------------------------------------------------------------------------------- | -------------------------------- |
| VALIDATOR_CYCLE1_PAYMENTS_MAX_AMOUNT      | Valor máximo de transferência de pagamento no ciclo 1                                                 | ```"1000.00"```                  |
| VALIDATOR_CYCLE1_PAYMENTS_LOCALINSTRUMENT | Tipos de iniciação de pagamentos disponíveis no ciclo 1                                               | ```"MANU,DICT,INIC"```           |
| VALIDATOR_CYCLE1_CPF                      | CPF/CNPJ dos usuário permitidos a iniciarem um pagamento no ciclo 1                                   | ```[]```                         |
| VALIDATOR_CYCLE1_CUSTOMDAYS               | Parâmetro que indica se há configuração de dia da semana e de horário de funcionamento para o ciclo 1 | ```ENABLED```                    |
| VALIDATOR_CYCLE1_WORKINGDAYS_WEEKDAYS     | Dias da semana em que o serviço se encontra disponível no ciclo 1                                     | ```"Mon,Tue,Wed,Thu,Fri"```      |
| VALIDATOR_CYCLE1_WORKINGDAYS_START        | Horário de início do serviço para os dias da semana definidos no ciclo 1                              | ```"080000"```                   |
| VALIDATOR_CYCLE1_WORKINGDAYS_END          | Horário de encerramento do serviço para os dias da semana definidos no ciclo 1                        | ```"200000"```                   |
| VALIDATOR_CYCLE1_SPECIALDAYS_WEEKDAYS     | Dias da semana em que o serviço se encontra disponível no ciclo 1                                     | ```DISABLED```                   |
| VALIDATOR_CYCLE1_SPECIALDAYS_START        | Horário de início do serviço para os dias da semana definidos no ciclo 1                              | ```DISABLED```                   |
| VALIDATOR_CYCLE1_SPECIALDAYS_END          | Horário de encerramento do serviço para os dias da semana definidos no ciclo 1                        | ```DISABLED```                   |
| VALIDATOR_CYCLE2_PAYMENTS_MAX_AMOUNT      | Valor máximo de transferência de pagamento no ciclo 2                                                 | ```"1000.00"```                  |
| VALIDATOR_CYCLE2_DAY1                     | Data de início do ciclo 2                                                                             | ```"20211115"```                 |
| VALIDATOR_CYCLE2_PAYMENTS_LOCALINSTRUMENT | Tipos de iniciação de pagamentos disponíveis no ciclo 2                                               | ```"MANU,DICT,INIC"```           |
| VALIDATOR_CYCLE2_CPF                      | CPF/CNPJ dos usuário permitidos a iniciarem um pagamento no ciclo 2                                   | ```[]```                         |
| VALIDATOR_CYCLE2_CUSTOMDAYS               | Parâmetro que indica se há configuração de dia da semana e de horário de funcionamento para o ciclo 2 | ```ENABLED```                    |
| VALIDATOR_CYCLE2_WORKINGDAYS_WEEKDAYS     | Dias da semana em que o serviço se encontra disponível no ciclo 2                                     | ```"Mon,Tue,Wed,qua"```          |
| VALIDATOR_CYCLE2_WORKINGDAYS_START        | Horário de início do serviço para os dias da semana definidos no ciclo 2                              | ```"080000"```                   |
| VALIDATOR_CYCLE2_WORKINGDAYS_END          | Horário de encerramento do serviço para os dias da semana definidos no ciclo 2                        | ```"200000"```                   |
| VALIDATOR_CYCLE2_SPECIALDAYS_WEEKDAYS     | Dias da semana em que o serviço se encontra disponível no ciclo 2                                     | ```"Thu,Fri"```                  |
| VALIDATOR_CYCLE2_SPECIALDAYS_START        | Horário de início do serviço para os dias da semana definidos no ciclo 2                              | ```"000000"```                   |
| VALIDATOR_CYCLE2_SPECIALDAYS_END          | Horário de encerramento do serviço para os dias da semana definidos no ciclo 2                        | ```"235959"```                   |
| VALIDATOR_CYCLE3_DAY1                     | Data de início do ciclo 3                                                                             | ```"20211201"```                 |
| VALIDATOR_CYCLE3_PAYMENTS_LOCALINSTRUMENT | Tipos de iniciação de pagamentos disponíveis no ciclo 3                                               | ```"MANU,DICT,INIC,QRDN,QRES"``` |
| VALIDATOR_CYCLE3_CPF                      | CPF/CNPJ dos usuário permitidos a iniciarem um pagamento no ciclo 3                                   | ```DISABLED```                   |
| VALIDATOR_CYCLE3_CUSTOMDAYS               | Parâmetro que indica se há configuração de dia da semana e de horário de funcionamento para o ciclo 3 | ```ENABLED```                    |
| VALIDATOR_CYCLE3_WORKINGDAYS_WEEKDAYS     | Dias da semana em que o serviço se encontra disponível no ciclo 3                                     | ```"Mon,Tue,Wed"```              |
| VALIDATOR_CYCLE3_WORKINGDAYS_START        | Horário de início do serviço para os dias da semana definidos no ciclo 3                              | ```"080000"```                   |
| VALIDATOR_CYCLE3_WORKINGDAYS_END          | Horário de encerramento do serviço para os dias da semana definidos no ciclo 3                        | ```"200000"```                   |
| VALIDATOR_CYCLE3_SPECIALDAYS_WEEKDAYS     | Dias da semana em que o serviço se encontra disponível no ciclo 3                                     | ```"Thu,Fri"```                  |
| VALIDATOR_CYCLE3_SPECIALDAYS_START        | Horário de início do serviço para os dias da semana definidos no ciclo 3                              | ```"000000"```                   |
| VALIDATOR_CYCLE3_SPECIALDAYS_END          | Horário de encerramento do serviço para os dias da semana definidos no ciclo 3                        | ```"235959"```                   |
| VALIDATOR_CYCLE3_PAYMENTS_MAX_AMOUNT      | Valor máximo de transferência de pagamento no ciclo 3                                                 | ```"1000.00"```                  |
| VALIDATOR_CYCLE4_DAY1                     | Data de início do ciclo 4                                                                             | ```"20211201"```                 |
| VALIDATOR_CYCLE4_FINALDAY                 | Tipos de iniciação de pagamentos disponíveis no ciclo 4                                               | ```"20220217"```                 |
| VALIDATOR_CYCLE4_PAYMENTS_LOCALINSTRUMENT | Tipos de iniciação de pagamentos disponíveis no ciclo 4                                               | ```"MANU,DICT,INIC,QRDN,QRES"``` |
| VALIDATOR_CYCLE4_CPF                      | CPF/CNPJ dos usuário permitidos a iniciarem um pagamento no ciclo 4                                   | ```DISABLED```                   |
| VALIDATOR_CYCLE4_CUSTOMDAYS               | Parâmetro que indica se há configuração de dia da semana e de horário de funcionamento para o ciclo 4 | ```DISABLED```                   |
| VALIDATOR_CYCLE4_WORKINGDAYS_WEEKDAYS     | Dias da semana em que o serviço se encontra disponível no ciclo 4                                     | ```DISABLED```                   |
| VALIDATOR_CYCLE4_WORKINGDAYS_START        | Horário de início do serviço para os dias da semana definidos no ciclo 4                              | ```DISABLED```                   |
| VALIDATOR_CYCLE4_WORKINGDAYS_END          | Horário de encerramento do serviço para os dias da semana definidos no ciclo 4                        | ```DISABLED```                   |
| VALIDATOR_CYCLE4_SPECIALDAYS_WEEKDAYS     | Dias da semana em que o serviço se encontra disponível no ciclo 4                                     | ```DISABLED```                   |
| VALIDATOR_CYCLE4_SPECIALDAYS_START        | Horário de início do serviço para os dias da semana definidos no ciclo 4                              | ```DISABLED```                   |
| VALIDATOR_CYCLE4_SPECIALDAYS_END          | Horário de encerramento do serviço para os dias da semana definidos no ciclo 4                        | ```DISABLED```                   |
| VALIDATOR_CYCLE4_PAYMENTS_MAX_AMOUNT      | Valor máximo de transferência de pagamento no ciclo 4                                                 | ```DISABLED```                   |

### Alteração dos valores padrões das variáveis de ambiente

É possível alterar os valores dos parâmetros da tabela acima, definindo as variáveis
de ambiente como uma variável de ambiente opcional (additionalVars) na instalação
do helm chart.

#### Regras de preenchimento para a alteração do validador de dia de início do ciclo

**Obs:** Como durante o ciclo 1 apenas os usuários pré-selecionados pela instituição
terão acesso ao serviço, foi definido que não haverá uma data de início para o
ciclo 1, sendo que sua última data corresponde ao dia antes do início do ciclo 2.
Dessa forma, será possível que a instituição cliente realize testes sem a necessidade
de alterar os parâmetros default.

**Obs 2:** Após o fim do ciclo 4 (VALIDATOR_CYCLE4_FINALDAY), todos os validadores
serão desativados.

| Nome da variável          | Formatação   | Regra                                                                        | Valores possíveis |
| ------------------------- | ------------ | ---------------------------------------------------------------------------- | ----------------- |
| VALIDATOR_CYCLE2_DAY1     | `"yyyyMMdd"` | Parâmetro deve possuir 8 dígitos e eles devem estar entre aspas duplas `""`. | ["yyyyMMdd"]      |
| VALIDATOR_CYCLE3_DAY1     | `"yyyyMMdd"` | Parâmetro deve possuir 8 dígitos e eles devem estar entre aspas duplas `""`. | ["yyyyMMdd"]      |
| VALIDATOR_CYCLE4_DAY1     | `"yyyyMMdd"` | Parâmetro deve possuir 8 dígitos e eles devem estar entre aspas duplas `""`. | ["yyyyMMdd"]      |
| VALIDATOR_CYCLE4_FINALDAY | `"yyyyMMdd"` | Parâmetro deve possuir 8 dígitos e eles devem estar entre aspas duplas `""`. | ["yyyyMMdd"]      |

Regra geral: VALIDATOR_CYCLE2_DAY1 < VALIDATOR_CYCLE3_DAY1 < VALIDATOR_CYCLE4_DAY1
< VALIDATOR_CYCLE4_FINALDAY

#### Regras de preenchimento para a alteração do validador de valor máximo de pagamento

| Nome da variável                     | Formatação       | Regra                                                                                                                                                                                             | Valores possíveis       |
| ------------------------------------ | ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| VALIDATOR_CYCLE1_PAYMENTS_MAX_AMOUNT | ```"DDDDD.DD"``` | Valor > 0, utilizar ponto `.` para a separação entre o inteiro e o decimal e deve estar entre aspas duplas `""`. Para desativar o limite do valor de pagamento, definir o parâmetro como DISABLED | ["DDDDDD.DD", DISABLED] |
| VALIDATOR_CYCLE2_PAYMENTS_MAX_AMOUNT | ```"DDDDD.DD"``` | Valor > 0, utilizar ponto `.` para a separação entre o inteiro e o decimal e deve estar entre aspas duplas `""`. Para desativar o limite do valor de pagamento, definir o parâmetro como DISABLED | ["DDDDDD.DD", DISABLED] |
| VALIDATOR_CYCLE3_PAYMENTS_MAX_AMOUNT | ```"DDDDD.DD"``` | Valor > 0, utilizar ponto `.` para a separação entre o inteiro e o decimal e deve estar entre aspas duplas `""`. Para desativar o limite do valor de pagamento, definir o parâmetro como DISABLED | ["DDDDDD.DD", DISABLED] |

#### Regras de preenchimento para a alteração do validador de lista de CPF/CNPJ dos usuários autorizados

**Obs:** Caso não seja adicionada nenhuma lista de CPF/CNPJ nos ciclos 1 e 2, nenhum
usuário terá permissão para acessar o serviço de pagamento por padrão.

| Nome da variável     | Formatação                         | Regra                                                                                                                                                                                                                | Valores possíveis                        |
| -------------------- | ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| VALIDATOR_CYCLE1_CPF | ```"DDDDDDDDDDD,DDDDDDDDDDDDDD"``` | A lista dos CPF/CNPJ deve estar entre aspas duplas '"lista"' e entre cada item deve existir apenas uma vírgula ',' sem espaçamento. Para liberar o serviço para todos os clientes, definir o parâmetro como DISABLED | ["DDDDDDDDDDD,DDDDDDDDDDDDDD", DISABLED] |
| VALIDATOR_CYCLE2_CPF | ```"DDDDDDDDDDD,DDDDDDDDDDDDDD"``` | A lista dos CPF/CNPJ deve estar entre aspas duplas '"lista"' e entre cada item deve existir apenas uma vírgula ',' sem espaçamento. Para liberar o serviço para todos os clientes, definir o parâmetro como DISABLED | ["DDDDDDDDDDD,DDDDDDDDDDDDDD", DISABLED] |
| VALIDATOR_CYCLE3_CPF | ```"DDDDDDDDDDD,DDDDDDDDDDDDDD"``` | A lista dos CPF/CNPJ deve estar entre aspas duplas '"lista"' e entre cada item deve existir apenas uma vírgula ',' sem espaçamento. Para liberar o serviço para todos os clientes, definir o parâmetro como DISABLED | ["DDDDDDDDDDD,DDDDDDDDDDDDDD", DISABLED] |
| VALIDATOR_CYCLE4_CPF | ```"DDDDDDDDDDD,DDDDDDDDDDDDDD"``` | A lista dos CPF/CNPJ deve estar entre aspas duplas '"lista"' e entre cada item deve existir apenas uma vírgula ',' sem espaçamento. Para liberar o serviço para todos os clientes, definir o parâmetro como DISABLED | ["DDDDDDDDDDD,DDDDDDDDDDDDDD", DISABLED] |

#### Regras de preenchimento para a alteração do validador de dia da semana e horário de funcionamento

| Nome da variável                      | Formatação      | Regra                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | Valores possíveis                        |
| ------------------------------------- | --------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------- |
| VALIDATOR_CYCLE1_CUSTOMDAYS           | `VALOR`         | Para os casos em que há horários de funcionamento distintos entre os dias da semana (ex: padrão do ciclo 1 e 2), parâmetro `deve` ser configurado como ENABLED. Caso contrário (ex: padrão do ciclo 3 e ciclo 4), DISABLED.                                                                                                                                                                                                                                                                                                                                                                                                                          | [ENABLED, DISABLED]                      |
| VALIDATOR_CYCLE1_WORKINGDAYS_WEEKDAYS | `"Hhh,Hhh,Hhh"` | A lista dos dias da semana de funcionamento deve estar entre aspas duplas '"lista"' e entre cada item deve existir apenas uma vírgula ',' sem espaçamento. Caso não tenha nenhuma exceção de dia da semana e/ou de horário de funcionamento, definir o parâmetro como DISABLED. **Obs**: Caso VALIDATOR_CYCLE1_CUSTOMDAYS seja definido como DISABLED, esse parâmetro também `deve` ser preenchido como DISABLED                                                                                                                                                                                                                                     | ["Sun,Mon,Tue,Wed,Thu,Fri,Sat", DISABLE] |
| VALIDATOR_CYCLE1_WORKINGDAYS_START    | `"hhMMss"`      | Parâmetro deve possuir seis dígitos e devem estar entre aspas duplas `""`, sendo que "hh" corresponde às horas, "MM" minutos, e "ss" segundos. **Obs**: Caso VALIDATOR_CYCLE1_WORKINGDAYS_WEEKDAYS seja DISABLED, definir este parâmetro como DISABLED também.                                                                                                                                                                                                                                                                                                                                                                                       | ["hhMMss", DISABLED]                     |
| VALIDATOR_CYCLE1_WORKINGDAYS_END      | `"hhMMss"`      | Parâmetro deve possuir seis dígitos e devem estar entre aspas duplas `""`, sendo que "hh" corresponde às horas, "MM" minutos, e "ss" segundos. **Obs**: Caso VALIDATOR_CYCLE1_WORKINGDAYS_WEEKDAYS seja DISABLED, `deve-se` definir este parâmetro como DISABLED também.                                                                                                                                                                                                                                                                                                                                                                             | ["hhMMss", DISABLED]                     |
| VALIDATOR_CYCLE1_SPECIALDAYS_WEEKDAYS | `"Hhh,Hhh,Hhh"` | A lista dos dias da semana de funcionamento deve estar entre aspas duplas '"lista"' e entre cada item deve existir apenas uma vírgula ',' sem espaçamento. Este parâmetro foi criado a fim de atender os casos em que há variação de horário de funcionamento entre os dias da semana (ex: ciclo 2 - nas seg, ter e qua funciona das 08:00:00 ~ 20:00:00 e nas qui e sex, 00:00:00 ~ 23:59:59) Caso não tenha nenhuma exceção de dia da semana e/ou de horário de funcionamento, definir o parâmetro como DISABLED. **Obs**: Caso VALIDATOR_CYCLE1_CUSTOMDAYS seja definido como DISABLED, esse parâmetro também `deve` ser preenchido como DISABLED | ["Sun,Mon,Tue,Wed,Thu,Fri,Sat", DISABLE] |
| VALIDATOR_CYCLE1_SPECIAL_START        | `"hhMMss"`      | Parâmetro deve possuir seis dígitos e devem estar entre aspas duplas `""`, sendo que "hh" corresponde às horas, "MM" minutos, e "ss" segundos. **Obs**: Caso VALIDATOR_CYCLE1_SPECIAL_WEEKDAYS seja DISABLED, `deve-se` definir este parâmetro como DISABLED também.                                                                                                                                                                                                                                                                                                                                                                                 | ["hhMMss", DISABLED]                     |
| VALIDATOR_CYCLE1_SPECIAL_END          | `"hhMMss"`      | Parâmetro deve possuir seis dígitos e devem estar entre aspas duplas `""`, sendo que "hh" corresponde às horas, "MM" minutos, e "ss" segundos. **Obs**: Caso VALIDATOR_CYCLE1_SPECIAL_WEEKDAYS seja DISABLED, `deve-se` definir este parâmetro como DISABLED também.                                                                                                                                                                                                                                                                                                                                                                                 | ["hhMMss", DISABLED]                     |
| VALIDATOR_CYCLE2_CUSTOMDAYS           | `VALOR`         | Para os casos em que há horários de funcionamento distintos entre os dias da semana (ex: padrão do ciclo 1 e 2), parâmetro `deve` ser configurado como ENABLED. Caso contrário (ex: padrão do ciclo 3 e ciclo 4), DISABLED.                                                                                                                                                                                                                                                                                                                                                                                                                          | [ENABLED, DISABLED]                      |
| VALIDATOR_CYCLE2_WORKINGDAYS_WEEKDAYS | `"Hhh,Hhh,Hhh"` | A lista dos dias da semana de funcionamento deve estar entre aspas duplas '"lista"' e entre cada item deve existir apenas uma vírgula ',' sem espaçamento. Caso não tenha nenhuma exceção de dia da semana e/ou de horário de funcionamento, definir o parâmetro como DISABLED. **Obs**: Caso VALIDATOR_CYCLE2_CUSTOMDAYS seja definido como DISABLED, esse parâmetro também `deve` ser preenchido como DISABLED                                                                                                                                                                                                                                     | ["Sun,Mon,Tue,Wed,Thu,Fri,Sat", DISABLE] |
| VALIDATOR_CYCLE2_WORKINGDAYS_START    | `"hhMMss"`      | Parâmetro deve possuir seis dígitos e devem estar entre aspas duplas `""`, sendo que "hh" corresponde às horas, "MM" minutos, e "ss" segundos. **Obs**: Caso VALIDATOR_CYCLE2_WORKINGDAYS_WEEKDAYS seja DISABLED, definir este parâmetro como DISABLED também.                                                                                                                                                                                                                                                                                                                                                                                       | ["hhMMss", DISABLED]                     |
| VALIDATOR_CYCLE2_WORKINGDAYS_END      | `"hhMMss"`      | Parâmetro deve possuir seis dígitos e devem estar entre aspas duplas `""`, sendo que "hh" corresponde às horas, "MM" minutos, e "ss" segundos. **Obs**: Caso VALIDATOR_CYCLE2_WORKINGDAYS_WEEKDAYS seja DISABLED, `deve-se` definir este parâmetro como DISABLED também.                                                                                                                                                                                                                                                                                                                                                                             | ["hhMMss", DISABLED]                     |
| VALIDATOR_CYCLE2_SPECIALDAYS_WEEKDAYS | `"Hhh,Hhh,Hhh"` | A lista dos dias da semana de funcionamento deve estar entre aspas duplas '"lista"' e entre cada item deve existir apenas uma vírgula ',' sem espaçamento. Este parâmetro foi criado a fim de atender os casos em que há variação de horário de funcionamento entre os dias da semana (ex: ciclo 2 - nas seg, ter e qua funciona das 08:00:00 ~ 20:00:00 e nas qui e sex, 00:00:00 ~ 23:59:59) Caso não tenha nenhuma exceção de dia da semana e/ou de horário de funcionamento, definir o parâmetro como DISABLED. **Obs**: Caso VALIDATOR_CYCLE2_CUSTOMDAYS seja definido como DISABLED, esse parâmetro também `deve` ser preenchido como DISABLED | ["Sun,Mon,Tue,Wed,Thu,Fri,Sat", DISABLE] |
| VALIDATOR_CYCLE2_SPECIAL_START        | `"hhMMss"`      | Parâmetro deve possuir seis dígitos e devem estar entre aspas duplas `""`, sendo que "hh" corresponde às horas, "MM" minutos, e "ss" segundos. **Obs**: Caso VALIDATOR_CYCLE2_SPECIAL_WEEKDAYS seja DISABLED, `deve-se` definir este parâmetro como DISABLED também.                                                                                                                                                                                                                                                                                                                                                                                 | ["hhMMss", DISABLED]                     |
| VALIDATOR_CYCLE2_SPECIAL_END          | `"hhMMss"`      | Parâmetro deve possuir seis dígitos e devem estar entre aspas duplas `""`, sendo que "hh" corresponde às horas, "MM" minutos, e "ss" segundos. **Obs**: Caso VALIDATOR_CYCLE2_SPECIAL_WEEKDAYS seja DISABLED, `deve-se` definir este parâmetro como DISABLED também.                                                                                                                                                                                                                                                                                                                                                                                 | ["hhMMss", DISABLED]                     |
| VALIDATOR_CYCLE3_CUSTOMDAYS           | `VALOR`         | Para os casos em que há horários de funcionamento distintos entre os dias da semana (ex: padrão do ciclo 1 e 2), parâmetro `deve` ser configurado como ENABLED. Caso contrário (ex: padrão do ciclo 3 e ciclo 4), DISABLED.                                                                                                                                                                                                                                                                                                                                                                                                                          | [ENABLED, DISABLED]                      |
| VALIDATOR_CYCLE3_WORKINGDAYS_WEEKDAYS | `"Hhh,Hhh,Hhh"` | A lista dos dias da semana de funcionamento deve estar entre aspas duplas '"lista"' e entre cada item deve existir apenas uma vírgula ',' sem espaçamento. Caso não tenha nenhuma exceção de dia da semana e/ou de horário de funcionamento, definir o parâmetro como DISABLED. **Obs**: Caso VALIDATOR_CYCLE3_CUSTOMDAYS seja definido como DISABLED, esse parâmetro também `deve` ser preenchido como DISABLED                                                                                                                                                                                                                                     | ["Sun,Mon,Tue,Wed,Thu,Fri,Sat", DISABLE] |
| VALIDATOR_CYCLE3_WORKINGDAYS_START    | `"hhMMss"`      | Parâmetro deve possuir seis dígitos e devem estar entre aspas duplas `""`, sendo que "hh" corresponde às horas, "MM" minutos, e "ss" segundos. **Obs**: Caso VALIDATOR_CYCLE3_WORKINGDAYS_WEEKDAYS seja DISABLED, definir este parâmetro como DISABLED também.                                                                                                                                                                                                                                                                                                                                                                                       | ["hhMMss", DISABLED]                     |
| VALIDATOR_CYCLE3_WORKINGDAYS_END      | `"hhMMss"`      | Parâmetro deve possuir seis dígitos e devem estar entre aspas duplas `""`, sendo que "hh" corresponde às horas, "MM" minutos, e "ss" segundos. **Obs**: Caso VALIDATOR_CYCLE3_WORKINGDAYS_WEEKDAYS seja DISABLED, `deve-se` definir este parâmetro como DISABLED também.                                                                                                                                                                                                                                                                                                                                                                             | ["hhMMss", DISABLED]                     |
| VALIDATOR_CYCLE3_SPECIALDAYS_WEEKDAYS | `"Hhh,Hhh,Hhh"` | A lista dos dias da semana de funcionamento deve estar entre aspas duplas '"lista"' e entre cada item deve existir apenas uma vírgula ',' sem espaçamento. Este parâmetro foi criado a fim de atender os casos em que há variação de horário de funcionamento entre os dias da semana (ex: ciclo 2 - nas seg, ter e qua funciona das 08:00:00 ~ 20:00:00 e nas qui e sex, 00:00:00 ~ 23:59:59) Caso não tenha nenhuma exceção de dia da semana e/ou de horário de funcionamento, definir o parâmetro como DISABLED. **Obs**: Caso VALIDATOR_CYCLE3_CUSTOMDAYS seja definido como DISABLED, esse parâmetro também `deve` ser preenchido como DISABLED | ["Sun,Mon,Tue,Wed,Thu,Fri,Sat", DISABLE] |
| VALIDATOR_CYCLE3_SPECIAL_START        | `"hhMMss"`      | Parâmetro deve possuir seis dígitos e devem estar entre aspas duplas `""`, sendo que "hh" corresponde às horas, "MM" minutos, e "ss" segundos. **Obs**: Caso VALIDATOR_CYCLE3_SPECIAL_WEEKDAYS seja DISABLED, `deve-se` definir este parâmetro como DISABLED também.                                                                                                                                                                                                                                                                                                                                                                                 | ["hhMMss", DISABLED]                     |
| VALIDATOR_CYCLE3_SPECIAL_END          | `"hhMMss"`      | Parâmetro deve possuir seis dígitos e devem estar entre aspas duplas `""`, sendo que "hh" corresponde às horas, "MM" minutos, e "ss" segundos. **Obs**: Caso VALIDATOR_CYCLE3_SPECIAL_WEEKDAYS seja DISABLED, `deve-se` definir este parâmetro como DISABLED também.                                                                                                                                                                                                                                                                                                                                                                                 | ["hhMMss", DISABLED]                     |
| VALIDATOR_CYCLE4_CUSTOMDAYS           | `VALOR`         | Para os casos em que há horários de funcionamento distintos entre os dias da semana (ex: padrão do ciclo 1 e 2), parâmetro `deve` ser configurado como ENABLED. Caso contrário (ex: padrão do ciclo 3 e ciclo 4), DISABLED.                                                                                                                                                                                                                                                                                                                                                                                                                          | [ENABLED, DISABLED]                      |
| VALIDATOR_CYCLE4_WORKINGDAYS_WEEKDAYS | `"Hhh,Hhh,Hhh"` | A lista dos dias da semana de funcionamento deve estar entre aspas duplas '"lista"' e entre cada item deve existir apenas uma vírgula ',' sem espaçamento. Caso não tenha nenhuma exceção de dia da semana e/ou de horário de funcionamento, definir o parâmetro como DISABLED. **Obs**: Caso VALIDATOR_CYCLE4_CUSTOMDAYS seja definido como DISABLED, esse parâmetro também `deve` ser preenchido como DISABLED                                                                                                                                                                                                                                     | ["Sun,Mon,Tue,Wed,Thu,Fri,Sat", DISABLE] |
| VALIDATOR_CYCLE4_WORKINGDAYS_START    | `"hhMMss"`      | Parâmetro deve possuir seis dígitos e devem estar entre aspas duplas `""`, sendo que "hh" corresponde às horas, "MM" minutos, e "ss" segundos. **Obs**: Caso VALIDATOR_CYCLE4_WORKINGDAYS_WEEKDAYS seja DISABLED, definir este parâmetro como DISABLED também.                                                                                                                                                                                                                                                                                                                                                                                       | ["hhMMss", DISABLED]                     |
| VALIDATOR_CYCLE4_WORKINGDAYS_END      | `"hhMMss"`      | Parâmetro deve possuir seis dígitos e devem estar entre aspas duplas `""`, sendo que "hh" corresponde às horas, "MM" minutos, e "ss" segundos. **Obs**: Caso VALIDATOR_CYCLE4_WORKINGDAYS_WEEKDAYS seja DISABLED, `deve-se` definir este parâmetro como DISABLED também.                                                                                                                                                                                                                                                                                                                                                                             | ["hhMMss", DISABLED]                     |
| VALIDATOR_CYCLE4_SPECIALDAYS_WEEKDAYS | `"Hhh,Hhh,Hhh"` | A lista dos dias da semana de funcionamento deve estar entre aspas duplas '"lista"' e entre cada item deve existir apenas uma vírgula ',' sem espaçamento. Este parâmetro foi criado a fim de atender os casos em que há variação de horário de funcionamento entre os dias da semana (ex: ciclo 2 - nas seg, ter e qua funciona das 08:00:00 ~ 20:00:00 e nas qui e sex, 00:00:00 ~ 23:59:59) Caso não tenha nenhuma exceção de dia da semana e/ou de horário de funcionamento, definir o parâmetro como DISABLED. **Obs**: Caso VALIDATOR_CYCLE4_CUSTOMDAYS seja definido como DISABLED, esse parâmetro também `deve` ser preenchido como DISABLED | ["Sun,Mon,Tue,Wed,Thu,Fri,Sat", DISABLE] |
| VALIDATOR_CYCLE4_SPECIAL_START        | `"hhMMss"`      | Parâmetro deve possuir seis dígitos e devem estar entre aspas duplas `""`, sendo que "hh" corresponde às horas, "MM" minutos, e "ss" segundos. **Obs**: Caso VALIDATOR_CYCLE4_SPECIAL_WEEKDAYS seja DISABLED, `deve-se` definir este parâmetro como DISABLED também.                                                                                                                                                                                                                                                                                                                                                                                 | ["hhMMss", DISABLED]                     |
| VALIDATOR_CYCLE4_SPECIAL_END          | `"hhMMss"`      | Parâmetro deve possuir seis dígitos e devem estar entre aspas duplas `""`, sendo que "hh" corresponde às horas, "MM" minutos, e "ss" segundos. **Obs**: Caso VALIDATOR_CYCLE4_SPECIAL_WEEKDAYS seja DISABLED, `deve-se` definir este parâmetro como DISABLED também.                                                                                                                                                                                                                                                                                                                                                                                 | ["hhMMss", DISABLED]                     |

#### Regras de preenchimento para a alteração do validador de iniciação de transação de pagamentos do arranjo PIX do ciclo

| Nome da variável                          | Formatação    | Regra                                                                                                                                                                                                                                       | Valores possíveis                      |
| ----------------------------------------- | ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------- |
| VALIDATOR_CYCLE1_PAYMENTS_LOCALINSTRUMENT | `"MMMM,MMMM"` | A lista dos meios de iniciação de pagamento deve estar entre aspas duplas '"lista"' e entre cada item deve existir apenas uma vírgula ',' sem espaçamento. Caso deseja-se liberar todos os meios de pagamento, definir valor como DISABLED. | ["MANU,DICT,INIC,QRDN,QRES", DISABLED] |
| VALIDATOR_CYCLE2_PAYMENTS_LOCALINSTRUMENT | `"MMMM,MMMM"` | A lista dos meios de iniciação de pagamento deve estar entre aspas duplas '"lista"' e entre cada item deve existir apenas uma vírgula ',' sem espaçamento. Caso deseja-se liberar todos os meios de pagamento, definir valor como DISABLED. | ["MANU,DICT,INIC,QRDN,QRES", DISABLED] |
| VALIDATOR_CYCLE3_PAYMENTS_LOCALINSTRUMENT | `"MMMM,MMMM"` | A lista dos meios de iniciação de pagamento deve estar entre aspas duplas '"lista"' e entre cada item deve existir apenas uma vírgula ',' sem espaçamento. Caso deseja-se liberar todos os meios de pagamento, definir valor como DISABLED. | ["MANU,DICT,INIC,QRDN,QRES", DISABLED] |
| VALIDATOR_CYCLE4_PAYMENTS_LOCALINSTRUMENT | `"MMMM,MMMM"` | A lista dos meios de iniciação de pagamento deve estar entre aspas duplas '"lista"' e entre cada item deve existir apenas uma vírgula ',' sem espaçamento. Caso deseja-se liberar todos os meios de pagamento, definir valor como DISABLED. | ["MANU,DICT,INIC,QRDN,QRES", DISABLED] |

### Serviços auxiliares

Serviços auxiliares foram criados em Java a fim de facilitar a implementação do conector.

Os serviços e suas respectivas funcionalidades são:

| Nome do serviço | Descrição                                                                       | Comando de chamada no arquivo .xml   |
| --------------- | ------------------------------------------------------------------------------- | ------------------------------------ |
| getDayOfTheWeek | Obter o dia da semana atual em inglês no padrão `EEE` (ex: "Fri" - sexta-feira) | `${bean:camelUtils.getDayOfTheWeek}` |

Exemplo de chamada do serviço getDayOfTheWeek:

```xml
<setProperty name="currentWeekday">
  <simple>${bean:camelUtils.getDayOfTheWeek}</simple>
</setProperty>
```

### Criação de arquivo de rota customizada

A solução desenvolvida pela OPUS permite que a instituição parceira construa seu
próprio serviço de aprovação de criação de consentimento, apontando para uma base
de clientes externa. Neste caso, a instuição deve solicitar à Opus o código fonte
do conector.

Exemplo de comando utilizado no `Dockerfile` para adicionar o arquivo da rota
`approvePaymentConsentCreation` criado pela instituição parceira:

```dockerfile
ARG approvePaymentRoute=file:/specs/custom-approvePaymentConsentCreation-routes.xml
ENV camel.main.routes-include-pattern=$approvePaymentRoute
```

## Verificação do status do pagamento agendado no sistema legado da instituição

A verificação do status do pagamento agendado é o ponto de integração entre o
Opus Open Banking e o sistema legado da instituição responsável pela atualização
do status do consentimento para os casos em que o pagamento é revogado fora do
sistema do Opus Open Banking.

### O que mudou com a adição do pagamento agendado?

Foi definido pelo [Open Banking Brasil - OBB](https://openbanking-brasil.github.io/areadesenvolvedor/#fase-3-apis-do-open-banking-brasil) que um novo valor possível para o status do
consentimento será adicionado: REVOKED (REVOGADO). O status de um consentimento
só poderá ser alterado para REVOKED, quando seu status atual for CONSUMED, e seu respectivo pagamento for do tipo
agendado e cancelado por algum motivo, seja pelo próprio usuário ou pela
instituição iniciadora ou detentora do pagamento.

A razão para a criação de uma rota de verificação do status do pagamento agendado
é devido à possibilidade de cancelar o pagamento fora do sistema do Opus Open Banking,
sendo necessário existir um meio que permita verificar a situação do pagamento a
fim de atualizar as informações de seu respectivo
consentimento, caso ele seja revogado.

### Momentos da verificação do status do pagamento no sistema legado

O único momento em que a verificação do status do pagamento no sistema legado
ocorrerá é durante a verificação das informações de um consentimento através do
serviço GET Consent.

Para não ocorrer chamadas desnecessárias no sistema legado,
foram definidas as seguintes condições:

- O pagamento ao qual o consentimento se refere deve ser do tipo agendado;
- O status atual do consentimento deve ser CONSUMED;
- Durante a última verificação, foi informado que o pagamento ainda não tinha
sido finalizado, e nem revogado;

A tabela a seguir lista os pontos de integração para a verificação do status do pagamento:

| Tipo do consentimento | Nome da rota Camel                         |
| --------------------- | ------------------------------------------ |
| Pagamento             | ```direct:checkPaymentStatus```            |

A tabela a seguir corresponde aos schemas do Request e do Response do conector:

| Tipo     | JSON Schema                                                                                       | Exemplo |
| -------- | ------------------------------------------------------------------------------------------------- | ------- |
| Request  | [checkPaymentStatus-request.json](../schemas/v2/consent/checkPaymentStatus/request-schema.json)   | [checkPaymentStatus-request-example.json](../schemas/v2/consent/checkPaymentStatus/request-example.json) |
| Response | [checkPaymentStatus-response.json](../schemas/v2/consent/checkPaymentStatus/response-schema.json) | [checkPaymentStatus-response-example.json](../schemas/v2/consent/checkPaymentStatus/response-example.json) |

Vale a pena ressaltar que para qualquer resposta obtida pelo conector que não
siga os padrões definidos pelo schema acima - seja erro, má formatação ou falta
de informação - as informações apresentadas ao usuário durante a chamada para o
serviço do GET Consent serão aquelas já existentes no sistema do Opus Open Banking.
Dessa forma, caso o pagamento tenha sido cancelado fora do sistema do
Opus Open Banking, as informações apresentadas ao usuário estarão desatualizadas.
No entanto, na próxima vez em que ocorrer a pesquisa do mesmo consentimento, a
verificação de seu respectivo pagamento no sistema legado ocorrerá novamente, e
caso o retorno obtido atenda os padrões definidos, seus dados serão atualizados 
e apresentados de forma correta ao usuário.

A tabela abaixo possui mais alguns exemplos de respostas que a rota checkPaymentStatus pode retornar:

| Caso | Exemplo de Resposta                         |
| --------------------- | ------------------------------------------ |
| Revogação realizada pelo USER             | [revokedByUser.json](../schemas/v2/consent/checkPaymentStatus/response-examples/response_revokedByUser.json) |
| Revogação realizada pelo TPP             | [revokedByTPP.json](../schemas/v2/consent/checkPaymentStatus/response-examples/response_revokedByTPP.json) |
| Revogação realizada pelo ASPSP             | [revokedByASPSP.json](../schemas/v2/consent/checkPaymentStatus/response-examples/response_revokedByASPSP.json) |
| Pagamento rejeitado sem revogação             | [rejected.json](../schemas/v2/consent/checkPaymentStatus/response-examples/response_rejectedPayment.json) |
| Pagamento pendente             | [pendingPayment.json](../schemas/v2/consent/checkPaymentStatus/response-examples/response_pendingPayment.json) |

Já os **headers** enviados para a rota checkPaymentStatus são:
| Nome do campo | Descrição                                             | Tipo          |
| ------------- | ------------------------------------------------------| ------------- |
| correlationId | CorrelationId correspondente ao GET Consent realizado | String        |


## Revogação do consentimento de pagamento

A revogação de um consentimento de pagamento só é possível para o caso do pagamento 
ser do tipo Pix Agendado, o consentimento estar consumido (status CONSUMED) e a data 
da solicitação de revogação ser até o dia anterior, ou seja, a meia noite no fuso 
horário de Brasília do dia imediatamente anterior a data alvo da liquidação do pagamento. 
Com a revogação o status do consentimento é atualizado para REVOKED.

A rota para realizar a revogação de um pagamento Pix Agendado foi criada para atender o que foi 
definido no guia de experiência do usuário, possibilitando estes 5 cenários de revogação:

1.	Revogação pelo usuário na iniciadora na área de gestão de pagamentos do open banking 
2.	Revogação pelo usuário na detentora na área de gestão de pagamentos do open banking 
3.	Revogação pelo usuário na detentora na área de gestão de Pix
4.	Revogação pela iniciadora sem a presença do usuário
5.	Revogação pela detentora sem a presença do usuário

A tabela a seguir lista o ponto de integração para a revogação do consentimento do  pagamento:

| Tipo do consentimento | Nome da rota Camel                         |
| --------------------- | ------------------------------------------ |
| Pagamento             | ```direct:consentPaymentRevocation```            |

A tabela a seguir corresponde aos schemas do Request e do Response do conector:

| Tipo     | JSON Schema                                                                                           | Exemplo |
| -------- | ----------------------------------------------------------------------------------------------------- | ------- |
| Request  | [revokeConsentPayment-request.json](../schemas/v2/consent/revokeConsentPayment/request-schema.json)   | [revokeConsentPayment-request-example.json](../schemas/v2/consent/revokeConsentPayment/request-example.json) |

| Response | [revokeConsentPayment-response.json](../schemas/v2/consent/revokeConsentPayment/response-schema.json) | [revokeConsentPayment-response-example.json](../schemas/v2/consent/revokeConsentPayment/response-example.json) |

Caso seja enviado um payload na requisição que não atenda ao objeto definido no JSON Schema
ou não seja possível regovar o consentimento do pagamento por não atender os requisitos que 
possibilitem a revogação, será retornado um objeto de erro a exemplo deste  
[revokeConsentPayment-response-error-schema.json](../schemas/v2/revokeConsentPayment/response-error-schema.json)