# Opus Open Finance Platform Open Data Installation

## Installation

The module is installed via Helm Chart.

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

Defines the address of the open data service to be called via the standard GET route when the connector is not implemented. The service URI should be provided without `query parameters`. The variable should end with the name of the [route](../../integration-connector/open-data/readme.md) you want to associate the service with. The following example defines a URI for the `getFundsInvestments` and `getExchangeOnlineRate` routes:

**Example:**

```yaml
additionalVars:
  - name: OOB_CONNECTOR_SERVICEURI_GETFUNDSINVESTMENTS
    value: "https://service.bank.com.br/open-data/investments-funds"
  - name: OOB_CONNECTOR_SERVICEURI_GETEXCHANGEONLINERATE
    value: "https://service.bank.com.br/open-data/exchange-online-rate"
```
