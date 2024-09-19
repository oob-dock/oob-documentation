# Camel Routes Financial Data Version 1

## Accounts

&nbsp;

| Endpoint                                  | Camel Route                                               |
|-------------------------------------------|-----------------------------------------------------------|
| /accounts                                 | ```direct:accountsGetAccounts```                          |
| /accounts/\{accountId\}                   | ```direct:accountsGetAccountsAccountId```                 |
| /accounts/\{accountId\}/balances          | ```direct:accountsGetAccountsAccountIdBalances```         |
| /accounts/\{accountId\}/transactions      | ```direct:accountsGetAccountsAccountIdTransactions```     |
| /accounts/\{accountId\}/overdraft-limits  | ```direct:accountsGetAccountsAccountIdOverdraftLimits```  |

&nbsp;

## Credit Cards

&nbsp;

| Endpoint                                                          | Camel Route                                                                  |
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

| Endpoint                      | Camel Route                                         |
|-------------------------------|-----------------------------------------------------|
| /personal/identifications     | ```direct:customersGetPersonalIdentifications```    |
| /personal/qualifications      | ```direct:customersGetPersonalQualifications```     |
| /personal/financial-relations | ```direct:customersGetPersonalFinancialRelations``` |
| /business/identifications     | ```direct:customersGetBusinessIdentifications```    |
| /business/qualifications      | ```direct:customersGetBusinessQualifications```     |
| /business/financial-relations | ```direct:customersGetBusinessFinancialRelations``` |

&nbsp;

## Financings

&nbsp;

| Endpoint                                          | Camel Route                                                       |
|---------------------------------------------------|-------------------------------------------------------------------|
| /contracts                                        | ```direct:financingsGetContracts```                               |
| /contracts/\{contractId\}                         | ```direct:financingsGetContractsContractId```                     |
| /contracts/\{contractId\}/warranties              | ```direct:financingsGetContractsContractIdWarranties```           |
| /contracts/\{contractId\}/scheduled-instalments   | ```direct:financingsGetContractsContractIdScheduledInstalments``` |
| /contracts/\{contractId\}/payments                | ```direct:financingsGetContractsContractIdPayments```             |

&nbsp;

## Invoice Financings

&nbsp;

| Endpoint                                          | Camel Route                                                             |
|---------------------------------------------------|---------------------------------------------------------------------------|
| /contracts                                        | ```direct:invoiceFinancingsGetContracts```                                |
| /contracts/\{contractId\}                         | ```direct:invoiceFinancingsGetContractsContractId```                      |
| /contracts/\{contractId\}/warranties              | ```direct:invoiceFinancingsGetContractsContractIdWarranties```            |
| /contracts/\{contractId\}/scheduled-instalments   | ```direct:invoiceFinancingsGetContractsContractIdScheduledInstalments```  |
| /contracts/\{contractId\}/payments                | ```direct:invoiceFinancingsGetContractsContractIdPayments```              |

&nbsp;

## Loans

&nbsp;

| Endpoint                                          | Camel Route                                                 |
|---------------------------------------------------|-------------------------------------------------------------|
| /contracts                                        | ```direct:loansGetContracts```                              |
| /contracts/\{contractId\}                         | ```direct:loansGetContractsContractId```                    |
| /contracts/\{contractId\}/warranties              | ```direct:loansGetContractsContractIdWarranties```          |
| /contracts/\{contractId\}/scheduled-instalments   | ```direct:loansGetContractsContractIdScheduledInstalments```|
| /contracts/\{contractId\}/payments                | ```direct:loansGetContractsContractIdPayments```            |

&nbsp;

## Unarranged Accounts Overdraft

&nbsp;

| Endpoint                                          | Camel Route                                                                         |
|---------------------------------------------------|-------------------------------------------------------------------------------------|
| /contracts                                        | ```direct:unarrangedAccountsOverdraftGetContracts```                                |
| /contracts/\{contractId\}                         | ```direct:unarrangedAccountsOverdraftGetContractsContractId```                      |
| /contracts/\{contractId\}/warranties              | ```direct:unarrangedAccountsOverdraftGetContractsContractIdWarranties```            |
| /contracts/\{contractId\}/scheduled-instalments   | ```direct:unarrangedAccountsOverdraftGetContractsContractIdScheduledInstalments```  |
| /contracts/\{contractId\}/payments                | ```direct:unarrangedAccountsOverdraftGetContractsContractIdPayments```              |

