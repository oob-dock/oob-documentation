
# Rotas Camel Financial Data Versão 2

## Accounts

&nbsp;

| Endpoint                                          | Rota do Camel                                                   |
|---------------------------------------------------|-----------------------------------------------------------------|
| /accounts                                         | ```direct:accountsGetAccounts_v2```                             |
| /accounts/\{accountId\}                           | ```direct:accountsGetAccountsAccountId_v2```                    |
| /accounts/\{accountId\}/balances                  | ```direct:accountsGetAccountsAccountIdBalances_v2```            |
| /accounts/\{accountId\}/transactions              | ```direct:accountsGetAccountsAccountIdTransactions_v2```        |
| /accounts/\{accountId\}/overdraft-limits          | ```direct:accountsGetAccountsAccountIdOverdraftLimits_v2```     |
| /accounts/\{accountId\}/transactions-current      | ```direct:accountsGetAccountsAccountIdTransactionsCurrent_v2``` |

&nbsp;

## Credit Cards

&nbsp;

| Endpoint                                                          | Rota do Camel                                                                    |
|-------------------------------------------------------------------|----------------------------------------------------------------------------------|
| /accounts                                                         | ```direct:creditCardsGetAccounts_v2```                                           |
| /accounts/\{creditCardAccountId\}                                 | ```direct:creditCardsGetAccountsCreditCardAccountId_v2```                        |
| /accounts/\{creditCardAccountId\}/bills                           | ```direct:creditCardsGetAccountsCreditCardAccountIdBills_v2```                   |
| /accounts/\{creditCardAccountId\}/bills/\{billId\}/transactions   | ```direct:creditCardsGetAccountsCreditCardAccountIdBillsBillIdTransactions_v2``` |
| /accounts/\{creditCardAccountId\}/limits                          | ```direct:creditCardsGetAccountsCreditCardAccountIdLimits_v2```                  |
| /accounts/\{creditCardAccountId\}/transactions                    | ```direct:creditCardsGetAccountsCreditCardAccountIdTransactions_v2```            |
| /accounts/\{creditCardAccountId\}/transactions-current            | ```direct:creditCardsGetAccountsCreditCardAccountIdTransactionsCurrent_v2```     |

&nbsp;

## Customers

&nbsp;

| Endpoint                      | Rota do Camel                                            |
|-------------------------------|----------------------------------------------------------|
| /personal/identifications     | ```direct:customersGetPersonalIdentifications_v2```      |
| /personal/qualifications      | ```direct:customersGetPersonalQualifications_v2```       |
| /personal/financial-relations | ```direct:customersGetPersonalFinancialRelations_v2```   |
| /business/identifications     | ```direct:customersGetBusinessIdentifications_v2```      |
| /business/qualifications      | ```direct:customersGetBusinessQualifications_v2```       |
| /business/financial-relations | ```direct:customersGetBusinessFinancialRelations_v2```   |

&nbsp;

## Financings

&nbsp;

| Endpoint                                          | Rota do Camel                                                        |
|---------------------------------------------------|----------------------------------------------------------------------|
| /contracts                                        | ```direct:financingsGetContracts_v2```                               |
| /contracts/\{contractId\}                         | ```direct:financingsGetContractsContractId_v2```                     |
| /contracts/\{contractId\}/warranties              | ```direct:financingsGetContractsContractIdWarranties_v2```           |
| /contracts/\{contractId\}/scheduled-instalments   | ```direct:financingsGetContractsContractIdScheduledInstalments_v2``` |
| /contracts/\{contractId\}/payments                | ```direct:financingsGetContractsContractIdPayments_v2```             |

&nbsp;

## Invoice Financings

&nbsp;

| Endpoint                                          | Rota do Camel                                                                |
|---------------------------------------------------|------------------------------------------------------------------------------|
| /contracts                                        | ```direct:invoiceFinancingsGetContracts_v2```                                |
| /contracts/\{contractId\}                         | ```direct:invoiceFinancingsGetContractsContractId_v2```                      |
| /contracts/\{contractId\}/warranties              | ```direct:invoiceFinancingsGetContractsContractIdWarranties_v2```            |
| /contracts/\{contractId\}/scheduled-instalments   | ```direct:invoiceFinancingsGetContractsContractIdScheduledInstalments_v2```  |
| /contracts/\{contractId\}/payments                | ```direct:invoiceFinancingsGetContractsContractIdPayments_v2```              |

&nbsp;

## Loans

&nbsp;

| Endpoint                                          | Rota do Camel                                                    |
|---------------------------------------------------|------------------------------------------------------------------|
| /contracts                                        | ```direct:loansGetContracts_v2```                                |
| /contracts/\{contractId\}                         | ```direct:loansGetContractsContractId_v2```                      |
| /contracts/\{contractId\}/warranties              | ```direct:loansGetContractsContractIdWarranties_v2```            |
| /contracts/\{contractId\}/scheduled-instalments   | ```direct:loansGetContractsContractIdScheduledInstalments_v2```  |
| /contracts/\{contractId\}/payments                | ```direct:loansGetContractsContractIdPayments_v2```              |

&nbsp;

## Unarranged Accounts Overdraft

&nbsp;

| Endpoint                                          | Rota do Camel                                                                            |
|---------------------------------------------------|------------------------------------------------------------------------------------------|
| /contracts                                        | ```direct:unarrangedAccountsOverdraftGetContracts_v2```                                  |
| /contracts/\{contractId\}                         | ```direct:unarrangedAccountsOverdraftGetContractsContractId_v2```                        |
| /contracts/\{contractId\}/warranties              | ```direct:unarrangedAccountsOverdraftGetContractsContractIdWarranties_v2```              |
| /contracts/\{contractId\}/scheduled-instalments   | ```direct:unarrangedAccountsOverdraftGetContractsContractIdScheduledInstalments_v2```    |
| /contracts/\{contractId\}/payments                | ```direct:unarrangedAccountsOverdraftGetContractsContractIdPayments_v2```                |