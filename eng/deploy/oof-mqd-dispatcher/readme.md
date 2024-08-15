# Installation of Opus Open Finance MQD Dispatcher Module

## Prerequisites

### Message Queue

This module consumes and processes events published in a message queue. Therefore, it is necessary to have a correctly installed and configured *message broker* that can be used by the OOF MQD Dispatcher and that is compatible with [Dapr](/deploy/shared-definitions.md#dapr).

### Dapr

The OOF MQD Dispatcher module uses Dapr to subscribe to API call events that must be reported to the Data Quality Engine (in Portuguese, *Motor de Qualidade de Dados*, hence its acronym *MQD*). This module also applies (via Helm) a [resiliency](https://docs.dapr.io/reference/resource-specs/resiliency-schema/) component used to ensure that messages have a retry policy in case of failure during their consumption due to various issues, including communication failures between services.

Given this scenario, the installation of Dapr as well as the application of the resiliency component are necessary requirements for the correct operation of this module.

## Installation

The module installation is done via Helm Chart.

## Configuration

### dapr

Dapr-related configurations.

* `dapr.enabled`: Enables Dapr in the application to consume events. Possible values: `true` or `false`. **Default:** `true`.

* `dapr.retryPubsubId`: Identifier of the pub/sub component that implements retry policies. All events consumed by this module support reprocessing in case of failures, so the pub/sub component to be used by the module as a whole should be the one that supports retries.

**Example:**

```yaml
  dapr:
    enabled: "true"
    retryPubsubId: "pub-sub-retry"
```

### organisation.ids

Identifier(s) of the organization(s) for which the MQD Dispatcher module will receive events and send reports to the MQD Client module. The values should be comma-separated.

**Example 1:**

```yaml
  brand:
    ids: "singleOrganization"
```

**Example 2:**

```yaml
  brand:
    ids: "organization1,organization2"
```

## additionalVars

Used to define optional configurations in the application. This configuration allows defining a list of properties to be passed to the application in the format:

```yaml
additionalVars:
  - name: FIRST_PROPERTY
    value: "FIRST_VALUE"
  - name: SECOND_PROPERTY
    value: "SECOND_VALUE"
```

The configurations that can be defined in this format are listed below:

### LOG_LEVEL

Defines the message level that will be logged by the application. The possible values for this configuration are: `debug`, `info`, `warn`, `error`, and `fatal`.

* `debug`: Displays messages at `debug`, `info`, `warn`, `error`, and `fatal` levels.
* `info`: **Default value.** Displays messages at `info`, `warn`, `error`, and `fatal` levels.
* `warn`: Displays messages at `warn`, `error`, and `fatal` levels.
* `error`: Displays messages at `error` and `fatal` levels.
* `fatal`: Displays messages only at the `fatal` level.

**Example:**

```yaml
additionalVars:
  - name: LOG_LEVEL
    value: "debug"
```

### DAPR_BULK_SUBSCRIBE_MAX_MESSAGES_COUNT

Defines the maximum number of messages delivered at once by Dapr to the application. The default value is `10`.

**Example:**

```yaml
additionalVars:
  - name: DAPR_BULK_SUBSCRIBE_MAX_MESSAGES_COUNT
    value: "10"
```

### DAPR_BULK_SUBSCRIBE_MAX_AWAITING_DURATION_MS

Maximum waiting time in milliseconds before a batch of messages is delivered by Dapr to the application. The default value is `1000`.

**Example:**

```yaml
additionalVars:
  - name: DAPR_BULK_SUBSCRIBE_MAX_AWAITING_DURATION_MS
    value: "1000"
```

### MQD_CLIENT_REQUEST_TIMEOUT_SECONDS

Maximum time in seconds that the MQD Dispatcher application will wait for a response from the MQD Client application when sending a request with the content of an API call that must be reported. The default value is `5`.

**Example:**

```yaml
additionalVars:
  - name: MQD_CLIENT_REQUEST_TIMEOUT_SECONDS
    value: "5"
```