## Bank Fixed Incomes

| Endpoint                                         | Camel Route                                                               |
| ------------------------------------------------ | --------------------------------------------------------------------------|
| /investments                                     | ```direct:bankFixedIncomesGetInvestments```                                |
| /investments/{investmentId}                      | ```direct:bankFixedIncomesGetInvestmentsInvestmentId```                    |
| /investments/{investmentId}/balances             | ```direct:bankFixedIncomesGetInvestmentsInvestmentIdBalances```            |
| /investments/{investmentId}/transactions         | ```direct:bankFixedIncomesGetInvestmentsInvestmentIdTransactions```        |
| /investments/{investmentId}/transactions-current | ```direct:bankFixedIncomesGetInvestmentsInvestmentIdTransactionsCurrent``` |

## Credit Fixed Incomes

| Endpoint                                         | Camel Route                                                                 |
| ------------------------------------------------ | --------------------------------------------------------------------------- |
| /investments                                     | ```direct:creditFixedIncomesGetInvestments```                                |
| /investments/{investmentId}                      | ```direct:creditFixedIncomesGetInvestmentsInvestmentId```                    |
| /investments/{investmentId}/balances             | ```direct:creditFixedIncomesGetInvestmentsInvestmentIdBalances```            |
| /investments/{investmentId}/transactions         | ```direct:creditFixedIncomesGetInvestmentsInvestmentIdTransactions```        |
| /investments/{investmentId}/transactions-current | ```direct:creditFixedIncomesGetInvestmentsInvestmentIdTransactionsCurrent``` |

## Variable Incomes

| Endpoint                                         | Camel Route                                                             |
| ------------------------------------------------ | ----------------------------------------------------------------------- |
| /investments                                     | ```direct:variableIncomesGetInvestments```                                |
| /investments/{investmentId}                      | ```direct:variableIncomesGetInvestmentsInvestmentId```                    |
| /investments/{investmentId}/balances             | ```direct:variableIncomesGetInvestmentsInvestmentIdBalances```            |
| /investments/{investmentId}/transactions         | ```direct:variableIncomesGetInvestmentsInvestmentIdTransactions```        |
| /investments/{investmentId}/transactions-current | ```direct:variableIncomesGetInvestmentsInvestmentIdTransactionsCurrent``` |
| /broker-notes/{brokerNoteId}                     | ```direct:variableIncomesGetInvestmentsBrokerNotesBrokernoteId```         |

## Treasure Titles

| Endpoint                                         | Camel Route                                                              |
| ------------------------------------------------ | -------------------------------------------------------------------------|
| /investments                                     | ```direct:treasureTitlesGetInvestments```                                |
| /investments/{investmentId}                      | ```direct:treasureTitlesGetInvestmentsInvestmentId```                    |
| /investments/{investmentId}/balances             | ```direct:treasureTitlesGetInvestmentsInvestmentIdBalances```            |
| /investments/{investmentId}/transactions         | ```direct:treasureTitlesGetInvestmentsInvestmentIdTransactions```        |
| /investments/{investmentId}/transactions-current | ```direct:treasureTitlesGetInvestmentsInvestmentIdTransactionsCurrent``` |

## Funds

| Endpoint                                         | Camel Route                                                   |
| ------------------------------------------------ | ------------------------------------------------------------- |
| /investments                                     | ```direct:fundsGetInvestments```                                |
| /investments/{investmentId}                      | ```direct:fundsGetInvestmentsInvestmentId```                    |
| /investments/{investmentId}/balances             | ```direct:fundsGetInvestmentsInvestmentIdBalances```            |
| /investments/{investmentId}/transactions         | ```direct:fundsGetInvestmentsInvestmentIdTransactions```        |
| /investments/{investmentId}/transactions-current | ```direct:fundsGetInvestmentsInvestmentIdTransactionsCurrent``` |

## Exchanges

| Endpoint                         | Camel Route                                        |
| ---------------------------------| -------------------------------------------------- |
| /operations                      | ```direct:exchangesGetOperations```                 |
| /operations/{operationId}        | ```direct:exchangesGetOperationsOperationId```      |
| /operations/{operationId}/events | ```direct:exchangesGetOperationsOperationIdEvents```|
