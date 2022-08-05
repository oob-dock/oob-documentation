
# Rotas Camel Financial Data Versão 1

## Accounts

&nbsp;

| Endpoint                                  | Rota do Camel                                             |
|-------------------------------------------|-----------------------------------------------------------|
| /accounts                                 | ```direct:accountsGetAccounts```                          |
| /accounts/\{accountId\}                   | ```direct:accountsGetAccountsAccountId```                 |
| /accounts/\{accountId\}/balances          | ```direct:accountsGetAccountsAccountIdBalances```         |
| /accounts/\{accountId\}/transactions      | ```direct:accountsGetAccountsAccountIdTransactions```     |
| /accounts/\{accountId\}/overdraft-limits  | ```direct:accountsGetAccountsAccountIdOverdraftLimits```  |

&nbsp;

## Credit Cards

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

## Customers

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

## Financings

&nbsp;

| Endpoint                                          | Rota do Camel                                                     |
|---------------------------------------------------|-------------------------------------------------------------------|
| /contracts                                        | ```direct:financingsGetContracts```                               |
| /contracts/\{contractId\}                         | ```direct:financingsGetContractsContractId```                     |
| /contracts/\{contractId\}/warranties              | ```direct:financingsGetContractsContractIdWarranties```           |
| /contracts/\{contractId\}/scheduled-instalments   | ```direct:financingsGetContractsContractIdScheduledInstalments``` |
| /contracts/\{contractId\}/payments                | ```direct:financingsGetContractsContractIdPayments```             |

&nbsp;

## Invoice Financings

&nbsp;

| Endpoint                                          | Rota do Camel                                                             |
|---------------------------------------------------|---------------------------------------------------------------------------|
| /contracts                                        | ```direct:invoiceFinancingsGetContracts```                                |
| /contracts/\{contractId\}                         | ```direct:invoiceFinancingsGetContractsContractId```                      |
| /contracts/\{contractId\}/warranties              | ```direct:invoiceFinancingsGetContractsContractIdWarranties```            |
| /contracts/\{contractId\}/scheduled-instalments   | ```direct:invoiceFinancingsGetContractsContractIdScheduledInstalments```  |
| /contracts/\{contractId\}/payments                | ```direct:invoiceFinancingsGetContractsContractIdPayments```              |

&nbsp;

## Loans

&nbsp;

| Endpoint                                          | Rota do Camel                                                 |
|---------------------------------------------------|---------------------------------------------------------------|
| /contracts                                        | ```direct:loansGetContracts```                                |
| /contracts/\{contractId\}                         | ```direct:loansGetContractsContractId```                      |
| /contracts/\{contractId\}/warranties              | ```direct:loansGetContractsContractIdWarranties```            |
| /contracts/\{contractId\}/scheduled-instalments   | ```direct:loansGetContractsContractIdScheduledInstalments```  |
| /contracts/\{contractId\}/payments                | ```direct:loansGetContractsContractIdPayments```              |

&nbsp;

## Unarranged Accounts Overdraft

&nbsp;

| Endpoint                                          | Rota do Camel                                                                         |
|---------------------------------------------------|---------------------------------------------------------------------------------------|
| /contracts                                        | ```direct:unarrangedAccountsOverdraftGetContracts```                                  |
| /contracts/\{contractId\}                         | ```direct:unarrangedAccountsOverdraftGetContractsContractId```                        |
| /contracts/\{contractId\}/warranties              | ```direct:unarrangedAccountsOverdraftGetContractsContractIdWarranties```              |
| /contracts/\{contractId\}/scheduled-instalments   | ```direct:unarrangedAccountsOverdraftGetContractsContractIdScheduledInstalments```    |
| /contracts/\{contractId\}/payments                | ```direct:unarrangedAccountsOverdraftGetContractsContractIdPayments```                |