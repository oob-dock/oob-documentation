# Installation of Opus Open Finance Platform Event Service Module

## Prerequisites

### Database

This module requires its own database for operation. Currently, it supports Postgres databases.

### Message Queue

This module consumes and processes events published in a message queue. Therefore, it is necessary to have a correctly installed and configured *message broker* that can be used by the OOF Event Service and that is compatible with [Dapr](/deploy/shared-definitions.md#dapr).

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

The OOF Event Service module uses Dapr to subscribe to webhook events that should be sent during the transition of payment and consent states. This module also applies (via Helm) a [cron binding](https://docs.dapr.io/reference/components-reference/supported-bindings/cron/) component used for reprocessing webhooks.

Given this scenario, the installation of Dapr as well as the application of the binding component are necessary requirements for the correct operation of this module.

### Creation of secret(s) to store private keys

The certificates and private keys of the organizations configured in the OOF Event Service must be securely stored. It is highly recommended to use a password vault for this storage. If this is not possible, traditional secrets can be created in Kubernetes to persist this information. The procedure below describes one of the ways to create this secret.

```shell
kubectl -n <NAMESPACE_NAME> create secret generic <SECRET_NAME> --from-file=<DIRECTORY_PATH>
```

Consider, for example, that the brand's certificate and key are already created and stored in a local directory:

```shell
ls /tmp/event-service
cert.pem  sig.key
```

By running the command below, the secret is created:

```shell
kubectl -n oob create secret generic webhook-certificates --from-file=/tmp/event-service
secret/webhook-certificates created
```

To describe the content of the secret, the following command can be used:

```shell
apiVersion: v1
data:
  tls.crt: LS0t...tLQ==
  tls.key: LS0t...LS0=
kind: Secret
metadata:
  creationTimestamp: "2023-06-22T10:30:27Z"
  name: webhook-certificates
  namespace: oob
  resourceVersion: "535257094"
  selfLink: /api/v1/namespaces/oob/secrets/webhook-certificates
  uid: ee47ec34-c4b8-45b8-ab95-ad6ed38f4376
type: Opaque
```

## Installation

The module installation is done via Helm Chart.

## Configuration

### db

Database access configuration.

* `host`: Database host.
* `port`: Database port (optional). **Default:** `5432`.
* `name`: Database name.
* `username`: Database access username.
* `password`: Database access password.

**Example:**

```yaml
  db:
    host: "oof_event_service"
    port: 5432
    name: "oof_event_service"
    username: "oof_event_service"
    password: "oof_event_service"
```

### DDL Script Execution

See the [definition](../shared-definitions.md#ddl-scripts)

### dapr

Dapr-related configurations.

* `dapr.enabled`: Enables Dapr in the application to consume events.
Possible values: `true` or `false`. **Default:** `true`.
* `dapr.daprPubsubId`: Identifier of the Dapr pub/sub component to be used.

**Example:**

```yaml
  dapr:
    enabled: "true"
    daprPubsubId: "event-service-pub-sub"
```

### config

Basic service configurations.

* `config.logLevel`: Sets the minimum log level for the service.

**Example:**

```yaml
  config:
    logLevel: "info"
```

### privateKeys

Identifiers of organizations and their brands, containing their certificates for making mtls calls.

* `privateKeys.orgId`: Organization identifier in the central directory.
* `privateKeys.softwareStatements.brandId`: Organization brand identifier.
* `privateKeys.softwareStatements.brcacSecretName`: Name of the secret that contains the BRCAC certificate.
* `privateKeys.softwareStatements.brcacSecretKey`: Name of the secret property that contains the BRCAC certificate.
* `privateKeys.softwareStatements.brcacSecretName`: Name of the secret that contains the private key of the certificate.
* `privateKeys.softwareStatements.brcacSecretKey`: Name of the secret property that contains the private key of the certificate.
* `privateKeys.softwareStatements.notificationUrl`: Optional configuration for sending notifications to the backoffice webhook of the institution where the module is installed.

**Example 1:**

```yaml
  privateKeys:
    orgId: "03f9155a-c230-4c87-a051-c63272092030"
    - softwareStatements:
        - brandId: "cbank"
          brcacSecretName: "webhook-certificates"
          brcacSecretKey: "tls.crt"
          brcacKeySecretName: "webhook-certificates"
          brcacKeySecretKey: "tls.key"
    - softwareStatements:
        - brandId: "dbanco"
          brcacSecretName: "webhook-certificates2"
          brcacSecretKey: "tls.crt"
          brcacKeySecretName: "webhook-certificates2"
          brcacKeySecretKey: "tls.key"
          notificationUrl: "http://amazingbank.com/notification"
```

> **Warning:** The backoffice webhook payload specification is provided below. Ensure you review and implement it according to your institution's requirements.

### Backoffice Webhook Payload Specification

The webhook payload sent to the backoffice will have the following structure:

 Example:

```json
{
  "consentVersion": 2,
  "eventType": "CONSENT_AUTHORIZATION_EXPIRED",
  "message": "Autorização expirou por falta de confirmação do usuário",
  "status": "REJECTED",
  "updateStatusTimestamp": "2025-09-17T12:41:11.001667-03:00",
  "consentId": "urn:amazingbank:4136f4ae-ab4c-40e3-8d8d-608e10dad36b",
  "brandId": "cbanco"
}
```

#### OpenAPI Specification

```yaml
openapi: 3.0.3
info:
  title: Backoffice Webhook Payload
  version: 1.0.0
paths:
  /:
    post:
      summary: Receives webhook payload
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/BackofficeWebhookPayload'
      responses:
        '200':
          description: Webhook received
components:
  schemas:
    BackofficeWebhookPayload:
      type: object
      properties:
        consentVersion:
          type: integer
          example: 2
        eventType:
          type: string
          enum:
            - CONSENT_AUTHORIZATION_NOT_COMPLETED
            - CONSENT_AUTHORIZATION_EXPIRED
          example: CONSENT_AUTHORIZATION_EXPIRED
        message:
          type: string
          example:
           - Autorização iniciada não for concluída dentro do prazo regulatório falta de resposta da Iniciadora
           - Autorização expirou por falta de confirmação do usuário
        status:
          type: string
          example: REJECTED
        updateStatusTimestamp:
          type: string
          format: date-time
          example: "2025-09-17T12:41:11.001667-03:00"
        consentId:
          type: string
          example: urn:amazingbank:4136f4ae-ab4c-40e3-8d8d-608e10dad36b
        brandId:
          type: string
          example: cbanco
      required:
        - consentVersion
        - eventType
        - message
        - status
        - updateStatusTimestamp
        - consentId
        - brandId
```

## additionalVars

Used to define optional service configurations. This configuration allows defining a list of properties to be passed to the service in the format:

```yaml
additionalVars:
  - name: FIRST_PROPERTY
    value: "FIRST_VALUE"
  - name: SECOND_PROPERTY
    value: "SECOND_VALUE"
```

### OOF_WEBHOOK_PAYMENT_ENABLED

Defines whether payment webhook sending should be enabled.

**Default**: "false"

**Example:**

```yaml
additionalVars:
  - name: OOF_WEBHOOK_PAYMENT_ENABLED
    value: "true"
```

### VALIDATE_CERTIFICATE

Defines whether the service will validate the certificates used in sending webhooks.

**Default**: "false"

**Example:**

```yaml
additionalVars:
  - name: VALIDATE_CERTIFICATE
    value: "true"
```

### OOF_WEBHOOK_PAYMENT_DELAY_SECONDS

Configuration for payment webhook event sending delay in seconds.

**Example:**

```yaml
additionalVars:
  - name: OOF_WEBHOOK_PAYMENT_DELAY_SECONDS
    value: "10"
```

### OOF_WEBHOOK_PAYMENT_CONSENT_DELAY_SECONDS

Configuration for payment consent webhook event sending delay in seconds.

**Example:**

```yaml
additionalVars:
  - name: OOF_WEBHOOK_PAYMENT_CONSENT_DELAY_SECONDS
    value: "5"
```

### OOF_WEBHOOK_PAYMENT_STATUS

Defines which payment statuses are configured for webhook sending. The default value is the statuses indicated in the open finance documentation.

**Default**: "CANC,PATC,PDNG,SCHD,RJCT,ACSC"

**Example:**

```yaml
additionalVars:
  - name: OOF_WEBHOOK_PAYMENT_STATUS
    value: "CANC,SCHD,RJCT,ACSC"
```

### OOF_WEBHOOK_PAYMENT_CONSENT_STATUS

Defines which payment consent statuses are configured for webhook sending. The default value is the statuses indicated in the open finance documentation.

**Default**: "CONSUMED,REJECTED,REVOKED,TIMEOUT_AUTHORISATION,TIMEOUT_PAYMENT,EXPIRED"

**Example:**

```yaml
additionalVars:
  - name: OOF_WEBHOOK_PAYMENT_CONSENT_STATUS
    value: "CONSUMED,REJECTED,REVOKED,TIMEOUT_AUTHORISATION,TIMEOUT_PAYMENT,EXPIRED"
```

### DAPR_ACTOR_TYPE

Defines the suffix that will be used in the types of actors instantiated in the environment, typically the name of the environment itself; if empty, nothing is added, meaning the actor type is used as is, e.g., WebhookActor. This is used so that Dapr instantiates an actor per environment.

**Example:**

```yaml
additionalVars:
  - name: DAPR_ACTOR_TYPE
    value: "Qa"
```
