# API Financial Data

This document presents the **Camel Routes** and **Supported Configurations** for the financial data service, which corresponds to the combination of the following Open Finance Brazil APIs:

&nbsp;

- [Dados Cadastrais (Personal data)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17370003/API+-+Dados+Cadastrais)
- [Cartão de Crédito (Credit card)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17370864/API+-+Cart+o+de+Cr+dito)
- [Contas (Accounts)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17371726/API+-+Contas)
- [Operações de Crédito - Empréstimos (Loans)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17372520/API+-+Opera+es+de+Cr+dito+-+Empr+stimos)
- [Operações de Crédito - Financiamentos (financings)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17373362/API+-+Opera+es+de+Cr+dito+-+Financiamento)
- [Operações de Crédito - Adiantamento a Depositantes (Unarranged-accounts-overdraft)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17374226/API+-+Opera+es+de+Cr+dito+-+Adiantamento+a+Depositantes)
- [Operações de Crédito - Direitos Creditórios Descontados (Invoice-financings)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17375055/API+-+Opera+es+de+Cr+dito+-+Direitos+Credit+rios+Descontados)
- [Investimentos - Renda Fixa Bancária (Bank fixed incomes)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/75006394/API+-+Investimentos+-+Renda+Fixa+Banc+ria)
- [Investimentos - Renda Fixa Crédito (Credit fixed incomes)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/75005953/API+-+Investimentos+-+Renda+Fixa+Cr+dito)
- [Investimentos - Renda Variável (Variable incomes)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/82378753/API+-+Investimentos+-+Renda+Vari+vel)
- [Investimentos - Títulos do Tesouro Direto (Treasure titles)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/86605826/API+-+Investimentos+-+T+tulos+do+Tesouro+Direto)
- [Investimentos - Fundos de Investimento (Investment funds)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/89784321/API+-+Investimentos+-+Fundos+de+Investimento)
- [Câmbio (Exchange)](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/114032641/DC+API+-+C+mbio)

&nbsp;

To ensure this service functions properly for each of the endpoints of the APIs mentioned above, one or more plugins should be created containing routes for each of the [Camel Routes](#rotas-do-camel) presented here.

&nbsp;

## Supported Configuration Variables

&nbsp;

By default, the application allows modification of some configurations via environment variables, which can be injected via `Dockerfile`, `docker build`, or during image execution (via `docker run`).

The table below lists the variables currently supported.

| Variable                              | Purpose                                                              | Default Value |
|---------------------------------------|---------------------------------------------------------------------------------------------------------------------------------|--------------|
| camel.main.routes-include-pattern     | Indicates the locations where Camel should look for routes                                                                           |              |
| apis.validation.json-schema.enabled   | Enables validation of the request/response objects sent/received by the plugin against defined specs (affects performance) | false        |
| apis.validation.openapi.enabled-request       | Enables validation of request objects received by the API against the Open Finance Brazil specification   | true         |
| apis.validation.openapi.enabled-response       | Enables validation of response objects returned by the API against the Open Finance Brazil specification (affects performance)   | false         |

&nbsp;

**In addition to the variables presented above, depending on the Quarkus Camel component(s) that the plugin uses, there may be others as specified in the documentation of the component being used. Furthermore, the plugin can create its own environment variables to be injected.

&nbsp;

## Camel Routes

The following subsections contain all the `endpoints` that need to have routes defined in Camel and for which one or more plugins must be created.

For the endpoint `/accounts/{accountId}/balances`, for example, the route should be defined in the plugin as:

\```xml
<from uri="direct:accountsGetAccountsAccountIdBalances"/>
\```

Routes related to version 1 endpoints can be found [here](routes-v1.md).

Routes related to version 2 endpoints can be found [here](routes-v2.md).
