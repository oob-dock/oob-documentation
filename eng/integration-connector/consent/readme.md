# API Consent

- [API Consent](#api-consent)
  - [Resource Discovery in Opus Open Finance](#resource-discovery-in-opus-open-finance)
    - [Discovery Moments](#discovery-moments)
      - [Selectable Products](#selectable-products)
      - [Non-selectable Products](#non-selectable-products)
    - [Consent and Products](#consent-and-products)
    - [Identifier Handling](#identifier-handling)
    - [Discovery Connectors](#discovery-connectors)
      - [Selectable Product Connector](#selectable-product-connector)
      - [Non-selectable Product Connector](#non-selectable-product-connector)
    - [Payment Data Validation Connector](#payment-data-validation-connector)
    - [Risk Signals Validation Connector](#risk-signals-validation-connector)
    - [Additional Processing](#additional-processing)
      - [Account Filter](#account-filter)
  - [Permission Groups in Consent Creation](#permission-groups-in-consent-creation)
  - [Approval of Payment Consent Creation](#approval-of-payment-consent-creation)
    - [Provisional Solution for approvePaymentConsentCreation Route](#provisional-solution-for-approvepaymentconsentcreation)
  - [Auxiliary Services](#auxiliary-services)

## Resource Discovery in Opus Open Finance

Resource discovery in Opus Open Finance is one of the integration points between the platform and the institution's backend systems. It is the integration responsible for discovering the products linked to a consent. Resource discovery occurs at two distinct moments within Open Finance.

### Discovery Moments

#### Selectable Products

The discovery moment occurs during the institution's customer's consent acceptance phase. Data-sharing consents that involve **account** and **credit card** products, as well as payment consents, need to display the product instances during the authentication and consent acceptance stage to be actively chosen by the customer. We call these products **selectable products**.

The following table compiles all the selectable products handled by Opus Open Finance and their types:

| Consent Type           | Product             | Product Type   | Camel Route Name                                |
| ---------------------- | ------------------- | -------------- | ----------------------------------------------- |
| Data Sharing           | ACCOUNT             | Selectable     | ```direct:discoverAccounts```                   |
| Data Sharing           | CREDIT_CARD_ACCOUNT | Selectable     | ```direct:discoverCreditCardAccounts```         |
| Payment                | PAYMENT[^1]         | Selectable     | ```direct:discoverPayments_v2```                |

[^1]: The **PAYMENT** product allows the selection of the payment source to be independent of the ACCOUNT product, enabling payments via credit card or other distinct sources that the institution may offer.

If the institution provides any data-sharing product, it will be necessary to create the Camel route as referenced in the table, respecting the [request and response format indicated by the product type](#conectores-de-discovery). If these products are not provided (Camel route creation), the default discovery return is null, and the institution does not need to implement such routes.

#### Non-selectable Products

The discovery moment occurs during the use of data-sharing consent when the *TPP* calls the regulatory API [```GET /resources/v1/resources```](https://openbankingbrasil.atlassian.net/wiki/spaces/OB/pages/33849604/Informa+es+T+cnicas+-+Resources+-+v1.0.2) or [```GET /resources/v2/resources```](https://openbankingbrasil.atlassian.net/wiki/spaces/OB/pages/57409630/Informa+es+T+cnicas+-+Resources+-+v2.0.0). This API must return all resources accessible within the consent, i.e., the products actively selected by the customer during consent acceptance and the other consent products. We call these latter products **non-selectable products**.

The following table compiles all the non-selectable products handled by Opus Open Finance and their types:

| Consent Type           | Product                      | Product Type   | Camel Route Name                                |
| ---------------------- | ---------------------------- | -------------- | ----------------------------------------------- |
| Data Sharing           | INVOICE_FINANCING            | Non-selectable | ```direct:discoverInvoiceFinancings```          |
| Data Sharing           | FINANCING                    | Non-selectable | ```direct:discoverFinancings```                 |
| Data Sharing           | LOAN                         | Non-selectable | ```direct:discoverLoans```                      |
| Data Sharing           | UNARRANGED_ACCOUNT_OVERDRAFT | Non-selectable | ```direct:discoverUnarrangedAccountOverdrafts```|
| Data Sharing           | BANK_FIXED_INCOMES_READ      | Non-selectable | ```direct:discoverBankFixedIncomes```           |
| Data Sharing           | CREDIT_FIXED_INCOMES_READ    | Non-selectable | ```direct:discoverCreditFixedIncomes```         |
| Data Sharing           | FUNDS_READ                   | Non-selectable | ```direct:discoverFunds```                      |
| Data Sharing           | VARIABLE_INCOMES_READ        | Non-selectable | ```direct:discoverVariableIncomes```            |
| Data Sharing           | TREASURE_TITLES_READ         | Non-selectable | ```direct:discoverTreasureTitles```             |
| Data Sharing           | EXCHANGES_READ               | Non-selectable | ```direct:discoverExchanges```                  |

If the institution provides any data-sharing product, it will be necessary to create the Camel route as referenced in the table, respecting the [request and response format indicated by the product type](#conectores-de-discovery). If these products are not provided (Camel route creation), the default discovery return is null, and the institution does not need to implement such routes.

The possible statuses for non-selectable resources are listed in the table below:

| Status                  | Description                                                                                       | Transition                                        |
| ----------------------- | ------------------------------------------------------------------------------------------------- | ------------------------------------------------- |
| PENDING_AUTHORISATION   | When resources still require multi-level approval                                                 | Can transition to all statuses                    |
| TEMPORARILY_UNAVAILABLE | Temporarily blocked resources that are unavailable in electronic service channels for end-users   | Can transition to AVAILABLE or UNAVAILABLE        |
| AVAILABLE               | Resources in full use and available in electronic service channels for end-users                  | Can transition to TEMPORARILY_UNAVAILABLE or UNAVAILABLE |
| UNAVAILABLE             | Resources that are closed, migrated, canceled, or lost and are unavailable in electronic service channels for end-users | Cannot transition to any status       |

### Consent and Products

In the previous topic, we saw the possible discovery moments and the relationship between moments and products. Another important point is the relationship between the permissions requested in the consent and the products. This relationship dictates which discoveries will occur for a given consent.

| Consent Type           | Permissions                                                                                                                                                                                | Product                      |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------- |
| Data Sharing           | ACCOUNTS_READ, ACCOUNTS_BALANCES_READ, ACCOUNTS_TRANSACTIONS_READ, ACCOUNTS_OVERDRAFT_LIMITS_READ                                                                                           | ACCOUNT                      |
| Data Sharing           | CREDIT_CARDS_ACCOUNTS_READ, CREDIT_CARDS_ACCOUNTS_BILLS_READ, CREDIT_CARDS_ACCOUNTS_BILLS_TRANSACTIONS_READ, CREDIT_CARDS_ACCOUNTS_LIMITS_READ, CREDIT_CARDS_ACCOUNTS_TRANSACTIONS_READ     | CREDIT_CARD_ACCOUNT          |
| Data Sharing           | INVOICE_FINANCINGS_READ, INVOICE_FINANCINGS_SCHEDULED_INSTALMENTS_READ, INVOICE_FINANCINGS_PAYMENTS_READ, INVOICE_FINANCINGS_WARRANTIES_READ                                                | INVOICE_FINANCING            |
| Data Sharing           | FINANCINGS_READ, FINANCINGS_SCHEDULED_INSTALMENTS_READ, FINANCINGS_PAYMENTS_READ, FINANCINGS_WARRANTIES_READ                                                                                | FINANCING                    |
| Data Sharing           | LOANS_READ, LOANS_SCHEDULED_INSTALMENTS_READ, LOANS_PAYMENTS_READ, LOANS_WARRANTIES_READ                                                                                                    | LOAN                         |
| Data Sharing           | UNARRANGED_ACCOUNTS_OVERDRAFT_READ, UNARRANGED_ACCOUNTS_OVERDRAFT_SCHEDULED_INSTALMENTS_READ, UNARRANGED_ACCOUNTS_OVERDRAFT_PAYMENTS_READ, UNARRANGED_ACCOUNTS_OVERDRAFT_WARRANTIES_READ    | UNARRANGED_ACCOUNT_OVERDRAFT |
| Payment                | N/A                                                                                                                                                                                        | PAYMENT                      |

A data-sharing consent with all permissions will conduct the discovery of ACCOUNT and CREDIT_CARD products during the consent confirmation stage and INVOICE_FINANCING, FINANCING, LOAN, and UNARRANGED_ACCOUNT_OVERDRAFT products when a call is made to ```GET /resources/v1/resources```. Discovery is always performed in parallel to minimize the APIs' response time.

### Identifier Handling

An important point in Open Finance is the [formation and stability of the ID](https://openbanking-brasil.github.io/areadesenvolvedor/#formacao-e-estabilidade-do-id) which requires that identifiers transmitted within the Open Finance ecosystem be devoid of meaning.

The Opus Open Finance solution ensures the anonymization and uniqueness of identifiers in Open Finance by converting identifiers from the source systems to Open Finance identifiers.

The identification of products across various source systems can vary, sometimes even using composite keys. The Opus Open Finance interfaces use an array structure of keys and values when referencing a backend identifier. It is this structure that the Open Finance identifier generation is based on.

### Discovery Connectors

Discovery connectors are indeed implemented in Apache Camel, similar to other integration connectors between Opus Open Finance and the bank's backend systems.

The connector interface must adhere to one of two product models: selectable and non-selectable.

#### Selectable Product Connector

Selectable products must have their connectors adhere to the following schemas:

| Type     | JSON Schema                                                                                                        |
| -------- | ----------------------------------------------------------------------------------------------------------------- |
| Request  | [discovery-resource-request.json](../schemas/v2/consent/discoveryDataSharing/discovery-resource-request.json)      |
| Response | [discovery-selectable-resource-response.json](../schemas/v2/consent/discoveryDataSharing/discovery-selectable-resource-response.json) |

Example response for a selectable product:

```json
{
  "resources":[
    {
      "resourceName":[
        {
          "key":"Branch",
          "value":"1234"
        },
        {
          "key":"Checking Account",
          "value":"12345-6"
        }
      ],
      "resourceLegacyId":[
        {
          "key":"pkBranch",
          "value":"1234"
        },
        {
          "key":"pkCheckingAccount",
          "value":"123456"
        }
      ],
      "resourceBalanceCurrency":"BRL",
      "resourceBalanceAmount":239.12,
      "authorizers":[
        {
          "cpf":"06672639004",
          "name":"João da Silva"
        },
        {
          "cpf":"05473670075",
          "name":"Maria da Silva"
        }
      ],
      "defaultSelected":true
    }
  ]
}
```

#### Non-selectable Product Connector

Non-selectable products must have their connectors adhere to the following schemas:

| Type     | JSON Schema                                                                                                              |
| -------- | ------------------------------------------------------------------------------------------------------------------------ |
| Request  | [discovery-resource-request.json](../schemas/v2/consent/discoveryDataSharing/discovery-resource-request.json)             |
| Response | [discovery-nonselectable-resource-response.json](../schemas/v2/consent/discoveryDataSharing/discovery-nonselectable-resource-response.json) |

*[DRAFT: The consent schema within the request is under review]*

Example response for a non-selectable product:

```json
{
  "resources":[
    {
      "resourceLegacyId":[
        {
          "key":"pkEmprestimo",
          "value":"ABC12010"
        }
      ],
      "validUntil":"2022-06-07"
    },
    {
      "resourceLegacyId":[
        {
          "key":"pkEmprestimo",
          "value":"DEF51242"
        }
      ],
      "status": "TEMPORARILY_UNAVAILABLE",
      "validUntil":"2022-06-07"
    }
  ]
}
```

**IMPORTANT**: The bank's backend system must be responsible for controlling the status of the resource and the validity of the resource (`validUntil`).

### Payment Data Validation Connector

The payment validation connector is implemented in Apache Camel, like the other integration connectors, and is responsible for performing certain validations on payment data, such as:

- Validate DICT data
- Validate QR Code (QRND/QRES)
- Validate account data

The Camel route listens for calls made to `direct:validatePaymentData`, and an example can be found in [request](../schemas/v3/consent/validatePaymentData/request-example.json).

**Important**: Starting from version 4 of the consent, if multiple errors are identified during validation, the error with the highest priority must be returned. The priority table can be found in the *Technical Information* of the [Payments API](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17375943/SV+API+-+Pagamentos).

### Account Holder Discovery Connector

Due to a regulatory resolution, the PCM (Metric Collection Platform) must provide information on whether the person (PF/PJ) who requested consent is an account holder at the institution or not.

To this end, an account holder connector was created with the following functionality: receiving a CPF/CNPJ and validating against the institution if it belongs to an account holder.

The response should be:
- Positive (CPF/CNPJ belongs to an account holder);
- Negative (CPF/CNPJ does not belong to an account holder);

The following table lists the integration points for the account holder verification:

| Consent Type           | Camel Route Name                             |
| ---------------------- | -------------------------------------------- |
| All                    | ```direct:checkAccountHolderStatus```        |

Definitions:
- [request-schema](../schemas/v3/consent/checkAccountHolderStatus/request-schema.json)
- [response-schema](../schemas/v3/consent/checkAccountHolderStatus/response-schema.json)

Examples:
- [request-example](../schemas/v3/consent/checkAccountHolderStatus/request-example.json)
- [response-example](../schemas/v3/consent/checkAccountHolderStatus/response-example.json)

**Note**

The standard implemented connector should call the account holder connector. If it does not exist, the account discovery connector will be called, and if this does not suffice, a new connector must be implemented.

### Risk Signals Validation Connector

During two moments of the No Redirect Journey, the user must
send various information related to their device, such as geolocation,
operating system version, language, etc.

If the institution wishes to perform validations on this data, it should implement
the `direct:validateRiskSignals` route.

**IMPORTANT**: The implementation of the route is not mandatory, but it is recommended.

Definitions:

- [request-schema](../schemas/v3/consent/validateRiskSignals/request-schema.json)
- [response-schema](../schemas/v3/consent/validateRiskSignals/response-schema.json)

### Additional Processing

#### Account Filter

In some situations, the account used for a financial transaction is defined by the customer before account selection in the payment initiation application. In these scenarios, the `debtorAccount` object will be filled in the consent, and the returned list should be filtered to return only the pre-selected account or an empty list if this is not a selectable option for the customer. This processing should be done in the connector or remote account listing service.

## Permission Groups in Consent Creation

At the moment of consent creation, all the permissions for the data groups for which consent is desired must be sent. This set of required permissions, called permission groups, is designated as per the table below ([link](https://openbanking-brasil.github.io/openapi/swagger-apis/consents/1.0.3.yml) for official documentation):

| Data Category          | Group                        | Permissions                                                                                                                                   |
| ---------------------- | ---------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| Registration           | PF Registration Data         | CUSTOMERS_PERSONAL_IDENTIFICATIONS_READ, RESOURCES_READ                                                                                       |
| Registration           | PF Additional Information    | CUSTOMERS_PERSONAL_ADITTIONALINFO_READ, RESOURCES_READ                                                                                        |
| Registration           | PJ Registration Data         | CUSTOMERS_BUSINESS_IDENTIFICATIONS_READ, RESOURCES_READ                                                                                       |
| Registration           | PJ Additional Information    | CUSTOMERS_BUSINESS_ADITTIONALINFO_READ, RESOURCES_READ                                                                                        |
| Accounts               | Balances                     | ACCOUNTS_READ, ACCOUNTS_BALANCES_READ, RESOURCES_READ                                                                                         |
| Accounts               | Limits                       | ACCOUNTS_READ, ACCOUNTS_OVERDRAFT_LIMITS_READ, RESOURCES_READ                                                                                 |
| Accounts               | Statements                   | ACCOUNTS_READ, ACCOUNTS_TRANSACTIONS_READ, RESOURCES_READ                                                                                     |
| Credit Card            | Limits                       | CREDIT_CARDS_ACCOUNTS_READ, CREDIT_CARDS_ACCOUNTS_LIMITS_READ, RESOURCES_READ                                                                 |
| Credit Card            | Transactions                 | CREDIT_CARDS_ACCOUNTS_READ, CREDIT_CARDS_ACCOUNTS_TRANSACTIONS_READ, RESOURCES_READ                                                           |
| Credit Card            | Bills                        | CREDIT_CARDS_ACCOUNTS_READ, CREDIT_CARDS_ACCOUNTS_BILLS_READ, CREDIT_CARDS_ACCOUNTS_BILLS_TRANSACTIONS_READ, RESOURCES_READ                   |
| Credit Operations      | Contract Data                | LOANS_READ, LOANS_WARRANTIES_READ, LOANS_SCHEDULED_INSTALMENTS_READ, LOANS_PAYMENTS_READ, FINANCINGS_READ, FINANCINGS_WARRANTIES_READ, FINANCINGS_SCHEDULED_INSTALMENTS_READ, FINANCINGS_PAYMENTS_READ, UNARRANGED_ACCOUNTS_OVERDRAFT_READ, UNARRANGED_ACCOUNTS_OVERDRAFT_WARRANTIES_READ, UNARRANGED_ACCOUNTS_OVERDRAFT_SCHEDULED_INSTALMENTS_READ, UNARRANGED_ACCOUNTS_OVERDRAFT_PAYMENTS_READ, INVOICE_FINANCINGS_READ, INVOICE_FINANCINGS_WARRANTIES_READ, INVOICE_FINANCINGS_SCHEDULED_INSTALMENTS_READ, INVOICE_FINANCINGS_PAYMENTS_READ, RESOURCES_READ |
| Credit Operations      | Receivables Prepayment       | INVOICE_FINANCINGS_READ, INVOICE_FINANCINGS_WARRANTIES_READ, INVOICE_FINANCINGS_SCHEDULED_INSTALMENTS_READ, INVOICE_FINANCINGS_PAYMENTS_READ, RESOURCES_READ                           |
| Credit Operations      | Financing                    | FINANCINGS_READ, FINANCINGS_WARRANTIES_READ, FINANCINGS_SCHEDULED_INSTALMENTS_READ, FINANCINGS_PAYMENTS_READ, RESOURCES_READ                                                       |
| Credit Operations      | Loans                        | LOANS_READ, LOANS_WARRANTIES_READ, LOANS_SCHEDULED_INSTALMENTS_READ, LOANS_PAYMENTS_READ, RESOURCES_READ                                                                             |
| Credit Operations      | Overdrafts                   | UNARRANGED_ACCOUNTS_OVERDRAFT_READ, UNARRANGED_ACCOUNTS_OVERDRAFT_WARRANTIES_READ, UNARRANGED_ACCOUNTS_OVERDRAFT_SCHEDULED_INSTALMENTS_READ, UNARRANGED_ACCOUNTS_OVERDRAFT_PAYMENTS_READ, RESOURCES_READ |
| Credit Operations      | Investments                  | BANK_FIXED_INCOMES_READ, CREDIT_FIXED_INCOMES_READ, FUNDS_READ, VARIABLE_INCOMES_READ, TREASURE_TITLES_READ, RESOURCES_READ                                                          |
| Credit Operations      | Foreign Exchange             | EXCHANGES_READ, RESOURCES_READ                                                                                                                                                       |

## Approval of Payment Consent Creation

When the consent creation API is called by a *TPP*, the OOB platform must evaluate whether this consent can be created. Technical validations (message format, call limits) and security validations (credential validity, access permissions) are performed within the platform itself. Business validations, however, are delegated to a backend system of the account-holding institution through a connector.

The validations that can be performed by the institution include:

- Verify if the user logged into the TPP is a known and active customer;
- Verify if the type of operation is accepted by the institution;
- Verify if the selected values are within the limits defined by the institution;
- Verify if the operation complies with anti-fraud policies;
- Verify if the consent creation characteristics comply with the institution's rules for **TED** and **TEF** payments - day of the week, holiday, time, maximum transfer amount, etc.

The following table lists the integration points for the approval of consent creation:

| Consent Type           | Camel Route Name                             |
| ---------------------- | -------------------------------------------- |
| Payment                | ```direct:approvePaymentConsentCreation_v3``` |

The return of these integration points should be:

- A success message (usually an empty object) when the consent can be created;
- A business error message, described in the integration schema with a specific enum in the *code* field, defining the reason for which the consent was denied. This message also has an optional *restrictionType* field informing the type of restriction that disapproved the consent;
- A generic error message, defined by the schema [response-error-schema.json](../schemas/v2/common/response-error-schema.json) when a technical error prevents the request from being evaluated, such as a network error or an inoperative system.

The following table corresponds to the Request and Response schemas for the connector:

| Type     | JSON Schema                                                                                                        |
| -------- | ----------------------------------------------------------------------------------------------------------------- |
| Request  | [approvePaymentConsent-request.json](../schemas/v3/consent/approvePaymentConsentCreation_v3/request-schema.json)   |
| Response | [approvePaymentConsent-response.json](../schemas/v3/consent/approvePaymentConsentCreation_v3/response-schema.json) |

Example of a Request:

```json
{
    "requestBody": {
        "data": {
            "tpp": {
                "name": "GuiaBolsa"
            },
            "loggedUser": {
                "document": {
                    "identification": "11111111111",
                    "rel": "CPF"
                }
            },
            "creditor": {
                "personType": "PESSOA_NATURAL",
                "cpfCnpj": "11111111111",
                "name": "Marco Antonio de Brito"
            },
            "payment": {
                "type": "PIX",
                "date": "2021-01-01",
                "currency": "BRL",
                "amount": "100000.04",
                "details": {
                    "localInstrument": "DICT",
                    "proxy": "12345678901",
                    "creditorAccount": {
                        "ispb": "12345678",
                        "number": "1234567890",
                        "accountType": "CACC",
                        "issuer": "1774"
                    }
                },
                "ibgeTownCode": "5300108"
            },
            "debtorAccount": {
                "ispb": "87654321",
                "number": "0987654321",
                "accountType": "CACC",
                "issuer": "1774"
            }
        }
    },
    "requestMeta": {
        "correlationId": "700dd46b-b2a6-2e28-41ef-f5c597640af3",
        "brandId": "cbanco"
    }
}
```

More examples of request and response for the "approvePaymentConsentCreation" route can be found [here](../schemas/v3/consent/approvePaymentConsentCreation_v3).

Example of a command used in the `Dockerfile` to add the route files `approvePaymentConsentCreation`, `approvePaymentConsentCreation_v2`, and `approvePaymentConsentCreation_v3`:

```dockerfile
ARG approvePaymentRoute=file:/specs/custom-approvePaymentConsentCreation-routes.xml
ENV camel.main.routes-include-pattern=$approvePaymentRoute
```

### Temporary Solution for the approvePaymentConsentCreation Route

In order to facilitate the development of partner entities' solutions, Opus Software provides an .xml file (approvePaymentConsentCreation-routes.xml) with a **temporary solution** for the "approvePaymentConsentCreation" route. This file approves any consent without applying any verification rules and should be used **only** for development purposes and while the backend system's payment consent approval services are not yet adapted for TED and TEF payment types.

Example of a command used in the `Dockerfile` to utilize the temporary solution for the `approvePaymentConsentCreation`, `approvePaymentConsentCreation_v2`, and `approvePaymentConsentCreation_v3` routes:

```dockerfile
ARG approvePaymentRoute=file:/specs/approvePaymentConsentCreation-routes.xml
ENV camel.main.routes-include-pattern=$approvePaymentRoute
```
## Auxiliary Services

Auxiliary services were created in Java to facilitate the implementation of the connectors.

The services and their respective functionalities are:

| Service Name       | Description                                                                                          | Call Command in the .xml File                                                                                  |
| ------------------ | ---------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| getDayOfTheWeek    | Get the current day of the week in English in the `EEE` format (e.g., "Fri" - Friday)                 | `${bean:camelUtils.getDayOfTheWeek}`                                                                           |
| concatenateStrings | Get a string that is the concatenation of the two strings passed as parameters                        | `${bean:camelUtils.concatenateStrings("ab", "cd")}`                                                            |
| hmacCalculator     | Get the hash calculation of data based on a specific algorithm with a provided secret key            | `${bean:camelUtils.hmacCalculator("HmacSHA256", "abcd", "bc19bec7-339f-452f-8548-3daa889e6f79)}`               |
| makePostCall       | Used for post calls with mtls                                                                        | `${bean:camelUtils.makePostCall(${authorization}, ${transactionHash}, ${contentType},  ${endpoint}, ${body})}` |
| makeGetCall        | Used for get calls with mtls                                                                         | `${bean:camelUtils.makeGetCall(${authorization}, ${transactionHash}, ${contentType}, ${endpoint})}`            |

**Example of calling the getDayOfTheWeek service:**

```xml
<setProperty name="currentWeekday">
  <simple>${bean:camelUtils.getDayOfTheWeek}</simple>
</setProperty>
```

**Example of calling the concatenateStrings service:**

```xml
<setProperty name="concatenatedString">
    <simple>${bean:camelHelper.concatenateStrings("ab", "cd")}</simple>
</setProperty>
```

The result would be: abcd

**Example of calling the hmacCalculator service:**

```xml
<setProperty name="hmacCalculatated">
    <simple>${bean:camelHelper.hmacCalculator("HmacSHA256", "abcd", "bc19bec7-339f-452f-8548-3daa889e6f79)}</simple>
</setProperty>
```

Supported algorithms:

```text
HmacMD5
HmacSHA1
HmacSHA224
HmacSHA256
HmacSHA384
HmacSHA512
```