# API Open Data

This document presents the **Camel Routes** and **Supported Configurations** for the open-data service, which corresponds to the combination of the following Open Finance Brasil APIs:

&nbsp;

- [Canais de atendimento (Channels)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17368301/API+-+Canais+de+Atendimentos)
- [Produtos e Serviços (Product and services)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17367858/API+-+Produtos+e+Servi+os)
- [Contas (Accounts)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/180257084/DA+API+-+Contas)
- [Cartão de Crédito (Credit card)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/180257194/DA+API+-+Cart+o+de+Cr+dito)
- [Adiantamento de Recebíveis (Invoice financings)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/180061315/DA+API+-+Adiantamento+de+Receb+veis)
- [Empréstimos (Loans)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/180256974/DA+API+-+Empr+stimos)
- [Financiamentos (Financings)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/180257414/DA+API+-+Financiamentos)
- [Adiantamento a Depositantes (Unarranged account overdraft)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/180257304/DA+API+-+Adiantamento+a+Depositantes)
- [Títulos de Capitalização (Capitalization titles)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17368637/API+-+T+tulos+de+Capitaliza+o)
- [Investimentos (Investments)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17368743/API+-+Investimentos)
- [Câmbio (Exchange)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17368866/API+-+C+mbio)
- [Credenciamento (Acquiring services)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17368974/API+-+Credenciamento)
- [Previdência (Pension)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17369082/API+-+Previd+ncia)
- [Seguros (Insurance)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17369190/API+-+Seguros)

&nbsp;

