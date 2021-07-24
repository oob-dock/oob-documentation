# Contoles de segurança por API

- [Contoles de segurança por API](#contoles-de-segurança-por-api)
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
  - [Payments](#payments)
  - [Consent](#consent)
    - [Consents](#consents)
    - [Resources](#resources)
    - [OOB consents](#oob-consents)
    - [OOB Internal consents](#oob-internal-consents)
  - [Observações](#observações)

## Channels catalog

**Base path:** /open-banking/channels

**Cliente API:** Qualquer um (Aberto na internet)

| Operação | API                                  | Valida token | Escopo de acesso | Valida JWS | Valida consentId | Observações |
| -------- | ------------------------------------ | ------------ | ---------------- | ---------- | ---------------- | ----------- |
| GET      | /v1/branches                         | Não          |                  | Não        | Não              |             |
| GET      | /v1/electronic-channels              | Não          |                  | Não        | Não              |             |
| GET      | /v1/phone-channels                   | Não          |                  | Não        | Não              |             |
| GET      | /v1/banking-agents                   | Não          |                  | Não        | Não              |             |
| GET      | /v1/shared-automated-teller-machines | Não          |                  | Não        | Não              |             |

## Channels catalog maintance

**Base path:** /open-banking/channels-maintenance

**Cliente API:**

- Portal backoffice
- Sistema interno banco

| Operação | API                                                         | Valida token | Escopo de acesso   | Valida JWS | Valida consentId | Observações |
| -------- | ----------------------------------------------------------- | ------------ | ------------------ | ---------- | ---------------- | ----------- |
| GET      | /v1/brand                                                   | Sim          | oob_opendata:read  | Não        | Não              |             |
| PUT      | /v1/brand                                                   | Sim          | oob_opendata:write | Não        | Não              |             |
| GET      | /v1/banking-agents-contractors                              | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/electronic-channels                                     | Sim          | oob_opendata:read  | Não        | Não              |             |
| POST     | /v1/electronic-channels                                     | Sim          | oob_opendata:write | Não        | Não              |             |
| PUT      | /v1/electronic-channels/\{ID\}                              | Sim          | oob_opendata:write | Não        | Não              |             |
| DELETE   | /v1/electronic-channels/\{ID\}                              | Sim          | oob_opendata:write | Não        | Não              |             |
| GET      | /v1/phone-channels                                          | Sim          | oob_opendata:read  | Não        | Não              |             |
| POST     | /v1/phone-channels                                          | Sim          | oob_opendata:write | Não        | Não              |             |
| PUT      | /v1/phone-channels/\{ID\}                                   | Sim          | oob_opendata:write | Não        | Não              |             |
| DELETE   | /v1/phone-channels/\{ID\}                                   | Sim          | oob_opendata:write | Não        | Não              |             |
| GET      | /v1/companies                                               | Sim          | oob_opendata:read  | Não        | Não              |             |
| POST     | /v1/companies                                               | Sim          | oob_opendata:write | Não        | Não              |             |
| PUT      | /v1/companies/\{ID\}                                        | Sim          | oob_opendata:write | Não        | Não              |             |
| DELETE   | /v1/companies/\{ID\}                                        | Sim          | oob_opendata:write | Não        | Não              |             |
| GET      | /v1/shared-automated-teller-machines                        | Sim          | oob_opendata:read  | Não        | Não              |             |
| POST     | /v1/shared-automated-teller-machines                        | Sim          | oob_opendata:write | Não        | Não              |             |
| PUT      | /v1/shared-automated-teller-machines/\{ID\}                 | Sim          | oob_opendata:write | Não        | Não              |             |
| DELETE   | /v1/shared-automated-teller-machines/\{ID\}                 | Sim          | oob_opendata:write | Não        | Não              |             |
| GET      | /v1/banking-agents                                          | Sim          | oob_opendata:read  | Não        | Não              |             |
| POST     | /v1/banking-agents                                          | Sim          | oob_opendata:write | Não        | Não              |             |
| PUT      | /v1/banking-agents/\{ID\}                                   | Sim          | oob_opendata:write | Não        | Não              |             |
| DELETE   | /v1/banking-agents/\{ID\}                                   | Sim          | oob_opendata:write | Não        | Não              |             |
| GET      | /v1/branches                                                | Sim          | oob_opendata:read  | Não        | Não              |             |
| POST     | /v1/branches                                                | Sim          | oob_opendata:write | Não        | Não              |             |
| PUT      | /v1/branches/\{ID\}                                         | Sim          | oob_opendata:write | Não        | Não              |             |
| DELETE   | /v1/branches/\{ID\}                                         | Sim          | oob_opendata:write | Não        | Não              |             |
| POST     | /v1/banking-agents-contractors                              | Sim          | oob_opendata:write | Não        | Não              |             |
| DELETE   | /v1/banking-agents-contractors/\{ID\}                       | Sim          | oob_opendata:write | Não        | Não              |             |
| PUT      | /v1/banking-agents-contractors/\{ID\}                       | Sim          | oob_opendata:write | Não        | Não              |             |
| GET      | /v1/companies/\{ID\}                                        | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/branches/\{ID\}                                         | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/electronic-channels/\{ID\}                              | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/phone-channels/\{ID\}                                   | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/banking-agents/\{ID\}                                   | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/banking-agents-contractors/\{ID\}                       | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/shared-automated-teller-machines/\{ID\}                 | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/domains/branch-type                                     | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/domains/shared-automated-teller-machines-services-names | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/domains/shared-automated-teller-machines-services-codes | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/domains/phone-channel-type                              | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/domains/phone-type                                      | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/domains/electronic-type                                 | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/domains/branch-phone-and-electronic-name                | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/domains/branch-phone-and-electronic-code                | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/domains/banking-agent-name                              | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/domains/banking-agent-code                              | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/domains/weekday                                         | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/domains                                                 | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/domains/country-sub-division                            | Sim          | oob_opendata:read  | Não        | Não              |             |

## Products and services catalog

**Base path:** /open-banking/products-services

**Cliente API:** Qualquer um (Aberto na internet)

| Operação | API                                       | Valida token | Escopo de acesso | Valida JWS | Valida consentId | Observações |
| -------- | ----------------------------------------- | ------------ | ---------------- | ---------- | ---------------- | ----------- |
| GET      | /v1/personal-accounts                     | Não          |                  | Não        | Não              |             |
| GET      | /v1/business-accounts                     | Não          |                  | Não        | Não              |             |
| GET      | /v1/personal-loans                        | Não          |                  | Não        | Não              |             |
| GET      | /v1/business-loans                        | Não          |                  | Não        | Não              |             |
| GET      | /v1/personal-financings                   | Não          |                  | Não        | Não              |             |
| GET      | /v1/business-financings                   | Não          |                  | Não        | Não              |             |
| GET      | /v1/personal-invoice-financings           | Não          |                  | Não        | Não              |             |
| GET      | /v1/business-invoice-financings           | Não          |                  | Não        | Não              |             |
| GET      | /v1/personal-credit-cards                 | Não          |                  | Não        | Não              |             |
| GET      | /v1/business-credit-cards                 | Não          |                  | Não        | Não              |             |
| GET      | /v1/personal-unarranged-account-overdraft | Não          |                  | Não        | Não              |             |
| GET      | /v1/business-unarranged-account-overdraft | Não          |                  | Não        | Não              |             |

## Products and services catalog maintance

**Base path:** /open-banking/products-services-maintenance

**Cliente API:**

- Portal backoffice
- Sistema interno banco

| Operação | API                                                        | Valida token | Escopo de acesso   | Valida JWS | Valida consentId | Observações |
| -------- | ---------------------------------------------------------- | ------------ | ------------------ | ---------- | ---------------- | ----------- |
| GET      | /v1/brand                                                  | Sim          | oob_opendata:read  | Não        | Não              |             |
| PUT      | /v1/brand                                                  | Sim          | oob_opendata:write | Não        | Não              |             |
| GET      | /v1/companies                                              | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/companies/\{ID\}                                       | Sim          | oob_opendata:read  | Não        | Não              |             |
| POST     | /v1/companies                                              | Sim          | oob_opendata:write | Não        | Não              |             |
| PUT      | /v1/companies/\{ID\}                                       | Sim          | oob_opendata:write | Não        | Não              |             |
| DELETE   | /v1/companies/\{ID\}                                       | Sim          | oob_opendata:write | Não        | Não              |             |
| GET      | /v1/accounts                                               | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/accounts/\{ID\}                                        | Sim          | oob_opendata:read  | Não        | Não              |             |
| POST     | /v1/accounts                                               | Sim          | oob_opendata:write | Não        | Não              |             |
| PUT      | /v1/accounts/\{ID\}                                        | Sim          | oob_opendata:write | Não        | Não              |             |
| DELETE   | /v1/accounts/\{ID\}                                        | Sim          | oob_opendata:write | Não        | Não              |             |
| GET      | /v1/loans                                                  | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/loans/\{ID\}                                           | Sim          | oob_opendata:read  | Não        | Não              |             |
| POST     | /v1/loans                                                  | Sim          | oob_opendata:write | Não        | Não              |             |
| PUT      | /v1/loans/\{ID\}                                           | Sim          | oob_opendata:write | Não        | Não              |             |
| DELETE   | /v1/loans/\{ID\}                                           | Sim          | oob_opendata:write | Não        | Não              |             |
| GET      | /v1/credit-cards                                           | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/credit-cards/\{ID\}                                    | Sim          | oob_opendata:read  | Não        | Não              |             |
| POST     | /v1/credit-cards                                           | Sim          | oob_opendata:write | Não        | Não              |             |
| PUT      | /v1/credit-cards/\{ID\}                                    | Sim          | oob_opendata:write | Não        | Não              |             |
| DELETE   | /v1/credit-cards/\{ID\}                                    | Sim          | oob_opendata:write | Não        | Não              |             |
| GET      | /v1/financings                                             | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/financings/\{ID\}                                      | Sim          | oob_opendata:read  | Não        | Não              |             |
| POST     | /v1/financings                                             | Sim          | oob_opendata:write | Não        | Não              |             |
| PUT      | /v1/financings/\{ID\}                                      | Sim          | oob_opendata:write | Não        | Não              |             |
| DELETE   | /v1/financings/\{ID\}                                      | Sim          | oob_opendata:write | Não        | Não              |             |
| GET      | /v1/invoice-financings                                     | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/invoice-financings/\{ID\}                              | Sim          | oob_opendata:read  | Não        | Não              |             |
| POST     | /v1/invoice-financings                                     | Sim          | oob_opendata:write | Não        | Não              |             |
| PUT      | /v1/invoice-financings/\{ID\}                              | Sim          | oob_opendata:write | Não        | Não              |             |
| DELETE   | /v1/invoice-financings/\{ID\}                              | Sim          | oob_opendata:write | Não        | Não              |             |
| GET      | /v1/unarranged-account-overdraft                           | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/unarranged-account-overdraft/\{ID\}                    | Sim          | oob_opendata:read  | Não        | Não              |             |
| POST     | /v1/unarranged-account-overdraft                           | Sim          | oob_opendata:write | Não        | Não              |             |
| PUT      | /v1/unarranged-account-overdraft/\{ID\}                    | Sim          | oob_opendata:write | Não        | Não              |             |
| DELETE   | /v1/unarranged-account-overdraft/\{ID\}                    | Sim          | oob_opendata:write | Não        | Não              |             |
| GET      | /v1/domains                                                | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/domains/credit-card-identification-credit-card-network | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/domains/credit-card-identification-product-type        | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/domains/financing-type                                 | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/domains/invoice-financing-type                         | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/domains/loan-type                                      | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/domains/unarranged-account-overdraft-fee-code          | Sim          | oob_opendata:read  | Não        | Não              |             |
| GET      | /v1/domains/unarranged-account-overdraft-fee-name          | Sim          | oob_opendata:read  | Não        | Não              |             |

## Status

### Status

**Base path:** /open-banking/discovery

**Cliente API:** Qualquer um (Aberto na internet)

| Operação | API         | Valida token | Escopo de acesso | Valida JWS | Valida consentId | Observações |
| -------- | ----------- | ------------ | ---------------- | ---------- | ---------------- | ----------- |
| GET      | /v1/status  | Não          |                  | Não        | Não              |             |
| GET      | /v1/outages | Não          |                  | Não        | Não              |             |

### Admin

**Base path:** /open-banking/admin

**Cliente API:** Qualquer um (Aberto na internet)

| Operação | API         | Valida token | Escopo de acesso | Valida JWS | Valida consentId | Observações |
| -------- | ----------- | ------------ | ---------------- | ---------- | ---------------- | ----------- |
| GET      | /v1/metrics | Não          |                  | Não        | Não              |             |

## Outages maintance

**Base path:** /open-banking/outages-maintenance

**Cliente API:**

- Portal backoffice
- Sistema interno banco

| Operação | API                      | Valida token | Escopo de acesso  | Valida JWS | Valida consentId | Observações |
| -------- | ------------------------ | ------------ | ----------------- | ---------- | ---------------- | ----------- |
| GET      | /v1/domains/failure-type | Sim          | oob_outages:read  | Não        | Não              |             |
| GET      | /v1/endpoints            | Sim          | oob_outages:read  | Não        | Não              |             |
| GET      | /v1/outages              | Sim          | oob_outages:read  | Não        | Não              |             |
| POST     | /v1/outages              | Sim          | oob_outages:write | Não        | Não              |             |
| GET      | /v1/outages/\{ID\}       | Sim          | oob_outages:read  | Não        | Não              |             |
| PUT      | /v1/outages/\{ID\}       | Sim          | oob_outages:write | Não        | Não              |             |
| DELETE   | /v1/outages/\{ID\}       | Sim          | oob_outages:write | Não        | Não              |             |
| GET      | /v1/failures             | Sim          | oob_outages:read  | Não        | Não              |             |
| GET      | /v1/failures/\{ID\}      | Sim          | oob_outages:read  | Não        | Não              |             |
| PUT      | /v1/failures/\{ID\}      | Sim          | oob_outages:write | Não        | Não              |             |
| GET      | /v1/services             | Sim          | oob_outages:read  | Não        | Não              |             |

## Financial data

### Customers

**Base path:** /open-banking/customers

**Cliente API:** TPP

| Operação | API                              | Valida token | Escopo de acesso | Valida JWS | ConsentPermission                       | Valida consentId | Observações |
| -------- | -------------------------------- | ------------ | ---------------- | ---------- | --------------------------------------- | ---------------- | ----------- |
| GET      | /v1/business/identifications     | Sim          | customers        | Não        | CUSTOMERS_PERSONAL_IDENTIFICATIONS_READ | Sim              |             |
| GET      | /v1/business/financial-relations | Sim          | customers        | Não        | CUSTOMERS_PERSONAL_ADITTIONALINFO_READ  | Sim              |             |
| GET      | /v1/business/qualifications      | Sim          | customers        | Não        | CUSTOMERS_PERSONAL_ADITTIONALINFO_READ  | Sim              |             |
| GET      | /v1/personal/identifications     | Sim          | customers        | Não        | CUSTOMERS_BUSINESS_IDENTIFICATIONS_READ | Sim              |             |
| GET      | /v1/personal/financial-relations | Sim          | customers        | Não        | CUSTOMERS_BUSINESS_ADITTIONALINFO_READ  | Sim              |             |
| GET      | /v1/personal/qualifications      | Sim          | customers        | Não        | CUSTOMERS_BUSINESS_ADITTIONALINFO_READ  | Sim              |             |

### Credit cards accounts

**Base path:** /open-banking/credit-cards-accounts

**Cliente API:** TPP

| Operação | API                                                 | Valida token | Escopo de acesso      | Valida JWS | ConsentPermission                             | Valida consentId | Observações |
| -------- | --------------------------------------------------- | ------------ | --------------------- | ---------- | --------------------------------------------- | ---------------- | ----------- |
| GET      | /v1/accounts                                        | Sim          | credit-cards-accounts | Não        | CREDIT_CARDS_ACCOUNTS_READ                    | Sim              |             |
| GET      | /v1/accounts/\{ID\}                                 | Sim          | credit-cards-accounts | Não        | CREDIT_CARDS_ACCOUNTS_READ                    | Sim              |             |
| GET      | /v1/accounts/\{ID\}/bills                           | Sim          | credit-cards-accounts | Não        | CREDIT_CARDS_ACCOUNTS_BILLS_READ              | Sim              |             |
| GET      | /v1/accounts/\{ID\}/bills/\{ID\}/bills/transactions | Sim          | credit-cards-accounts | Não        | CREDIT_CARDS_ACCOUNTS_BILLS_TRANSACTIONS_READ | Sim              |             |
| GET      | /v1/accounts/\{ID\}/limits                          | Sim          | credit-cards-accounts | Não        | CREDIT_CARDS_ACCOUNTS_LIMITS_READ             | Sim              |             |
| GET      | /v1/accounts/\{ID\}/transactions                    | Sim          | credit-cards-accounts | Não        | CREDIT_CARDS_ACCOUNTS_TRANSACTIONS_READ       | Sim              |             |

### Accounts

**Base path:** /open-banking/accounts

**Cliente API:** TPP

| Operação | API                                  | Valida token | Escopo de acesso | Valida JWS | ConsentPermission              | Valida consentId | Observações |
| -------- | ------------------------------------ | ------------ | ---------------- | ---------- | ------------------------------ | ---------------- | ----------- |
| GET      | /v1/accounts                         | Sim          | accounts         | Não        | ACCOUNTS_READ                  | Sim              |             |
| GET      | /v1/accounts/\{ID\}                  | Sim          | accounts         | Não        | ACCOUNTS_READ                  | Sim              |             |
| GET      | /v1/accounts/\{ID\}/overdraft-limits | Sim          | accounts         | Não        | ACCOUNTS_OVERDRAFT_LIMITS_READ | Sim              |             |
| GET      | /v1/accounts/\{ID\}/balances         | Sim          | accounts         | Não        | ACCOUNTS_BALANCES_READ         | Sim              |             |
| GET      | /v1/accounts/\{ID\}/transactions     | Sim          | accounts         | Não        | ACCOUNTS_TRANSACTIONS_READ     | Sim              |             |

### Loans

**Base path:** /open-banking/loans

**Cliente API:** TPP

| Operação | API                                        | Valida token | Escopo de acesso | Valida JWS | ConsentPermission                | Valida consentId | Observações |
| -------- | ------------------------------------------ | ------------ | ---------------- | ---------- | -------------------------------- | ---------------- | ----------- |
| GET      | /v1/contracts                              | Sim          | loans            | Não        | LOANS_READ                       | Sim              |             |
| GET      | /v1/contracts/\{ID\}                       | Sim          | loans            | Não        | LOANS_READ                       | Sim              |             |
| GET      | /v1/contracts/\{ID\}/payments              | Sim          | loans            | Não        | LOANS_PAYMENTS_READ              | Sim              |             |
| GET      | /v1/contracts/\{ID\}/scheduled-instalments | Sim          | loans            | Não        | LOANS_SCHEDULED_INSTALMENTS_READ | Sim              |             |
| GET      | /v1/contracts/\{ID\}/warranties            | Sim          | loans            | Não        | LOANS_WARRANTIES_READ            | Sim              |             |

### Financings

**Base path:** /open-banking/financings

**Cliente API:** TPP

| Operação | API                                        | Valida token | Escopo de acesso | Valida JWS | ConsentPermission                     | Valida consentId | Observações |
| -------- | ------------------------------------------ | ------------ | ---------------- | ---------- | ------------------------------------- | ---------------- | ----------- |
| GET      | /v1/contracts                              | Sim          | financings       | Não        | FINANCINGS_READ                       | Sim              |             |
| GET      | /v1/contracts/\{ID\}                       | Sim          | financings       | Não        | FINANCINGS_READ                       | Sim              |             |
| GET      | /v1/contracts/\{ID\}/payments              | Sim          | financings       | Não        | FINANCINGS_PAYMENTS_READ              | Sim              |             |
| GET      | /v1/contracts/\{ID\}/scheduled-instalments | Sim          | financings       | Não        | FINANCINGS_SCHEDULED_INSTALMENTS_READ | Sim              |             |
| GET      | /v1/contracts/\{ID\}/warranties            | Sim          | financings       | Não        | FINANCINGS_WARRANTIES_READ            | Sim              |             |

### Unarranged accounts overdraft

**Base path:** /open-banking/unarranged-accounts-overdraft

**Cliente API:** TPP

| Operação | API                                        | Valida token | Escopo de acesso              | Valida JWS | ConsentPermission                                        | Valida consentId | Observações |
| -------- | ------------------------------------------ | ------------ | ----------------------------- | ---------- | -------------------------------------------------------- | ---------------- | ----------- |
| GET      | /v1/contracts                              | Sim          | unarranged-accounts-overdraft | Não        | UNARRANGED_ACCOUNTS_OVERDRAFT_READ                       | Sim              |             |
| GET      | /v1/contracts/\{ID\}                       | Sim          | unarranged-accounts-overdraft | Não        | UNARRANGED_ACCOUNTS_OVERDRAFT_READ                       | Sim              |             |
| GET      | /v1/contracts/\{ID\}/payments              | Sim          | unarranged-accounts-overdraft | Não        | UNARRANGED_ACCOUNTS_OVERDRAFT_PAYMENTS_READ              | Sim              |             |
| GET      | /v1/contracts/\{ID\}/scheduled-instalments | Sim          | unarranged-accounts-overdraft | Não        | UNARRANGED_ACCOUNTS_OVERDRAFT_SCHEDULED_INSTALMENTS_READ | Sim              |             |
| GET      | /v1/contracts/\{ID\}/warranties            | Sim          | unarranged-accounts-overdraft | Não        | UNARRANGED_ACCOUNTS_OVERDRAFT_WARRANTIES_READ            | Sim              |             |

### Invoice financings

**Base path:** /open-banking/invoice-financings

**Cliente API:** TPP

| Operação | API                                        | Valida token | Escopo de acesso   | Valida JWS | ConsentPermission                             | Valida consentId | Observações |
| -------- | ------------------------------------------ | ------------ | ------------------ | ---------- | --------------------------------------------- | ---------------- | ----------- |
| GET      | /v1/contracts                              | Sim          | invoice-financings | Não        | INVOICE_FINANCINGS_READ                       | Sim              |             |
| GET      | /v1/contracts/\{ID\}                       | Sim          | invoice-financings | Não        | INVOICE_FINANCINGS_READ                       | Sim              |             |
| GET      | /v1/contracts/\{ID\}/payments              | Sim          | invoice-financings | Não        | INVOICE_FINANCINGS_PAYMENTS_READ              | Sim              |             |
| GET      | /v1/contracts/\{ID\}/scheduled-instalments | Sim          | invoice-financings | Não        | INVOICE_FINANCINGS_SCHEDULED_INSTALMENTS_READ | Sim              |             |
| GET      | /v1/contracts/\{ID\}/warranties            | Sim          | invoice-financings | Não        | INVOICE_FINANCINGS_WARRANTIES_READ            | Sim              |             |

## Payments

**Base path:** /open-banking/payments

**Cliente API:** TPP

| Operação | API                     | Valida token | Escopo de acesso | Valida JWS | Valida consentId | Observações |
| -------- | ----------------------- | ------------ | ---------------- | ---------- | ---------------- | ----------- |
| POST     | /v1/consents            | Sim          | consents         | Sim        | Não              |             |
| GET      | /v1/consents/\{ID\}     | Sim          | consents         | Não        | Sim              |             |
| POST     | /v1/pix/payments        | Sim          | payments         | Sim        | Sim              |             |
| GET      | /v1/pix/payments/\{ID\} | Sim          | payments         | Não        | Sim              |             |

## Consent

### Consents

**Base path:** /open-banking/consents

**Cliente API:** TPP

| Operação | API                 | Valida token | Escopo de acesso | Valida JWS | Valida consentId | Observações        |
| -------- | ------------------- | ------------ | ---------------- | ---------- | ---------------- | ------------------ |
| POST     | /v1/consents        | Sim          | consents         | Não        | Não              |                    |
| GET      | /v1/consents/\{ID\} | Sim          | consents         | Não        | Não              | [*1](#observações) |
| DELETE   | /v1/consents/\{ID\} | Sim          | consents         | Não        | Não              | [*1](#observações) |

### Resources

**Base path:** /open-banking/resources

**Cliente API:** TPP

| Operação | API           | Valida token | Escopo de acesso | Valida JWS | ConsentPermission | Valida consentId | Observações |
| -------- | ------------- | ------------ | ---------------- | ---------- | ----------------- | ---------------- | ----------- |
| GET      | /v1/resources | Sim          | resources        | Não        | RESOURCES_READ    | Sim              |             |

### OOB consents

**Base path:** /open-banking/oob-consents

**Cliente API:**

- Portal gestão consentimento (backoffice)
- Portal gestão consentimento (cliente)

| Operação | API                              | Valida token | Escopo de acesso                 | Valida JWS | Valida consentId | Observações        |
| -------- | -------------------------------- | ------------ | -------------------------------- | ---------- | ---------------- | ------------------ |
| GET      | /v1/domains/permission           | Sim          | oob_consents:read, oob_customer  | Não        | Não              |                    |
| GET      | /v1/domains/consent-type         | Sim          | oob_consents:read, oob_customer  | Não        | Não              |                    |
| GET      | /v1/domains/consent-status       | Sim          | oob_consents:read, oob_customer  | Não        | Não              |                    |
| *GET     | /v1/domains/resource-type        | Sim          | oob_consents:read, oob_customer  | Não        | Não              |                    |
| *DELETE  | /v1/authorisations/\{ID\}        | Sim          | oob_consents:write, oob_customer | Não        | Não              | [*2](#observações) |
| *PUT     | /v1/authorisations/\{ID\}/accept | Sim          | oob_consents:write, oob_customer | Não        | Não              | [*2](#observações) |
| *GET     | /v1/consents                     | Sim          | oob_consents:read, oob_customer  | Não        | Não              |                    |
| *GET     | /v1/consents/\{ID\}              | Sim          | oob_consents:read, oob_customer  | Não        | Não              | [*2](#observações) |

### OOB Internal consents

**Base path:** /open-banking/oob-internal-consents

**Cliente API:**

- AS OOB
- Serviços OOB

**OBS:** APIS de uso interno da plataforma, não expostas no Kong.

| Operação | API                                                     | Valida token | Escopo de acesso | Valida JWS | Valida consentId | Observações |
| -------- | ------------------------------------------------------- | ------------ | ---------------- | ---------- | ---------------- | ----------- |
| GET      | /v1/consents/\{ID\}/basic-info$                         | Não          | oob_as           | Não        | Não              |             |
| GET      | /v1/consents/\{ID\}                                     | Não          | oob_as           | Não        | Não              |             |
| PUT      | /v1/consents/\{ID\}                                     | Não          | oob_as           | Não        | Não              |             |
| DELETE   | /v1/consents/\{ID\}                                     | Não          | oob_as           | Não        | Não              |             |
| POST     | /v1/consents/\{ID\}/consume                             | Não          |                  | Não        | Sim              |             |
| PUT      | /v1/consents/\{ID\}/legacy-ids                          | Não          |                  | Não        | Sim              |             |
| GET      | /v1/consents/\{ID\}/open-banking-ids/\{ID\}/type/\{ID\} | Não          |                  | Não        | Sim              |             |
| GET      | /v1/domains/permission                                  | Não          | oob_as           | Não        | Não              |             |
| GET      | /v1/domains/resource-type                               | Não          | oob_as           | Não        | Não              |             |

## Observações

- `*1:` Valida se o consentimento referenciado pertence ao TPP.
- `*2:` Quando escopo = oob_customer, valida se o consentimento referenciado pertence ao cliente.