# Opus Open Finance Platform Fido Server Module Installation

## Installation

The module is installed via Helm Chart.

## Configuration

### db

Database access configuration:

* name: Database name
* username: Database access username
* password: Database access password
* host: Database host
* port: Database port

Example:

```yaml
env:
  db:
    name: "oof_fido_server"
    username: "oof_fido_server"
    password: "oof_fido_server"
    host: "postgres.local"
    port: 5432
```

### DDL Script Execution

See the [definition](../shared-definitions.md#ddl-scripts)

### liquibase/contexts

See the [definição](../shared-definitions.md#liquibase-contexts).

## FIDO

The default settings for the RP can be configured with the following attributes.

Example:

```yaml
env:
  fido:
    attestation: "none"
    authenticatorSelection:
      residentKey: "discouraged"
      userVerification: "preferred"
    algorithms: "-65535,-257,-258,-259,-7,-35,-36,-8"
```

***Important***: The default values defined above follow the standard set
in the W3C specification for WebAuthn 2 - https://www.w3.org/TR/webauthn-2 -
and should be maintained. They should only be changed upon request
from the RP (ITP).

### Attestation

Defines how the RP would like to receive information from the
authenticator/credentials used for validation on the server, as defined in
https://www.w3.org/TR/webauthn-2/#attestation-conveyance.

It can be set to the following values: 
"none", "indirect", "direct", or "enterprise".

Default value: "none".

### Authenticator Selection

Defines the requirements that must be met by the authenticator 
selected by the client for the creation and management of the
cryptographic keys used in FIDO2.

#### Resident Key

Defines whether the authenticator must store an identifier for the
user's access credential, as defined in
https://www.w3.org/TR/webauthn-2/#dom-authenticatorselectioncriteria-residentkey.

It can be set to the following values: "discouraged", "preferred", or "required".

Default value: "discouraged".

#### User Verification

Defines whether the authenticator must support some method of user validation,
such as biometrics, PIN, etc.

It can be set to the following values: "required", "preferred", or "discouraged".

Default value: "preferred".

### Algorithms

List of cryptographic algorithms supported by the server,
separated by commas. The supported values are according to the
[`IANA COSE Algorithms registry`](https://www.iana.org/assignments/cose/cose.xhtml#algorithms).

Currently, the supported algorithms are:

* RS1 -> -65535;
* RS256 -> -257;
* RS384 -> -258;
* RS512 -> -259;
* ES256 -> -7;
* ES384 -> -35;
* ES512 -> -36;
* EdDSA -> -8;

Default value: "-65535,-257,-258,-259,-7,-35,-36,-8"

## opentelemetry

This module is instrumented via [Open Telemetry](https://opentelemetry.io/),
logging trace information (when available) and exporting it to a tool like
[Tempo](https://grafana.com/oss/tempo/), which is used for visualizing and
analyzing distributed tracing of the performed requests.

Configurations:

* `env/opentelemetry/tracer/exporter/url/grpc`: Address of the analysis tool.
**Important:** This variable must be filled with the **GRPC** address provided
by the tool to receive the tracing information.

Example:

```yaml
env:
  opentelemetry:
    tracer:
      exporter:
        url:
          grpc: "http://127.0.0.1:4317"
```

## Additional Vars

### RP Customization

If it is necessary to change a FIDO configuration for a single
RP, you must add its identifier (CN from the BRCAC certificate)
to the configuration name and include it as an additional var.

The following example considers an RP (ITP) with a BRCAC CN equals
to "opussoftware.com.br":

```yaml
additionalVars:
    - name: fido_opussoftware_com_br_attestation
      value: direct
```

***Important***: All non-alphanumeric characters must be replaced with ***_***.

This will only change the *attestation* configuration
for this RP. All other configurations will use the default value.

### LOGGING_LEVEL_ROOT

Defines the log detail level of the application. 
It is recommended to activate DEBUG level only in development/testing environments
or to facilitate error analysis in production.
In production, it is advisable to use the INFO level.

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