To ensure this service functions properly for each of the endpoints of the APIs mentioned above, one or more plugins should be created containing routes for each of the [Camel Routes](#rotas-do-camel) presented here.

&nbsp;

## Supported Configuration Variables

&nbsp;

By default, the application allows modification of some configurations via environment variables, which can be injected via `Dockerfile`, `docker build`, or during image execution (via `docker run`).

The table below lists the variables currently supported.

| Variable                                 | Purpose                                                                                                                       | Default Value |
| ---------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ------------- |
| camel.main.routes-include-pattern        | Indicates the locations where Camel should look for routes                                                                   |               |
| apis.validation.openapi.enabled-request  | Enables validation of request objects received by the API against the Open Finance Brasil specification                      | true          |
| apis.validation.openapi.enabled-response | Enables validation of response objects returned by the API against the Open Finance Brasil specification (affects performance) | false         |

&nbsp;

**Important**: In addition to the variables listed above, depending on the Quarkus Camel component(s) that the plugin uses, there may be others as specified in the documentation of the component being used. Furthermore, the plugin can create its own environment variables to be injected.

&nbsp;

## Camel Routes

The following subsections contain all the `endpoints` that need to have routes defined in Camel and for which one or more plugins must be created.

For the endpoint `/personal-accounts`, for example, the route should be defined in the plugin as:

```xml
<from uri="direct:getPersonalAccounts"/>
```

The responses sent by each of these routes must be in the format specified on the [Open Finance Brasil portal](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17367790/Dados+Abertos) for the API corresponding to the route.

**Important**: The open-data service is responsible for pagination and caching of the response, so the *meta* and *links* fields may be omitted. If they are sent, they will be ignored by the service.

## Default Routes

For cases where the connector consists of only a GET request to a service, the Opus Open Finance product provides default routes for each of the open-data `endpoints` listed here.

To activate the default route, the configuration `OOB_CONNECTOR_SERVICEURI_<ROUTE>` must be included, as described in the [product configuration instructions](../../deploy/oob-open-data/readme.md#oob_connector_serviceuri).

The default route will cache the query result, making a new query every **180 seconds**.

**Important**: The default route will only be activated if no connector is included for the original route. If the connector does not exist and this configuration is not included, execution of the `endpoint` will result in `HTTP 404 - Not Found`.

&nbsp;

### Canais de atendimento

&nbsp;

| Endpoint                          | Camel Route                                   |
| --------------------------------- | --------------------------------------------- |
| /branches                         | ```direct:getBranches```                      |
| /electronic-channels              | ```direct:getElectronicChannels```            |
| /phone-channels                   | ```direct:getPhoneChannels```                 |
| /banking-agents                   | ```direct:getBankingAgents```                 |
| /shared-automated-teller-machines | ```direct:getSharedAutomatedTellerMachines``` |

### Produtos e Serviços

&nbsp;

| Endpoint                                     | Camel Route                                        |
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

### Contas

&nbsp;

| Endpoint                                     | Camel Route                                      |
|----------------------------------------------|--------------------------------------------------|
| /personal-accounts                           | ```direct:getOpenDataPersonalAccounts```         |
| /business-accounts                           | ```direct:getOpenDataBusinessAccounts```         |

&nbsp;

### Cartão de Crédito

&nbsp;

| Endpoint                                     | Camel Route                                       |
|----------------------------------------------|---------------------------------------------------|
| /personal-credit-cards                       | ```direct:getOpenDataPersonalCreditCards```       |
| /business-credit-cards                       | ```direct:getOpenDataBusinessCreditCards```       |

&nbsp;

### Adiantamento de Recebíveis

&nbsp;

| Endpoint                                     | Camel Route                                            |
|----------------------------------------------|--------------------------------------------------------|
| /personal-invoice-financings                 | ```direct:getOpenDataPersonalInvoiceFinancings```      |
| /business-invoice-financings                 | ```direct:getOpenDataBusinessInvoiceFinancings```      |

&nbsp;

### Empréstimos

&nbsp;

| Endpoint                                     | Camel Route                                      |
|----------------------------------------------|--------------------------------------------------|
| /personal-loans                              | ```direct:getOpenDataPersonalLoans```            |
| /business-loans                              | ```direct:getOpenDataBusinessLoans```            |

&nbsp;

### Financiamentos

&nbsp;

| Endpoint                                     | Camel Route                                      |
|----------------------------------------------|--------------------------------------------------|
| /personal-financings                         | ```direct:getOpenDataPersonalFinancings```       |
| /business-financings                         | ```direct:getOpenDataBusinessFinancings```       |

&nbsp;

### Adiantamento a Depositantes

&nbsp;

| Endpoint                                     | Camel Route                                              |
|----------------------------------------------|----------------------------------------------------------|
| /personal-unarranged-account-overdraft       | ```direct:getOpenDataPersonalUnarrangedAccountOverdraft```|
| /business-unarranged-account-overdraft       | ```direct:getOpenDataBusinessUnarrangedAccountOverdraft```|

&nbsp;

### Títulos de Capitalização

&nbsp;

| Endpoint | Camel Route         |
|----------|---------------------|
| /bonds   | ```direct:getBonds```|

&nbsp;

### Investimentos

&nbsp;

| Endpoint              | Camel Route                                   |
|-----------------------|-----------------------------------------------|
| /funds                | ```direct:getFundsInvestments```              |
| /bank-fixed-incomes   | ```direct:getFixedIncomeBankInvestments```    |
| /credit-fixed-incomes | ```direct:getFixedIncomeCreditInvestments```  |
| /variable-incomes     | ```direct:getVariableIncomeInvestments```     |
| /treasure-titles      | ```direct:getTreasureInvestments```           |

&nbsp;

### Câmbio

&nbsp;

| Endpoint      | Camel Route                       |
|---------------|-----------------------------------|
| /online-rates | ```direct:getExchangeOnlineRate```|
| /vet-values   | ```direct:getExchangeVetValue```  |

&nbsp;

### Credenciamento

&nbsp;

| Endpoint    | Camel Route                             |
|-------------|-----------------------------------------|
| /personals  | ```direct:getPersonalAcquiringServices```|
| /businesses | ```direct:getBusinessAcquiringServices```|

&nbsp;

### Previdência

&nbsp;

| Endpoint            | Camel Route                            |
|---------------------|-----------------------------------------|
| /risk-coverages     | ```direct:getPensionRiskCoverages```    |
| /survival-coverages | ```direct:getPensionSurvivalCoverages```|

&nbsp;

### Seguros

&nbsp;

| Endpoint     | Camel Route                             |
|--------------|-----------------------------------------|
| /automotives | ```direct:getAutomotiveInsurance```     |
| /homes       | ```direct:getHomeInsurance```           |
| /personals   | ```direct:getPersonalInsurance```       |

&nbsp;
