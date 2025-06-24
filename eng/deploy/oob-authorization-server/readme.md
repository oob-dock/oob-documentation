# Installation of the Opus Open Finance Platform Authorization Server

## Prerequisites

### Creation of the secret(s) to store private keys

The Authorization Server (AS) private keys must be securely persisted, and it is highly recommended to use a password vault for this persistence. If this is not possible, traditional secrets can be created in Kubernetes to persist this information. The procedure below describes one way to create this secret.

The command below can be used to create a secret with the content of a directory:

```shell
kubectl -n <NAMESPACE_NAME> create secret generic <SECRET_NAME> --from-file=<DIRECTORY_PATH>
```

Consider, for example, that the keys are previously created and stored in a local directory:

```shell
ls /tmp/as
enc.key  sig.key
```

By executing the command below, the secret is created:

```shell
kubectl -n oob create secret generic oob-as-keys --from-file=/tmp/as
secret/oob-as-keys created
```

To describe the content of the secret, the following command can be used:

```shell
kubectl -n oob get secret oob-as-keys -o yaml
apiVersion: v1
data:
  enc.key: LS0t.................LS0t
  sig.key: LS0t.................LQ==
kind: Secret
metadata:
  creationTimestamp: "2021-07-29T20:40:31Z"
  name: oob-as-keys
  namespace: oob
  resourceVersion: "105304459"
  selfLink: /api/v1/namespaces/oob/secrets/oob-as-keys
  uid: dc2acbec-d585-4bc2-88e7-b65d2f41e708
type: Opaque
```

## Installation

The module installation is done via Helm Chart.

## Configuration

### db

Database access configuration:

* name: Database name
* username: Database access username
* password: Database access password
* host: Database host
* type: Database type. Default: "postgres"

Example:

```yaml
  db:
    name: "authorization_server"
    username: "authorization_server"
    password: "authorization_server"
    host: "postgres.local"
    type: "postgres"
```

### Support for read replica

The OOB Authorization Server supports the use of a read replica of the database. 

The replica needs the same configurations as the base, except for *type*. These properties use the *read-only* base identifier, as shown in the example below:

```yaml
  db:
    read-only:
      name: "authorization_server"
      username: "readonly-user"
      password: "readonly-password"
      host: "readonly.postgres.local"
```

To activate the use of the read replica, the feature/readReplica/enabled property must be changed to "1", as shown in the example:

```yaml
  feature:
    readReplica:
      enabled: "1"
```

### DDL Script Execution

