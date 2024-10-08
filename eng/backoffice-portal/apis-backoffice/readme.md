# Backoffice APIs

This section describes the consent view and revocation APIs for the Opus Open Banking Backoffice Portal.

## Open API Specification

The API Rest definitions in Open API Specification 3.0 format can be found
[here](./oas-oob-consents.yaml).

## Consent Listing

        GET /open-banking/oob-consents/v1/consents

The consent listing API allows listing the consents linked
to an owner, who must be identified in one of the following ways:

`cpf`: Identifies the individual responsible for creating the consent.
It should contain only the digits.

**Example**: *99999999999*.

`consent-owner`: Set of information defined by the Institution to identify
the consent owner such as agency, account, CPF, CNPJ, etc.
It is represented by a *key/value* dictionary in *JSON URL Encoded* format.

**Example**: For an identifier formed by agency and account:

```json
[{"key": "conta", "value": "12345"}, {"key": "agencia", "value": "12345"}]
```

**Json URL encoded**:

```text
%5B%7B%22key%22%3A%20%22conta%22%2C%20%22value%22%3A%20%2212345%22%7D%2C%20%7B%22key%22%3A%20%22agencia%22%2C%20%22value%22%3A%20%2212345%22%7D%5D
```
Additionally, the following information can be used to filter the results:

`createdOnBegin`: Indicates the minimum creation date (inclusive) for querying consents.
It must be provided with date and time in the format specified in [RFC-3339](https://datatracker.ietf.org/doc/html/rfc3339).

**Example**: 2022-12-19T16:39:57Z.

`createdOnEnd`: Indicates the maximum creation date (inclusive) for querying consents.
It must be provided with date and time in the format specified in [RFC-3339](https://datatracker.ietf.org/doc/html/rfc3339).

**Example**: 2023-01-19T16:39:57-01:00.

`type`: Limits the query to payment or data sharing consents represented, respectively, by the values *PAYMENT* and *DATA_SHARING*.

`status`: Limits the query to consents with the specified status. For payment consents, it supports the values defined in the [Open Banking state machine](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/345178187/M+quina+de+Estados+-+v1.0.0+-+SV+Pagamentos+Autom+ticos). For data sharing consents, it supports the values *AWAITING_AUTHORISATION*, *AUTHORISED*, and *REJECTED*, which vary according to their [basic flow](https://openbanking-brasil.github.io/areadesenvolvedor/documents/fluxo_basico_consentimento.pdf).

`modalityType`[*1](#observações): Limits the query to immediate or scheduled payment consents represented, respectively, by the values *IMMEDIATE* and *SCHEDULED*.

`paymentType`[*1](#observações): Limits the query to payment consents. It supports the types: *PIX* (Instant Payment), *TED* (Disponible Electronic Transfer), or *TEF* (Financial electronic transfer).

## Consent Details

        GET /open-banking/oob-consents/v1/consents/{consentId}

This API is responsible for retrieving all information about a consent,
including the resources and a history of status changes made. The query is made through the internal identifier in UUID format.

## Consent Revocation (Deprecated)

        PATCH /open-banking/oob-consents/v1/consents/{consentId}

The usage is equivalent to the payment consent revocation below, but this endpoint will be discontinued.

## Data Sharing Consent Revocation

        PATCH /open-banking/oob-consents/consents/v1/consents/{consentId}

Responsible for revoking the consent related to the specified *consentId*.

## Active Data Sharing Consents Listing

        GET /open-banking/oob-consents/consents/v2/active

Responsible for listing authorized consents. It has two optional parameters:
- startDate: If provided, selects all active consents that were created after this date.
- endDate: If provided, selects all consents whose expiration is before the provided date.
  - Indeterminate consents will not be returned when this parameter is provided.
- page: Desired page number.
- page-size: Page size.

## Listing Payments Related to a Consent

        GET /open-banking/oob-consents/consents/v1/consents/{consentId}/payments

Displays the list of all payments related to the consent identified by the specified *consentId*.

## Payment Consent Revocation

        PATCH /open-banking/oob-consents/payments/v1/consents/{consentId}

Responsible for revoking automatic payment consents identified by the specified *consentId*.

## Payment Revocation

        PATCH /open-banking/oob-payments/v2/pix/payments/{paymentId}

Responsible for revoking the payment related to the open-banking identifier *paymentId*.

## Listing Payment Ids Generated by ITP

        GET /open-banking/oob-consents/v1/tpps/payment-legacy-ids

Lists the payment ids generated by ITPs within a time range defined by the parameters:

`startDate`: Indicates the minimum creation date (inclusive) of the payment id. Must be provided as a date.

**Example**: 2022-12-19.

`endDate`: Indicates the maximum creation date (inclusive) of the payment id. Must be provided as a date.

**Example**: 2022-12-25.

## Payment Status Change Notification

        POST /open-banking/oob-consents/v1/payment-status-notification

Responsible for notifying the OOB of a payment status change.

## Consent Extension Details

        GET /open-banking/oob-consents/v1/consents/{consentId}/extends

This API is responsible for listing all extensions of a consent.
The query is made through the internal identifier in UUID format.

## Full Authorization of Multiple Requirer Payment Consent

        POST /open-banking/oob-consents/v1/payments/consents/{consentId}/authorisation

This API is responsible for fully authorizing a payment consent by signaling the approval of multiple requirers for this consent.

## Post Search Key

        POST /open-banking/oob-consents/consents/v1/consents/{consentId}/search-key/{searchKey}

This API is responsible for adding a search key related to a consent, allowing consents to be listed based on this search key later.

## Delete Search Key

        DELETE /open-banking/oob-consents/consents/v1/consents/{consentId}/search-key/{searchKey}

This API is responsible for deleting a search key related to a consent.

## Put Consent Metadata

        PUT /open-banking/oob-consents/consents/v1/consents/{consentId}/meta-data

This API is responsible for adding a JSON metadata linked to a consent, replacing any value previously in this metadata field. It can be used to add extra information to the consent, for example, to add relevant information to app screen.

## Get Consent Metadata

        GET /open-banking/oob-consents/consents/v1/consents/{consentId}/meta-data

This API is responsible for retrieving the JSON metadata information previously sent.

## Patch Consent Metadata

        PATCH /open-banking/oob-consents/consents/v1/consents/{consentId}/meta-data

This API is responsible for updating the JSON metadata linked to a consent, adding information to the existing metadata.

## Delete Consent Metadata

        DELETE /open-banking/oob-consents/consents/v1/consents/{consentId}/meta-data

This API is responsible for deleting the metadata information related to a consent.

## Enrollment Revocation

        PATCH /open-banking/oob-consents/enrollments/v1/enrollments/{enrollmentId}

This API is responsible for revoking an enrollment, returning its details and the history of status changes made. The revocation is done through the internal identifier of the enrollment in UUID format.

## Authentication

To access the endpoints listed here, a token generated from the *Client Credentials* flow in the non-regulatory base path of the Authorization Server must be used.

The AS configuration, as well as details for creating clients, can be found in the [deploy](../../deploy/oob-authorization-server/readme.md) section.

The necessary scopes for access are listed in the [security](../../security/apis/readme.md#oob-consents) section.

## Notes

- `*1`: Can only be used for payment consent queries.
