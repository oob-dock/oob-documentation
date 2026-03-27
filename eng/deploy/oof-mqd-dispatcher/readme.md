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

* `dapr.largeEventStateStore`:
  * State store used to retrieve events that have a very large payload and
  therefore could not be published directly to queues. In this case, the event
  is persisted in this state store and the ID of the persisted entry is received
  in this module, which then retrieves the event payload. **Its configuration is
  mandatory.**
    * `name`: Name of the Dapr component to be initialized. **Important:** Kong
    also uses this same component to fetch published events, and the connection
    between modules occurs through the component name. Therefore, the name
    defined here must be the same as defined in `terraform` in the `dapr_large_event_store` variable.
      * `type`: Type of the Dapr component to be used as state store.
        * A list of components can be found [here](https://docs.dapr.io/reference/components-reference/supported-state-stores/)
    * `version`: Component version.
    * `connectionMetadata`: Connection settings for the component to be used as state store.

  * **Important:**
    * This Dapr state store component must be configured with a `keyPrefix` field
    with the value `name`, so that all persisted entries have the same prefix that
    is shared by `oob-kong` and `oof-mqd-dispatcher`. This prefix will be exactly
    the name defined in the `dapr.largeEventStateStore.name` variable.
    * This component must be created in every namespace that uses it. If Kong
    is in the same namespace as `oof-mqd-dispatcher`, it only needs to be
    defined once. Otherwise, it must be defined in both the Kong namespace and
    this module's namespace.
    * An example template of this component can be found in this module's helm
    chart, at `helm/oof-mqd-dispatcher/templates/large-event-state-store.yaml`.

**Example:**

```yaml
  dapr:
    enabled: "true"
    retryPubsubId: "pub-sub-retry"
    largeEventStateStore:
      name: "large-event-state-store"
      type: "state.postgresql"
      version: "v1"
      connectionMetadata:
        - name: "connectionString"
          value: "host=db-opus-open-banking.namespace.us-east-1.rds.amazonaws.com user=user password=passwd database=dapr_state"
        - name: timeout
          value: 10
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
