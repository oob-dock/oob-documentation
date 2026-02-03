# Opus Open Finance Platform Consent Module Installation

## Prerequisites

### Message Queue

This module produces events to be published in a message queue. Therefore, a properly installed and configured message broker compatible with [Dapr](/deploy/shared-definitions.md#dapr) is required for OOB Consents.

## Installation

The module is installed via Helm Chart.

## Configuration

### db

Database access configuration:

* name: Database name
* username: Database access username
* password: Database access password
* kind: Database type. Default: "postgres"
* dialect: Translates database instructions. Default: "org.hibernate.dialect.PostgreSQLDialect"
* host: Database host

Example:

```yaml
  db:
    name: "api_consent"
    username: "api_consent"
    password: "api_consent"
    kind: "postgresql"
    dialect: "org.hibernate.dialect.PostgreSQLDialect"
    host: "postgres.local"
```

### Read Replica Support

OOB Consent supports the use of a read replica for the database. The replica requires the same configurations as the main database but with the *read-only* identifier, as shown below:

```yaml
  db:
    read-only:
      name: "api_consent"
      username: "readonly-user"
      password: "readonly-password"
      kind: "postgresql"
      host: "readonly.postgres.local"
```

To activate the use of the read replica, change the feature/readReplica/enabled property value to "1", as shown below:

```yaml
  feature:
    readReplica:
      enabled: "1"
```

**Important**: With the read replica activated, all Quarkus database-related configurations should include the name **base** for the primary instance and **read-only** for the replica. For example, to change the database connection pool settings:

```yaml
  # Main instance (base) configuration
  - name: quarkus.datasource.base.jdbc.max-size
    value: 100
  # Read replica configuration
  - name: quarkus.datasource.read-only.jdbc.max-size
    value: 110
```

### DDL Script Execution

See the [definição](../shared-definitions.md#ddl-scripts)

### liquibase/contexts

See the [definition](../shared-definitions.md#liquibase-contexts).

### oidc

See the [definition](../shared-definitions.md#oidc).

### signature

Signature key for messages. Use the same values from the authorization server certificate with use = `sig`. See the [definition](../shared-definitions.md#formatos-de-chave-privada-suportados) for details on supported key formats.

* kid: Key identifier (obtained from the participant directory)
* certSecretName: Name of the secret containing the private key
* certSecretKey: Secret property name containing the private key
* passphraseSecretName: Name of the secret containing the private key passphrase (optional)
* passphraseSecretKey: Secret property name containing the private key passphrase (optional)

The `passphraseSecretName` and `passphraseSecretKey` properties should only be defined for encrypted keys. If they are not provided, it is assumed the keys are open.

Example:

```yaml
    kid: "MPguImG0DEQwu9ZUvwDzw_0xybh1yAETY9VBLdYXibo"
    certSecretName: "oob-as-keys"
    certSecretKey: "sig.key"
    passphraseSecretName: "oob-as-keys"
    passphraseSecretKey: "sig.key.passphrase"
```

### organisation/id

Fill with the organisationId of the institution registered in the participant directory. Use the sandbox id for non-production environments and the production value for production environments. This property is of UUID type.

Example: `7a176f46-75e6-454f-8d04-408d6beaee37`

### application/encryption/key

Fill with the key used to encrypt sensitive data in the database. A secure key is recommended, with 256 bits, and the values should be in hexadecimal format.

> **Attention**
>
> `It is necessary to store it securely because if it is changed to a different value from the initial production setup, the sensitive data from previous consents will be inaccessible.`

Example: `DC28A6ED862722859DD78F4DBF664BBF447C7DC43085C151C7680A80BBF316D4`

### application/encryption/salt

Fill with the salt used to generate the encryption key together with the key from the previous item; it is recommended to have 64 bits, and the values should be in hexadecimal format.

> **Attention**
>
> `It is necessary to store it securely because if it is changed to a different value from the initial production setup, the sensitive data from previous consents will be inaccessible.`

Example: `6598C77E29BB822B`

### application/authorizationServerId

Must be filled with the authorization server ID of the institution registered
in the participant directory. Use the sandbox ID in non-production environments
and the production ID in production. Type: UUID.

Example: `2e4c1b0c-1234-4f9d-9abc-55aa66bb7788`

### consent/external/id

Used to define the id related to consentId. The consentId is the unique identifier for the consent and should be a URN - Uniform Resource Name.

Using the string urn:amazingbank as an example for consentId:

* the namespace (urn), as defined in [RFC8141](https://datatracker.ietf.org/doc/html/rfc8141)
* the identifier associated with the transmitting institution's namespace (amazingbank)

Example: `urn:amazingbank`

### payments/basePath

Used to define the base URI of the payment service. It should consist of the protocol and host followed by the path `/open-banking`.

Default value: `http://oob-payment/open-banking`

### fidoServer/basePath

Used to define the base URI of the fido server. It should consist of the protocol and host.

Default value: `http://oof-fido-server`

### dapr/enabled

Enables Dapr in the application to send events.

**Format:**: `true` or `false`.

Default value: `true`

### dapr/daprPubsubId

Identifier of the Dapr pub/sub component to be used.

Example: `oob-consent-pub-sub`

### dapr/daprRetryPubsubId

Identifier of the pub/sub component implementing retry policies. This component will be used when a specific message topic needs reprocessing support.

Example: `oob-consent-pub-sub-retry`

### dapr/appId

Identifier of the service to be used if there is more than one instance for different brands within the same environment. If not filled, the default name "oob-consent" will be used.

Example: `oob-consent-cbanco`

### brandId

Must be filled with the brand associated with the service instance. For more details, see the [definition](../shared-definitions.md#brand-id).

Example: `cbank`

### dapr/stateStore/introspection/name

Name of the state store to be used for caching token introspection. It should receive the same value assigned to the [Authorization Server](../oob-authorization-server/readme.md#state-store) under the same property name.

Example: `token-state-store`

## dapr/stateStore/accountHolder

This module supports using cache for checking account holders using one of the state stores [supported by Dapr](https://docs.dapr.io/reference/components-reference/supported-state-stores/).

**Important**: The chosen state store must support TTL.

Configurations:

* name: Component name of the state store
* type: Type to be filled as per Dapr documentation [here](https://docs.dapr.io/operations/components/setup-state-store/).
* version: Version to be used. By default, *v1* will be used.
* ttlInSeconds: State store lifetime in seconds.
* connectionMetadata: Metadata required for connection with the desired state store in the name/value format, as shown below.

**Example:**

```yaml
env:
  dapr:
    stateStore:
      accountHolder:
        name: documentStateStore
        type: state.redis
        version: v1
        ttlInSeconds: 3600
        connectionMetadata:
          - name: redisHost
            value: localhost:6379
          - name: redisPassword
            value: password
```

**Important:** To enable cache usage, activate the *feature flag* [accountHolder](#featureaccountholdercacheenabled).

## dapr/schedulerHostAddress

This configuration must point to the Dapr scheduler service to enable the Dapr Jobs API functionality.
For more details, refer to the [Dapr documentation](https://docs.dapr.io/reference/arguments-annotations-overview/).

**Example:**

```yaml
env:
  dapr:
    schedulerHostAddress: dapr-scheduler-server.oob.svc.cluster.local:50006
```

## dapr/job/pcm/schedule

Used to define the schedule for the PCM consent stock report job.

**Format:** Cron-like string (ignoring seconds, just 5 fields) or expression for scheduling based on [Dapr Jobs API](https://docs.dapr.io/reference/api/jobs_api/#schedule).

**Default value**: `disabled`

**Example:** To schedule the job to run daily at 1 AM if utc (recommended):

```yaml
env:
  dapr:
    job:
      pcm:
        schedule: "0 4 * * *"
```

## dapr/job/activeConsents/schedule

Used to define the schedule for the active consents fetching os authorization server.

**Format:** Cron-like string (ignoring seconds, just 5 fields) or expression for scheduling based on [Dapr Jobs API](https://docs.dapr.io/reference/api/jobs_api/#schedule).

**Default value**: `disabled`

**Example:** To schedule the job to run every 5 minutes (recommended).

```yaml
env:
  dapr:
    job:
      activeConsents: "@every 5m"
```

## dapr/job/dropreason/schedule

Used to define the schedule for publishing the dropreason event.

**Format:** Cron-like string (ignoring seconds, just 5 fields) or expression for scheduling based on the [Dapr Jobs API](https://docs.dapr.io/reference/api/jobs_api/#schedule).

**Default value:** `disabled`

**Example:** To schedule the job to run every 5 minutes:

```yaml
env:
  dapr:
    job:
      dropreason:
        schedule: "@every 5m"
```

## dapr/job/consentExpiration/schedule

Used to define the schedule for check for consent expiration.

**Format:** Cron-like string (ignoring seconds, just 5 fields) or expression for scheduling based on the [Dapr Jobs API](https://docs.dapr.io/reference/api/jobs_api/#schedule).

**Default value:** `@every 60s`

**Example:** To schedule the job to run every 60 seconds:

```yaml
env:
  dapr:
    job:
      consentExpiration:
        schedule: "@every 60s"
```

## dapr/job/consentToExpire/schedule

Used to define the schedule for checking consents that are about to expire.

**Format:** Cron-like string (ignoring seconds, just 5 fields) or expression for scheduling based on the [Dapr Jobs API](https://docs.dapr.io/reference/api/jobs_api/).

**Default value:** `disabled`

**Example:** To schedule the job to run every day at 10am (recommended):

```yaml
env:
  dapr:
    job:
      consentToExpire:
        schedule: "0 10 * * *"
```

## dapr/job/instantPaymentWebhook/schedule

Used to set the job execution interval for status checks to send instant payment webhooks.
To activate the job, it is also necessary to activate the webhook feature in the instance.

**IMPORTANT**: Activating the job is part of the temporary webhook solution and should only be
enabled while the holder does not implement the
[Payment Status Change Notification API](../../backoffice-portal/apis-backoffice/readme.md#notificação-de-mudança-de-status-de-pagamento).

**Format:**  Cron-like string (ignoring seconds, just 5 fields) or expression for scheduling based on the [Dapr Jobs API](https://docs.dapr.io/reference/api/jobs_api/#schedule).

**Default value:** `disabled`

**Example:** To schedule the job to run every 5 seconds:

```yaml
env:
  dapr:
    job:
      instantPaymentWebhook:
        schedule: "@every 5s"
```

## dapr/job/scheduledPaymentWebhook/schedule

Used to set the job execution interval for status checks to send scheduled payment (SCHD) webhooks.
As with the previous one, activating this job depends on the activation of the webhook feature in the instance.
The job is disabled by default.

**Format:**  Cron-like string (ignoring seconds, just 5 fields) or expression for scheduling based on the [Dapr Jobs API](https://docs.dapr.io/reference/api/jobs_api/#schedule).

**Default value:** `disabled`

**Example:** To schedule the job to run every 60 seconds:

```yaml
env:
  dapr:
    job:
      scheduledPaymentWebhook:
        schedule: "@every 60s"
```

## dapr/job/scheduledEnrollment/schedule

Used to enable the validation of the daily payment limit for JSR consents.
It is recommended that this job remain disabled.

**Format:**  Cron-like string (ignoring seconds, just 5 fields) or expression for scheduling based on the [Dapr Jobs API](https://docs.dapr.io/reference/api/jobs_api/#schedule).

**Default value:** `disabled`

**Example:** To schedule the job to run every 24 hours:

```yaml
env:
  dapr:
    job:
      scheduledEnrollment:
        schedule: "@every 24h"
```

## dapr/job/resourceUpdate/schedule

Used to activate the resource query job for data-sharing consents that have not yet successfully
completed the discovery of all products.
It should only be activated if [asynchronous resource discovery](./readme.md#featureresourcesasyncenabled)
is enabled.

A daily execution is recommended.

**Format:**  Cron-like string (ignoring seconds, just 5 fields) or expression for scheduling based on the
[Dapr Jobs API](https://docs.dapr.io/reference/api/jobs_api/#schedule).

**Default value:** `disabled`

**Example:** To schedule the job to run every 12 hours:

```yaml
env:
  dapr:
    job:
      resourceUpdate:
        schedule: "@every 12h"
```

## dapr/job/consentToExpire/schedule

Used to define the schedule for checking consents that are about to expire.

**Format:** Cron-like string (ignoring seconds, just 5 fields) or expression for scheduling based on the [Dapr Jobs API](https://docs.dapr.io/reference/api/jobs_api/).

**Default value:** `disabled`

**Example:** To schedule the job to run every day at 10am (recommended):

```yaml
env:
  dapr:
    job:
      consentToExpire:
        schedule: "0 10 * * *"
```

## opentelemetry

This module is instrumented via [Open Telemetry](https://opentelemetry.io/),
logging trace information (when available) and exporting it to a tool like
[Tempo](https://grafana.com/oss/tempo/), which is used for visualizing and
analyzing distributed tracing of the performed requests.

Configurations:

* `opentelemetry.tracer.exporter.url.grpc`: Address of the analysis tool.
**Important:** This variable must be filled with the **GRPC** address provided
by the tool to receive the tracing information.
* `opentelemetry.sample.rate`: Defines the sampling rate for distributed
tracing, i.e., the proportion of requests that will be collected and sent for
analysis. Possible values: `0` to `1`. For example, a value of `0.5` means that
50% of the requests will be sampled. **Important**: If you wish to completely
disable the sending of traces to the receiving tool, simply set this variable
to `0`.

Example:

```yaml
env:
  opentelemetry:
    tracer:
      exporter:
        url:
          grpc: "http://127.0.0.1:4317"
    sample:
      rate: 1
```

## additionalVars

Used to define optional configurations in the application. This configuration allows defining a list of properties to be passed to the application in the following format:

```yaml
additionalVars:
  - name: FIRST_PROPERTY
    value: "FIRST_VALUE"
  - name: SECOND_PROPERTY
    value: "SECOND_VALUE"
```

The settings that can be defined in this format are listed below:

### QUARKUS_LOG_LEVEL

Used to set the application's log level. In production, it is advisable to be level = `INFO`.

**Possible values:** `OFF`, `FATAL`, `ERROR`, `WARN`, `INFO`, `DEBUG`, `TRACE`, `ALL`

Default value: `INFO`

**Example:**

```yaml
additionalVars:
  - name: QUARKUS_LOG_LEVEL
    value: "INFO"
```

### QUARKUS_LOG_INITIALIZATION_LEVEL

Defines the log level for service startup messages.
In production, it is recommended to set the level to `WARN`.

**Possible values:** `DEBUG`, `INFO`, `TRACE`, `WARNING` or `ERROR`

Default value: `WARN`

**Example:**

```yaml
additionalVars:
  - name: QUARKUS_LOG_INITIALIZATION_LEVEL
    value: "WARN"
```

### QUARKUS_LOG_CONSOLE_LEVEL

Used to set the log level for the application's console.

**Possible values:** `OFF`, `FATAL`, `ERROR`, `WARN`, `INFO`, `DEBUG`, `TRACE`, `ALL`

Default value: `INFO`

**Example:**

```yaml
additionalVars:
  - name: QUARKUS_LOG_CONSOLE_LEVEL
    value: "INFO"
```

### QUARKUS_LOG_CONSOLE_JSON

Used to set whether the log should be in JSON format.

**Format:** `true` or `false`

Default value: `true`

**Example:**

```yaml
additionalVars:
  - name: QUARKUS_LOG_CONSOLE_JSON
    value: "true"
```

### APPLICATION_CERTIFICATION_MOCK_RESOURCES_API_TEST_UNAVAILABLE_V2

Used to enable mocked resources with UNAVAILABLE status, necessary for phase 2 v2 certification test named *resources-api-test-unavailable-v2*.

**IMPORTANT**: This feature should be enabled only in development/testing environments.

**Format:** `true` or `false`

Default value: `false`

**Example:**

```yaml
additionalVars:
  - name: APPLICATION_CERTIFICATION_MOCK_RESOURCES_API_TEST_UNAVAILABLE_V2
    value: "true"
```

### APPLICATION_VALIDATION_CURRENCY

Used to set the national currency code according to the ISO-4217 model.

Default value: `BRL`

**Example:**

```yaml
additionalVars:
  - name: APPLICATION_VALIDATION_CURRENCY
    value: "BRL"
```

### APPLICATION_VALIDATION_ENROLLMENT_MAXLIMITDAILY

Used to set the maximum value for enrollments limits daily.

Default value: `500`

**Example:**

```yaml
additionalVars:
  - name: APPLICATION_VALIDATION_ENROLLMENT_MAXLIMITTDAILY
    value: "500"
```

### APPLICATION_VALIDATION_ENROLLMENT_MAXLIMITTRANSACTION

Used to set the maximum value for enrollments limits transaction.

Default value: `500`

**Example:**

```yaml
additionalVars:
  - name: APPLICATION_VALIDATION_ENROLLMENT_MAXLIMITTRANSACTION
    value: "500"
```

### APPLICATION_TEDTEF_ENABLED

Used to enable or disable TED/TEF type consents.

**Format:** `true` or `false`

Default value: `false`

**Example:**

```yaml
additionalVars:
  - name: APPLICATION_TEDTEF_ENABLED
    value: "false"
```

### APPLICATION_WEBHOOK_PAYMENT_ENABLED

Used to enable or disable payment webhook sending.

**Format:** `true` or `false`

Default value: `false`

**Example:**

```yaml
additionalVars:
  - name: APPLICATION_WEBHOOK_PAYMENT_ENABLED
    value: "true"
```

### CONSENT_PERMISSIONS

Used to define the list of permissions supported by the institution.

**IMPORTANT**: If `DATA_SHARING` services are used, this variable becomes mandatory.

**Example:**

Example configuration for an installation that supports only sharing personal data:

```yaml
additionalVars:
  - name: CONSENT_PERMISSIONS
    value: CUSTOMERS_PERSONAL_IDENTIFICATIONS_READ,CUSTOMERS_PERSONAL_ADITTIONALINFO_READ,CUSTOMERS_BUSINESS_IDENTIFICATIONS_READ,CUSTOMERS_BUSINESS_ADITTIONALINFO_READ,RESOURCES_READ
```

### CONSENT_DEBTORACCOUNT_IBGETOWNCODE

Configuration used in the context of Automatic Payments. It is used to indicate the municipality code of the payer's registration in the institution. If the institution has all registrations in the same municipality, this variable can be used. However, if the institution has several locations, this information should come from the legacy system.

**Example:**

```yaml
additionalVars:
  - name: CONSENT_DEBTORACCOUNT_IBGETOWNCODE
    value: "3550308"
```

### CONSENT_CUSTOMERS_ENABLED

Used to enable or disable the return of an empty list in the resources v3 API.

**IMPORTANT**: This feature should be enabled only for institutions that transmit only registration data.

**Format:** `true` or `false`

Default value: `false`

**Example:**

```yaml
additionalVars:
  - name: CONSENT_CUSTOMERS_ENABLED
    value: "false"
```

### CAMEL_CONNECTOR_MTLS_CERT

Used to define the MTLS certificate for calls to the legacy endpoint.

**IMPORTANT**: If you plan to use camelUtils for makePostCall and makeGetCall, this variable becomes mandatory.

**Example:**

Place the complete certificate, only part of the key is shown as an example.

```yaml
additionalVars:
  - name: CAMEL_CONNECTOR_MTLS_CERT
    value: -----BEGIN CERTIFICATE-----\nMIIEyzCCArMCAQEwDQYJKoZIhvcNAQELBQAwgasxCzAJBgNVBAYTAkJSMRIwEAYD(...)\n-----END CERTIFICATE-----
```

### CAMEL_CONNECTOR_MTLS_KEY

Used to define the MTLS private key for calls to the legacy endpoint.

**IMPORTANT**: If you plan to use camelUtils for makePostCall and makeGetCall, this variable becomes mandatory.

**Example:**

Place the complete key, only part of the key is shown as an example.

```yaml
additionalVars:
  - name: CAMEL_CONNECTOR_MTLS_KEY
    value: -----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDFjalN4Lvam2AX(...)\n-----END PRIVATE KEY-----
```

### APPLICATION_FEATURE_CONSENT_ACCEPTANCE_CREDITOR

Used to define whether or not to return the **creditor** field in the authorization-server command for app2as flows.

**IMPORTANT**: This feature should be disabled after the institution adapts to the new format using **creditors** (array).

**Format:** `true` or `false`

Default value: `true`

```yaml
additionalVars:
  - name: APPLICATION_FEATURE_CONSENT_ACCEPTANCE_CREDITOR
    value: "true"
```

### APPLICATION_FEATURE_NOTIFYCPFTOWEBHOOK
Used to define whether or not to send the **cpf** field to notification webhooks for backoffice.

**Format:** `true` or `false`

Default value: `false`

```yaml
additionalVars:
  - name: APPLICATION_FEATURE_NOTIFYCPFTOWEBHOOK
    value: "true"
```

### APPLICATION_ENCRYPTION_CHARSET

Used to define the charset used in encrypting fields in the database.

Default value: `UTF-8`

### ENROLLMENT_PERMISSIONS

Used to define the list of device binding permissions supported by the institution.

**IMPORTANTE**: Mandatory if the institution supports No Redirect Journey

**Ex:**

Configuration example for an installation that supports No Redirect Journey for payment v4:

```yaml
additionalVars:
  - name: ENROLLMENT_PERMISSIONS
    value: PAYMENTS_INITIATE
```

#### SSL_CERTIFICATE_HEADER_NAME

Defines the name of the header used to send the client mTLS
certificate that made the request. In the No Redirect Journey
context, the certificate is used to validate the Rellying Party
ID field during FIDO Registration.

**Default:** `X-SSL-Client-Cert`

```yaml
additionalVars:
  - name: SSL_CERTIFICATE_HEADER_NAME
    value: "X-SSL-Client-Cert"
```

### CONSENT_DATA_SHARING_V31_DATE

Defines the date when the necessary modifications for Phase 2 v3.1 should be activated.
It must be configured once the official date is announced by BACEN.

**Format:** "YYYY-MM-DD"

**Example:** To activate the modifications on 12/25/2024, configure
as follows:

```yaml
additionalVars:
  - name: CONSENT_DATA_SHARING_V31_DATE
  - value: "2024-12-25"
```

### ENROLLMENT_V21_DATE

Defines the date when the necessary modifications for No Redirect Journey
v2.1 should be activated.
It must be configured once the official date is announced by BACEN.

**Format:** "YYYY-MM-DD"

**Example:** To activate the modifications on 01/10/2025, configure
as follows:

```yaml
additionalVars:
  - name: ENROLLMENT_V21_DATE
  - value: "2025-01-10"
```

### APPLICATION_CONSENT_RECURRING_APPROVAL_DUE_DATE_DAYS

Used to define the maximum number of days for the approval of consents with multiple approvals.

**Format:** Integer

Default value: `5`

**Ex:**

```yaml
additionalVars:
  - name: APPLICATION_CONSENT_RECURRING_APPROVAL_DUE_DATE_DAYS
    value: "5"
```

### APPLICATION_JWS_ISS

Used to sign JWT payloads in requests.

**IMPORTANT:** If not defined, the organisation ID will be used as the default value.

**Type:** String

**Example:**

```yaml
additionalVars:
  - name: APPLICATION_JWS_ISS
    value: "https://obb.qa.oob.opus-software.com.br"
```

### APPLICATION_WEBHOOK_PAYMENT_PARALLELISM_ENABLED

To improve the performance of the status check jobs for webhook sending, the holder can
enable execution parallelism, allowing multiple status checks to its banking core at once.

**Format:** `true` or `false`

Default value: `false`

**Example:**

```yaml
additionalVars:
  - name: APPLICATION_WEBHOOK_PAYMENT_PARALLELISM_ENABLED
    value: "true"
```

### Connectors

There are additionalVars for using the consent approval connector developed by Opus, which are listed in [consent](../../integration-connector/consent/readme.md) in the `File route implemented by OPUS` section.

### DAPR_JOB_CONSENTTOEXPIRE_DAYS

Configuration to set how many days before expiration the webhook must be sent to backoffice.

**Format:** Integer

Default value: `1`

**Ex:**

```yaml
additionalVars:
  - name: DAPR_JOB_CONSENTTOEXPIRE_DAYS
    value: "1"
```

## FEATURE FLAGS

### feature/consentusagepersistence/enabled

Used to enable or disable the persistence of last use and usage history of consents.

**Format:** `true` or `false`

Default value: `true`

**Example:**

```yaml
additionalVars:
  - name: FEATURE_CONSENTUSAGEPERSISTENCE_ENABLED
    value: "true"
```

### feature/introspection/cache/enabled

Enables or disables the cache for introspection in the service. It should be enabled **ONLY** if the functionality is correctly configured in the [Authorization Server](../oob-authorization-server/readme.md#state-store).

Example: `1`

**Important**: Depends on configuring the state store name as described in [introspection state store name](#daprstatestoreintrospectionname).

### feature/accountHolder/cache/enabled

Enables or disables the cache for account holder verification. It should be enabled **ONLY** if the functionality is correctly configured in the [Authorization Server](../oob-authorization-server/readme.md#state-store).

Example: `1`

**Important**: Depends on configuring the state store name as described in [accountHolder state store](#daprstatestoreaccountholder).

### feature/fido/enabled

Enables or disables RP registration in fido server during DCR. It should be enabled **ONLY** if No Redirect Journey is enabled.

Example: `1`

### feature/cpfCnpjSearchKey/enabled
Enable or disable the creation of CPF and CNPJ search keys at the time a consent is created.

Ex: `1`

### feature/async-payment-status/enabled

Enables or disables asynchronous requests to legacy endpoint to
get payment status.

This feature should not be enabled if the institution has
implemented the [status change notification](../../backoffice-portal/apis-backoffice/readme.md#payment-status-change-notification)
for ***ALL*** types of payments.

**Format:** `true` ou `false`

**Default value**: `false`

```yaml
additionalVars:
  - name: FEATURE_ASYNC_PAYMENT_STATUS_ENABLED
    value: "true"
```

### feature/resources/async/enabled

Enables or disables asynchronous requests to the backend system’s discovery service to check for resource changes.  

This feature should be enabled **ONLY** if the institution has implemented the 
[resource change notification](../../backoffice-portal/apis-backoffice/readme.md#resource-change-notification)
for all non-selectable resources.

**Format:** `0` ou `1`

**Default value**: `0`

### ENROLLMENT_BLOCK_RECURRING_PERMISSION_BEFORE

Defines the date when the necessary modifications for No Redirect Journey
v2.2 should be activated.
It must be configured once the official date is announced by BACEN.

**Format:** "YYYY-MM-DD"

**Example:** To activate the modifications on 15/10/2025, configure
as follows:

```yaml
additionalVars:
  - name: ENROLLMENT_BLOCK_RECURRING_PERMISSION_BEFORE
  - value: "2025-10-15"
```
