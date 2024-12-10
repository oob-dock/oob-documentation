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

### Change log level

It should be used to change the amount of information displayed in the logs.
The available levels are: `ERROR`, `WARN`, `INFO`, `DEBUG` ou `TRACE`.

For example, to enable request and response logs, the level should be set to `DEBUG`.

Default value: `INFO`

Example:

```yaml
additionalVars:
    - name: logging_level_software_opus_oof
      value: DEBUG
```