# API Open Data

Esse documento apresenta as **Rotas do Camel** e **Configurações Suportadas** para
o serviço de open-data, o qual equivale à junção das seguintes API do
Open Finance Brasil:

&nbsp;

- [Canais de atendimento](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17368301/API+-+Canais+de+Atendimentos)
- [Produtos e Serviços](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17367858/API+-+Produtos+e+Servi+os)
- [Títulos de Capitalização](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17368637/API+-+T+tulos+de+Capitaliza+o)
- [Investimentos](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17368743/API+-+Investimentos)
- [Câmbio](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17368866/API+-+C+mbio)
- [Credenciamento](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17368974/API+-+Credenciamento)
- [Previdência](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17369082/API+-+Previd+ncia)
- [Seguros](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17369190/API+-+Seguros)

&nbsp;

A fim de que esse serviço funcione propriamente para cada um dos endpoints das APIs
acima citadas, deve-se criar um ou mais plugins que contenham rotas para cada uma
das [Rotas do Camel](#rotas-do-camel) aqui apresentadas.

&nbsp;

## Variáveis de Configuração Suportadas

&nbsp;

Por padrão, a aplicação permite a modificação de algumas configurações via variáveis
de ambiente, as quais podem ser injetadas via `Dockerfile`, `docker build` ou execução
da imagem (via `docker run`).

A tabela abaixo contém uma lista das variáveis suportadas atualmente.

| Variável                                 | Objetivo                                                                                                                        | Valor Padrão |
| ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- | ------------ |
| camel.main.routes-include-pattern        | Indica os locais onde o Camel deve procurar por rotas                                                                      |            |
| apis.validation.openapi.enabled-request  | Habilita a validação dos objetos de request recebidos pela API com a especificação do Open Finance Brasil                       | true         |
| apis.validation.openapi.enabled-response | Habilita a validação dos objetos de response devolvidos pela API com a especificação do Open Finance Brasil (afeta performance) | false        |

&nbsp;

**Importante**: Além das variáveis acima apresentada, dependendo do(s) componente(s)
do quarkus camel que o plugin venha a utilizar, poderão existir outras de acordo
com o que estiver específicado na própria documentação do componente sendo utilizado.
Além disso, o plugin pode criar suas próprias variáveis de ambiente a serem injetadas.

&nbsp;

## Rotas do Camel

As subseções seguintes contêm todos os `endpoints` que precisam ter rotas definidas
no camel e para os quais é necessário a criação de um ou mais plugins.

Para o endpoint `/personal-accounts`, por exemplo, a rota deve estar
definida no plugin como:

```xml
<from uri="direct:getPersonalAccounts"/>
```

As respostas enviadas por cada um destas rotas deve estar no formato especificado
no portal do [Open Finance Brasil](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17367790/Dados+Abertos)
para a API correspondente a rota.

**Importante**: O serviço de open-data é responsável pela paginação e cacheamento
do retorno, assim, os campos *meta* e *links* podem ser omitidos.
Caso estes sejam enviados, serão ignorados pelo serviço.

## Rotas Padrão

Para casos em que o conector é formado apenas de uma chamada
GET a um serviço, o produto Opus Open Finance fornece rotas padrões para cada
um dos `endpoints` de dados abertos aqui listados.

Para que a rota padrão seja acionada, a configuração `OOB_CONNECTOR_SERVICEURI_<ROUTE>`
deve ser incluída, assim como descrito nas [instruções de configuração do produto](../../deploy/oob-open-data/readme.md#oob_connector_serviceuri).

A rota padrão armazenará o resultado da consulta em cache, realizando uma nova
consulta após **180 segundos**.

**Importante**: A rota padrão será ativada apenas se nenhum conector for incluído
para a rota original. Caso o conector não exista e essa configuração não seja incluída,
a execução do `endpoint` resultará em `HTTP 404 - Not Found`.

&nbsp;

### Canais de atendimento

&nbsp;

| Endpoint                          | Rota do Camel                                 |
| --------------------------------- | --------------------------------------------- |
| /branches                         | ```direct:getBranches```                      |
| /electronic-channels              | ```direct:getElectronicChannels```            |
| /phone-channels                   | ```direct:getPhoneChannels```                 |
| /banking-agents                   | ```direct:getBankingAgents```                 |
| /shared-automated-teller-machines | ```direct:getSharedAutomatedTellerMachines``` |

### Produtos e Serviços

&nbsp;

| Endpoint                                     | Rota do Camel                                      |
|----------------------------------------------|----------------------------------------------------|
| /personal-accounts                           | ```direct:getPersonalAccounts```                   |
| /business-accounts                           | ```direct:getBusinessAccounts```                   |
| /personal-credit-cards                       | ```direct:getPersonalCreditCards```                |
| /business-credit-cards                       | ```direct:getBusinessCreditCards```                |
| /personal-financings                         | ```direct:getPersonalFinancings```                 |
| /business-financings                         | ```direct:getBusinessFinancings```                 |
| /personal-invoice-financings                 | ```direct:getPersonalInvoiceFinancings```          |
| /business-invoice-financings                 | ```direct:getBusinessInvoiceFinancings```          |
| /personal-loans                              | ```direct:getPersonalLoans```                      |
| /business-loans                              | ```direct:getBusinessLoans```                      |
| /personal-unarranged-account-overdraft       | ```direct:getPersonalUnarrangedAccountOverdraft``` |
| /business-unarranged-account-overdraft       | ```direct:getBusinessUnarrangedAccountOverdraft``` |

&nbsp;

### Títulos de Capitalização

&nbsp;

| Endpoint | Rota do Camel         |
|----------|-----------------------|
| /bonds   | ```direct:getBonds``` |

&nbsp;

### Investimentos

&nbsp;

| Endpoint              | Rota do Camel                                 |
|-----------------------|-----------------------------------------------|
| /funds                | ```direct:getFundsInvestments```              |
| /bank-fixed-incomes   | ```direct:getFixedIncomeBankInvestments```    |
| /credit-fixed-incomes | ```direct:getFixedIncomeCreditInvestments```  |
| /variable-incomes     | ```direct:getVariableIncomeInvestments```     |
| /treasure-titles      | ```direct:getTreasureInvestments```           |

&nbsp;

### Câmbio

&nbsp;

| Endpoint      | Rota do Camel                      |
|---------------|------------------------------------|
| /online-rates | ```direct:getExchangeOnlineRate``` |
| /vet-values   | ```direct:getExchangeVetValue```   |

&nbsp;

### Credenciamento

&nbsp;

| Endpoint    | Rota do Camel                             |
|-------------|-------------------------------------------|
| /personals  | ```direct:getPersonalAcquiringServices``` |
| /businesses | ```direct:getBusinessAcquiringServices``` |

&nbsp;

### Previdência

&nbsp;

| Endpoint            | Rota do Camel                            |
|---------------------|------------------------------------------|
| /risk-coverages     | ```direct:getPensionRiskCoverages```     |
| /survival-coverages | ```direct:getPensionSurvivalCoverages``` |

&nbsp;

### Seguros

&nbsp;

| Endpoint     | Rota do Camel                              |
|--------------|--------------------------------------------|
| /automotives | ```direct:getAutomotiveInsurance```        |
| /homes       | ```direct:getHomeInsurance```              |
| /personals   | ```direct:getPersonalInsurance```          |

&nbsp;