See the [definition](../shared-definitions.md#ddl-scripts)

This service also provides the option to disable DDL scripts.
This configuration is necessary when the service is installed in
an environment with multiple instances of different brands
accessing the same database.
In this case, DDL scripts should remain enabled only for the
main brand (default behavior), while for the other brands,
the following value should be configured:

```yaml
  db:
    ddl:
      enabled: "0"
```

### api/baseUrlOobConsents

- Base address of the consent service

Internal pointing in K8s

Ex: `http://oob-consent`

### customer/federationJwksUrl

*For installations with client authentication through the institution's own application.*

Address where the service should fetch the JWKS with the public key to validate the JWT tokens issued by the application responsible for authenticating the bank's clients.

Ex: `https://idp.bank.com.br/jwks.jwks`

### privateKeys

List of private keys used to encrypt or sign messages. The list must contain at least one key with use = sig (signature) and one with use = enc (encryption). See the [definition](../shared-definitions.md#formatos-de-chave-privada-suportados) for details on the supported key formats.

* certSecretName: Name of the secret containing the private key
* certSecretKey: Name of the secret property containing the private key
* kid: Key identifier (Obtained from the participant directory)
* alg: Algorithm to be used with the key
* use: Purpose of use of the key by the authorization server. The possible values are `sig` (signature) or `enc` (encryption)
* passphraseSecretName: Name of the secret containing the password for the private key (optional) - ***deprecated***
* passphraseSecretKey: Name of the secret property containing the password for the private key (optional) - ***deprecated***

The `passphraseSecretName` and `passphraseSecretKey` properties should only be defined for encrypted keys. If they are not provided, it is assumed that the keys are open. **Attention:** Pair of properties **obsolete** (***deprecated***). Opus Open Banking may stop supporting encrypted keys in future versions.

Example:

```yaml
  privateKeys:
    - certSecretName: "oob-as-keys"
      certSecretKey: "sig.key"
      kid: "MPguImG0DEQwu9ZUvwDzw_0xybh1yAETY9VBLdYXibo"
      alg: "PS256"
      use: "sig"
      passphraseSecretName: "oob-as-keys"
      passphraseSecretKey: "sig.key.passphrase"
    - certSecretName: "oob-as-keys"
      certSecretKey: "enc.key"
      kid: "95NrL0TaTttM2-Awq0uCPqqE1gRYN9PRfYleHPlMv1w"
      alg: "RSA-OAEP"
      use: "enc"
```

The keys must be generated in the participant directory:

* BRSEAL=signature key
* BRCAC=encryption key

#### Internal Signing Key

By default, the OOB Authorization Server uses an internal
signing key for communicating token information
between services.

An ECDSA key (ES256, ES384, and ES512) must be generated by the
institution and configured along with the other keys, as shown
in the following example:

```yaml
  privateKeys:
      [...]
    - certSecretName: "oob-as-keys"
      certSecretKey: "internal-sig.key"
      kid: "7f38a01e-6bd5-4423-bd22-0e8284dbb9a8"
      alg: "ES256"
      use: "sig"
      internal: "true"
```

As shown in the example above, the key must have `use` 
set to `sign` and the `internal` field must be set to `true`.

*Note*: The properties `passphraseSecretName` and `passphraseSecretKey`
are also available for configuring this key.

***Important***: Configuring this key is mandatory if the feature
[```FEATURE_SUPPORT_JWT_INTROSPECTION```](#feature_support_jwt_introspection)
is enabled.

### clients

Configures the static clients (not dynamically registered) in the authorization server. It should be used to register internal bank systems that will generate tokens to access the OOB platform.

* clientSecretName: Name of the secret containing the client's access secret
* clientSecretKey: Name of the secret property containing the client's access secret
* clientId: Client's access ClientId
* redirectUris: Client URLs authorized for redirect in web authentication flows
* postLogoutRedirectUris: Client URLs authorized for redirect in logout scenarios of web authentication flows
* responseTypes: Client response type
* grantTypes: Allowed grant types for the client
* tokenEndpointAuthMethod: Authorization type for the client
* allowedScopes: Allowed scopes for the client

Example:

```yaml
  clients:
    - clientSecretName: "oob-as-clients"
      clientSecretKey: "oob-internal-client"
      clientId: "oob-internal-client"
      redirectUris: ""
      responseTypes: ""
      grantTypes: "client_credentials"
      tokenEndpointAuthMethod: "client_secret_post"
      allowedScopes: "openid"
```

At least one client must be configured in the authorization server to be used in the modules that perform token introspection.

### as

Various general configurations of the Authorization Server (AS):

#### issuer

Public FQDN of the Authorization Server for the purpose of publishing the configuration at the `openid-configuration` address. Use the FQDN without MTLS.

Ex: `https://auth.bank.com.br`

#### authBasePath

Base path of the Authorization Server for installations that use the same FQDN to expose the Authorization Server and the Open Banking APIs, thus reducing the number of required certificates.

This configuration must always end with `/`, for cases where the Authorization Server is exposed on an exclusive FQDN, configure with the value `/`.

Ex: `/auth/`

#### authNonFapiBasePath

Base path of the non-regulatory Authorization Server. This configuration must always end with `/`.

Ex: `/auth-nonfapi/`

#### central_directory_jwks

Address of the JWKS of the participant directory. Non-production environments should use the sandbox directory address.

| Environment | Address                                                                       |
| ----------- | ----------------------------------------------------------------------------- |
| Sandbox     | <https://keystore.sandbox.directory.openbankingbrasil.org.br/openbanking.jwks> |
| Production  | <https://keystore.directory.openbankingbrasil.org.br/openbanking.jwks>         |

Reference: [Open Finance Brasil SSA Key Store and Issuer Details](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/246120449/EN+Open+Finance+Brasil+Financial-grade+API+Dynamic+Client+Registration+2.0+RC1+Implementers+Draft+3#9.2.-Open-Finance-Brasil-SSA-Key-Store-and-Issuer-Details)

#### regulatory_ttl

TTL in seconds of the tokens issued by the Authorization Server to TPPs. The [Open Banking Brasil Financial-Grade API Security Profile](https://openfinancebrasil.atlassian.net/wiki/spaces/DraftOF/pages/191857429/DTO+EN+Open+Finance+Brasil+Financial-grade+API+Security+Profile+2.0-RC1#5.2.-Open-Finance-Brasil-security-provisions) defines that the TTL must be between 300 and 900 seconds. Any value outside this range will generate a certification error.

Suggested configuration: `300`

#### mtls_fqdn_regex

Configuration composed of `find` and `replace` to replace the non-MTLS address of the Authorization Server with the MTLS address. The fields are used by a regular expression (RegEx) replace function with the URL of each Authorization Server endpoint.

To add `mtls-` to the Authorization Server endpoint URLs, use the values `find`: "^(https://)(.*)$" and `replace`: "https://mtls-$2". Note that the URLs must be HTTPS.

#### directory_webhook_guid

Randomly generated GUID to be used for webhook registration in the Open Finance directory.

Ex: `13032100-c4ae-4aca-9b73-79366f0519a5`

The registration must be done in the directory after updating the service with the following address:

>https://[\<public_fqdn\>](../terraform/readme.md#public_fqdn)/[\<authBasePath\>](readme.md#authbasepath)/webhook/<directory_webhook_guid>

#### application/encryption/key

Encryption key value to be used to encrypt sensitive data before persisting them in the Authorization Server database tables. It is recommended that the key be 256 bits and that the value format be hexadecimal.

Ex: `703273357538782F413F4428472B4B6250655368566D59713374367739792442`

#### application/encryption/salt

Salt value to be used for generating the encryption key in conjunction with the key provided in the previous variable. It is recommended to be 64 bits and the value format be hexadecimal.

Ex: `635166546A576E5A`

>**Attention**
>
> `Both the key and the salt will be stored inside the secret oob-authorization-server similarly to how database access is configured`

#### consent.channels

Type of channel supported for authentication in the Authorization Server. Supported values: `web`, `mobile`, and `web,mobile`.

#### consent.unsupportedRedirectUrl

URL to which the client will be redirected if there is no `web` support in the configuration

Ex: `https://play.google.com/store/apps/details?id=com.google.android.apps.maps`

#### brand.id

See the [definition](../shared-definitions.md#brand-id)

#### brand.name

Brand name. This variable will be used to display the brand name on the client redirect screen during the use of the web flow, and it is also returned in the APP2AS integration.

Ex: `C Banco`

#### brand.logo

URL containing the brand logo, to be used on the consent redirect screens.

Ex: `https://www.opus-software.com.br/wp-content/uploads/2019/01/opus_logo.png`

### features

Indicates the [features](../shared-definitions.md) supported by the installation, restricting the supported Open Banking services to the features.

**Ex:**

```yaml
features: "core,payments"
```

### dapr

Settings related to [Dapr](../shared-definitions.md#Dapr).

* enabled: Enables Dapr in the application to produce events. Possible values: `true` or `false`. **Default:** `true`.
* pubSubId: Identifier of the Dapr pub/sub component to be used.
* appId: The application's unique ID. Used for service discovery, state encapsulation, and pub/sub consumer ID.

**Example:**

```yaml
  dapr:
    enabled: "true"
    appId: oob-authorization-server
    pubSubId: "oof-pub-sub"
```

### scheduler

This module also applies (via Helm) a component of type [cron binding](https://docs.dapr.io/reference/components-reference/supported-bindings/cron/) used to periodically synchronize public signing keys.

Given this scenario, the installation of Dapr as well as the application of the *binding* component are necessary requirements for the proper functioning of this module.

Configurations:

* jwks_minutes_interval: Interval for updating public signing keys in the database.

**Example:**

```yaml
 scheduler:
    jwks_minutes_interval: "30"
```

## state store

This module supports the use of cache for introspection using one of the state stores [supported by Dapr](https://docs.dapr.io/reference/components-reference/supported-state-stores/).

**Important**: The chosen state store must obligatorily support TTL.

Configurations:

* name: Name given to the state store component
* type: Type to be filled as per the [dapr](https://docs.dapr.io/operations/components/setup-state-store/) documentation.
* version: Version to be used. By default, *v1* will be used.
* connectionMetadata: Metadata required to connect to the desired state store to be included in the name/value format, as an example.

**Example:**

```yaml
env:
  dapr:
    stateStore:
      introspection:
        name: token-state-store
        type: state.redis
        version: v1
        connectionMetadata:
          - name: redisHost
            value: localhost:6379
          - name: redisPassword
            value: password
```

**Important:** To enable the use of cache, the following feature flag must be activated.

### feature/introspection/cache/enabled

Enables or disables cache for introspection in the Authorization Server.

It should be enabled **ONLY** if the state store configuration is performed in this service and in the [OOB-Consents](../oob-consent/readme.md#daprstatestoreintrospectionname) service;

**Default value**: `0` (disabled)

**Format:** : `0` or `1`.

**Example:**

```yaml
env:
  feature:
    introspection:
      cache:
        enabled: "1"
```

## server/org/id

Organization ID used in the PCM report of the Hybrid Flow type, according to the [OF specification](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/37912663/Documenta+o+da+API).

```yaml
env:
  server:
    org:
      id: "6fd64cd7-a56d-4287-b12c-15bacf242f72"
```

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
50% of the requests will be sampled.

Example:

```yaml
env:
  opentelemetry:
    tracer:
      exporter:
        url:
          grpc: "http://127.0.0.1:4317"
    sample:
      rate: 1
```

## additionalVars

Used to define optional configurations in the application. This configuration allows you to define a list of properties to be passed to the application in the following format:

```yaml
additionalVars:
  - name: FIRST_PROPERTY
    value: "FIRST_VALUE"
  - name: SECOND_PROPERTY
    value: "SECOND_VALUE"
```

The configurations that can be defined in this format are listed below:

### DIRECTORY_KEYSTORE_BASE

Base address of the central directory public key API. The registration must always be done with the sandbox API base address for the homologation environment and the official one for the production environment.

Sandbox: `https://keystore.sandbox.directory.openbankingbrasil.org.br`
Production: `https://keystore.directory.openbankingbrasil.org.br`

The default value is configured for the production environment.

```yaml
additionalVars:
  - name: DIRECTORY_KEYSTORE_BASE
    value: "https://keystore.sandbox.directory.openbankingbrasil.org.br"
```

### AS_LOG_REQUESTS

Defines whether the application should log received requests. It is recommended to activate it only in development environments. In production, it is inadvisable.

**Format:** `0` or `1`

**Ex:**

```yaml
additionalVars:
  - name: AS_LOG_REQUESTS
    value: "1"
```

### CONSENT_LOGIN_SCREEN_MOCK_ENABLED

Enables or disables the display of the mocked login screen. Use only in non-production environments.

**Format:** `0` or `1`
Default value: `0`

**Ex:**

```yaml
additionalVars:
  - name: CONSENT_LOGIN_SCREEN_MOCK_ENABLED
    value: "0"
```

### AUTH_JWT_JTI_VALIDATION

Defines whether the authentication process defined in the [APP2AS](../../consent/app2as/readme.md) integration should validate the `jti` provided in the payload during the request.

**Format:** `0` or `1`

**Ex:**

```yaml
additionalVars:
  - name: AUTH_JWT_JTI_VALIDATION
    value: "1"
```

### APPLE_APP_ID

AppId of the iOS application, used in the universal link. [More details on Apple's website](https://developer.apple.com/library/archive/documentation/General/Conceptual/AppSearch/UniversalLinks.html)

**Ex:**

```yaml
additionalVars:
  - name: APPLE_APP_ID
    value: "9999999999.com.apple.wwdc"
```

### AS_LOG_LEVEL

Defines the log level to be displayed in the application console. In production, it is advisable to be level `info`.

**Possible values:** `emerg`, `error`, `warn`, `info`, `debug`

Default value: `info`

**Ex:**

```yaml
additionalVars:
  - name: AS_LOG_LEVEL
    value: "debug"
```

### ANDROID_PACKAGE_NAME

Application ID declared in the build.gradle file. [More details on the Android website](https://developer.android.com/build)

### ANDROID_CERT_FINGERPRINTS

SHA256 fingerprints of your application's signing certificate. Use a comma to separate each of the fingerprints, as shown in the following example:

**Ex:**

```yaml
additionalVars:
  - name: ANDROID_CERT_FINGERPRINTS
    value: "14:6D:E9:83:C5:73:06:50:D8:EE:B9:95:2F:34:FC:64:16:A0:83:42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:70,14:6D:E9:83:C5:73:06:50:D8:EE:B9:95:2F:34:FC:64:16:A0:83:42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:45"
```

The following command generates the fingerprint via Java keytool:

`
keytool -list -v -keystore my-release-key.keystore
`

### SSL Certificate Headers Configuration

Configuration of the headers where the certificate used by the client in mTLS is sent to the application. This configuration can be omitted if the default headers (X-SSL-*) are used.

* SSL_CLIENT_HEADER_NAME
* SSL_CLIENT_VERIFY_HEADER_NAME
* SSL_CLIENT_CERT_HEADER_NAME

**Ex:**

```yaml
additionalVars:
  - name: SSL_CLIENT_HEADER_NAME
    value: "SSL-Client"
  - name: SSL_CLIENT_VERIFY_HEADER_NAME
    value: "SSL-Client-Verify"
  - name: SSL_CLIENT_CERT_HEADER_NAME
    value: "SSL-Client-Cert"
```

### CUSTOM_WEB_APP_AUTH_URL

Template of the custom authentication URL defined by the institution.

When this variable is defined, user authentication will occur via web using the institution's login screen. The initial identifier of the authentication flow will be merged into the URL defined in this variable in place of `<IDENTIFICADOR>`.

**Format:**

The merge allows the institution to receive the identifier through the `query string`, `fragment`, or `url`, as shown in the table below:

| Format      | Example URL                                            |
| ----------- | ------------------------------------------------------ |
| Query string | `https://ev.instituicao.com.br?codigo=<IDENTIFICADOR>` |
| Fragment     | `https://ev.instituicao.com.br#<IDENTIFICADOR>`        |
| URL          | `https://ev.instituicao.com.br/<IDENTIFICADOR>`        |

It is recommended to use the fragment whenever possible, as it also removes the identifier from the navigation history.

**Ex:**

```yaml
additionalVars:
  - name: CUSTOM_WEB_APP_AUTH_URL
    value: "https://ev.instituicao.com.br#<IDENTIFICADOR>"
```

### CUSTOM_WEB_APP_CONSENT_ENABLED

This variable works in conjunction with the `CUSTOM_WEB_APP_AUTH_URL` variable. Once the custom authentication URL is defined, this configuration determines whether the web authentication flow will use custom screens for the consent generation flow or if the standard screens provided by Opus Open Banking will be used. When its value is set to `0` the standard screens will be used, when set to `1` the custom screens should render the consent generation flow.

**Format:** `0` or `1`

**Default value:** `0`

**Ex:**

```yaml
additionalVars:
  - name: CUSTOM_WEB_APP_CONSENT_ENABLED
    value: "1"
```

### HANDOFF_RESOURCE_URL

Template of the handoff page URL implemented by the institution, using the JavaScript library hosted on the authorization server.

When this variable is defined, the handoff flow will be active, and if the institution does not have a web login screen configured, the handoff will be used. The initial identifier of the handoff flow will be merged into the URL defined in this variable in place of `<IDENTIFICADOR>`.

**IMPORTANT**: If you do not want to enable the handoff flow, do not fill in the variable. If it is filled with an incorrect value, the flow will be interrupted by an error.

**Format:**

The merge allows the institution to receive the identifier through the `query string`, `fragment`, or `url`, as shown in the table below:

| Format      | Example URL                                                                |
| ----------- | -------------------------------------------------------------------------- |
| Query string | `https://ev.instituicao.com.br/pagina_handoff.html?codigo=<IDENTIFICADOR>` |
| Fragment     | `https://ev.instituicao.com.br/pagina_handoff.html#<IDENTIFICADOR>`        |
| URL          | `https://ev.instituicao.com.br/pagina_handoff.html/<IDENTIFICADOR>`        |

It is recommended to use the fragment whenever possible, as it also removes the identifier from the navigation history.

**Ex:**

```yaml
additionalVars:
  - name: HANDOFF_RESOURCE_URL"
    value: "https://ev.instituicao.com.br/pagina_handoff.html#<IDENTIFICADOR>"
```

### HANDOFF_TYPECODE_CHARSET

Character set to be used for generating the typeCode for the handoff. If this configuration is not present, the typeCode generation will not be performed.

**Ex:**

```yaml
additionalVars:
  - name: HANDOFF_TYPECODE_CHARSET"
    value: "BCDFGHJKLMNPQRSTVWXZ"
```

### HANDOFF_TYPECODE_FORMAT

Format used for generating the typeCode for the handoff, '*' represents where the character defined in the charset will be placed. It is recommended to use 6 or more characters to avoid repetition.

**Ex:**

```yaml
additionalVars:
  - name: HANDOFF_TYPECODE_FORMAT"
    value: "********"
```

### INTERNAL_USERS_FEDERATION_DISCOVERY_ENDPOINT

Address of the discovery endpoint of the external Authorization Server where the final users of the Back Office Portal are registered.

**Ex:**

```yaml
additionalVars:
  - name: INTERNAL_USERS_FEDERATION_DISCOVERY_ENDPOINT"
    value: "https://external-idp.com.br/auth/.well-known/openid-configuration"
```

### INTERNAL_USERS_FEDERATION_ALLOWED_CLIENT_IDS

Defines the list of client identifiers that will be allowed to initiate the authentication process of the Back Office Portal application with the OOB Authorization Server. If the Back Office user authentication process is initiated by a client whose identifier is not in this list, an error will be returned by the Authorization Server.

**Ex:**

```yaml
additionalVars:
  - name: INTERNAL_USERS_FEDERATION_ALLOWED_CLIENT_IDS"
    value: "portal-backoffice"
```

### INTERNAL_USERS_FEDERATION_CLIENT_ID

Defines the client identifier that will be used by the OOB Authorization Server to initiate the authentication process with the external Authorization Server where the final users of the Back Office Portal are registered.

**Ex:**

```yaml
additionalVars:
  - name: INTERNAL_USERS_FEDERATION_CLIENT_ID"
    value: "internal-users-federation"
```

### INTERNAL_USERS_FEDERATION_SECRET

Contains the client secret defined in the previous variable. We suggest that it be defined as a reference to a [Kubernetes secret](https://kubernetes.io/docs/concepts/configuration/secret/).

**Ex:**

```yaml
additionalVars:
  - name: INTERNAL_USERS_FEDERATION_SECRET"
    valueFrom:
      secretKeyRef:
        name: oob-users
        key: internal-users-federation-secret
```

### PORTAL_BACKOFFICE_URL

Address of the Back Office Portal. It is necessary to define this variable to avoid CORS issues in the communication between the Back Office Portal and the OOB Authorization Server.

**Ex:**

```yaml
additionalVars:
  - name: PORTAL_BACKOFFICE_URL"
    value: "https://instituicao-portal-backoffice.com.br"
```

### BOT_VERIFICATION_ENABLED

This variable determines whether the bot/crawler usage verification is enabled or not. When its value is set to `0`, verification is disabled; when set to `1`, it is enabled.

**Format:** `0` or `1`

**Default value:** `1`

**Ex:**

```yaml
additionalVars:
  - name: BOT_VERIFICATION_ENABLED
    value: "1"
```

### OOB_ALLOWAUTHCODETOKEN_LIMITDATE

Enables the blocking of refresh tokens from authorization code flow tokens after the payment consent has been consumed. This variable must receive a date when this blocking should start.

The default value is '2023-07-18' as per specification.

**Format:** `yyyy-MM-dd`

**Default:** `2023-07-18`

```yaml
additionalVars:
  - name: OOB_ALLOWAUTHCODETOKEN_LIMITDATE
    value: "2023-07-18"
```

### FEATURE_MULTIPLE_REQUIRER

Enables multiple authority flow in the authorization process
of consent.

The default value is '0' as per specification.

**Formato:** `0` or `1`

**Default:** `0`

```yaml
additionalVars:
  - name: FEATURE_MULTIPLE_REQUIRER
    value: "1"
```

### OVERRIDE_AUTHORIZATION_ENDPOINT

Replaces the authorization_endpoint exposed in .well-know.

```yaml
additionalVars:
  - name: OVERRIDE_AUTHORIZATION_ENDPOINT
    value: "https://sharedconsent.com.br/auth"
```

### FEATURE_SUPPORT_JWT_INTROSPECTION

Indicates whether the response for internal introspection
should support JWT. If this functionality is enabled,
this service must be configured with an internal-use signing
key of type ES256, ES384, or ES512, as explained [earlier](#internal-signing-key).

This feature is enabled by default. To disable it, follow the example
below:

```yaml
additionalVars:
  - name: FEATURE_SUPPORT_JWT_INTROSPECTION
    value: "0"
```

### UNIQUE_PROFILE_START_DATE

Enables validation for the adaptation period of the unique FAPI profile of Open Finance Brazil.

The default value is '2024-03-27' as per specification. To perform security tests, it should be changed to a date in the past.

**Format:** `yyyy-MM-dd`

**Default:** `2024-03-27`

### UNIQUE_PROFILE_MANDATORY_DATE

Enables the blocking of clients that do not comply with the unique FAPI profile of Open Finance Brazil.

The default value is '2024-05-22' as per specification. To perform security tests, it should be changed to a date in the past.

**Format:** `yyyy-MM-dd`

**Default:** `2024-05-22`

## Exposure

As access to the Authorization Server is not done through Kong, an ingress needs to be created. [More details here](../readme.md)

## Certification Environment

### Password for authentication (mock login screen)

testeOpenBanking
