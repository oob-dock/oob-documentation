# Security Controls per API

- [Security Controls per API](#security-controls-per-api)
  - [Channels catalog](#channels-catalog)
  - [Channels catalog maintenance](#channels-catalog-maintenance)
  - [Products and services catalog](#products-and-services-catalog)
  - [Products and services catalog maintenance](#products-and-services-catalog-maintenance)
  - [Accounts catalog](#accounts-catalog)
  - [Credit cards catalog](#credit-cards-catalog)
  - [Invoice financings catalog](#invoice-financings-catalog)
  - [Loans catalog](#loans-catalog)
  - [Financings catalog](#financings-catalog)
  - [Unarranged account overdraft catalog](#unarranged-account-overdraft-catalog)
  - [Status](#status)
    - [Status](#status-1)
    - [Admin](#admin)
  - [Outages maintenance](#outages-maintenance)
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
    - [Exchanges](#exchanges)
  - [Payments](#payments)
  - [No Redirect Journey](#no-redirect-journey)
  - [Automatic Payments](#automatic-payments)
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
  - [Notes](#notes)

## Channels catalog

**Base path:** /open-banking/channels

**Client API:** Any (Open on the internet)

| Operation | API                                  | Token Validated | Access Scope   | JWS Validated | consentId Validated | mTLS | Notes |
| --------- | ------------------------------------ | --------------- | -------------- | ------------- | ------------------- | ---- | ----- |
| GET       | /v1/branches                         | No              |                | No            | No                  | No   |       |
| GET       | /v1/electronic-channels              | No              |                | No            | No                  | No   |       |
| GET       | /v1/phone-channels                   | No              |                | No            | No                  | No   |       |
| GET       | /v1/banking-agents                   | No              |                | No            | No                  | No   |       |
| GET       | /v1/shared-automated-teller-machines | No              |                | No            | No                  | No   |       |
| GET       | /v2/branches                         | No              |                | No            | No                  | No   |       |
| GET       | /v2/electronic-channels              | No              |                | No            | No                  | No   |       |
| GET       | /v2/phone-channels                   | No              |                | No            | No                  | No   |       |
| GET       | /v2/banking-agents                   | No              |                | No            | No                  | No   |       |
| GET       | /v2/shared-automated-teller-machines | No              |                | No            | No                  | No   |       |

## Channels catalog maintenance

**Base path:** /open-banking/channels-maintenance

**Client API:**

- Backoffice portal
- Internal bank system

| Operation | API                                                         | Token Validated | Access Scope        | JWS Validated | consentId Validated | mTLS | Notes |
| --------- | ----------------------------------------------------------- | --------------- | ------------------- | ------------- | ------------------- | ---- | ----- |
| GET       | /v1/brand                                                   | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| PUT       | /v1/brand                                                   | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| GET       | /v1/banking-agents-contractors                              | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/electronic-channels                                     | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| POST      | /v1/electronic-channels                                     | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| PUT       | /v1/electronic-channels/\{ID\}                              | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| DELETE    | /v1/electronic-channels/\{ID\}                              | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| GET       | /v1/phone-channels                                          | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| POST      | /v1/phone-channels                                          | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| PUT       | /v1/phone-channels/\{ID\}                                   | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| DELETE    | /v1/phone-channels/\{ID\}                                   | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| GET       | /v1/companies                                               | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| POST      | /v1/companies                                               | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| PUT       | /v1/companies/\{ID\}                                        | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| DELETE    | /v1/companies/\{ID\}                                        | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| GET       | /v1/shared-automated-teller-machines                        | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| POST      | /v1/shared-automated-teller-machines                        | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| PUT       | /v1/shared-automated-teller-machines/\{ID\}                 | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| DELETE    | /v1/shared-automated-teller-machines/\{ID\}                 | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| GET       | /v1/banking-agents                                          | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| POST      | /v1/banking-agents                                          | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| PUT       | /v1/banking-agents/\{ID\}                                   | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| DELETE    | /v1/banking-agents/\{ID\}                                   | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| GET       | /v1/branches                                                | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| POST      | /v1/branches                                                | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| PUT       | /v1/branches/\{ID\}                                         | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| DELETE    | /v1/branches/\{ID\}                                         | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| POST      | /v1/banking-agents-contractors                              | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| DELETE    | /v1/banking-agents-contractors/\{ID\}                       | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| PUT       | /v1/banking-agents-contractors/\{ID\}                       | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| GET       | /v1/companies/\{ID\}                                        | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/branches/\{ID\}                                         | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/electronic-channels/\{ID\}                              | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/phone-channels/\{ID\}                                   | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/banking-agents/\{ID\}                                   | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/banking-agents-contractors/\{ID\}                       | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/shared-automated-teller-machines/\{ID\}                 | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/domains/branch-type                                     | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/domains/shared-automated-teller-machines-services-names | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/domains/shared-automated-teller-machines-services-codes | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/domains/phone-channel-type                              | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/domains/phone-type                                      | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/domains/electronic-type                                 | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/domains/branch-phone-and-electronic-name                | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/domains/branch-phone-and-electronic-code                | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/domains/banking-agent-name                              | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/domains/banking-agent-code                              | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/domains/weekday                                         | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/domains                                                 | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/domains/country-sub-division                            | Yes             | oob_opendata:read   | No            | No                  | No   |       |

## Products and services catalog

**Base path:** /open-banking/products-services

**Client API:** Any (Open on the internet)

| Operation | API                                       | Token Validated | Access Scope | JWS Validated | consentId Validated | mTLS | Notes |
| --------- | ----------------------------------------- | --------------- | ------------ | ------------- | ------------------- | ---- | ----- |
| GET       | /v1/personal-accounts                     | No              |              | No            | No                  | No   |       |
| GET       | /v1/business-accounts                     | No              |              | No            | No                  | No   |       |
| GET       | /v1/personal-loans                        | No              |              | No            | No                  | No   |       |
| GET       | /v1/business-loans                        | No              |              | No            | No                  | No   |       |
| GET       | /v1/personal-financings                   | No              |              | No            | No                  | No   |       |
| GET       | /v1/business-financings                   | No              |              | No            | No                  | No   |       |
| GET       | /v1/personal-invoice-financings           | No              |              | No            | No                  | No   |       |
| GET       | /v1/business-invoice-financings           | No              |              | No            | No                  | No   |       |
| GET       | /v1/personal-credit-cards                 | No              |              | No            | No                  | No   |       |
| GET       | /v1/business-credit-cards                 | No              |              | No            | No                  | No   |       |
| GET       | /v1/personal-unarranged-account-overdraft | No              |              | No            | No                  | No   |       |
| GET       | /v1/business-unarranged-account-overdraft | No              |              | No            | No                  | No   |       |

## Products and services catalog maintenance

**Base path:** /open-banking/products-services-maintenance

**Client API:**

- Backoffice portal
- Internal bank system

| Operation | API                                                        | Token Validated | Access Scope        | JWS Validated | consentId Validated | mTLS | Notes |
| --------- | ---------------------------------------------------------- | --------------- | ------------------- | ------------- | ------------------- | ---- | ----- |
| GET       | /v1/brand                                                  | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| PUT       | /v1/brand                                                  | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| GET       | /v1/companies                                              | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/companies/\{ID\}                                       | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| POST      | /v1/companies                                              | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| PUT       | /v1/companies/\{ID\}                                       | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| DELETE    | /v1/companies/\{ID\}                                       | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| GET       | /v1/accounts                                               | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/accounts/\{ID\}                                        | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| POST      | /v1/accounts                                               | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| PUT       | /v1/accounts/\{ID\}                                        | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| DELETE    | /v1/accounts/\{ID\}                                        | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| GET       | /v1/loans                                                  | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/loans/\{ID\}                                           | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| POST      | /v1/loans                                                  | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| PUT       | /v1/loans/\{ID\}                                           | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| DELETE    | /v1/loans/\{ID\}                                           | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| GET       | /v1/credit-cards                                           | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/credit-cards/\{ID\}                                    | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| POST      | /v1/credit-cards                                           | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| PUT       | /v1/credit-cards/\{ID\}                                    | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| DELETE    | /v1/credit-cards/\{ID\}                                    | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| GET       | /v1/financings                                             | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/financings/\{ID\}                                      | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| POST      | /v1/financings                                             | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| PUT       | /v1/financings/\{ID\}                                      | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| DELETE    | /v1/financings/\{ID\}                                      | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| GET       | /v1/invoice-financings                                     | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/invoice-financings/\{ID\}                              | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| POST      | /v1/invoice-financings                                     | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| PUT       | /v1/invoice-financings/\{ID\}                              | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| DELETE    | /v1/invoice-financings/\{ID\}                              | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| GET       | /v1/unarranged-account-overdraft                           | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/unarranged-account-overdraft/\{ID\}                    | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| POST      | /v1/unarranged-account-overdraft                           | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| PUT       | /v1/unarranged-account-overdraft/\{ID\}                    | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| DELETE    | /v1/unarranged-account-overdraft/\{ID\}                    | Yes             | oob_opendata:write  | No            | No                  | No   |       |
| GET       | /v1/domains                                                | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/domains/credit-card-identification-credit-card-network | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/domains/credit-card-identification-product-type        | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/domains/financing-type                                 | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/domains/invoice-financing-type                         | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/domains/loan-type                                      | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/domains/unarranged-account-overdraft-fee-code          | Yes             | oob_opendata:read   | No            | No                  | No   |       |
| GET       | /v1/domains/unarranged-account-overdraft-fee-name          | Yes             | oob_opendata:read   | No            | No                  | No   |       |

## Accounts catalog

**Base path:** /open-banking/opendata-accounts

**Client API:** Any (Open on the internet)

| Operation | API                                       | Token Validated | Access Scope | JWS Validated | consentId Validated | mTLS | Notes |
| --------- | ----------------------------------------- | --------------- | ------------ | ------------- | ------------------- | ---- | ----- |
| GET       | /v1/personal-accounts                     | No              |              | No            | No                  | No   |       |
| GET       | /v1/business-accounts                     | No              |              | No            | No                  | No   |       |

## Credit cards catalog

**Base path:** /open-banking/opendata-creditcards

**Client API:** Any (Open on the internet)

| Operation | API                                       | Token Validated | Access Scope | JWS Validated | consentId Validated | mTLS | Notes |
| --------- | ----------------------------------------- | --------------- | ------------ | ------------- | ------------------- | ---- | ----- |
| GET       | /v1/personal-credit-cards                 | No              |              | No            | No                  | No   |       |
| GET       | /v1/business-credit-cards                 | No              |              | No            | No                  | No   |       |

## Invoice financings catalog

**Base path:** /open-banking/opendata-invoicefinancings

**Client API:** Any (Open on the internet)

| Operation | API                                       | Token Validated | Access Scope | JWS Validated | consentId Validated | mTLS | Notes |
| --------- | ----------------------------------------- | --------------- | ------------ | ------------- | ------------------- | ---- | ----- |
| GET       | /v1/personal-invoice-financings           | No              |              | No            | No                  | No   |       |
| GET       | /v1/business-invoice-financings           | No              |              | No            | No                  | No   |       |

## Loans catalog

**Base path:** /open-banking/opendata-loans

**Client API:** Any (Open on the internet)

| Operation | API                                       | Token Validated | Access Scope | JWS Validated | consentId Validated | mTLS | Notes |
| --------- | ----------------------------------------- | --------------- | ------------ | ------------- | ------------------- | ---- | ----- |
| GET       | /v1/personal-loans                        | No              |              | No            | No                  | No   |       |
| GET       | /v1/business-loans                        | No              |              | No            | No                  | No   |       |

## Financings catalog

**Base path:** /open-banking/opendata-financings

**Client API:** Any (Open on the internet)

| Operation | API                                       | Token Validated | Access Scope | JWS Validated | consentId Validated | mTLS | Notes |
| --------- | ----------------------------------------- | --------------- | ------------ | ------------- | ------------------- | ---- | ----- |
| GET       | /v1/personal-financings                   | No              |              | No            | No                  | No   |       |
| GET       | /v1/business-financings                   | No              |              | No            | No                  | No   |       |

## Unarranged account overdraft catalog

**Base path:** /open-banking/opendata-unarranged

**Client API:** Any (Open on the internet)

| Operation | API                                       | Token Validated | Access Scope | JWS Validated | consentId Validated | mTLS | Notes |
| --------- | ----------------------------------------- | --------------- | ------------ | ------------- | ------------------- | ---- | ----- |
| GET       | /v1/personal-unarranged-account-overdraft | No              |              | No            | No                  | No   |       |
| GET       | /v1/business-unarranged-account-overdraft | No              |              | No            | No                  | No   |       |

## Status

### Status

**Base path:** /open-banking/discovery

**Client API:** Any (Open on the internet)

| Operation | API         | Token Validated | Access Scope | JWS Validated | consentId Validated | mTLS | Notes |
| --------- | ----------- | --------------- | ------------ | ------------- | ------------------- | ---- | ----- |
| GET       | /v1/status  | No              |              | No            | No                  | No   |       |
| GET       | /v1/outages | No              |              | No            | No                  | No   |       |
| GET       | /v2/status  | No              |              | No            | No                  | No   |       |
| GET       | /v2/outages | No              |              | No            | No                  | No   |       |

### Admin

**Base path:** /open-banking/admin

**Client API:** Any (Open on the internet)

| Operation | API         | Token Validated | Access Scope | JWS Validated | consentId Validated | mTLS | Notes |
| --------- | ----------- | --------------- | ------------ | ------------- | ------------------- | ---- | ----- |
| GET       | /v1/metrics | No              |              | No            | No                  | No   |       |
| GET       | /v2/metrics | No              |              | No            | No                  | No   |       |

## Outages maintenance

**Base path:** /open-banking/outages-maintenance

**Client API:**

- Backoffice portal
- Internal bank system

| Operation | API                      | Token Validated | Access Scope    | JWS Validated | consentId Validated | mTLS | Notes |
| --------- | ------------------------ | --------------- | --------------- | ------------- | ------------------- | ---- | ----- |
| GET       | /v1/domains/failure-type | Yes             | oob_outages:read | No            | No                  | No   |       |
| GET       | /v1/endpoints            | Yes             | oob_outages:read | No            | No                  | No   |       |
| GET       | /v1/outages              | Yes             | oob_outages:read | No            | No                  | No   |       |
| POST      | /v1/outages              | Yes             | oob_outages:write | No            | No                  | No   |       |
| GET       | /v1/outages/\{ID\}       | Yes             | oob_outages:read | No            | No                  | No   |       |
| PUT       | /v1/outages/\{ID\}       | Yes             | oob_outages:write | No            | No                  | No   |       |
| DELETE    | /v1/outages/\{ID\}       | Yes             | oob_outages:write | No            | No                  | No   |       |
| GET       | /v1/failures             | Yes             | oob_outages:read | No            | No                  | No   |       |
| GET       | /v1/failures/\{ID\}      | Yes             | oob_outages:read | No            | No                  | No   |       |
| PUT       | /v1/failures/\{ID\}      | Yes             | oob_outages:write | No            | No                  | No   |       |
| GET       | /v1/services             | Yes             | oob_outages:read | No            | No                  | No   |       |

## Financial data

### Customers

**Base path:** /open-banking/customers

**Client API:** TPP

| Operation | API                              | Token Validated | Access Scope | JWS Validated | Consent Permission                      | consentId Validated | mTLS | Notes |
| --------- | -------------------------------- | --------------- | ------------ | ------------- | --------------------------------------- | ------------------- | ---- | ----- |
| GET       | /v1/business/identifications     | Yes             | customers    | No            | CUSTOMERS_BUSINESS_IDENTIFICATIONS_READ | Yes                 | Yes  |       |
| GET       | /v1/business/financial-relations | Yes             | customers    | No            | CUSTOMERS_BUSINESS_ADDITIONALINFO_READ  | Yes                 | Yes  |       |
| GET       | /v1/business/qualifications      | Yes             | customers    | No            | CUSTOMERS_BUSINESS_ADDITIONALINFO_READ  | Yes                 | Yes  |       |
| GET       | /v1/personal/identifications     | Yes             | customers    | No            | CUSTOMERS_PERSONAL_IDENTIFICATIONS_READ | Yes                 | Yes  |       |
| GET       | /v1/personal/financial-relations | Yes             | customers    | No            | CUSTOMERS_PERSONAL_ADDITIONALINFO_READ  | Yes                 | Yes  |       |
| GET       | /v1/personal/qualifications      | Yes             | customers    | No            | CUSTOMERS_PERSONAL_ADDITIONALINFO_READ  | Yes                 | Yes  |       |
| GET       | /v2/business/identifications     | Yes             | customers    | No            | CUSTOMERS_BUSINESS_IDENTIFICATIONS_READ | Yes                 | Yes  |       |
| GET       | /v2/business/financial-relations | Yes             | customers    | No            | CUSTOMERS_BUSINESS_ADDITIONALINFO_READ  | Yes                 | Yes  |       |
| GET       | /v2/business/qualifications      | Yes             | customers    | No            | CUSTOMERS_BUSINESS_ADDITIONALINFO_READ  | Yes                 | Yes  |       |
| GET       | /v2/personal/identifications     | Yes             | customers    | No            | CUSTOMERS_PERSONAL_IDENTIFICATIONS_READ | Yes                 | Yes  |       |
| GET       | /v2/personal/financial-relations | Yes             | customers    | No            | CUSTOMERS_PERSONAL_ADDITIONALINFO_READ  | Yes                 | Yes  |       |
| GET       | /v2/personal/qualifications      | Yes             | customers    | No            | CUSTOMERS_PERSONAL_ADDITIONALINFO_READ  | Yes                 | Yes  |       |

### Credit cards accounts

**Base path:** /open-banking/credit-cards-accounts

**Client API:** TPP

| Operation | API                                                 | Token Validated     | Access Scope           | JWS Validated | Consent Permission                               | consentId Validated | mTLS | Notes |
| --------- | --------------------------------------------------- | ------------------- | ---------------------- | ------------- | ------------------------------------------------ | ------------------- | ---- | ----- |
| GET       | /v1/accounts                                        | Yes                 | credit-cards-accounts  | No            | CREDIT_CARDS_ACCOUNTS_READ                       | Yes                 | Yes  |       |
| GET       | /v1/accounts/\{ID\}                                 | Yes                 | credit-cards-accounts  | No            | CREDIT_CARDS_ACCOUNTS_READ                       | Yes                 | Yes  |       |
| GET       | /v1/accounts/\{ID\}/bills                           | Yes                 | credit-cards-accounts  | No            | CREDIT_CARDS_ACCOUNTS_BILLS_READ                 | Yes                 | Yes  |       |
| GET       | /v1/accounts/\{ID\}/bills/\{ID\}/bills/transactions | Yes                 | credit-cards-accounts  | No            | CREDIT_CARDS_ACCOUNTS_BILLS_TRANSACTIONS_READ    | Yes                 | Yes  |       |
| GET       | /v1/accounts/\{ID\}/limits                          | Yes                 | credit-cards-accounts  | No            | CREDIT_CARDS_ACCOUNTS_LIMITS_READ                | Yes                 | Yes  |       |
| GET       | /v1/accounts/\{ID\}/transactions                    | Yes                 | credit-cards-accounts  | No            | CREDIT_CARDS_ACCOUNTS_TRANSACTIONS_READ          | Yes                 | Yes  |       |
| GET       | /v2/accounts                                        | Yes                 | credit-cards-accounts  | No            | CREDIT_CARDS_ACCOUNTS_READ                       | Yes                 | Yes  |       |
| GET       | /v2/accounts/\{ID\}                                 | Yes                 | credit-cards-accounts  | No            | CREDIT_CARDS_ACCOUNTS_READ                       | Yes                 | Yes  |       |
| GET       | /v2/accounts/\{ID\}/bills                           | Yes                 | credit-cards-accounts  | No            | CREDIT_CARDS_ACCOUNTS_BILLS_READ                 | Yes                 | Yes  |       |
| GET       | /v2/accounts/\{ID\}/bills/\{ID\}/bills/transactions | Yes                 | credit-cards-accounts  | No            | CREDIT_CARDS_ACCOUNTS_BILLS_TRANSACTIONS_READ    | Yes                 | Yes  |       |
| GET       | /v2/accounts/\{ID\}/limits                          | Yes                 | credit-cards-accounts  | No            | CREDIT_CARDS_ACCOUNTS_LIMITS_READ                | Yes                 | Yes  |       |
| GET       | /v2/accounts/\{ID\}/transactions                    | Yes                 | credit-cards-accounts  | No            | CREDIT_CARDS_ACCOUNTS_TRANSACTIONS_READ          | Yes                 | Yes  |       |
| GET       | /v2/accounts/\{ID\}/transactions-current            | Yes                 | credit-cards-accounts  | No            | CREDIT_CARDS_ACCOUNTS_TRANSACTIONS_READ          | Yes                 | Yes  |       |

### Accounts

**Base path:** /open-banking/accounts

**Client API:** TPP

| Operation | API                                          | Token Validated | Access Scope   | JWS Validated | Consent Permission              | consentId Validated | mTLS | Notes |
| --------- | -------------------------------------------- | --------------- | -------------- | ------------- | ------------------------------ | ------------------- | ---- | ----- |
| GET       | /v1/accounts                                 | Yes             | accounts       | No            | ACCOUNTS_READ                  | Yes                 | Yes  |       |
| GET       | /v1/accounts/\{ID\}                          | Yes             | accounts       | No            | ACCOUNTS_READ                  | Yes                 | Yes  |       |
| GET       | /v1/accounts/\{ID\}/overdraft-limits         | Yes             | accounts       | No            | ACCOUNTS_OVERDRAFT_LIMITS_READ | Yes                 | Yes  |       |
| GET       | /v1/accounts/\{ID\}/balances                 | Yes             | accounts       | No            | ACCOUNTS_BALANCES_READ         | Yes                 | Yes  |       |
| GET       | /v1/accounts/\{ID\}/transactions             | Yes             | accounts       | No            | ACCOUNTS_TRANSACTIONS_READ     | Yes                 | Yes  |       |
| GET       | /v2/accounts                                 | Yes             | accounts       | No            | ACCOUNTS_READ                  | Yes                 | Yes  |       |
| GET       | /v2/accounts/\{ID\}                          | Yes             | accounts       | No            | ACCOUNTS_READ                  | Yes                 | Yes  |       |
| GET       | /v2/accounts/\{ID\}/overdraft-limits         | Yes             | accounts       | No            | ACCOUNTS_OVERDRAFT_LIMITS_READ | Yes                 | Yes  |       |
| GET       | /v2/accounts/\{ID\}/balances                 | Yes             | accounts       | No            | ACCOUNTS_BALANCES_READ         | Yes                 | Yes  |       |
| GET       | /v2/accounts/\{ID\}/transactions             | Yes             | accounts       | No            | ACCOUNTS_TRANSACTIONS_READ     | Yes                 | Yes  |       |
| GET       | /v2/accounts/\{ID\}/transactions-current     | Yes             | accounts       | No            | ACCOUNTS_TRANSACTIONS_READ     | Yes                 | Yes  |       |

### Loans

**Base path:** /open-banking/loans

**Client API:** TPP

| Operation | API                                        | Token Validated | Access Scope | JWS Validated | Consent Permission                | consentId Validated | mTLS | Notes |
| --------- | ------------------------------------------ | --------------- | ------------ | ------------- | -------------------------------- | ------------------- | ---- | ----- |
| GET       | /v1/contracts                              | Yes             | loans        | No            | LOANS_READ                       | Yes                 | Yes  |       |
| GET       | /v1/contracts/\{ID\}                       | Yes             | loans        | No            | LOANS_READ                       | Yes                 | Yes  |       |
| GET       | /v1/contracts/\{ID\}/payments              | Yes             | loans        | No            | LOANS_PAYMENTS_READ              | Yes                 | Yes  |       |
| GET       | /v1/contracts/\{ID\}/scheduled-instalments | Yes             | loans        | No            | LOANS_SCHEDULED_INSTALMENTS_READ | Yes                 | Yes  |       |
| GET       | /v1/contracts/\{ID\}/warranties            | Yes             | loans        | No            | LOANS_WARRANTIES_READ            | Yes                 | Yes  |       |
| GET       | /v2/contracts                              | Yes             | loans        | No            | LOANS_READ                       | Yes                 | Yes  |       |
| GET       | /v2/contracts/\{ID\}                       | Yes             | loans        | No            | LOANS_READ                       | Yes                 | Yes  |       |
| GET       | /v2/contracts/\{ID\}/payments              | Yes             | loans        | No            | LOANS_PAYMENTS_READ              | Yes                 | Yes  |       |
| GET       | /v2/contracts/\{ID\}/scheduled-instalments | Yes             | loans        | No            | LOANS_SCHEDULED_INSTALMENTS_READ | Yes                 | Yes  |       |
| GET       | /v2/contracts/\{ID\}/warranties            | Yes             | loans        | No            | LOANS_WARRANTIES_READ            | Yes                 | Yes  |       |

### Financings

**Base path:** /open-banking/financings

**Client API:** TPP

| Operation | API                                        | Token Validated | Access Scope | JWS Validated | Consent Permission                     | consentId Validated | mTLS | Notes |
| --------- | ------------------------------------------ | --------------- | ------------ | ------------- | ------------------------------------- | ------------------- | ---- | ----- |
| GET       | /v1/contracts                              | Yes             | financings   | No            | FINANCINGS_READ                       | Yes                 | Yes  |       |
| GET       | /v1/contracts/\{ID\}                       | Yes             | financings   | No            | FINANCINGS_READ                       | Yes                 | Yes  |       |
| GET       | /v1/contracts/\{ID\}/payments              | Yes             | financings   | No            | FINANCINGS_PAYMENTS_READ              | Yes                 | Yes  |       |
| GET       | /v1/contracts/\{ID\}/scheduled-instalments | Yes             | financings   | No            | FINANCINGS_SCHEDULED_INSTALMENTS_READ | Yes                 | Yes  |       |
| GET       | /v1/contracts/\{ID\}/warranties            | Yes             | financings   | No            | FINANCINGS_WARRANTIES_READ            | Yes                 | Yes  |       |
| GET       | /v2/contracts                              | Yes             | financings   | No            | FINANCINGS_READ                       | Yes                 | Yes  |       |
| GET       | /v2/contracts/\{ID\}                       | Yes             | financings   | No            | FINANCINGS_READ                       | Yes                 | Yes  |       |
| GET       | /v2/contracts/\{ID\}/payments              | Yes             | financings   | No            | FINANCINGS_PAYMENTS_READ              | Yes                 | Yes  |       |
| GET       | /v2/contracts/\{ID\}/scheduled-instalments | Yes             | financings   | No            | FINANCINGS_SCHEDULED_INSTALMENTS_READ | Yes                 | Yes  |       |
| GET       | /v2/contracts/\{ID\}/warranties            | Yes             | financings   | No            | FINANCINGS_WARRANTIES_READ            | Yes                 | Yes  |       |

### Unarranged accounts overdraft

**Base path:** /open-banking/unarranged-accounts-overdraft

**Client API:** TPP

| Operation | API                                        | Token Validated                 | Access Scope                 | JWS Validated | Consent Permission                | consentId Validated         | mTLS | Notes |
| --------- | ------------------------------------------ | ------------------------------- | ---------------------------- | ------------- | -------------------------------- | --------------------------- | ---- | ----- |
| GET       | /v1/contracts                              | Yes                             | unarranged-accounts-overdraft | No            | UNARRANGED_ACCOUNTS_OVERDRAFT_READ | Yes                         | Yes  |       |
| GET       | /v1/contracts/\{ID\}                       | Yes                             | unarranged-accounts-overdraft | No            | UNARRANGED_ACCOUNTS_OVERDRAFT_READ | Yes                         | Yes  |       |
| GET       | /v1/contracts/\{ID\}/payments              | Yes                             | unarranged-accounts-overdraft | No            | UNARRANGED_ACCOUNTS_OVERDRAFT_PAYMENTS_READ | Yes               | Yes  |       |
| GET       | /v1/contracts/\{ID\}/scheduled-instalments | Yes                             | unarranged-accounts-overdraft | No            | UNARRANGED_ACCOUNTS_OVERDRAFT_SCHEDULED_INSTALMENTS_READ | Yes | Yes  |       |
| GET       | /v1/contracts/\{ID\}/warranties            | Yes                             | unarranged-accounts-overdraft | No            | UNARRANGED_ACCOUNTS_OVERDRAFT_WARRANTIES_READ | Yes               | Yes  |       |
| GET       | /v2/contracts                              | Yes                             | unarranged-accounts-overdraft | No            | UNARRANGED_ACCOUNTS_OVERDRAFT_READ | Yes                         | Yes  |       |
| GET       | /v2/contracts/\{ID\}                       | Yes                             | unarranged-accounts-overdraft | No            | UNARRANGED_ACCOUNTS_OVERDRAFT_READ | Yes                         | Yes  |       |
| GET       | /v2/contracts/\{ID\}/payments              | Yes                             | unarranged-accounts-overdraft | No            | UNARRANGED_ACCOUNTS_OVERDRAFT_PAYMENTS_READ | Yes               | Yes  |       |
| GET       | /v2/contracts/\{ID\}/scheduled-instalments | Yes                             | unarranged-accounts-overdraft | No            | UNARRANGED_ACCOUNTS_OVERDRAFT_SCHEDULED_INSTALMENTS_READ | Yes | Yes  |       |
| GET       | /v2/contracts/\{ID\}/warranties            | Yes                             | unarranged-accounts-overdraft | No            | UNARRANGED_ACCOUNTS_OVERDRAFT_WARRANTIES_READ | Yes               | Yes  |       |

### Invoice financings

**Base path:** /open-banking/invoice-financings

**Client API:** TPP

| Operation | API                                        | Token Validated     | Access Scope     | JWS Validated | Consent Permission                 | consentId Validated | mTLS | Notes |
| --------- | ------------------------------------------ | ------------------- | ---------------- | ------------- | ---------------------------------- | ------------------- | ---- | ----- |
| GET       | /v1/contracts                              | Yes                 | invoice-financings | No            | INVOICE_FINANCINGS_READ            | Yes                 | Yes  |       |
| GET       | /v1/contracts/\{ID\}                       | Yes                 | invoice-financings | No            | INVOICE_FINANCINGS_READ            | Yes                 | Yes  |       |
| GET       | /v1/contracts/\{ID\}/payments              | Yes                 | invoice-financings | No            | INVOICE_FINANCINGS_PAYMENTS_READ   | Yes                 | Yes  |       |
| GET       | /v1/contracts/\{ID\}/scheduled-instalments | Yes                 | invoice-financings | No            | INVOICE_FINANCINGS_SCHEDULED_INSTALMENTS_READ | Yes         | Yes  |       |
| GET       | /v1/contracts/\{ID\}/warranties            | Yes                 | invoice-financings | No            | INVOICE_FINANCINGS_WARRANTIES_READ | Yes                 | Yes  |       |
| GET       | /v2/contracts                              | Yes                 | invoice-financings | No            | INVOICE_FINANCINGS_READ            | Yes                 | Yes  |       |
| GET       | /v2/contracts/\{ID\}                       | Yes                 | invoice-financings | No            | INVOICE_FINANCINGS_READ            | Yes                 | Yes  |       |
| GET       | /v2/contracts/\{ID\}/payments              | Yes                 | invoice-financings | No            | INVOICE_FINANCINGS_PAYMENTS_READ   | Yes                 | Yes  |       |
| GET       | /v2/contracts/\{ID\}/scheduled-instalments | Yes                 | invoice-financings | No            | INVOICE_FINANCINGS_SCHEDULED_INSTALMENTS_READ | Yes         | Yes  |       |
| GET       | /v2/contracts/\{ID\}/warranties            | Yes                 | invoice-financings | No            | INVOICE_FINANCINGS_WARRANTIES_READ | Yes                 | Yes  |       |

### Bank fixed incomes

**Base path:** /open-banking/bank-fixed-incomes

**Client API:** TPP

| Operation | API                                                 | Token Validated     | Access Scope     | JWS Validated | Consent Permission       | consentId Validated | mTLS | Notes |
| --------- | --------------------------------------------------- | ------------------- | ---------------- | ------------- | ----------------------- | ------------------- | ---- | ----- |
| GET       | /v1/investments                                     | Yes                 | bank-fixed-incomes | No            | BANK_FIXED_INCOMES_READ | Yes                 | Yes  |       |
| GET       | /v1/investments/{investmentId}                      | Yes                 | bank-fixed-incomes | No            | BANK_FIXED_INCOMES_READ | Yes                 | Yes  |       |
| GET       | /v1/investments/{investmentId}/balances             | Yes                 | bank-fixed-incomes | No            | BANK_FIXED_INCOMES_READ | Yes                 | Yes  |       |
| GET       | /v1/investments/{investmentId}/transactions         | Yes                 | bank-fixed-incomes | No            | BANK_FIXED_INCOMES_READ | Yes                 | Yes  |       |
| GET       | /v1/investments/{investmentId}/transactions-current | Yes                 | bank-fixed-incomes | No            | BANK_FIXED_INCOMES_READ | Yes                 | Yes  |       |

### Credit fixed incomes

**Base path:** /open-banking/credit-fixed-incomes

**Client API:** TPP

| Operation | API                                                 | Token Validated       | Access Scope       | JWS Validated | Consent Permission         | consentId Validated | mTLS | Notes |
| --------- | --------------------------------------------------- | --------------------- | ------------------ | ------------- | ------------------------- | ------------------- | ---- | ----- |
| GET       | /v1/investments                                     | Yes                   | credit-fixed-incomes | No            | CREDIT_FIXED_INCOMES_READ | Yes                 | Yes  |       |
| GET       | /v1/investments/{investmentId}                      | Yes                   | credit-fixed-incomes | No            | CREDIT_FIXED_INCOMES_READ | Yes                 | Yes  |       |
| GET       | /v1/investments/{investmentId}/balances             | Yes                   | credit-fixed-incomes | No            | CREDIT_FIXED_INCOMES_READ | Yes                 | Yes  |       |
| GET       | /v1/investments/{investmentId}/transactions         | Yes                   | credit-fixed-incomes | No            | CREDIT_FIXED_INCOMES_READ | Yes                 | Yes  |       |
| GET       | /v1/investments/{investmentId}/transactions-current | Yes                   | credit-fixed-incomes | No            | CREDIT_FIXED_INCOMES_READ | Yes                 | Yes  |       |

### Variable incomes

**Base path:** /open-banking/variable-incomes

**Client API:** TPP

| Operation | API                                                 | Token Validated   | Access Scope    | JWS Validated | Consent Permission     | consentId Validated | mTLS | Notes |
| --------- | --------------------------------------------------- | ----------------- | --------------- | ------------- | --------------------- | ------------------- | ---- | ----- |
| GET       | /v1/investments                                     | Yes               | variable-incomes | No            | VARIABLE_INCOMES_READ | Yes                 | Yes  |       |
| GET       | /v1/investments/{investmentId}                      | Yes               | variable-incomes | No            | VARIABLE_INCOMES_READ | Yes                 | Yes  |       |
| GET       | /v1/investments/{investmentId}/balances             | Yes               | variable-incomes | No            | VARIABLE_INCOMES_READ | Yes                 | Yes  |       |
| GET       | /v1/investments/{investmentId}/transactions         | Yes               | variable-incomes | No            | VARIABLE_INCOMES_READ | Yes                 | Yes  |       |
| GET       | /v1/investments/{investmentId}/transactions-current | Yes               | variable-incomes | No            | VARIABLE_INCOMES_READ | Yes                 | Yes  |       |
| GET       | /v1/broker-notes/{brokerNoteId}                     | Yes               | variable-incomes | No            | VARIABLE_INCOMES_READ | Yes                 | Yes  |       |

### Treasure titles

**Base path:** /open-banking/treasure-titles

**Client API:** TPP

| Operation | API                                                 | Token Validated   | Access Scope    | JWS Validated | Consent Permission    | consentId Validated | mTLS | Notes |
| --------- | --------------------------------------------------- | ----------------- | --------------- | ------------- | -------------------- | ------------------- | ---- | ----- |
| GET       | /v1/investments                                     | Yes               | treasure-titles | No            | TREASURE_TITLES_READ | Yes                 | Yes  |       |
| GET       | /v1/investments/{investmentId}                      | Yes               | treasure-titles | No            | TREASURE_TITLES_READ | Yes                 | Yes  |       |
| GET       | /v1/investments/{investmentId}/balances             | Yes               | treasure-titles | No            | TREASURE_TITLES_READ | Yes                 | Yes  |       |
| GET       | /v1/investments/{investmentId}/transactions         | Yes               | treasure-titles | No            | TREASURE_TITLES_READ | Yes                 | Yes  |       |
| GET       | /v1/investments/{investmentId}/transactions-current | Yes               | treasure-titles | No            | TREASURE_TITLES_READ | Yes                 | Yes  |       |

### Funds

**Base path:** /open-banking/funds

**Client API:** TPP

| Operation | API                                                 | Token Validated   | Access Scope | JWS Validated | Consent Permission | consentId Validated | mTLS | Notes |
| --------- | --------------------------------------------------- | ----------------- | ------------ | ------------- | ----------------- | ------------------- | ---- | ----- |
| GET       | /v1/investments                                     | Yes               | funds        | No            | FUNDS_READ        | Yes                 | Yes  |       |
| GET       | /v1/investments/{investmentId}                      | Yes               | funds        | No            | FUNDS_READ        | Yes                 | Yes  |       |
| GET       | /v1/investments/{investmentId}/balances             | Yes               | funds        | No            | FUNDS_READ        | Yes                 | Yes  |       |
| GET       | /v1/investments/{investmentId}/transactions         | Yes               | funds        | No            | FUNDS_READ        | Yes                 | Yes  |       |
| GET       | /v1/investments/{investmentId}/transactions-current | Yes               | funds        | No            | FUNDS_READ        | Yes                 | Yes  |       |

### Exchanges

**Base path:** /open-banking/exchanges

**Client API:** TPP

| Operation | API                                 | Token Validated | Access Scope | JWS Validated | Consent Permission | consentId Validated | mTLS | Notes |
| --------- | ----------------------------------- | --------------- | ------------ | ------------- | ----------------- | ------------------- | ---- | ----- |
| GET       | /v1/operations                      | Yes             | exchanges    | No            | EXCHANGES_READ    | Yes                 | Yes  |       |
| GET       | /v1/operations/{operationId}        | Yes             | exchanges    | No            | EXCHANGES_READ    | Yes                 | Yes  |       |
| GET       | /v1/operations/{operationId}/events | Yes             | exchanges    | No            | EXCHANGES_READ    | Yes                 | Yes  |       |

## Payments

**Base path:** /open-banking/payments

**Client API:** TPP

| Operation | API                              | Token Validated | Access Scope | JWS Validated | consentId Validated | mTLS | Notes |
| --------- | -------------------------------- | --------------- | ------------ | ------------- | ------------------- | ---- | ----- |
| POST      | /v1/consents                     | Yes             | payments     | Yes           | No                  | Yes  |       |
| GET       | /v1/consents/\{ID\}              | Yes             | payments     | No            | No                  | Yes  |       |
| POST      | /v2/consents                     | Yes             | payments     | Yes           | No                  | Yes  |       |
| GET       | /v2/consents/\{ID\}              | Yes             | payments     | No            | No                  | Yes  |       |
| POST      | /v3/consents                     | Yes             | payments     | Yes           | No                  | Yes  |       |
| GET       | /v3/consents/\{ID\}              | Yes             | payments     | No            | No                  | Yes  |       |
| POST      | /v4/consents                     | Yes             | payments     | Yes           | No                  | Yes  |       |
| GET       | /v4/consents/\{ID\}              | Yes             | payments     | No            | No                  | Yes  |       |
| POST      | /v1/pix/payments                 | Yes             | payments     | Yes           | Yes                 | Yes  |       |
| GET       | /v1/pix/payments/\{ID\}          | Yes             | payments     | No            | No                  | Yes  |       |
| POST      | /v2/pix/payments                 | Yes             | payments     | Yes           | Yes                 | Yes  |       |
| GET       | /v2/pix/payments/\{ID\}          | Yes             | payments     | No            | No                  | Yes  |       |
| PATCH     | /v2/pix/payments/\{ID\}          | Yes             | payments     | Yes           | No                  | Yes  |       |
| POST      | /v3/pix/payments                 | Yes             | payments     | Yes           | Yes                 | Yes  |       |
| GET       | /v3/pix/payments/\{ID\}          | Yes             | payments     | No            | No                  | Yes  |       |
| PATCH     | /v3/pix/payments/\{ID\}          | Yes             | payments     | Yes           | No                  | Yes  |       |
| POST      | /v4/pix/payments                 | Yes             | payments     | Yes           | Yes                 | Yes  |       |
| GET       | /v4/pix/payments/\{ID\}          | Yes             | payments     | No            | No                  | Yes  |       |
| PATCH     | /v4/pix/payments/\{ID\}          | Yes             | payments     | Yes           | No                  | Yes  |       |
| PATCH     | /v4/pix/payments/consents/\{ID\} | Yes             | payments     | Yes           | No                  | Yes  |       |

## No Redirect Journey

**Base path:** /open-banking/enrollments

**Cliente API:** TPP

| Operation | API                                             | Token Validated | Access Scope     | JWS Validated | enrollmentId Validated | mTLS | Notes |
| -------- | ------------------------------------------------ | --------------- | ---------------- | ------------- | ---------------------- | ---- | ----- |
| POST     | /v2/enrollments                                  | Yes             | payments         | Yes           | No                     | Yes  |       |
| POST     | /v2/enrollments/\{ID\}/risk-signals              | Yes             | payments         | Yes           | No                     | Yes  |       |
| GET      | /v2/enrollments/\{ID\}                           | Yes             | payments         | No            | No                     | Yes  |       |
| PATCH    | /v2/enrollments/\{ID\}                           | Yes             | payments         | Yes           | No                     | Yes  |       |
| POST     | /v2/enrollments/\{ID\}/fido-registration-options | Yes             | payments         | Yes           | Yes                    | Yes  |       |
| POST     | /v2/enrollments/\{ID\}/fido-registration         | Yes             | payments         | Yes           | Yes                    | Yes  |       |
| POST     | /v2/enrollments/\{ID\}/fido-sign-options         | Yes             | payments         | Yes           | No                     | Yes  |       |

## Automatic Payments

**Base path:** /open-banking/automatic-payments

**Client API:** TPP

| Operation | API                              | Token Validated | Access Scope         | JWS Validated | consentId Validated | mTLS | Notes |
| --------- | -------------------------------- | --------------- | -------------------- | ------------- | ------------------- | ---- | ----- |
| POST      | /v1/recurring-consents           | Yes             | recurring-payments   | Yes           | No                  | Yes  |       |
| GET       | /v1/recurring-consents/\{ID\}    | Yes             | recurring-payments   | Yes           | No                  | Yes  |       |
| PATCH     | /v1/recurring-consents/\{ID\}    | Yes             | recurring-payments   | Yes           | No                  | Yes  |       |
| POST      | /v1/pix/recurring-payments       | Yes             | recurring-payments   | Yes           | Yes                 | Yes  |       |
| GET       | /v1/pix/recurring-payments       | Yes             | recurring-payments   | No            | No                  | Yes  |       |
| GET       | /v1/pix/recurring-payments/\{ID\}| Yes             | recurring-payments   | No            | No                  | Yes  |       |
| PATCH     | /v1/pix/recurring-payments/\{ID\}| Yes             | recurring-payments   | No            | No                  | Yes  |       |

## Consent

### Consents

**Base path:** /open-banking/consents

**Client API:** TPP

| Operation | API                            | Token Validated | Access Scope | JWS Validated | consentId Validated | mTLS | Notes                |
| --------- | ------------------------------ | --------------- | ------------ | ------------- | ------------------- | ---- | -------------------- |
| POST      | /v1/consents                   | Yes             | consents     | No            | No                  | Yes  |                      |
| GET       | /v1/consents/\{ID\}            | Yes             | consents     | No            | No                  | Yes  | [*1](#notes)         |
| DELETE    | /v1/consents/\{ID\}            | Yes             | consents     | No            | No                  | Yes  | [*1](#notes)         |
| POST      | /v2/consents                   | Yes             | consents     | No            | No                  | Yes  |                      |
| DELETE    | /v2/consents/\{ID\}            | Yes             | consents     | No            | No                  | Yes  | [*1](#notes)         |
| GET       | /v2/consents/\{ID\}            | Yes             | consents     | No            | No                  | Yes  | [*1](#notes)         |
| POST      | /v2/consents/\{ID\}/extends    | Yes             | consents     | No            | Yes                 | Yes  | [*1](#notes)         |
| GET       | /v2/consents/\{ID\}/extends    | Yes             | consents     | No            | No                  | Yes  | [*1](#notes)         |
| POST      | /v3/consents                   | Yes             | consents     | No            | No                  | Yes  |                      |
| GET       | /v3/consents/\{ID\}            | Yes             | consents     | No            | No                  | Yes  | [*1](#notes)         |
| DELETE    | /v3/consents/\{ID\}            | Yes             | consents     | No            | No                  | Yes  | [*1](#notes)         |
| POST      | /v3/consents/\{ID\}/extends    | Yes             | consents     | No            | Yes                 | Yes  | [*1](#notes)         |
| GET       | /v3/consents/\{ID\}/extensions | Yes             | consents     | No            | No                  | Yes  | [*1](#notes)         |

### Resources

**Base path:** /open-banking/resources

**Client API:** TPP

| Operation | API           | Token Validated | Access Scope | JWS Validated | Consent Permission | consentId Validated | mTLS | Notes |
| --------- | ------------- | --------------- | ------------ | ------------- | ------------------ | ------------------- | ---- | ----- |
| GET       | /v1/resources | Yes             | resources    | No            | RESOURCES_READ     | Yes                 | Yes  |       |
| GET       | /v2/resources | Yes             | resources    | No            | RESOURCES_READ     | Yes                 | Yes  |       |
| GET       | /v3/resources | Yes             | resources    | No            | RESOURCES_READ     | Yes                 | Yes  |       |

### OOB consents

**Base path:** /open-banking/oob-consents

**Client API:**

- Consent management portal (backoffice)
- Consent management portal (client)

| Operation | API                                   | Token Validated | Access Scope                  | JWS Validated | consentId Validated | mTLS | Notes                |
| --------- | ------------------------------------- | --------------- | ----------------------------- | ------------- | ------------------- | ---- | -------------------- |
| GET       | /v1/domains/permission                | Yes             | oob_consents:read, oob_customer | No            | No                  | No   |                      |
| GET       | /v1/domains/consent-type              | Yes             | oob_consents:read, oob_customer | No            | No                  | No   |                      |
| GET       | /v1/domains/consent-status            | Yes             | oob_consents:read, oob_customer | No            | No                  | No   |                      |
| *GET      | /v1/domains/resource-type             | Yes             | oob_consents:read, oob_customer | No            | No                  | No   |                      |
| *DELETE   | /v1/authorisations/\{ID\}             | Yes             | oob_consents:write, oob_customer | No            | No                  | No   | [*2](#notes)         |
| *PUT      | /v1/authorisations/\{ID\}/accept      | Yes             | oob_consents:write, oob_customer | No            | No                  | No   | [*2](#notes)         |
| *GET      | /v1/consents                          | Yes             | oob_consents:read, oob_customer | No            | No                  | No   |                      |
| *GET      | /v1/consents/\{ID\}                   | Yes             | oob_consents:read, oob_customer | No            | No                  | No   | [*2](#notes)         |
| *PATCH    | /v1/consents/\{ID\}                   | Yes             | oob_consents:write, oob_customer | No            | No                  | No   | [*2](#notes)         |
| *PATCH    | /consents/v1/consents/\{ID\}          | Yes             | oob_consents:write, oob_customer | No            | No                  | No   | [*2](#notes)         |
| *GET      | /consents/v1/consents/\{ID\}/payments | Yes             | oob_consents:read, oob_customer | No            | No                  | No   | [*2](#notes)         |
| *PATCH    | /consents/v1/consents/\{ID\}/payments | Yes             | oob_consents:write, oob_customer | No            | No                  | No   | [*2](#notes)         |
| *PATCH    | /enrollments/v1/enrollments/\{ID\}    | Yes             | oob_consents:write, oob_customer | No            | No                  | No   | [*2](#notes)         |
| *GET      | /v1/tpps/payment-legacy-ids           | Yes             | oob_consents:read               | No            | No                  | No   |                      |
| POST      | /v1/payment-status-notification       | Yes             | oob_payments:write              | No            | No                  | No   |                      |
| *GET      | /v1/consents/\{ID\}/extends           | Yes             | oob_consents:read               | No            | No                  | No   |                      |

## Capitalization bonds catalog

**Base path:** /open-banking/opendata-capitalization

**Client API:** Any (Open on the internet)

| Operation | API       | Token Validated | Access Scope | JWS Validated | consentId Validated | mTLS | Notes |
| --------- | --------- | --------------- | ------------ | ------------- | ------------------- | ---- | ----- |
| GET       | /v1/bonds | No              |              | No            | No                  | No   |       |

## Investments catalog

**Base path:** /open-banking/opendata-investments

**Client API:** Any (Open on the internet)

| Operation | API                      | Token Validated | Access Scope | JWS Validated | consentId Validated | mTLS | Notes |
| --------- | -----------------------  | --------------- | ------------ | ------------- | ------------------- | ---- | ----- |
| GET       | /v1/funds                | No              |              | No            | No                  | No   |       |
| GET       | /v1/bank-fixed-incomes   | No              |              | No            | No                  | No   |       |
| GET       | /v1/credit-fixed-incomes | No              |              | No            | No                  | No   |       |
| GET       | /v1/variable-incomes     | No              |              | No            | No                  | No   |       |
| GET       | /v1/treasure-titles      | No              |              | No            | No                  | No   |       |

## Exchange catalog

**Base path:** /open-banking/opendata-exchange

**Client API:** Any (Open on the internet)

| Operation | API               | Token Validated | Access Scope | JWS Validated | consentId Validated | mTLS | Notes |
| --------- | ----------------- | --------------- | ------------ | ------------- | ------------------- | ---- | ----- |
| GET       | /v1/online-rates  | No              |              | No            | No                  | No   |       |
| GET       | /v1/vet-values    | No              |              | No            | No                  | No   |       |

## Acquiring services catalog

**Base path:** /open-banking/opendata-acquiring-services

**Client API:** Any (Open on the internet)

| Operation | API            | Token Validated | Access Scope | JWS Validated | consentId Validated | mTLS | Notes |
| --------- | -------------- | --------------- | ------------ | ------------- | ------------------- | ---- | ----- |
| GET       | /v1/personals  | No              |              | No            | No                  | No   |       |
| GET       | /v1/businesses | No              |              | No            | No                  | No   |       |

## Pension catalog

**Base path:** /open-banking/opendata-pension

**Client API:** Any (Open on the internet)

| Operation | API                    | Token Validated | Access Scope | JWS Validated | consentId Validated | mTLS | Notes |
| --------- | ---------------------- | --------------- | ------------ | ------------- | ------------------- | ---- | ----- |
| GET       | /v1/risk-coverages     | No              |              | No            | No                  | No   |       |
| GET       | /v1/survival-coverages | No              |              | No            | No                  | No   |       |

## Insurance catalog

**Base path:** /open-banking/opendata-insurance

**Client API:** Any (Open on the internet)

| Operation | API             | Token Validated | Access Scope | JWS Validated | consentId Validated | mTLS | Notes |
| --------- | --------------- | --------------- | ------------ | ------------- | ------------------- | ---- | ----- |
| GET       | /v1/automotives | No              |              | No            | No                  | No   |       |
| GET       | /v1/homes       | No              |              | No            | No                  | No   |       |
| GET       | /v1/personals   | No              |              | No            | No                  | No   |       |

## Notes

- `*1:` Validates if the referenced consent belongs to the TPP.
- `*2:` When scope = oob_customer, validates if the referenced consent belongs to the customer.