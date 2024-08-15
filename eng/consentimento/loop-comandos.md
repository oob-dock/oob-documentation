# Command Loop

The institution's mobile or web application will be guided by the Authorization Server (AS) of the OOB through the consent flow by executing a set of tasks. In this documentation and the auxiliary documents, we refer to these tasks as `commands`.

Currently, the AS has the following `commands`:

| Command      | Application Action                                                              | Ends the Loop  |
| ------------ | --------------------------------------------------------------------------------| -------------- |
| authenticate | Request user authentication                                                     | No             |
| consent      | Display the TPP request, asking for user consent and product choices            | No             |
| error        | Display error message and initiate return flow to TPP                           | Yes            |
| completed    | Display success message and initiate return flow to TPP                         | Yes            |

When starting the consent generation flow, the application will receive one of the commands above. The next command is determined by the AS's response to the previous execution until a command that ends the loop is executed.

**Important**: There is no predetermined sequence of `commands` to be executed.

The definition of the APIs used to execute the commands is available in the [Open API Specification](./oas-webapp2as.yaml).

## Command *authenticate*

Sent by the AS to the application to request user authentication.

The application must ensure the [minimum security requirement](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/240648193/Seguran+a) defined by the AS through the `acr` field of the command, as shown in the example below:

```json
{
    "command": "authenticate",
    "commandId": "identifier",
    "tpp": {
        "name": "Nome TPP",
        "logoUrl": "https://upload.wikimedia.org/wikipedia/commons/4/4f/SVG_Logo.svg"
    },
    "type": "PAYMENT",
    "authenticateCommand": {
        "acr": "urn:brasil:openbanking:loa3",
        "jti": "94a328c2-c72a-4cab-84a2-2df2b106b2af"
    }
}

The *ACR* can have the following values:

- `urn:brasil:openbanking:loa2`: LoA2 (Level of Assurance 2) which requires the user to be authenticated with at least one authentication factor.

- `urn:brasil:openbanking:loa3`: Requires the use of at least two authentication factors.

If the user has successfully authenticated, the institution must issue a signed JWT token and send it to the AS through the API `PUT /app/commands/{id}/authentication`, where `id` is the `commandId` of the executed command.

**Important**: The JWT token must not be signed in the application to avoid exposing the private signing key. The public key used must be exposed via a URL containing the *JWKS* to be configured through the property [`customer/federationJwksUrl`](../deploy/oob-authorization-server/readme.md#customerfederationjwksurl).

To understand the following section of the text, consider:

- `cpf` is the unique identification number of a citizen in Brazilian government registers
- `cnpj` is the unique identification number of a company in Brazilian government registers

The JWT must have the following claims, with those marked with an asterisk being mandatory:

- `cpf`**\***: User's CPF containing only digits.

- `name`**\***: User's name.

- `cnpj`: Institution's CNPJ related to the logged-in user containing only digits.

- `iat`**\***: JWT issuance date and time in *EPOCH* format.

- `jti`**\***: Unique token identifier in *UUID* format used to avoid *replay-attacks*. It must be filled with the same value received from the AS in the command.

- `authExtraData`: Set of extra information related to the logged-in user represented by an array of key/value dictionaries with two mandatory fields, `key` and `value`. It should be used to send user credentials if the institution does not use *cpf* or *cnpj* for authentication.

- `consentOwner`: Set of information defined by the institution to identify the consent owner, such as agency, account, CPF, and/or CNPJ. It consists of an array of key/value dictionaries with two mandatory fields, `key` and `value`. This field is used for consent consultation via the [Backoffice API](../portal-backoffice/apis-backoffice/readme.md).

**Important**: If the `consentOwner` claim is not sent, the OOB solution will use the user's `cpf` and `cnpj` to define the consent owner.

To understand the following JSON consider that "agencia" is the portuguese term for bank's branch of an account holder, and "conta" is its account numeric identification. 

An example of the JSON content to be used in the JWT token:

```json
{
    "iat": 1618664738,
    "jti": "e8f172c9-6f83-4d36-9dbb-e3ce7ca8a39b",
    "cpf": "32180490089",
    "cnpj": "77202036000182",
    "name": "João Maria José",
    "authExtraData": [
        {
            "key": "agencia",
            "value": "1234"
        },
        {
            "key": "conta",
            "value": "1234-5"
        }
    ],
    "consentOwner": [
        {
            "key": "conta",
            "value": "542345234"
        },
        {
            "key": "cnpj",
            "value": "77202036000182"
        }
    ]
}

