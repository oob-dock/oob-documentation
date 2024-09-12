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

### consent/external/id

Used to define the id related to consentId. The consentId is the unique identifier for the consent and should be a URN - Uniform Resource Name.

Using the string urn:amazingbank as an example for consentId:

* the namespace (urn), as defined in [RFC8141](https://datatracker.ietf.org/doc/html/rfc8141)
* the identifier associated with the transmitting institution's namespace (amazingbank)

Example: `urn:amazingbank`

### payments/basePath

Used to define the base URI of the payment service. It should consist of the protocol and host followed by the path `/open-banking`.

Default value: `http://oob-payment/open-banking`

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

### Connectors

There are additionalVars for using the consent approval connector developed by Opus, which are listed in [consent](../../integração-plugin/consent/readme.md) in the `File route implemented by OPUS` section.

## additionalVarsDaemon

Used to define optional configurations for daemon instances.

### DAEMON_WEBHOOK_PAYMENT_INSTANT_INTERVAL

Used to set the daemon execution interval for status checks to send instant payment webhooks. This configuration value should be an integer followed by a time unit expressed in `m` for minutes or `s` for seconds. To activate the daemon, it is also necessary to activate the webhook feature in the instance.

**Example:**

The following example shows a configuration for running the daemon at 5-second intervals:

```yaml
additionalVarsDaemon:
  - name: DAEMON_WEBHOOK_PAYMENT_INSTANT_INTERVAL
    value: "5s"
  - name: APPLICATION_WEBHOOK_PAYMENT_ENABLED
    value: "true"
```

**IMPORTANT**: Activating the daemon is part of the temporary webhook solution and should only be enabled while the holder does not implement the [Payment Status Change Notification API](../../portal-backoffice/apis-backoffice/readme.md#notificação-de-mudança-de-status-de-pagamento). The daemon is disabled by default, but if the holder chooses to use it, the recommended interval value is `1s`, to meet the regulatory expected time.

Default value: `disabled`

### DAEMON_WEBHOOK_PAYMENT_SCHEDULED_INTERVAL

Used to set the daemon execution interval for status checks to send scheduled payment (SCHD) webhooks. The daemon configuration follows the same pattern as the previous one and is also considered a temporary solution to be used while the holder does not implement the payment status notification via API. As with the previous one, activating this daemon depends on the activation of the webhook feature in the instance. The daemon is disabled by default, but if the holder chooses to use it, the recommended interval value is `1s`, to meet the regulatory expected time.

**Example:**

```yaml
additionalVarsDaemon:
  - name: DAEMON_WEBHOOK_PAYMENT_SCHEDULED_INTERVAL
    value: "5s"
  - name: APPLICATION_WEBHOOK_PAYMENT_ENABLED
    value: "true"
```

Default value: `disabled`

### DAEMON_WEBHOOK_PAYMENT_PARALLELISM_ENABLED

To improve the performance of the status check daemons for webhook sending, the holder can enable execution parallelism, allowing multiple status checks to its banking core at once.

**Format:** `true` or `false`

Default value: `false`

**Example:**

```yaml
additionalVarsDaemon:
  - name: DAEMON_WEBHOOK_PAYMENT_PARALLELISM_ENABLED
    value: "true"
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

### feature/introspection/cache/enabled

Enables or disables the cache for introspection in the service. It should be enabled **ONLY** if the functionality is correctly configured in the [Authorization Server](../oob-authorization-server/readme.md#state-store).

Example: `1`

**Important**: Depends on configuring the state store name as described in [introspection state store name](#daprstatestoreintrospectionname).

### feature/accountHolder/cache/enabled

Enables or disables the cache for account holder verification. It should be enabled **ONLY** if the functionality is correctly configured in the [Authorization Server](../oob-authorization-server/readme.md#state-store).

Example: `1`

**Important**: Depends on configuring the state store name as described in [accountHolder state store](#daprstatestoreaccountholder).
