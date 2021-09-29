# API Financial Data

Esse documento apresenta as **Rotas do Camel** e **Configurações Suportadas** para
o serviço de financial data, o qual equivale à junção das seguintes API do
Open Banking Brasil:

&nbsp;

- [Dados Cadastrais](https://openbanking-brasil.github.io/areadesenvolvedor/#fase-2-apis-do-open-banking-brasil-api-dados-cadastrais)
- [Cartão de Crédito](https://openbanking-brasil.github.io/areadesenvolvedor/#lista-de-cartoes-de-credito)
- [Contas](https://openbanking-brasil.github.io/areadesenvolvedor/#lista-de-contas)
- [Operações de Crédito - Empréstimos](https://openbanking-brasil.github.io/areadesenvolvedor/#emprestimos)
- [Operações de Crédito - Financiamentos](https://openbanking-brasil.github.io/areadesenvolvedor/#financiamentos-contrato)
- [Operações de Crédito - Adiantamento a Depositantes](https://openbanking-brasil.github.io/areadesenvolvedor/#adiantamento-a-depositantes-contrato)
- [Operações de Crédito - Direitos Creditórios Descontados](https://openbanking-brasil.github.io/areadesenvolvedor/#direitos-creditorios-descontados-contrato)

&nbsp;

A fim de que esse serviço funcione propriamente para cada um dos endpoints das APIs
acima citadas, deve-se criar um ou mais plugins que contenham rotas para cada uma
das [Rotas do Camel](#rotas-do-camel) aqui apresentadas.

&nbsp;

## Variáveis de Configuração Suportadas

&nbsp;

Por padrão, a aplicação permite a modificação de algumas configurações via variáveis
de ambiente, as quais podem ser injetadas via `Dockerfile`, `docker build` ou exeção
da imagem (via `docker run`).

A tabela abaixo contém uma lista das variáveis suportadas atualmente.

| Variável                              | Objetivo                                                              | Valor Padrão |
|---------------------------------------|---------------------------------------------------------------------------------------------------------------------------------|--------------|
| camel.main.routes-include-pattern     | Indica os locais onde o Camel deve procurar por rotas                                                                           |              |
| apis.validation.json-schema.enabled   | Habilita a validação dos objetos de request/response envidados/recebidos pelo plugin com as specs definidas (afeta performance) | false        |
| apis.validation.openapi.enabled-request       | Habilita a validação dos objetos de request recebidos pela API com a especificação do Open Banking Brasil   | true         |
| apis.validation.openapi.enabled-response       | Habilita a validação dos objetos de response devolvidos pela API com a especificação do Open Banking Brasil (afeta performance)   | false         |

&nbsp;

**Além das variáveis acima apresentada, dependendo do(s) componente(s) do quarkus
camel que o plugin venha a utilizar, poderão existir outras de acordo com o que
estiver específicado na própria documentação do componente sendo utilizado. Além
disso, o plugin pode criar suas próprias variáveis de ambiente a serem injetadas.

&nbsp;

## Rotas do Camel

As subseções seguintes contêm todos os `endpoints` que precisam ter rotas defnidas
no camel e para os quais é necessário a criação de um ou mais plugins.

Para o endpoint `/accounts/{accountId}/balances`, por exemplo, a rota deve estar

definida no plugin como:

```xml
<from uri="direct:accountsGetAccountsAccountIdBalances"/>
```

&nbsp;

### Accounts

&nbsp;

| Endpoint                                  | Rota do Camel                                             |
|-------------------------------------------|-----------------------------------------------------------|
| /accounts                                 | ```direct:accountsGetAccounts```                          |
| /accounts/\{accountId\}                   | ```direct:accountsGetAccountsAccountId```                 |
| /accounts/\{accountId\}/balances          | ```direct:accountsGetAccountsAccountIdBalances```         |
| /accounts/\{accountId\}/transactions      | ```direct:accountsGetAccountsAccountIdTransactions```     |
| /accounts/\{accountId\}/overdraft-limits  | ```direct:accountsGetAccountsAccountIdOverdraftLimits```  |

&nbsp;

### Credit Cards

&nbsp;

| Endpoint                                                          | Rota do Camel                                                                 |
|-------------------------------------------------------------------|-------------------------------------------------------------------------------|
| /accounts                                                         | ```direct:creditCardsGetAccounts```                                           |
| /accounts/\{creditCardAccountId\}                                 | ```direct:creditCardsGetAccountsCreditCardAccountId```                        |
| /accounts/\{creditCardAccountId\}/bills                           | ```direct:creditCardsGetAccountsCreditCardAccountIdBills```                   |
| /accounts/\{creditCardAccountId\}/bills/\{billId\}/transactions   | ```direct:creditCardsGetAccountsCreditCardAccountIdBillsBillIdTransactions``` |
| /accounts/\{creditCardAccountId\}/limits                          | ```direct:creditCardsGetAccountsCreditCardAccountIdLimits```                  |
| /accounts/\{creditCardAccountId\}/transactions                    | ```direct:creditCardsGetAccountsCreditCardAccountIdTransactions```            |

&nbsp;

### Customers

&nbsp;

| Endpoint                      | Rota do Camel                                         |
|-------------------------------|-------------------------------------------------------|
| /personal/identifications     | ```direct:customersGetPersonalIdentifications```      |
| /personal/qualifications      | ```direct:customersGetPersonalQualifications```       |
| /personal/financial-relations | ```direct:customersGetPersonalFinancialRelations```   |
| /business/identifications     | ```direct:customersGetBusinessIdentifications```      |
| /business/qualifications      | ```direct:customersGetBusinessQualifications```       |
| /business/financial-relations | ```direct:customersGetBusinessFinancialRelations```   |

&nbsp;

### Financings

&nbsp;

| Endpoint                                          | Rota do Camel                                                     |
|---------------------------------------------------|-------------------------------------------------------------------|
| /contracts                                        | ```direct:financingsGetContracts```                               |
| /contracts/\{contractId\}                         | ```direct:financingsGetContractsContractId```                     |
| /contracts/\{contractId\}/warranties              | ```direct:financingsGetContractsContractIdWarranties```           |
| /contracts/\{contractId\}/scheduled-instalments   | ```direct:financingsGetContractsContractIdScheduledInstalments``` |
| /contracts/\{contractId\}/payments                | ```direct:financingsGetContractsContractIdPayments```             |

&nbsp;

### Invoice Financings

&nbsp;

| Endpoint                                          | Rota do Camel                                                             |
|---------------------------------------------------|---------------------------------------------------------------------------|
| /contracts                                        | ```direct:invoiceFinancingsGetContracts```                                |
| /contracts/\{contractId\}                         | ```direct:invoiceFinancingsGetContractsContractId```                      |
| /contracts/\{contractId\}/warranties              | ```direct:invoiceFinancingsGetContractsContractIdWarranties```            |
| /contracts/\{contractId\}/scheduled-instalments   | ```direct:invoiceFinancingsGetContractsContractIdScheduledInstalments```  |
| /contracts/\{contractId\}/payments                | ```direct:invoiceFinancingsGetContractsContractIdPayments```              |

&nbsp;

### Loans

&nbsp;

| Endpoint                                          | Rota do Camel                                                 |
|---------------------------------------------------|---------------------------------------------------------------|
| /contracts                                        | ```direct:loansGetContracts```                                |
| /contracts/\{contractId\}                         | ```direct:loansGetContractsContractId```                      |
| /contracts/\{contractId\}/warranties              | ```direct:loansGetContractsContractIdWarranties```            |
| /contracts/\{contractId\}/scheduled-instalments   | ```direct:loansGetContractsContractIdScheduledInstalments```  |
| /contracts/\{contractId\}/payments                | ```direct:loansGetContractsContractIdPayments```              |

&nbsp;

### Unarranged Accounts Overdraft

&nbsp;

| Endpoint                                          | Rota do Camel                                                                         |
|---------------------------------------------------|---------------------------------------------------------------------------------------|
| /contracts                                        | ```direct:unarrangedAccountsOverdraftGetContracts```                                  |
| /contracts/\{contractId\}                         | ```direct:unarrangedAccountsOverdraftGetContractsContractId```                        |
| /contracts/\{contractId\}/warranties              | ```direct:unarrangedAccountsOverdraftGetContractsContractIdWarranties```              |
| /contracts/\{contractId\}/scheduled-instalments   | ```direct:unarrangedAccountsOverdraftGetContractsContractIdScheduledInstalments```    |
| /contracts/\{contractId\}/payments                | ```direct:unarrangedAccountsOverdraftGetContractsContractIdPayments```                |