## Command *consent*

Requests the display of the consent intent requested by the TPP to the institution. The consent information is returned along with the command, in addition to the TPP's information, the institution's brand (for installations with multi-brand support), and, for data sharing consents, descriptive information of the permissions and types of resources requested.

The application's role at this point is to display the TPP request to the user and collect the user's consent in addition to the choice of selectable resources.

Data sharing consents can handle various types of resources simultaneously, and many of these types can be selectable resources. The selectable resources must be displayed for the user to choose whether or not to share each product.

Payment initiation consents exclusively handle the "payment" resource; this type of resource was internally created in the OOB to allow various products as financial sources for payments, decoupled from the exclusivity of using current/savings accounts. The "payment" resources have two extra properties to transmit the balance and the balance currency, allowing the application to display them to facilitate the user's choice of the financial source for the payment in question.

It is important to follow the [User Experience Guide](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17378535/Guia+de+Experi+ncia+do+Usu+rio) of Open Finance Brazil at this stage.

The selected resources and consequently the consent acceptance must be sent to the AS through the API `PUT /app/command/{id}/consent`.

### Non-selectable Products

Unlike other products, non-selectable products are shared based on the permissions provided in the data-sharing consent. Therefore, during consent approval, they are not selected.

## Command *error*

Indicates the occurrence of an error during the OIDC authentication flow. The error is described in the command and can be known errors of the Open Finance Brazil process or unexpected errors as seen in the table below.

| Error Code                                   | Description                                                                                                 |
| -------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| CPF_MISMATCH                                 | User's authenticated CPF differs from the one sent by the TPP in the consent intent                         |
| CNPJ_MISMATCH                                | User's authenticated CNPJ differs from the one sent by the TPP in the consent intent                        |
| EXPIRED_CONSENT                              | Expired consent                                                                                            |
| INVALID_SESSION                              | Session does not exist or expired due to the 10-minute timeout                                              |
| RESOURCE_MUST_CONTAIN_ID                     | The resource list in consent approval must contain at least one ID                                          |
| RESOURCE_MUST_CONTAIN_ID_SELECTABLE_PRODUCTS | The resource list in consent approval must contain at least one ID for each selectable product              |
| DISCOVERY_ERROR                              | Discovery process failure                                                                                   |
| DISCOVERY_TIMEOUT                            | Discovery process exceeded the timeout                                                                      |
| INVALID_STATUS_CONFIRMATION                  | Consent status is not valid for confirmation                                                                |
| INVALID_PAYMENT_DATA                         | Consent payment data validation failure                                                                     |
| GENERIC_ERROR                                | AS generic error, the `message` field contains the error description to be displayed to the user            |

The `error` command concludes the consent generation. In handoff cases, the application should only display the error message to the user and end the consent generation process. The page on the device that initiated the consent process will automatically return to the TPP informing the consent error reason.

In the case of a traditional hybrid flow, the application, in addition to displaying the error message, should also request the device's operating system to open the return URL sent in the command, ensuring that the TPP is informed of the error reason and resumes the flow as expected by the Open Finance Brazil User Experience Guide.

The `isHandOff` property indicates if the flow is a hybrid flow with handoff, and in cases where the value is `false`, the `redirectTo` property, when returned, contains the URL that should be opened in the device's operating system to return to the TPP.

The application should properly guide the user for scenarios where the `redirectTo` property is not present.

## Command *completed*

Indicates the successful completion of the consent generation flow.

The treatment is the same as the `error` command, but the message to be displayed to the user is the success of the consent. The return to the TPP should be handled as described in the `error`.

## Changelog

### 2023-07-27 - v1.2.2

- Addition of the new error command INVALID_STATUS_CONFIRMATION.

### 2023-05-15 - v1.2.1

- Addition of the new error command DISCOVERY_TIMEOUT.

### 2023-02-15 - v1.2.0

- Addition of the *type* field (consent type) in the authenticate command response.

### 2022-11-09 - v1.1.2

- Addition of new error codes RESOURCE_MUST_CONTAIN_ID_SELECTABLE_PRODUCTS.

### 2022-08-25 - v1.1.1

- Addition of new error codes.

### 2022-04-06 - v1.1.0

- Addition of the new claim `consentOwner` in the JWT token JSON for use in the authenticate command.

### 2022-01-24 - v1.0.1

- Addition of the new claim `authExtraData` in the JWT token JSON for use in the authenticate command.

### 2022-01-11 - v1.0.0

- Initial version of the file.


