# Connector Interface Definitions (Schemas)

Definition of the format of the messages sent and received by connectors in JSON schema format.

The definitions follow the directory structure **version**/**module_name**/**endpoint**

Where:

- **version**: Interface version (detailed below).
- **module_name**: Name of the OPUS Open Finance platform module where the connector should be inserted.
- **endpoint**: Name of the endpoint that represents a route or integration point between OPUS Open Finance and internal systems.

Within each of these directories are the definitions of the request object (which will be sent to the connector), the response object (which should be returned by the connector upon successful operation), and the error object (which should be returned by the connector in case of failure). In cases where the error response is not defined, the standard format described in the `response-error-schema.json` file should be used.

The `common` directories contain the definition of objects used in more than one integration point.

## Artifact Versioning

Artifacts are versioned using semantic versioning (SemVer):

\<**Major**\>.\<**Minor**\>.\<**Patch**\>

Where:

- **Major**: Incremented when the interface version has incompatibilities with the previous version. In other words, the connectors will need to be altered to work with the new version of OPUS Open Finance Platform. For each new major version, a directory is created, allowing access to previous versions.
- **Minor**: Incremented when the interface has been altered but remains compatible with previous versions within the same Major. Connectors may be updated to utilize the changes, but it is not mandatory.
- **Patch**: Incremented when a change is made to the documents without altering the interface, such as correcting a description, filling example, or format details. Connectors may be updated to utilize the changes, but it is not mandatory.

## Changelog

### 2024-12-03 - v4.4.0

- Inclusion of the lastRetryRecurringPaymentIds field for POST paymentV3
- Inclusion of Pix Automatic V2 in the automatic field of recurringConsent

### 2024-08-19 - v4.3.0

- Inclusion of No Redirect Journey consent for payment in the discoverPayments_v2 route

### 2024-08-01 - v4.2.0

- Inclusion of the risk signals validation connector for No Redirect Journey

### 2024-07-16 - v4.1.0

- Schema changes for financial-data: accounts (2.4.0-rc.1), customers (2.1.0-rc.1).

### 2024-06-24 - v4.0.0

- Schema changes for financial-data: credit-cards-accounts (2.3.1), loans (2.2.0), financings (2.1.0), invoice-financings (2.1.0), and unarranged-accounts-overdraft (2.1.0).

### 2024-06-20 - v3.8.0

- Changes to the consent connector checkAccountHolderStatus to support two documents.

### 2024-05-28 - v3.7.0

- Schema changes for financial-data customers, adapting to version 2.1.0-beta.2 of the Open Finance specification.
- Schema changes for financial-data accounts, adapting to version 2.4.0-beta.1 of the Open Finance specification.

### 2024-05-13 - v3.6.0

- New connector checkAccountHolderStatus for verification of account holders for a report sent to the PCM.

### 2024-03-06 - v3.5.0

- Inclusion of idempotencyKey in patchPixPaymentsPaymentId_v3.
- Inclusion of REJECTED in EnumPaymentCancellationStatusType.

### 2023-12-19 - v3.4.0

- Inclusion of automatic payment schemas version 1 in phase 3 version 3.

### 2023-09-14 - v3.3.0

- Inclusion of investments schemas version 1:
  - bank-fixed-incomes
  - credit-fixed-incomes
  - variable-incomes
  - funds
  - treasury-titles

### 2023-08-25 - v3.2.0

- Consent
  - Inclusion of the Validation of Payment route:
    - validatePaymentData: Payment Validation

### 2023-07-28 - v3.1.0

- Consent
  - Inclusion of routes for version 2 of discovery in phase 3:
    - discoverPayments_v2: Payment Discovery

### 2023-07-20 - v3.0.0

- Addition of payment initiation schemas version 3:
  - Payment
    - Error enum changes
    - RejectionReason enum changes
  - Consent
    - Error enum changes
    - Pattern change in creditor.name
    - Addition of rejectionReason enum

### 2022-11-30 - v2.10.0

- Consent
  - Creation of the paymentsGetPixPaymentsPaymentId_v2 route with the new error objects from version 2 of the payment APIs.
  - Removal of the revokeConsentPayment route.
- Payment
  - Update of request and response field patterns.
  - Inclusion of routes for version 2 of phase 3:
    - paymentsGetPixPaymentsPaymentId_v2: Payment query
    - paymentsPatchPixPayments_v2: Payment cancellation
    - paymentsPostPixPayments_v2: Payment initiation creation

### 2022-10-06 - v2.9.0

- Payment
  - The endToEndId field is now mandatory in the payment creation schema.

### 2022-09-02 - v2.8.0

- Payment
  - Inclusion of the endToEndId field in the payment creation schema.

### 2022-04-27 - v2.7.0

- Consent
  - Inclusion of the externalId field in the consent revocation schema.

### 2022-04-12 - v2.6.2

- Consent
  - Inclusion of the consentOwner field in the common consent schema.
  - Inclusion of the consentOwner field in the payment consent schema.
  - Inclusion of the consentOwner field in the payment discovery example request.

