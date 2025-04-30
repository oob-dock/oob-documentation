# Shared Definitions

## Brand Id

Simplified name of the brand, only containing lowercase letters and hyphens (-). The maximum length is 36 characters. This information is used to identify the brand within the system and integrations; it will not be displayed to the client. It must be unique per brand in institutions that have more than one brand.

***

**:warning: WARNING**: The value of the Brand Id property is used in the creation of the database structure in some modules, meaning that this value cannot be changed after the first execution of the application. In case of incorrect configuration, contact Opus.

***

Example: `cbanco`

## DDL Scripts

The DDL scripts will be applied in a process separate from the service execution.
To configure the execution of these scripts, it is necessary to set the values
of the following properties:

```yaml
  db:
    ddl:
      username: "ddl-username"
      password: "ddl-password"
      logLevel: "info"
```

**Note**: the `logLevel` configuration can take one of the following values:
`emerg`, `error`, `warn`, `info` or `debug`.

**Important**: Using the `debug` log level is **NOT** recommended because it
can produce a large amount of unnecessary information. This may make logs difficult
to read and obscure important messages in the noise.

## Liquibase Contexts

Context to be used to create the database.

Use "demo" to create example data in the database.

Use "default" for staging or production environments.

**Format:** `demo` or `default`

## oidc

Security configuration to validate access tokens received in requests.

* authServerUrl: Address of the oob-authorization-server. The address can be an internal Kubernetes endpoint.
* introspectionPath: Path of the introspection endpoint.
* clientId: Client created in the configuration of the oob-authorization-server.
* clientSecret: Client access secret.
* jwksPath: Path to the NON-FAPI JWKS endpoint. It should be formed by concatenating
the [auth_server_nonfapi_base_path](#auth_server_nonfapi_base_path) with `jwks`.

Example:

```yaml
authServerUrl: "http://oob-authorization-server"
introspectionPath: "/auth/token/introspection"
clientId: "oob-internal-client"
clientSecret: "oob-internal-client"
jwksPath: "/auth-nonFapi/jwks"
```

## auth_server_url

URL to access the authorization server.

**Example:** "<http://oob-authorization-server>"

## auth_server_base_path

Base path to access the authorization server.

**Example:** "/auth/"

## auth_server_nonfapi_base_path

Base path to access the non-FAPI endpoints of the authorization server.

**Example:** "/auth-nonfapi/"

## introspection_client_id

Client identifier for introspection.

**Example:** "oob-internal-client"

## introspection_client_secret

Client secret for introspection.

**Example:** "secret123"

## Support for Opus Open Finance Features

To optimize resource usage, monitor, and expose supported endpoints by the institution, we implemented feature support.

All endpoints exposed in Kong are necessarily tied to a feature.

### Supported Features

Below is the list of features supported by Opus Open Banking:

| Feature        | Description                                                                            |
| -------------- | -------------------------------------------------------------------------------------- |
| core           | Basic and mandatory functions of Opus Open Finance                                     |
| open-data      | Open data sharing (Phase 1 of Open Finance Brazil)                                     |
| financial-data | Data sharing requiring consent (Phase 2 of Open Finance Brazil)                        |
| payments       | Payments (Phase 3 of Open Finance Brazil)                                              |
| enrollments    | No Redirect Journey (Phase 3 of Open Finance Brazil)                                   |

### Features x Scopes

Each feature defined in the table above supports the following scopes:

| Feature        | Scopes                                                                                                                                       |
| -------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| core           | openid, oob_customer, oob_consents:read, oob_opendata:read, oob_opendata:write, oob_outages:read, oob_outages:write, profile, offline_access |
| open-data      | openid                                                                                                                                       |
| financial-data | openid, resources                                                                                                                            |
| payments       | openid, payments, recurring-payments                                                                                                         |
| enrollments    | openid, payments, nrp-consents                                                                                                               |

**IMPORTANT**: For the financial-data feature, it is not necessary to use the following access scopes: accounts, credit-cards-accounts, customers, invoice-financings, financings, loans, unarranged-accounts-overdraft.

## Supported Private Key Formats

The product supports PKCS1 and PKCS8 key formats. PKCS1 support is primarily for the use of the RSA algorithm for encryption. PKCS8 support is due to it being a standard that allows manipulation of private keys for all algorithms, not just RSA.

Both formats support the use of a password to increase the security of key usage, making it difficult for unauthorized parties to use the key.

## Dapr

[Dapr](https://dapr.io/) is a Distributed Application Runtime that aims to simplify connectivity between microservices through various [building blocks](https://docs.dapr.io/concepts/building-blocks-concept/).

Opus Open Finance uses the following Dapr building blocks:

* Publish and Subscribe: Used to publish and consume events from API calls that should be reported to the PCM (Metrics Collection Platform), for sending payment webhooks, and to publish events that allow tracking the overall behavior of the solution.

* Virtual Actors: Used to reprocess payment webhooks that failed on the first attempt.
