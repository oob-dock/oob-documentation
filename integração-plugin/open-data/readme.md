# API Open Data

Esse documento apresenta as **Rotas do Camel** e **Configurações Suportadas** para
o serviço de open-data, o qual equivale à junção das seguintes API do
Open Banking Brasil:

&nbsp;

- [Canais de atendimento](https://openbankingbrasil.atlassian.net/wiki/spaces/OB/pages/33686119/Informa+es+T+cnicas+-+Canais+de+Atendimentos+-+v1.0.2)
- [Produtos e Serviços](https://openbankingbrasil.atlassian.net/wiki/spaces/OB/pages/1736880/Informa+es+T+cnicas+-+Produtos+e+Servi+os+-+v1.0.2)
- [Títulos de Capitalização](https://openbankingbrasil.atlassian.net/wiki/spaces/OB/pages/46432740/Informa+es+T+cnicas+-+T+tulos+de+Capitaliza+o+-+v1.0.0-rc1.0)
- [Investimentos](https://openbankingbrasil.atlassian.net/wiki/spaces/OB/pages/47546407/Informa+es+T+cnicas+-+Investimentos+-+v1.0.0-rc1.0)
- [Câmbio](https://openbankingbrasil.atlassian.net/wiki/spaces/OB/pages/48005281/Informa+es+T+cnicas+-+C+mbio+-+v1.0.0-rc1.0)
- [Credenciamento](https://openbankingbrasil.atlassian.net/wiki/spaces/OB/pages/48005288/Informa+es+T+cnicas+-+Credenciamento+-+v1.0.0-rc1.0)
- [Previdência](https://openbankingbrasil.atlassian.net/wiki/spaces/OB/pages/47906992/Informa+es+T+cnicas+-+Previd+ncia+-+v1.0.0-rc1.0)
- [Seguros](https://openbankingbrasil.atlassian.net/wiki/spaces/OB/pages/48038088/Informa+es+T+cnicas+-+Seguros+-+v1.0.0-rc1.0)

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
| apis.validation.json-schema.enabled      | Habilita a validação dos objetos de request/response envidados/recebidos pelo plugin com as specs definidas (afeta performance) | false        |
| apis.validation.openapi.enabled-request  | Habilita a validação dos objetos de request recebidos pela API com a especificação do Open Banking Brasil                       | true         |
| apis.validation.openapi.enabled-response | Habilita a validação dos objetos de response devolvidos pela API com a especificação do Open Banking Brasil (afeta performance) | false        |

&nbsp;

**Além das variáveis acima apresentada, dependendo do(s) componente(s) do quarkus
camel que o plugin venha a utilizar, poderão existir outras de acordo com o que
estiver específicado na própria documentação do componente sendo utilizado. Além
disso, o plugin pode criar suas próprias variáveis de ambiente a serem injetadas.

&nbsp;

## Rotas do Camel

As subseções seguintes contêm todos os `endpoints` que precisam ter rotas defnidas
no camel e para os quais é necessário a criação de um ou mais plugins.

Para o endpoint `/personal-accounts`, por exemplo, a rota deve estar
definida no plugin como:

```xml
<from uri="direct:getPersonalAccounts"/>
```

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

| Endpoint              | Rota do Camel                      |
|-----------------------|------------------------------------|
| /funds                | ```direct:getFunds```              |
| /bank-fixed-incomes   | ```direct:getBankFixedIncomes```   |
| /credit-fixed-incomes | ```direct:getCreditFixedIncomes``` |
| /variable-incomes     | ```direct:getVariableIncomes```    |
| /treasure-titles      | ```direct:getTreasureTitles```     |

&nbsp;

### Câmbio

&nbsp;

| Endpoint      | Rota do Camel               |
|---------------|-----------------------------|
| /online-rates | ```direct:getOnlineRates``` |
| /vet-values   | ```direct:getVetValues```   |

&nbsp;

### Credenciamento

&nbsp;

| Endpoint    | Rota do Camel              |
|-------------|----------------------------|
| /personals  | ```direct:getPersonals```  |
| /businesses | ```direct:getBusinesses``` |

&nbsp;

### Previdência

&nbsp;

| Endpoint            | Rota do Camel                     |
|---------------------|-----------------------------------|
| /risk-coverages     | ```direct:getRiskCoverages```     |
| /survival-coverages | ```direct:getSurvivalCoverages``` |

&nbsp;

### Seguros

&nbsp;

| Endpoint     | Rota do Camel                      |
|--------------|------------------------------------|
| /automotives | ```direct:getAutomitives```        |
| /homes       | ```direct:getHomes```              |
| /personals   | ```direct:getInsurancePersonals``` |

&nbsp;