### 2022-03-16 - v2.6.1

- General
  - Addition of new shared definitions.
- Consent
  - Schema changes to use the new shared definitions.
- Payment
  - Schema changes to use the new shared definitions.

### 2022-03-07 - v2.6

- Consent
  - Inclusion of the consent schema for TED/TEF.
- Payment
  - Inclusion of schemas for creating and querying TED/TEF payment status.

### 2022-03-03 - v2.5.3

- General
  - Correction of inconsistencies in shared schemas.
- Consent
  - Adjustments to the schema of the checkPaymentStatus route to use shared definitions.
  - Adjustments to the response of the revokeConsentPayment route to use the correct enum in the action field.
- Payment
  - Adjustments to the shared payment schema to create shared definitions.

### 2022-02-25 - v2.5.2

- Consent
  - Inclusion of the purpose field in the common consent schema.
  - Inclusion of the purposeAdditionalInfo field in the common consent schema.

### 2022-02-15 - v2.5.1

- Consent
  - Added error code AGENDAMENTO_INVALIDO in consent creation.
  - Adjustments to error descriptions for consent revocation.

### 2022-01-13 - v2.5.0

- General
  - Inclusion of the schedule field in payment consent.
- Payment
  - Added SASP and SASC status for scheduled Pix and CONSENT_REVOKED rejectionReason.

### 2022-01-26 - v2.4.2

- Consent
  - Inclusion of the authExtraData field in the common consent schema.
  - Inclusion of the authExtraData field in the payment consent schema.
  - Inclusion of the authExtraData field in the payment discovery example request.

### 2022-01-05 - v2.4.1

- Payment
  - Change of the transactionIdentification field to have a maximum length of 35 characters.

### 2021-11-03 - v2.4.0

- Consent
  - Inclusion of the restrictionType field in the error response of approvePaymentConsentCreation.

### 2021-10-18 - v2.3.0

- Consent
  - Inclusion of a new integration point to approve the creation of payment consents (approvePaymentConsentCreation).

### 2021-10-14 - v2.2.0

- Consent
  - Addition of the FailingResources field in the common consent schema.
  - Addition of the FailingResources field in the consent schema for integration with the institution's app.
  - Addition of the defaultSelected field in the AvailableResources definition in the common consent schema.

### 2021-10-06 - v2.2.0

- Consent
  - Addition of the authorizers field in the AcceptedResources definition in the common consent schema.

### 2021-10-01 - v2.1.1

- Consent
  - Addition of balanceCurrency and balanceAmount fields in the consent schema for integration with the institution's app.

### 2021-09-30 - v2.1.0

- General
  - Correction of the URL of the schema used for draft 07.
- Consent
  - Syntax error adjustment in the discoverPayments request example.
- Payment
  - Adjustment of the minimum and maximum quantities of items in the PaymentId field to 1 and 10, respectively.
  - Inclusion of the following fields as mandatory in the request schema for the paymentsPostPixPayments operation:
    - requestMeta
  - Removal of the following fields as mandatory in the request schema for the paymentsPostPixPayments operation:
    - correlationId
    - brandId
  - Adjustment of the code field in the ResponseErrorCreatePixPayment definition in the error schema of the paymentsPostPixPayments operation.
  - Inclusion of the following fields as mandatory in the request schema for the paymentsGetPixPaymentsPaymentId operation:
    - requestMeta
  - Removal of the following fields as mandatory in the request schema for the paymentsGetPixPaymentsPaymentId operation:
    - correlationId
    - brandId

### 2021-09-21 - v2.0.0

- General
  - Restructuring of schema files.
  - Restructuring of the consent object:
    - Separation of data-sharing consent and payment schemas.
    - Creation of consent-customer-acceptance for use in the customer consent interface (not used in connectors).
    - Data structure change to better align with the Open Finance Brazil specification.
    - Replacement of the tppName field with the tpp field containing an object with TPP data.
  - Inclusion of the following fields in the payment consent:
    - details
    - ibgeTownCode
- Consent
  - Inclusion of the data field in the payment discovery response, where the response object will be, **making this version incompatible with interfaces in version 1.x.x.**
  - Inclusion of the requestMeta field in requests. The correlationId and brandId fields have been moved to this new object, **making this version incompatible with interfaces in version 1.x.x.**
- Payment
  - Removal of the following fields in responses:
    - consentId
    - correlationId
  - Removal of the following fields in requests:
    - brandName
  - Removal of the consent header in requests, **making this version incompatible with interfaces in version 1.x.x.**
  - Inclusion of the consent field in requests.
  - Inclusion of the following fields in the PIX payment initiation request:
    - transactionIdentification
    - ibgeTownCode
  - Inclusion of the following fields in the PIX payment initiation and query responses:
    - transactionIdentification
    - ibgeTownCode
  - Inclusion of the requestMeta field in requests. The correlationId and brandId fields have been moved to this new object, **making this version incompatible with interfaces in version 1.x.x.**
