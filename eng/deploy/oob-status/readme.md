# Opus Open Finance Platform Status Module Installation

## Installation

The module is installed via Helm Chart.

## Configuration

### db

Database access configuration:

* name: Database name
* username: Database access username
* password: Database access password
* host: Database host

### liquibase/contexts

See the [definition](../shared-definitions.md#liquibase-contexts).

### services

Configuration of the addresses of the services monitored/used by the API:

* prometheus/baseAddress: Base address of Prometheus. An internal Kubernetes address can be used.

**Example:** `http://prometheus-server`

* openData/baseAddress: Base address of the products and services and service channels API ([phase 1 of Open Finance Brazil](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17367790/Dados+Abertos+-+DA)). An internal Kubernetes address can be used.

**Example:** `http://oof-open-data`

* financialData/baseAddress: Base address of the financial data API (phase 2). An internal Kubernetes address can be used.

**Example:** `http://oof-financial-data`

* payment/baseAddress: Base address of the payments API (phase 3). An internal Kubernetes address can be used.

**Example:** `http://oof-payment`

* consent/baseAddress: Base address of the consent API. An internal Kubernetes address can be used.

**Example:** `http://oof-consent`

Configuration of the base addresses of externally accessible services, with or without mtls:

* publicFqdn: External base address of the API without mtls.

**Example:** `oof.qa.oob.opus-software.com.br`

* publicFqdnMtls: External base address of the API with mtls.

**Example:** `mtls-oof.qa.oob.opus-software.com.br`

### features

See the [definition](../shared-definitions.md#supported-features-of-opus-open-finance).

### plugins/metrics/brandId

See the [definition](../shared-definitions.md#brand-id).

### oidc

See the [definition](../shared-definitions.md#oidc).

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

### DAEMON_INCIDENT_ENABLED

Indicates if the incident daemon is enabled. It should be activated in production.

**Format:** `true` or `false`

**Default:** `true`

**Example:**

```yaml
additionalVars:
  - name: DAEMON_INCIDENT_ENABLED
    value: "true"
```
