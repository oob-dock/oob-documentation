# Opus Open Finance Platform Open Data Installation

## Installation

The module is installed via Helm Chart.

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

Defines the log detail level of the application. It is recommended to activate DEBUG level only in development/testing environments or to facilitate error analysis in production. In production, it is advisable to use the INFO level.

**Format:** `DEBUG`, `INFO`, `TRACE`, `WARNING`, or `ERROR`

**Default:** `INFO`

**Example:**

```yaml
additionalVars:
  - name: QUARKUS_LOG_LEVEL
    value: "DEBUG"
```

### APIS_VALIDATION_OPENAPI_ENABLED-REQUEST

Enables validation of request objects received by the API with the Open Finance Brasil specification. It is advisable to always keep it active.

**Format:** `true` or `false`

**Default:** `true`

**Example:**

```yaml
additionalVars:
  - name: APIS_VALIDATION_OPENAPI_ENABLED-REQUEST
    value: "true"
```

### APIS_VALIDATION_OPENAPI_ENABLED-RESPONSE

Enables validation of response objects returned by the API with the Open Finance Brasil specification (affects performance). It is advisable to disable it in production.

**Format:** `true` or `false`

**Default:** `false`

**Example:**

```yaml
additionalVars:
  - name: APIS_VALIDATION_OPENAPI_ENABLED-RESPONSE
    value: "true"
```

### OOB_CONNECTOR_SERVICEURI

Defines the address of the open data service to be called via the standard GET route when the connector is not implemented. The service URI should be provided without `query parameters`. The variable should end with the name of the [route](../../integração-plugin/open-data/readme.md) you want to associate the service with. The following example defines a URI for the `getFundsInvestments` and `getExchangeOnlineRate` routes:

**Example:**

```yaml
additionalVars:
  - name: OOB_CONNECTOR_SERVICEURI_GETFUNDSINVESTMENTS
    value: "https://service.bank.com.br/open-data/investments-funds"
  - name: OOB_CONNECTOR_SERVICEURI_GETEXCHANGEONLINERATE
    value: "https://service.bank.com.br/open-data/exchange-online-rate"
```
