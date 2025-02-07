# Opus Open Finance Platform Payment Module Installation

## Installation

The module is installed via Helm Chart.

## Configuration

### internalApis/consentServer

Base address of the consent service. An internal Kubernetes address can be used.

**Example:** `http://oob-consent`
  
### tokenValidationService

Authentication token validation configuration

  - **host**: Base address of the authorization server. An internal Kubernetes address can be used.

    > **Example:** `http://oob-authorization-server`

  - **path**: Introspection endpoint path

    > **Example:** /auth/token/introspection

  - **clientId**: Client created in the oob-authorization-server configuration

  - **clientSecret**: Secret of the client created in the oob-authorization-server configuration

  - **jwksPath**: Non-regulatory Authorization Server JWKS endpoint path - [NON FAPI](../oob-authorization-server/readme.md#authnonfapibasepath)

    > **Example:** `/auth-nonfapi/jwks`

### signature

Private key used to sign messages. It must contain a signature key. See the [definition](../shared-definitions.md#formatos-de-chave-privada-suportados) for details on supported key formats.

* certSecretName: Name of the secret containing the private key. Default: "oob-as-keys"
* certSecretKey: Name of the secret property containing the private key. Default: "sig.key"
* kid: Key identifier (obtained from the participant directory)
* passphraseSecretName: Name of the secret containing the private key passphrase (optional)
* passphraseSecretKey: Name of the secret property containing the private key passphrase (optional)

The `passphraseSecretName` and `passphraseSecretKey` properties should only be defined for encrypted keys. If not provided, it is assumed the keys are open.

Example:

```yaml
  signature:
    certSecretName: "oob-as-keys"
    certSecretKey: "sig.key"
    passphraseSecretName: "oob-as-keys"
    passphraseSecretKey: "sig.key.passphrase"
    kid: "uGe7YNnhE83esu86xeqGJMIQi8IamA8FTSaLd1pkXy8"
```

### organisation/id

Fill with the organisationId of the institution registered in the participant directory. Use the sandbox id for non-production environments and the production value for production environments.

Example:

```yaml
  organisation:
    id: "d7770ef0-6803-4b29-a5ea-4eac0e6cac0a"
```

#### cnpjInitiatorValidation

* directoryRolesUrl: Address of the participant directory. Non-production environments should use the sandbox address of the participant directory.

| Environment | Address                                                        |
| ----------- | -------------------------------------------------------------- |
| Sandbox     | <https://data.sandbox.directory.openbankingbrasil.org.br/roles> |
| Production  | <https://data.directory.openbankingbrasil.org.br/roles>         |

* cacheTimeout: Lifetime defined for caching the participant directory.

Accepted units:

* S - seconds
* M - minutes
* H - hours
* D - days

**Example:** 5M (five minutes)

#### cron/scheduled/participantDirectory

* Applies a `cron binding` for periodic update of the roles in the participant directory.

* The defined value refers to the interval at which the call to the participant directory API is made.

Accepted units:

* S - seconds
* M - minutes
* H - hours
* D - days

Example:

```yaml
  cron:
    scheduled:
      participantDirectory: 240M
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
      rate: "1"
```

## additionalVars

Used to define optional configurations in the application. This configuration
allows defining a list of properties to be passed to the application in the
following format:

```yaml
additionalVars:
  - name: FIRST_PROPERTY
    value: "FIRST_VALUE"
  - name: SECOND_PROPERTY
    value: "SECOND_VALUE"
```

The settings that can be defined in this format are listed below:

### QUARKUS_LOG_LEVEL

Defines the log detail level of the application. It is recommended to activate DEBUG level only in development/testing environments or to facilitate error analysis in production. In production, it is advisable to use the INFO level.

**Format:** `DEBUG`, `INFO`, `TRACE`, `WARNING`, or `ERROR`

**Default:** `INFO`

**Example:**

```yaml
additionalVars:
  - name: QUARKUS_LOG_LEVEL
    value: "DEBUG"
```

### APIS_VALIDATION_JSON-SCHEMA

Enables validation of request/response objects sent/received by the plugin with the defined specs (affects performance). It is advisable to disable it in production.

**Format:** `true` or `false`

**Default:** `false`

**Example:**

```yaml
additionalVars:
  - name: APIS_VALIDATION_JSON
    value: "true"
```

### APIS_VALIDATION_OPENAPI_ENABLED-REQUEST

Enables validation of request objects received by the API with the Open Banking Brasil specification. It is advisable to always keep it active.

**Format:** `true` or `false`

**Default:** `true`

**Example:**

```yaml
additionalVars:
  - name: APIS_VALIDATION_OPENAPI_ENABLED-REQUEST
    value: "true"
```

### APIS_VALIDATION_OPENAPI_ENABLED-RESPONSE

Enables validation of response objects returned by the API with the Open Banking Brasil specification (affects performance). It is advisable to disable it in production.

**Format:** `true` or `false`

**Default:** `false`

**Example:**

```yaml
additionalVars:
  - name: APIS_VALIDATION_OPENAPI_ENABLED-RESPONSE
    value: "true"
```

### OOB_ALLOWAUTHCODETOKEN_LIMITDATE

Enables blocking of GET and PATCH payment calls using the authorization code flow token. This variable should receive a date when this blocking should start.

The default value is '2023-07-18' as per specification.

**Format:** `yyyy-MM-dd`

**Default:** `2023-07-18`

```yaml
additionalVars:
  - name: OOB_ALLOWAUTHCODETOKEN_LIMITDATE
    value: "2023-07-18"
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
