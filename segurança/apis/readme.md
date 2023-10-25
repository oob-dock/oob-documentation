# Controles de segurança por API

- [Controles de segurança por API](#controles-de-segurança-por-api)
  - [Channels catalog](#channels-catalog)
  - [Channels catalog maintance](#channels-catalog-maintance)
  - [Products and services catalog](#products-and-services-catalog)
  - [Products and services catalog maintance](#products-and-services-catalog-maintance)
  - [Status](#status)
    - [Status](#status-1)
    - [Admin](#admin)
  - [Outages maintance](#outages-maintance)
  - [Financial data](#financial-data)
    - [Customers](#customers)
    - [Credit cards accounts](#credit-cards-accounts)
    - [Accounts](#accounts)
    - [Loans](#loans)
    - [Financings](#financings)
    - [Unarranged accounts overdraft](#unarranged-accounts-overdraft)
    - [Invoice financings](#invoice-financings)
    - [Bank fixed incomes](#bank-fixed-incomes)
    - [Credit fixed incomes](#credit-fixed-incomes)
    - [Variable incomes](#variable-incomes)
    - [Treasure titles](#treasure-titles)
    - [Funds](#funds)
  - [Payments](#payments)
  - [Consent](#consent)
    - [Consents](#consents)
    - [Resources](#resources)
    - [OOB consents](#oob-consents)
  - [Capitalization bonds catalog](#capitalization-bonds-catalog)
  - [Investments catalog](#investments-catalog)
  - [Exchange catalog](#exchange-catalog)
  - [Acquiring services catalog](#acquiring-services-catalog)
  - [Pension catalog](#pension-catalog)
  - [Insurance catalog](#insurance-catalog)
  - [Observações](#observações)

## Channels catalog

**Base path:** /open-banking/channels

**Cliente API:** Qualquer um (Aberto na internet)

| Operação | API                                  | Valida token | Escopo de acesso | Valida JWS | Valida consentId | mTLS | Obs |
| -------- | ------------------------------------ | ------------ | ---------------- | ---------- | ---------------- | ---- | --- |
| GET      | /v1/branches                         | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v1/electronic-channels              | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v1/phone-channels                   | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v1/banking-agents                   | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v1/shared-automated-teller-machines | Não          |                  | Não        | Não              | Não  |     |

## Channels catalog maintance

**Base path:** /open-banking/channels-maintenance

**Cliente API:**

- Portal backoffice
- Sistema interno banco

| Operação | API                                                         | Valida token | Escopo de acesso   | Valida JWS | Valida consentId | mTLS | Obs |
| -------- | ----------------------------------------------------------- | ------------ | ------------------ | ---------- | ---------------- | ---- | --- |
| GET      | /v1/brand                                                   | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| PUT      | /v1/brand                                                   | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| GET      | /v1/banking-agents-contractors                              | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/electronic-channels                                     | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| POST     | /v1/electronic-channels                                     | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| PUT      | /v1/electronic-channels/\{ID\}                              | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| DELETE   | /v1/electronic-channels/\{ID\}                              | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| GET      | /v1/phone-channels                                          | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| POST     | /v1/phone-channels                                          | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| PUT      | /v1/phone-channels/\{ID\}                                   | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| DELETE   | /v1/phone-channels/\{ID\}                                   | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| GET      | /v1/companies                                               | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| POST     | /v1/companies                                               | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| PUT      | /v1/companies/\{ID\}                                        | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| DELETE   | /v1/companies/\{ID\}                                        | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| GET      | /v1/shared-automated-teller-machines                        | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| POST     | /v1/shared-automated-teller-machines                        | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| PUT      | /v1/shared-automated-teller-machines/\{ID\}                 | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| DELETE   | /v1/shared-automated-teller-machines/\{ID\}                 | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| GET      | /v1/banking-agents                                          | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| POST     | /v1/banking-agents                                          | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| PUT      | /v1/banking-agents/\{ID\}                                   | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| DELETE   | /v1/banking-agents/\{ID\}                                   | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| GET      | /v1/branches                                                | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| POST     | /v1/branches                                                | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| PUT      | /v1/branches/\{ID\}                                         | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| DELETE   | /v1/branches/\{ID\}                                         | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| POST     | /v1/banking-agents-contractors                              | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| DELETE   | /v1/banking-agents-contractors/\{ID\}                       | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| PUT      | /v1/banking-agents-contractors/\{ID\}                       | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| GET      | /v1/companies/\{ID\}                                        | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/branches/\{ID\}                                         | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/electronic-channels/\{ID\}                              | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/phone-channels/\{ID\}                                   | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/banking-agents/\{ID\}                                   | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/banking-agents-contractors/\{ID\}                       | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/shared-automated-teller-machines/\{ID\}                 | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/domains/branch-type                                     | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/domains/shared-automated-teller-machines-services-names | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/domains/shared-automated-teller-machines-services-codes | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/domains/phone-channel-type                              | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/domains/phone-type                                      | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/domains/electronic-type                                 | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/domains/branch-phone-and-electronic-name                | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/domains/branch-phone-and-electronic-code                | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/domains/banking-agent-name                              | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/domains/banking-agent-code                              | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/domains/weekday                                         | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/domains                                                 | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/domains/country-sub-division                            | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |

## Products and services catalog

**Base path:** /open-banking/products-services

**Cliente API:** Qualquer um (Aberto na internet)

| Operação | API                                       | Valida token | Escopo de acesso | Valida JWS | Valida consentId | mTLS | Obs |
| -------- | ----------------------------------------- | ------------ | ---------------- | ---------- | ---------------- | ---- | --- |
| GET      | /v1/personal-accounts                     | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v1/business-accounts                     | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v1/personal-loans                        | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v1/business-loans                        | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v1/personal-financings                   | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v1/business-financings                   | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v1/personal-invoice-financings           | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v1/business-invoice-financings           | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v1/personal-credit-cards                 | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v1/business-credit-cards                 | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v1/personal-unarranged-account-overdraft | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v1/business-unarranged-account-overdraft | Não          |                  | Não        | Não              | Não  |     |

## Products and services catalog maintance

**Base path:** /open-banking/products-services-maintenance

**Cliente API:**

- Portal backoffice
- Sistema interno banco

| Operação | API                                                        | Valida token | Escopo de acesso   | Valida JWS | Valida consentId | mTLS | Obs |
| -------- | ---------------------------------------------------------- | ------------ | ------------------ | ---------- | ---------------- | ---- | --- |
| GET      | /v1/brand                                                  | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| PUT      | /v1/brand                                                  | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| GET      | /v1/companies                                              | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/companies/\{ID\}                                       | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| POST     | /v1/companies                                              | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| PUT      | /v1/companies/\{ID\}                                       | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| DELETE   | /v1/companies/\{ID\}                                       | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| GET      | /v1/accounts                                               | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/accounts/\{ID\}                                        | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| POST     | /v1/accounts                                               | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| PUT      | /v1/accounts/\{ID\}                                        | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| DELETE   | /v1/accounts/\{ID\}                                        | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| GET      | /v1/loans                                                  | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/loans/\{ID\}                                           | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| POST     | /v1/loans                                                  | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| PUT      | /v1/loans/\{ID\}                                           | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| DELETE   | /v1/loans/\{ID\}                                           | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| GET      | /v1/credit-cards                                           | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/credit-cards/\{ID\}                                    | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| POST     | /v1/credit-cards                                           | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| PUT      | /v1/credit-cards/\{ID\}                                    | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| DELETE   | /v1/credit-cards/\{ID\}                                    | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| GET      | /v1/financings                                             | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/financings/\{ID\}                                      | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| POST     | /v1/financings                                             | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| PUT      | /v1/financings/\{ID\}                                      | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| DELETE   | /v1/financings/\{ID\}                                      | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| GET      | /v1/invoice-financings                                     | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/invoice-financings/\{ID\}                              | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| POST     | /v1/invoice-financings                                     | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| PUT      | /v1/invoice-financings/\{ID\}                              | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| DELETE   | /v1/invoice-financings/\{ID\}                              | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| GET      | /v1/unarranged-account-overdraft                           | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/unarranged-account-overdraft/\{ID\}                    | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| POST     | /v1/unarranged-account-overdraft                           | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| PUT      | /v1/unarranged-account-overdraft/\{ID\}                    | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| DELETE   | /v1/unarranged-account-overdraft/\{ID\}                    | Sim          | oob_opendata:write | Não        | Não              | Não  |     |
| GET      | /v1/domains                                                | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/domains/credit-card-identification-credit-card-network | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/domains/credit-card-identification-product-type        | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/domains/financing-type                                 | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/domains/invoice-financing-type                         | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/domains/loan-type                                      | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/domains/unarranged-account-overdraft-fee-code          | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |
| GET      | /v1/domains/unarranged-account-overdraft-fee-name          | Sim          | oob_opendata:read  | Não        | Não              | Não  |     |

## Status

### Status

**Base path:** /open-banking/discovery

**Cliente API:** Qualquer um (Aberto na internet)

| Operação | API         | Valida token | Escopo de acesso | Valida JWS | Valida consentId | mTLS | Obs |
| -------- | ----------- | ------------ | ---------------- | ---------- | ---------------- | ---- | --- |
| GET      | /v1/status  | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v1/outages | Não          |                  | Não        | Não              | Não  |     |

### Admin

**Base path:** /open-banking/admin

**Cliente API:** Qualquer um (Aberto na internet)

| Operação | API         | Valida token | Escopo de acesso | Valida JWS | Valida consentId | mTLS | Obs |
| -------- | ----------- | ------------ | ---------------- | ---------- | ---------------- | ---- | --- |
| GET      | /v1/metrics | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v2/metrics | Não          |                  | Não        | Não              | Não  |     |

## Outages maintance

**Base path:** /open-banking/outages-maintenance

**Cliente API:**

- Portal backoffice
- Sistema interno banco

| Operação | API                      | Valida token | Escopo de acesso  | Valida JWS | Valida consentId | mTLS | Obs |
| -------- | ------------------------ | ------------ | ----------------- | ---------- | ---------------- | ---- | --- |
| GET      | /v1/domains/failure-type | Sim          | oob_outages:read  | Não        | Não              | Não  |     |
| GET      | /v1/endpoints            | Sim          | oob_outages:read  | Não        | Não              | Não  |     |
| GET      | /v1/outages              | Sim          | oob_outages:read  | Não        | Não              | Não  |     |
| POST     | /v1/outages              | Sim          | oob_outages:write | Não        | Não              | Não  |     |
| GET      | /v1/outages/\{ID\}       | Sim          | oob_outages:read  | Não        | Não              | Não  |     |
| PUT      | /v1/outages/\{ID\}       | Sim          | oob_outages:write | Não        | Não              | Não  |     |
| DELETE   | /v1/outages/\{ID\}       | Sim          | oob_outages:write | Não        | Não              | Não  |     |
| GET      | /v1/failures             | Sim          | oob_outages:read  | Não        | Não              | Não  |     |
| GET      | /v1/failures/\{ID\}      | Sim          | oob_outages:read  | Não        | Não              | Não  |     |
| PUT      | /v1/failures/\{ID\}      | Sim          | oob_outages:write | Não        | Não              | Não  |     |
| GET      | /v1/services             | Sim          | oob_outages:read  | Não        | Não              | Não  |     |

## Financial data

### Customers

**Base path:** /open-banking/customers

**Cliente API:** TPP

| Operação | API                              | Valida token | Escopo de acesso | Valida JWS | ConsentPermission                       | Valida consentId | mTLS | Obs |
| -------- | -------------------------------- | ------------ | ---------------- | ---------- | --------------------------------------- | ---------------- | ---- | --- |
| GET      | /v1/business/identifications     | Sim          | customers        | Não        | CUSTOMERS_BUSINESS_IDENTIFICATIONS_READ | Sim              | Sim  |     |
| GET      | /v1/business/financial-relations | Sim          | customers        | Não        | CUSTOMERS_BUSINESS_ADITTIONALINFO_READ  | Sim              | Sim  |     |
| GET      | /v1/business/qualifications      | Sim          | customers        | Não        | CUSTOMERS_BUSINESS_ADITTIONALINFO_READ  | Sim              | Sim  |     |
| GET      | /v1/personal/identifications     | Sim          | customers        | Não        | CUSTOMERS_PERSONAL_IDENTIFICATIONS_READ | Sim              | Sim  |     |
| GET      | /v1/personal/financial-relations | Sim          | customers        | Não        | CUSTOMERS_PERSONAL_ADITTIONALINFO_READ  | Sim              | Sim  |     |
| GET      | /v1/personal/qualifications      | Sim          | customers        | Não        | CUSTOMERS_PERSONAL_ADITTIONALINFO_READ  | Sim              | Sim  |     |
| GET      | /v2/business/identifications     | Sim          | customers        | Não        | CUSTOMERS_BUSINESS_IDENTIFICATIONS_READ | Sim              | Sim  |     |
| GET      | /v2/business/financial-relations | Sim          | customers        | Não        | CUSTOMERS_BUSINESS_ADITTIONALINFO_READ  | Sim              | Sim  |     |
| GET      | /v2/business/qualifications      | Sim          | customers        | Não        | CUSTOMERS_BUSINESS_ADITTIONALINFO_READ  | Sim              | Sim  |     |
| GET      | /v2/personal/identifications     | Sim          | customers        | Não        | CUSTOMERS_PERSONAL_IDENTIFICATIONS_READ | Sim              | Sim  |     |
| GET      | /v2/personal/financial-relations | Sim          | customers        | Não        | CUSTOMERS_PERSONAL_ADITTIONALINFO_READ  | Sim              | Sim  |     |
| GET      | /v2/personal/qualifications      | Sim          | customers        | Não        | CUSTOMERS_PERSONAL_ADITTIONALINFO_READ  | Sim              | Sim  |     |

### Credit cards accounts

**Base path:** /open-banking/credit-cards-accounts

**Cliente API:** TPP

| Operação | API                                                 | Valida token | Escopo de acesso      | Valida JWS | ConsentPermission                             | Valida consentId | mTLS | Obs |
| -------- | --------------------------------------------------- | ------------ | --------------------- | ---------- | --------------------------------------------- | ---------------- | ---- | --- |
| GET      | /v1/accounts                                        | Sim          | credit-cards-accounts | Não        | CREDIT_CARDS_ACCOUNTS_READ                    | Sim              | Sim  |     |
| GET      | /v1/accounts/\{ID\}                                 | Sim          | credit-cards-accounts | Não        | CREDIT_CARDS_ACCOUNTS_READ                    | Sim              | Sim  |     |
| GET      | /v1/accounts/\{ID\}/bills                           | Sim          | credit-cards-accounts | Não        | CREDIT_CARDS_ACCOUNTS_BILLS_READ              | Sim              | Sim  |     |
| GET      | /v1/accounts/\{ID\}/bills/\{ID\}/bills/transactions | Sim          | credit-cards-accounts | Não        | CREDIT_CARDS_ACCOUNTS_BILLS_TRANSACTIONS_READ | Sim              | Sim  |     |
| GET      | /v1/accounts/\{ID\}/limits                          | Sim          | credit-cards-accounts | Não        | CREDIT_CARDS_ACCOUNTS_LIMITS_READ             | Sim              | Sim  |     |
| GET      | /v1/accounts/\{ID\}/transactions                    | Sim          | credit-cards-accounts | Não        | CREDIT_CARDS_ACCOUNTS_TRANSACTIONS_READ       | Sim              | Sim  |     |
| GET      | /v2/accounts                                        | Sim          | credit-cards-accounts | Não        | CREDIT_CARDS_ACCOUNTS_READ                    | Sim              | Sim  |     |
| GET      | /v2/accounts/\{ID\}                                 | Sim          | credit-cards-accounts | Não        | CREDIT_CARDS_ACCOUNTS_READ                    | Sim              | Sim  |     |
| GET      | /v2/accounts/\{ID\}/bills                           | Sim          | credit-cards-accounts | Não        | CREDIT_CARDS_ACCOUNTS_BILLS_READ              | Sim              | Sim  |     |
| GET      | /v2/accounts/\{ID\}/bills/\{ID\}/bills/transactions | Sim          | credit-cards-accounts | Não        | CREDIT_CARDS_ACCOUNTS_BILLS_TRANSACTIONS_READ | Sim              | Sim  |     |
| GET      | /v2/accounts/\{ID\}/limits                          | Sim          | credit-cards-accounts | Não        | CREDIT_CARDS_ACCOUNTS_LIMITS_READ             | Sim              | Sim  |     |
| GET      | /v2/accounts/\{ID\}/transactions                    | Sim          | credit-cards-accounts | Não        | CREDIT_CARDS_ACCOUNTS_TRANSACTIONS_READ       | Sim              | Sim  |     |
| GET      | /v2/accounts/\{ID\}/transactions-current            | Sim          | credit-cards-accounts | Não        | CREDIT_CARDS_ACCOUNTS_TRANSACTIONS_READ       | Sim              | Sim  |     |

### Accounts

**Base path:** /open-banking/accounts

**Cliente API:** TPP

| Operação | API                                          | Valida token | Escopo de acesso | Valida JWS | ConsentPermission              | Valida consentId | mTLS | Obs |
| -------- | -------------------------------------------- | ------------ | ---------------- | ---------- | ------------------------------ | ---------------- | ---- | --- |
| GET      | /v1/accounts                                 | Sim          | accounts         | Não        | ACCOUNTS_READ                  | Sim              | Sim  |     |
| GET      | /v1/accounts/\{ID\}                          | Sim          | accounts         | Não        | ACCOUNTS_READ                  | Sim              | Sim  |     |
| GET      | /v1/accounts/\{ID\}/overdraft-limits         | Sim          | accounts         | Não        | ACCOUNTS_OVERDRAFT_LIMITS_READ | Sim              | Sim  |     |
| GET      | /v1/accounts/\{ID\}/balances                 | Sim          | accounts         | Não        | ACCOUNTS_BALANCES_READ         | Sim              | Sim  |     |
| GET      | /v1/accounts/\{ID\}/transactions             | Sim          | accounts         | Não        | ACCOUNTS_TRANSACTIONS_READ     | Sim              | Sim  |     |
| GET      | /v2/accounts                                 | Sim          | accounts         | Não        | ACCOUNTS_READ                  | Sim              | Sim  |     |
| GET      | /v2/accounts/\{ID\}                          | Sim          | accounts         | Não        | ACCOUNTS_READ                  | Sim              | Sim  |     |
| GET      | /v2/accounts/\{ID\}/overdraft-limits         | Sim          | accounts         | Não        | ACCOUNTS_OVERDRAFT_LIMITS_READ | Sim              | Sim  |     |
| GET      | /v2/accounts/\{ID\}/balances                 | Sim          | accounts         | Não        | ACCOUNTS_BALANCES_READ         | Sim              | Sim  |     |
| GET      | /v2/accounts/\{ID\}/transactions             | Sim          | accounts         | Não        | ACCOUNTS_TRANSACTIONS_READ     | Sim              | Sim  |     |
| GET      | /v2/accounts/\{ID\}/transactions-current     | Sim          | accounts         | Não        | ACCOUNTS_TRANSACTIONS_READ     | Sim              | Sim  |     |

### Loans

**Base path:** /open-banking/loans

**Cliente API:** TPP

| Operação | API                                        | Valida token | Escopo de acesso | Valida JWS | ConsentPermission                | Valida consentId | mTLS | Obs |
| -------- | ------------------------------------------ | ------------ | ---------------- | ---------- | -------------------------------- | ---------------- | ---- | --- |
| GET      | /v1/contracts                              | Sim          | loans            | Não        | LOANS_READ                       | Sim              | Sim  |     |
| GET      | /v1/contracts/\{ID\}                       | Sim          | loans            | Não        | LOANS_READ                       | Sim              | Sim  |     |
| GET      | /v1/contracts/\{ID\}/payments              | Sim          | loans            | Não        | LOANS_PAYMENTS_READ              | Sim              | Sim  |     |
| GET      | /v1/contracts/\{ID\}/scheduled-instalments | Sim          | loans            | Não        | LOANS_SCHEDULED_INSTALMENTS_READ | Sim              | Sim  |     |
| GET      | /v1/contracts/\{ID\}/warranties            | Sim          | loans            | Não        | LOANS_WARRANTIES_READ            | Sim              | Sim  |     |
| GET      | /v2/contracts                              | Sim          | loans            | Não        | LOANS_READ                       | Sim              | Sim  |     |
| GET      | /v2/contracts/\{ID\}                       | Sim          | loans            | Não        | LOANS_READ                       | Sim              | Sim  |     |
| GET      | /v2/contracts/\{ID\}/payments              | Sim          | loans            | Não        | LOANS_PAYMENTS_READ              | Sim              | Sim  |     |
| GET      | /v2/contracts/\{ID\}/scheduled-instalments | Sim          | loans            | Não        | LOANS_SCHEDULED_INSTALMENTS_READ | Sim              | Sim  |     |
| GET      | /v2/contracts/\{ID\}/warranties            | Sim          | loans            | Não        | LOANS_WARRANTIES_READ            | Sim              | Sim  |     |

### Financings

**Base path:** /open-banking/financings

**Cliente API:** TPP

| Operação | API                                        | Valida token | Escopo de acesso | Valida JWS | ConsentPermission                     | Valida consentId | mTLS | Obs |
| -------- | ------------------------------------------ | ------------ | ---------------- | ---------- | ------------------------------------- | ---------------- | ---- | --- |
| GET      | /v1/contracts                              | Sim          | financings       | Não        | FINANCINGS_READ                       | Sim              | Sim  |     |
| GET      | /v1/contracts/\{ID\}                       | Sim          | financings       | Não        | FINANCINGS_READ                       | Sim              | Sim  |     |
| GET      | /v1/contracts/\{ID\}/payments              | Sim          | financings       | Não        | FINANCINGS_PAYMENTS_READ              | Sim              | Sim  |     |
| GET      | /v1/contracts/\{ID\}/scheduled-instalments | Sim          | financings       | Não        | FINANCINGS_SCHEDULED_INSTALMENTS_READ | Sim              | Sim  |     |
| GET      | /v1/contracts/\{ID\}/warranties            | Sim          | financings       | Não        | FINANCINGS_WARRANTIES_READ            | Sim              | Sim  |     |
| GET      | /v2/contracts                              | Sim          | financings       | Não        | FINANCINGS_READ                       | Sim              | Sim  |     |
| GET      | /v2/contracts/\{ID\}                       | Sim          | financings       | Não        | FINANCINGS_READ                       | Sim              | Sim  |     |
| GET      | /v2/contracts/\{ID\}/payments              | Sim          | financings       | Não        | FINANCINGS_PAYMENTS_READ              | Sim              | Sim  |     |
| GET      | /v2/contracts/\{ID\}/scheduled-instalments | Sim          | financings       | Não        | FINANCINGS_SCHEDULED_INSTALMENTS_READ | Sim              | Sim  |     |
| GET      | /v2/contracts/\{ID\}/warranties            | Sim          | financings       | Não        | FINANCINGS_WARRANTIES_READ            | Sim              | Sim  |     |

### Unarranged accounts overdraft

**Base path:** /open-banking/unarranged-accounts-overdraft

**Cliente API:** TPP

| Operação | API                                        | Valida token | Escopo de acesso              | Valida JWS | ConsentPermission                                        | Valida consentId | mTLS | Obs |
| -------- | ------------------------------------------ | ------------ | ----------------------------- | ---------- | -------------------------------------------------------- | ---------------- | ---- | --- |
| GET      | /v1/contracts                              | Sim          | unarranged-accounts-overdraft | Não        | UNARRANGED_ACCOUNTS_OVERDRAFT_READ                       | Sim              | Sim  |     |
| GET      | /v1/contracts/\{ID\}                       | Sim          | unarranged-accounts-overdraft | Não        | UNARRANGED_ACCOUNTS_OVERDRAFT_READ                       | Sim              | Sim  |     |
| GET      | /v1/contracts/\{ID\}/payments              | Sim          | unarranged-accounts-overdraft | Não        | UNARRANGED_ACCOUNTS_OVERDRAFT_PAYMENTS_READ              | Sim              | Sim  |     |
| GET      | /v1/contracts/\{ID\}/scheduled-instalments | Sim          | unarranged-accounts-overdraft | Não        | UNARRANGED_ACCOUNTS_OVERDRAFT_SCHEDULED_INSTALMENTS_READ | Sim              | Sim  |     |
| GET      | /v1/contracts/\{ID\}/warranties            | Sim          | unarranged-accounts-overdraft | Não        | UNARRANGED_ACCOUNTS_OVERDRAFT_WARRANTIES_READ            | Sim              | Sim  |     |
| GET      | /v2/contracts                              | Sim          | unarranged-accounts-overdraft | Não        | UNARRANGED_ACCOUNTS_OVERDRAFT_READ                       | Sim              | Sim  |     |
| GET      | /v2/contracts/\{ID\}                       | Sim          | unarranged-accounts-overdraft | Não        | UNARRANGED_ACCOUNTS_OVERDRAFT_READ                       | Sim              | Sim  |     |
| GET      | /v2/contracts/\{ID\}/payments              | Sim          | unarranged-accounts-overdraft | Não        | UNARRANGED_ACCOUNTS_OVERDRAFT_PAYMENTS_READ              | Sim              | Sim  |     |
| GET      | /v2/contracts/\{ID\}/scheduled-instalments | Sim          | unarranged-accounts-overdraft | Não        | UNARRANGED_ACCOUNTS_OVERDRAFT_SCHEDULED_INSTALMENTS_READ | Sim              | Sim  |     |
| GET      | /v2/contracts/\{ID\}/warranties            | Sim          | unarranged-accounts-overdraft | Não        | UNARRANGED_ACCOUNTS_OVERDRAFT_WARRANTIES_READ            | Sim              | Sim  |     |

### Invoice financings

**Base path:** /open-banking/invoice-financings

**Cliente API:** TPP

| Operação | API                                        | Valida token | Escopo de acesso   | Valida JWS | ConsentPermission                             | Valida consentId | mTLS | Obs |
| -------- | ------------------------------------------ | ------------ | ------------------ | ---------- | --------------------------------------------- | ---------------- | ---- | --- |
| GET      | /v1/contracts                              | Sim          | invoice-financings | Não        | INVOICE_FINANCINGS_READ                       | Sim              | Sim  |     |
| GET      | /v1/contracts/\{ID\}                       | Sim          | invoice-financings | Não        | INVOICE_FINANCINGS_READ                       | Sim              | Sim  |     |
| GET      | /v1/contracts/\{ID\}/payments              | Sim          | invoice-financings | Não        | INVOICE_FINANCINGS_PAYMENTS_READ              | Sim              | Sim  |     |
| GET      | /v1/contracts/\{ID\}/scheduled-instalments | Sim          | invoice-financings | Não        | INVOICE_FINANCINGS_SCHEDULED_INSTALMENTS_READ | Sim              | Sim  |     |
| GET      | /v1/contracts/\{ID\}/warranties            | Sim          | invoice-financings | Não        | INVOICE_FINANCINGS_WARRANTIES_READ            | Sim              | Sim  |     |
| GET      | /v2/contracts                              | Sim          | invoice-financings | Não        | INVOICE_FINANCINGS_READ                       | Sim              | Sim  |     |
| GET      | /v2/contracts/\{ID\}                       | Sim          | invoice-financings | Não        | INVOICE_FINANCINGS_READ                       | Sim              | Sim  |     |
| GET      | /v2/contracts/\{ID\}/payments              | Sim          | invoice-financings | Não        | INVOICE_FINANCINGS_PAYMENTS_READ              | Sim              | Sim  |     |
| GET      | /v2/contracts/\{ID\}/scheduled-instalments | Sim          | invoice-financings | Não        | INVOICE_FINANCINGS_SCHEDULED_INSTALMENTS_READ | Sim              | Sim  |     |
| GET      | /v2/contracts/\{ID\}/warranties            | Sim          | invoice-financings | Não        | INVOICE_FINANCINGS_WARRANTIES_READ            | Sim              | Sim  |     |

### Bank fixed incomes

**Base path:** /open-banking/bank-fixed-incomes

**Cliente API:** TPP

| Operação | API                                                 | Valida token | Escopo de acesso   | Valida JWS | ConsentPermission       | Valida consentId | mTLS | Obs |
| -------- | --------------------------------------------------- | ------------ | ------------------ | ---------- | ----------------------- | ---------------- | ---- | --- |
| GET      | /v1/investments                                     | Sim          | bank-fixed-incomes | Não        | BANK_FIXED_INCOMES_READ | Sim              | Sim  |     |
| GET      | /v1/investments/{investmentId}                      | Sim          | bank-fixed-incomes | Não        | BANK_FIXED_INCOMES_READ | Sim              | Sim  |     |
| GET      | /v1/investments/{investmentId}/balances             | Sim          | bank-fixed-incomes | Não        | BANK_FIXED_INCOMES_READ | Sim              | Sim  |     |
| GET      | /v1/investments/{investmentId}/transactions         | Sim          | bank-fixed-incomes | Não        | BANK_FIXED_INCOMES_READ | Sim              | Sim  |     |
| GET      | /v1/investments/{investmentId}/transactions-current | Sim          | bank-fixed-incomes | Não        | BANK_FIXED_INCOMES_READ | Sim              | Sim  |     |

### Credit fixed incomes

**Base path:** /open-banking/credit-fixed-incomes

**Cliente API:** TPP

| Operação | API                                                 | Valida token | Escopo de acesso     | Valida JWS | ConsentPermission         | Valida consentId | mTLS | Obs |
| -------- | --------------------------------------------------- | ------------ | -------------------- | ---------- | ------------------------- | ---------------- | ---- | --- |
| GET      | /v1/investments                                     | Sim          | credit-fixed-incomes | Não        | CREDIT_FIXED_INCOMES_READ | Sim              | Sim  |     |
| GET      | /v1/investments/{investmentId}                      | Sim          | credit-fixed-incomes | Não        | CREDIT_FIXED_INCOMES_READ | Sim              | Sim  |     |
| GET      | /v1/investments/{investmentId}/balances             | Sim          | credit-fixed-incomes | Não        | CREDIT_FIXED_INCOMES_READ | Sim              | Sim  |     |
| GET      | /v1/investments/{investmentId}/transactions         | Sim          | credit-fixed-incomes | Não        | CREDIT_FIXED_INCOMES_READ | Sim              | Sim  |     |
| GET      | /v1/investments/{investmentId}/transactions-current | Sim          | credit-fixed-incomes | Não        | CREDIT_FIXED_INCOMES_READ | Sim              | Sim  |     |

### Variable incomes

**Base path:** /open-banking/variable-incomes

**Cliente API:** TPP

| Operação | API                                                 | Valida token | Escopo de acesso | Valida JWS | ConsentPermission     | Valida consentId | mTLS | Obs |
| -------- | --------------------------------------------------- | ------------ | ---------------- | ---------- | --------------------- | ---------------- | ---- | --- |
| GET      | /v1/investments                                     | Sim          | variable-incomes | Não        | VARIABLE_INCOMES_READ | Sim              | Sim  |     |
| GET      | /v1/investments/{investmentId}                      | Sim          | variable-incomes | Não        | VARIABLE_INCOMES_READ | Sim              | Sim  |     |
| GET      | /v1/investments/{investmentId}/balances             | Sim          | variable-incomes | Não        | VARIABLE_INCOMES_READ | Sim              | Sim  |     |
| GET      | /v1/investments/{investmentId}/transactions         | Sim          | variable-incomes | Não        | VARIABLE_INCOMES_READ | Sim              | Sim  |     |
| GET      | /v1/investments/{investmentId}/transactions-current | Sim          | variable-incomes | Não        | VARIABLE_INCOMES_READ | Sim              | Sim  |     |
| GET      | /v1/broker-notes/{brokerNoteId}                     | Sim          | variable-incomes | Não        | VARIABLE_INCOMES_READ | Sim              | Sim  |     |

### Treasure titles

**Base path:** /open-banking/treasure-titles

**Cliente API:** TPP

| Operação | API                                                 | Valida token | Escopo de acesso | Valida JWS | ConsentPermission    | Valida consentId | mTLS | Obs |
| -------- | --------------------------------------------------- | ------------ | ---------------- | ---------- | -------------------- | ---------------- | ---- | --- |
| GET      | /v1/investments                                     | Sim          | treasure-titles  | Não        | TREASURE_TITLES_READ | Sim              | Sim  |     |
| GET      | /v1/investments/{investmentId}                      | Sim          | treasure-titles  | Não        | TREASURE_TITLES_READ | Sim              | Sim  |     |
| GET      | /v1/investments/{investmentId}/balances             | Sim          | treasure-titles  | Não        | TREASURE_TITLES_READ | Sim              | Sim  |     |
| GET      | /v1/investments/{investmentId}/transactions         | Sim          | treasure-titles  | Não        | TREASURE_TITLES_READ | Sim              | Sim  |     |
| GET      | /v1/investments/{investmentId}/transactions-current | Sim          | treasure-titles  | Não        | TREASURE_TITLES_READ | Sim              | Sim  |     |

### Funds

**Base path:** /open-banking/funds

**Cliente API:** TPP

| Operação | API                                                 | Valida token | Escopo de acesso | Valida JWS | ConsentPermission | Valida consentId | mTLS | Obs |
| -------- | --------------------------------------------------- | ------------ | ---------------- | ---------- | ----------------- | ---------------- | ---- | --- |
| GET      | /v1/investments                                     | Sim          | funds            | Não        | FUNDS_READ        | Sim              | Sim  |     |
| GET      | /v1/investments/{investmentId}                      | Sim          | funds            | Não        | FUNDS_READ        | Sim              | Sim  |     |
| GET      | /v1/investments/{investmentId}/balances             | Sim          | funds            | Não        | FUNDS_READ        | Sim              | Sim  |     |
| GET      | /v1/investments/{investmentId}/transactions         | Sim          | funds            | Não        | FUNDS_READ        | Sim              | Sim  |     |
| GET      | /v1/investments/{investmentId}/transactions-current | Sim          | funds            | Não        | FUNDS_READ        | Sim              | Sim  |     |

## Payments

**Base path:** /open-banking/payments

**Cliente API:** TPP

| Operação | API                     | Valida token | Escopo de acesso | Valida JWS | Valida consentId | mTLS | Obs |
| -------- | ----------------------- | ------------ | ---------------- | ---------- | ---------------- | ---- | --- |
| POST     | /v1/consents            | Sim          | payments         | Sim        | Não              | Sim  |     |
| GET      | /v1/consents/\{ID\}     | Sim          | payments         | Não        | Não              | Sim  |     |
| POST     | /v2/consents            | Sim          | payments         | Sim        | Não              | Sim  |     |
| GET      | /v2/consents/\{ID\}     | Sim          | payments         | Não        | Não              | Sim  |     |
| POST     | /v3/consents            | Sim          | payments         | Sim        | Não              | Sim  |     |
| GET      | /v3/consents/\{ID\}     | Sim          | payments         | Não        | Não              | Sim  |     |
| POST     | /v1/pix/payments        | Sim          | payments         | Sim        | Sim              | Sim  |     |
| GET      | /v1/pix/payments/\{ID\} | Sim          | payments         | Não        | Não              | Sim  |     |
| POST     | /v2/pix/payments        | Sim          | payments         | Sim        | Sim              | Sim  |     |
| GET      | /v2/pix/payments/\{ID\} | Sim          | payments         | Não        | Não              | Sim  |     |
| PATCH    | /v2/pix/payments/\{ID\} | Sim          | payments         | Sim        | Não              | Sim  |     |
| POST     | /v3/pix/payments        | Sim          | payments         | Sim        | Sim              | Sim  |     |
| GET      | /v3/pix/payments/\{ID\} | Sim          | payments         | Não        | Não              | Sim  |     |
| PATCH    | /v3/pix/payments/\{ID\} | Sim          | payments         | Sim        | Não              | Sim  |     |

## Consent

### Consents

**Base path:** /open-banking/consents

**Cliente API:** TPP

| Operação | API                         | Valida token | Escopo de acesso | Valida JWS | Valida consentId | mTLS | Obs                |
| -------- | --------------------------- | ------------ | ---------------- | ---------- | ---------------- | ---- | ------------------ |
| POST     | /v1/consents                | Sim          | consents         | Não        | Não              | Sim  |                    |
| GET      | /v1/consents/\{ID\}         | Sim          | consents         | Não        | Não              | Sim  | [*1](#observações) |
| DELETE   | /v1/consents/\{ID\}         | Sim          | consents         | Não        | Não              | Sim  | [*1](#observações) |
| POST     | /v2/consents                | Sim          | consents         | Não        | Não              | Sim  |                    |
| DELETE   | /v2/consents/\{ID\}         | Sim          | consents         | Não        | Não              | Sim  | [*1](#observações) |
| GET      | /v2/consents/\{ID\}         | Sim          | consents         | Não        | Não              | Sim  | [*1](#observações) |
| POST     | /v2/consents/\{ID\}/extends | Sim          | consents         | Não        | Sim              | Sim  | [*1](#observações) |
| GET      | /v2/consents/\{ID\}/extends | Sim          | consents         | Não        | Sim              | Sim  | [*1](#observações) |

### Resources

**Base path:** /open-banking/resources

**Cliente API:** TPP

| Operação | API           | Valida token | Escopo de acesso | Valida JWS | ConsentPermission | Valida consentId | mTLS | Obs |
| -------- | ------------- | ------------ | ---------------- | ---------- | ----------------- | ---------------- | ---- | --- |
| GET      | /v1/resources | Sim          | resources        | Não        | RESOURCES_READ    | Sim              | Sim  |     |
| GET      | /v2/resources | Sim          | resources        | Não        | RESOURCES_READ    | Sim              | Sim  |     |

### OOB consents

**Base path:** /open-banking/oob-consents

**Cliente API:**

- Portal gestão consentimento (backoffice)
- Portal gestão consentimento (cliente)

| Operação | API                              | Valida token | Escopo de acesso                 | Valida JWS | Valida consentId | mTLS | Obs                |
| -------- | -------------------------------- | ------------ | -------------------------------- | ---------- | ---------------- | ---- | ------------------ |
| GET      | /v1/domains/permission           | Sim          | oob_consents:read, oob_customer  | Não        | Não              | Não  |                    |
| GET      | /v1/domains/consent-type         | Sim          | oob_consents:read, oob_customer  | Não        | Não              | Não  |                    |
| GET      | /v1/domains/consent-status       | Sim          | oob_consents:read, oob_customer  | Não        | Não              | Não  |                    |
| *GET     | /v1/domains/resource-type        | Sim          | oob_consents:read, oob_customer  | Não        | Não              | Não  |                    |
| *DELETE  | /v1/authorisations/\{ID\}        | Sim          | oob_consents:write, oob_customer | Não        | Não              | Não  | [*2](#observações) |
| *PUT     | /v1/authorisations/\{ID\}/accept | Sim          | oob_consents:write, oob_customer | Não        | Não              | Não  | [*2](#observações) |
| *GET     | /v1/consents                     | Sim          | oob_consents:read, oob_customer  | Não        | Não              | Não  |                    |
| *GET     | /v1/consents/\{ID\}              | Sim          | oob_consents:read, oob_customer  | Não        | Não              | Não  | [*2](#observações) |
| *PATCH   | /v1/consents/\{ID\}              | Sim          | oob_consents:write, oob_customer | Não        | Não              | Não  | [*2](#observações) |
| *PATCH   | /consents/v1/consents/\{ID\}     | Sim          | oob_consents:write, oob_customer | Não        | Não              | Não  | [*2](#observações) |
| *GET     | /v1/tpps/payment-legacy-ids      | Sim          | oob_consents:read                | Não        | Não              | Não  |                    |
| POST     | /v1/payment-status-notification  | Sim          | oob_payments:write               | Não        | Não              | Não  |                    |
| *GET     | /v1/consents/\{ID\}/extends      | Sim          | oob_consents:read                | Não        | Não              | Não  |                    |

## Capitalization bonds catalog

**Base path:** /open-banking/opendata-capitalization

**Cliente API:** Qualquer um (Aberto na internet)

| Operação | API       | Valida token | Escopo de acesso | Valida JWS | Valida consentId | mTLS | Obs |
| -------- | --------- | ------------ | ---------------- | ---------- | ---------------- | ---- | --- |
| GET      | /v1/bonds | Não          |                  | Não        | Não              | Não  |     |

## Investments catalog

**Base path:** /open-banking/opendata-investments

**Cliente API:** Qualquer um (Aberto na internet)

| Operação | API                      | Valida token | Escopo de acesso | Valida JWS | Valida consentId | mTLS | Obs |
| -------- | -----------------------  | ------------ | ---------------- | ---------- | ---------------- | ---- | --- |
| GET      | /v1/funds                | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v1/bank-fixed-incomes   | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v1/credit-fixed-incomes | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v1/variable-incomes     | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v1/treasure-titles      | Não          |                  | Não        | Não              | Não  |     |

## Exchange catalog

**Base path:** /open-banking/opendata-exchange

**Cliente API:** Qualquer um (Aberto na internet)

| Operação | API               | Valida token | Escopo de acesso | Valida JWS | Valida consentId | mTLS | Obs |
| -------- | ----------------- | ------------ | ---------------- | ---------- | ---------------- | ---- | --- |
| GET      | /v1/online-rates  | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v1/vet-values    | Não          |                  | Não        | Não              | Não  |     |

## Acquiring services catalog

**Base path:** /open-banking/opendata-acquiring-services

**Cliente API:** Qualquer um (Aberto na internet)

| Operação | API            | Valida token | Escopo de acesso | Valida JWS | Valida consentId | mTLS | Obs |
| -------- | -------------- | ------------ | ---------------- | ---------- | ---------------- | ---- | --- |
| GET      | /v1/personals  | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v1/businesses | Não          |                  | Não        | Não              | Não  |     |

## Pension catalog

**Base path:** /open-banking/opendata-pension

**Cliente API:** Qualquer um (Aberto na internet)

| Operação | API                    | Valida token | Escopo de acesso | Valida JWS | Valida consentId | mTLS | Obs |
| -------- | ---------------------- | ------------ | ---------------- | ---------- | ---------------- | ---- | --- |
| GET      | /v1/risk-coverages     | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v1/survival-coverages | Não          |                  | Não        | Não              | Não  |     |

## Insurance catalog

**Base path:** /open-banking/opendata-insurance

**Cliente API:** Qualquer um (Aberto na internet)

| Operação | API             | Valida token | Escopo de acesso | Valida JWS | Valida consentId | mTLS | Obs |
| -------- | --------------- | ------------ | ---------------- | ---------- | ---------------- | ---- | --- |
| GET      | /v1/automotives | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v1/homes       | Não          |                  | Não        | Não              | Não  |     |
| GET      | /v1/personals   | Não          |                  | Não        | Não              | Não  |     |

## Observações

- `*1:` Valida se o consentimento referenciado pertence ao TPP.
- `*2:` Quando escopo = oob_customer, valida se o consentimento referenciado pertence ao cliente.