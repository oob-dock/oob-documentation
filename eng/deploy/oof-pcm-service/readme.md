# Installation of Opus Open Finance PCM Service

The Metric Collection Platform (in Portuguese, *Plataforma de Coleta de Métricas*, hence its acronym *PCM*) is a mandatory regulatory requirement that requires all participating institutions to report metrics on all API calls made and/or received to the governance structure of Open Finance Brazil. Both institutions involved in any operation must submit reports containing information such as accessed endpoint, event date and time, received result, and response time. The PCM Service module is responsible for receiving atomic reports of each call received or made by the Opus Open Finance Platform and sending them to the governance structure of Open Finance Brazil.

**Attention:** In the text you will find references to BRCAC certificates. BRCAC certificates are issued by Certifying Authorities authorized by ICP-Brasil and are only used for communication between entities participating in the Open Finance Brasil ecosystem. A detailed explanation of certificates standardized by Open Finance Brazil (in English) can be found [here](https://openfinancebrasil.atlassian.net/wiki/x/VoGSB).

## Prerequisites

### Database

This module requires its own database for operation. Currently, it supports Postgres databases.

### Message Queue

This module consumes and processes events published in a message queue. Therefore, it is necessary to have a correctly installed and configured *message broker* that can be used by the OOF PCM Service and that is compatible with [Dapr](/deploy/shared-definitions.md#dapr).

### Virtual Actors

This module uses [virtual actors](https://docs.dapr.io/developing-applications/building-blocks/actors/actors-overview/) from [Dapr](/deploy/shared-definitions.md#dapr). The use of this feature depends on the inclusion of a [state store](https://docs.dapr.io/reference/components-reference/supported-state-stores/) to maintain its operational states. Therefore, it will be necessary to include this configuration. **Important:** You must define a property called `actorStateStore` with the value `true` in the state store.

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

**Attention:** This is just an **example**. You need to adjust it to the desired technology and review all configured properties.

### Dapr

The OOF PCM Service module uses Dapr to subscribe to API call events that must be reported to the Metric Collection Platform (PCM). This module also applies (via Helm) a [cron binding](https://docs.dapr.io/reference/components-reference/supported-bindings/cron/) component used to send reports to the PCM periodically.

Given this scenario, the installation of Dapr as well as the application of the binding component are necessary requirements for the correct operation of this module.

### Creation of secret(s) to store private keys

The certificates and private keys of the organizations configured in the OOF PCM Service must be securely stored. It is highly recommended to use a password vault for this storage. If this is not possible, traditional secrets can be created in Kubernetes to persist this information. The procedure below describes one of the ways to create this secret.

```shell
kubectl -n <NAMESPACE_NAME> create secret generic <SECRET_NAME> --from-file=<DIRECTORY_PATH>
```

Consider, for example, that the organization's certificate and key are already created and stored in a local directory:

```shell
ls /tmp/pcm-service
cert.pem  sig.key
```

By running the command below, the secret is created:

```shell
kubectl -n oob create secret generic pcm-organization-tls --from-file=/tmp/pcm-service
secret/pcm-organization-tls created
```

To describe the content of the secret, the following yaml file can be used:

```yaml
apiVersion: v1
data:
  tls.crt: LS0t...tLQ==
  tls.key: LS0t...LS0=
kind: Secret
metadata:
  creationTimestamp: "2023-01-05T13:41:43Z"
  name: pcm-organization-tls
  namespace: oob
  resourceVersion: "535247094"
  selfLink: /api/v1/namespaces/oob/secrets/pcm-organization-tls
  uid: abf5558b-ad5a-478b-8625-bd82328f7f5f
type: Opaque
```

## Additional Configuration

### Header `x-request-start-time`

The OOF PCM Service includes an extra feature that allows the use of the HTTP
header `x-request-start-time` to assist in calculating the total processing
time of a request. This functionality is useful for achieving greater accuracy
in calculating the total processing time of the request to be reported via PCM.

#### Where to define the Header?

Ideally, this header should be defined at the first entry point of a new
request in the product. A good candidate for this is a WAF (Web
Application Firewall), for example.

The inclusion and injection of this header into the request **is optional**.
When defined, this value will be used as the start time of the request during
the calculation of the total processing time. If this header is not provided,
the time of arrival of the request at the API Gateway will be used for the
calculation.

#### Format

The `x-request-start-time` header must be provided in Unix epoch format,
preferably in milliseconds. The following formats are accepted:

- Milliseconds without decimals. Example: `1671373873945`
- Milliseconds with decimals. Example: `1671373873.945`
- Microseconds or higher precision. Example: `1671373873945345`. In this case,
the value will be truncated to milliseconds (13 characters).

**Attention!**

**It is not recommended to send the value in seconds** (10 characters) -
although it is accepted by the plugin. In this scenario, if the event is
provided in seconds, up to 1 additional second may be added to the total
request processing time due to rounding of the time unit.

**Ensure that the format sent is one of the accepted formats listed above!**
If the value is provided in any other format, there will be an issue with the
creation of the event, and the request will not be reported to PCM. This will
result in non-compliance with the rules established by the Open Finance Brazil
governance.

## Installation

The module installation is done via Helm Chart.

## Configuration

### db

Database access configuration.

* `host`: Database host.
* `port`: Database port (optional). **Default:** `5432`.
* `name`: Database name.
* `schema`: Database schema (optional). **Default:** `public`.
* `username`: Database access username.
* `password`: Database access password.

**Example:**

```yaml
  db:
    host: "oof_pcm_service"
    port: 5432
    name: "oof_pcm_service"
    schema: "public"
    username: "oof_pcm_service"
    password: "oof_pcm_service"
```

### dapr

Dapr-related configurations.

* `dapr.enabled`: Enables Dapr in the application to consume events. Possible values: `true` or `false`. **Default:** `true`.
* `dapr.pubSubId`: Identifier of the Dapr pub/sub component to be used.

**Example:**

```yaml
  dapr:
    enabled: "true"
    pubSubId: "pcm-event-pub-sub"
```

### brand.ids

Identifier(s) of the installation brand(s), separated by commas.

**Example 1:**

```yaml
  brand:
    ids: "single-brand"
```

**Example 2:**

```yaml
  brand:
    ids: "brand1,brand2"
```

### softwareStatements

List of *software statements* composed of: BRCAC certificate, private key, and client identifier. This information is necessary for the service to obtain the access token that enables the sending of reports to the PCM.

* `certSecretName`: Name of the secret that contains the BRCAC certificate(s).
* `certSecretKey`: Name of the secret property that contains the BRCAC certificate.
* `privateKeySecretName`: Name of the secret that contains the private key(s).
* `privateKeySecretKey`: Name of the secret property that contains the private key.
* `clientId`: Identifier(s) of the client(s) in the participant directory.

**Example:**

```yaml
  softwareStatements:
    - certSecretName: "pcm-organization-tls"
      certSecretKey: "tls.crt"
      privateKeySecretName: "pcm-organization-tls"
      privateKeySecretKey: "tls.key"
      clientId: "0b4841d2-773f-4286-92a0-611f6d066545"
    - certSecretName: "pcm-organization-tls"
      certSecretKey: "tls2.crt"
      privateKeySecretName: "pcm-organization-tls"
      privateKeySecretKey: "tls2.key"
      clientId: "1dfbae86-ce9b-41d9-bf29-832317f26b31"
```

### pcm

PCM-related configurations.

* `apiBaseUrl`: Base URL of the PCM APIs.
* `authBaseUrl`: Base URL of the PCM authentication API.

More details on the addresses for each environment can be found (in Portuguese) [at this link](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/37945515/Manual+de+Integra+o#Endere%C3%A7os-base).

**Example:**

```yaml
  pcm:
    apiBaseUrl: "https://api.pcm.sandbox.openfinancebrasil.org.br"
    authBaseUrl: "https://auth.pcm.sandbox.openfinancebrasil.org.br"
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

### REPORT_PCM_BATCH_DELAY

Delay for batch event collection for PCM reporting in minutes. The default value is 60 minutes.

**Example:**

```yaml
additionalVars:
  - name: REPORT_PCM_BATCH_DELAY
    value: "60"
```

### DAPR_BULK_SUBSCRIBE_MAX_MESSAGES_COUNT

Defines the maximum number of messages delivered at once by Dapr to the application. The default value is `10`.

**Example:**

```yaml
additionalVars:
  - name: DAPR_BULK_SUBSCRIBE_MAX_MESSAGES_COUNT
    value: "10"
```

**Important**: This configuration is currently only available for internal metrics monitoring events.

### DAPR_BULK_SUBSCRIBE_MAX_AWAITING_DURATION_MS

Maximum waiting time in milliseconds before a batch of messages is delivered by Dapr to the application. The default value is `1000`.

**Example:**

```yaml
additionalVars:
  - name: DAPR_BULK_SUBSCRIBE_MAX_AWAITING_DURATION_MS
    value: "1000"
```

**Important**: This configuration is currently only available for internal metrics monitoring events.

### METRIC_MAX_TIME_SECONDS

Maximum allowed delay time, in seconds, for the event to be considered for metric emission. The default value is `60` seconds.

**Example:**

```yaml
additionalVars:
  - name: METRIC_MAX_TIME_SECONDS
    value: "60"
```

### DAPR_ACTOR_TYPE

Defines the suffix that will be used in the types of actors used by this module that will be instantiated in the environment, typically the name of the environment itself; if empty, nothing is added, meaning the actor type is used as is, e.g., `pcmDispatcherBatch`. This is used so that Dapr instantiates an actor per environment.

**Example:**

```yaml
additionalVars:
  - name: DAPR_ACTOR_TYPE
    value: "Qa"
```
