# Opus Open Finance Platform Status Module Installation

## Prerequisites

### Virtual Actors

This module uses [virtual actors](https://docs.dapr.io/developing-applications/building-blocks/actors/actors-overview/)
from [Dapr](/deploy/shared-definitions.md#dapr). The use of this feature
depends on the inclusion of a [state store](https://docs.dapr.io/reference/components-reference/supported-state-stores/)
to maintain its operational states. Therefore, it will be necessary to include this configuration. 

**Important:** You must define a property called `actorStateStore` with the value `true` in the state store.

Below is an example of a state store component definition that uses Redis.

```yaml
apiVersion: dapr.io/v1alpha1
kind: Component
metadata:
  name: statestore
spec:
  type: state.redis
  version: v1
  metadata:
  - name: redisHost
    value: <host>:<port>
  - name: redisPassword
    value: ""
  - name: actorStateStore
    value: "true"
```

**Attention:** This is just an **example**. You need to adjust it to the
desired technology and review all configured properties.

## Installation

The module is installed via Helm Chart.

## Configuration

### db

Database access configuration:

* name: Database name
* username: Database access username
* password: Database access password
* host: Database host

### DDL Script Execution

See the [definition](../shared-definitions.md#ddl-scripts)

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

### dapr/enabled

Enables Dapr in the application to send events.

**Format:**: `true` or `false`.

Default value: `true`

### dapr/appId

Identifier of the service to be used if there is more than one instance
for different brands within the same environment.
If not filled, the default name "oob-status" will be used.

Example: `oob-status-cbanco`

### dapr/address

Dapr sidecar address to be used by the service.

Example: `localhost:3501`

### dapr/health/timeoutMs

Time, in milliseconds, that the service will wait until the
dapr sidecar is available.

Example: `10000`

## dapr/schedulerHostAddress

This configuration must point to the Dapr scheduler service to
enable the Dapr Jobs API functionality. For more details, refer
to the [Dapr documentation](https://docs.dapr.io/reference/arguments-annotations-overview/).

**Example:**

```yaml
env:
  dapr:
    schedulerHostAddress: dapr-scheduler-server.oob.svc.cluster.local:50006
```

## dapr/job/dailyMetric/schedule

Define the scheduling of daily metric processing for display in the OF metrics API.

**Format:** Cron-like string (ignoring seconds, just 5 fields) or expression for scheduling based on [Dapr Jobs API](https://docs.dapr.io/reference/api/jobs_api/).

**Default value**: `@every 300s` (each 300 seconds).

**Example:** To schedule the execution of the daily metrics collection every 300 seconds:

```yaml
env:
  dapr:
    job:
      dailyMetric:
        schedule: "@every 300s"
```

## dapr/job/activeConsents/schedule

Define the scheduling of the processing of service status and
data on the requests received at the regulatory endpoints.

**Format:** Cron-like string (ignoring seconds, just 5 fields) or expression for scheduling based on [Dapr Jobs API](https://docs.dapr.io/reference/api/jobs_api/).

**Default value**: `@every 30s`

**Example:** To schedule the execution of regulatory API data collection for every 30 seconds:

```yaml
env:
  dapr:
    job:
      incident:
        schedule: "@every 30s"
```

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

### LOGGING_LEVEL_ROOT

Defines the log detail level of the application. It is recommended to activate DEBUG level only in development/testing environments or to facilitate error analysis in production. In production, it is advisable to use the INFO level.

**Format:** `DEBUG`, `INFO`, `TRACE`, `WARNING`, or `ERROR`

**Default:** `INFO`

**Example:**

```yaml
additionalVars:
  - name: LOGGING_LEVEL_ROOT
    value: "DEBUG"
```

### LOGGING_LEVEL_INITIALIZATION

Defines the log level for service startup messages.
In production, it is recommended to set the level to `WARN`.

**Possible values:** `DEBUG`, `INFO`, `TRACE`, `WARNING` or `ERROR`

Default value: `WARN`

**Example:**

```yaml
additionalVars:
  - name: LOGGING_LEVEL_INITIALIZATION
    value: "WARN"
```