# Configurations using Terraform

- [Configurations using Terraform](#configurations-using-terraform)
  - [Kong Routes Configuration](#kong-routes-configuration)
    - [Configuration](#configuration)
      - [kong\_admin\_uri](#kong_admin_uri)
      - [kong\_admin\_tls\_skip\_verify](#kong_admin_tls_skip_verify)
      - [kong\_admin\_token](#kong_admin_token)
      - [kong\_admin\_username](#kong_admin_username)
      - [kong\_admin\_password](#kong_admin_password)
      - [kong\_api\_key](#kong_api_key)
      - [oob\_status\_api\_host](#oob_status_api_host)
      - [oob\_status\_api\_port](#oob_status_api_port)
      - [oob\_consent\_api\_host](#oob_consent_api_host)
      - [oob\_consent\_api\_port](#oob_consent_api_port)
      - [oob\_authorization\_server\_host](#oob_authorization_server_host)
      - [oob\_authorization\_server\_port](#oob_authorization_server_port)
      - [cors\_origins](#cors_origins)
      - [transaction\_limit\_global\_per\_second](#transaction_limit_global_per_second)
      - [transaction\_limit\_per\_ip\_per\_minute](#transaction_limit_per_ip_per_minute)
      - [api\_docs\_enabled](#api_docs_enabled)
      - [oob\_financial\_data\_api\_host](#oob_financial_data_api_host)
      - [oob\_financial\_data\_api\_port](#oob_financial_data_api_port)
      - [oob\_payment\_api\_host](#oob_payment_api_host)
      - [oob\_payment\_api\_port](#oob_payment_api_port)
      - [introspection\_client\_id](#introspection_client_id)
      - [introspection\_client\_secret](#introspection_client_secret)
      - [auth\_server\_url](#auth_server_url)
      - [auth\_server\_base\_path](#auth_server_base_path)
      - [auth\_server\_nonfapi\_base\_path](#auth_server_nonfapi_base_path)
      - [public\_fqdn](#public_fqdn)
      - [public\_fqdn\_mtls](#public_fqdn_mtls)
      - [internal\_fqdn](#internal_fqdn)
      - [supported\_features](#supported_features)
      - [brand\_id](#brand_id)
      - [x\_forwarded\_for\_header\_name](#x_forwarded_for_header_name)
      - [ssl\_certificate\_header\_name](#ssl_certificate_header_name)
      - [server\_org\_id](#server_org_id)
      - [pubsub\_id](#pubsub_id)
      - [dapr\_large\_event\_store](#dapr_large_event_store)
      - [route\_block\_enabled](#route_block_enabled)
      - [mqd\_event\_enabled](#mqd_event_enabled)
      - [opentelemetry\_tracer\_exporter\_url\_http](#opentelemetry_tracer_exporter_url_http)
      - [log\_request\_response\_enabled](#log_request_response_enabled)
      - [log\_request\_response\_collector\_url\_http](#log_request_response_collector_url_http)
      - [ocsp\_validation\_enabled](#ocsp_validation_enabled)
      - [ocsp\_cache\_ms\_duration](#ocsp_cache_ms_duration)
      - [ocsp\_server\_request\_ms\_timeout](#ocsp_server_request_ms_timeout)
      - [ocsp\_per\_cert\_server\_request\_ms\_timeout](#ocsp_per_cert_server_request_ms_timeout)
      - [operational\_limits\_enabled](#operational_limits_enabled)
      - [operational\_limits\_allow\_when\_over\_limit](#operational_limits_allow_when_over_limit)
      - [operational\_limits\_check\_limit\_timeout\_ms](#operational_limits_check_limit_timeout_ms)
  - [Grafana Configuration](#grafana-configuration)
    - [Configuration](#configuration-1)
      - [configure\_kong\_grafana\_dashboard](#configure_kong_grafana_dashboard)
      - [grafana\_uri](#grafana_uri)
      - [grafana\_username](#grafana_username)
      - [grafana\_password](#grafana_password)
      - [prometheus\_uri](#prometheus_uri)
  - [Running Terraform Scripts](#running-terraform-scripts)
    - [main.tf](#maintf)
    - [variables.tf](#variablestf)
    - [environment.tfvars](#environmenttfvars)

The configuration of external systems to OOB is done via Terraform, with two base modules available for use:

- kubernetes: should be used by clients with a single brand

- kubernetes_multibrand: should be used by clients with more than one brand listed in the participant directory (e.g., distinct institutions). In this case, many configurations are in the brands structure and must be declared for each brand.

## Kong Routes Configuration

Configuring routes in Kong is mandatory for the system to function properly.

### Configuration

#### kong_admin_uri

URL of the Kong administration portal

**Example:** "<https://kong-admin-oob.endpoint.com>"

#### kong_admin_tls_skip_verify

Indicates whether to skip TLS certificate validation for the Kong API when using https

**Format:** `true` or `false`

#### kong_admin_token

Optional parameter with the token used to access the Kong admin API

**Example:** "eyJhbGciOiJIUzI1NiJ9.MQ._Eo4szTYEfg90An06hX4C2tUAQcDucX_9xxFb19IJJv"

#### kong_admin_username

Optional parameter with the username used to access the Kong admin API

**Example:** "admin"

#### kong_admin_password

Optional parameter with the password used to access the Kong admin API

**Example:** "P@sswOrd"

#### kong_api_key

Optional parameter with the API Key used to access the Kong admin API

**Example:** "26b00dcb-fdb8-4682-87cd-660ee9b9210f"

#### oob_status_api_host

Host of the status API

**Example:** "oob-status"

#### oob_status_api_port

Port of the status API

**Example:** "80"

#### oob_consent_api_host

Host of the consent API

**Example:** "oob-consent"

#### oob_consent_api_port

Port of the consent API

**Example:** "80"

#### oob_authorization_server_host

Host of the Authorization Server API

**Ex:** "oob-authorization-server"

#### oob_authorization_server_port

Port of the Authorization Server API

**Ex:** "80"

#### cors_origins

Indicates allowed origins in CORS headers

**Example:** "*"

#### transaction_limit_global_per_second

Global transaction limit per second shared by all clients

**Example:** "300"

#### transaction_limit_per_ip_per_minute

Transaction limit per second per client IP

**Example:** "500"

#### api_docs_enabled

Indicates whether the API documentation should be enabled or not, useful only for development. It is not recommended for production.

**Format:** `true` or `false`

#### oob_financial_data_api_host

Host of the financial data API. Should only be filled out if the financial-data feature (Phase 2 of Open Banking Brazil) is enabled.

**Example:** "oob-financial-data"

#### oob_financial_data_api_port

Port of the financial data API

**Example:** "80"

#### oob_payment_api_host

Host of the payment API. Should only be filled out if the payments feature (Phase 3 of Open Banking Brazil) is enabled.

**Example:** "oob-payment"

#### oob_payment_api_port

Port of the payment API

**Example:** "80"

#### introspection_client_id

See the [definition](../shared-definitions.md#introspection_client_id)

#### introspection_client_secret

See the [definition](../shared-definitions.md#introspection_client_secret)

#### auth_server_url

See the [definition](../shared-definitions.md#auth_server_url)

#### auth_server_base_path

See the [definition](../shared-definitions.md#auth_server_base_path)

#### auth_server_nonfapi_base_path

See the [definition](../shared-definitions.md#auth_server_nonfapi_base_path)

#### public_fqdn

Public FQDN where open banking APIs can be accessed

**Example:** "oob.endpoint.com"

#### public_fqdn_mtls

Public FQDN where open banking APIs can be accessed with mTLS

**Example:** "mtls-oob.endpoint.com"

#### internal_fqdn

Optional parameter for including an internal FQDN where open banking Backoffice APIs can be accessed

**Example:** "internal.endpoint.com"

#### supported_features

See the [definition](../shared-definitions.md#supported-features-of-opus-open-finance)

**Example:** ["core", "open-data", "financial-data", "payments"]

#### brand_id

See the [definition](../shared-definitions.md#brand-id)

#### x_forwarded_for_header_name

Defines the name of the header used to identify the originating IP address of the request. In the PCM context, this header is used to populate the `additionalInfo.clientIp` field in the event generated by the `oob-api-event` plugin in Kong.

**Default:** `X-Forwarded-For`

#### ssl_certificate_header_name

Defines the name of the header used to send the client mTLS certificate that made the request. In the PCM and MQD context, this header is used to obtain the clientOrgId of the data recipient or payment initiator to be used by the `oob-api-event` and `oob-mqd-event` plugins in Kong.

**Default:** `X-SSL-Client-Cert`

#### server_org_id

Organization identifier in the participant directory.

#### pubsub_id

Identifier of the publish/subscribe component in [Dapr](../shared-definitions.md#dapr).

**Example:** `event-publisher`

#### dapr_large_event_store

Defines the name of the Dapr state store used to store events that have a very
large payload and therefore cannot be published directly to queues. In this
case, the event is persisted in this state store and the ID of the persisted
entry is sent via event to the target systems. **Used in the MQD scenario, its
configuration is mandatory. The name defined here must be the same as defined
in the `oof-mqd-dispatcher` module in the `env.dapr.largeEventStateStore.name`
variable**.

**Important:**

- This Dapr state store component must be configured with a `keyPrefix` field
with the value `name`, so that all persisted entries have the same prefix that
is shared by `oob-kong` and `oof-mqd-dispatcher`. This prefix will be exactly
the name defined in this configuration variable.
- This component must be created in every namespace that uses it. If Kong is in
the same namespace as `oof-mqd-dispatcher`, it only needs to be defined once.
Otherwise, it must be defined in the Kong namespace and in the
`oof-mqd-dispatcher` module namespace.
- An example template of this component can be found in the `oof-mqd-dispatcher`
helm chart, at `helm/oof-mqd-dispatcher/templates/large-event-state-store.yaml`.

#### route_block_enabled

Defines whether Kong routes should be blocked according to regulatory dates. This variable should be kept as `true` in production environments but set to `false` in homologation environments for certification execution.

**Default:** `true`
**Possible values:** `true` or `false`

#### mqd_event_enabled

Defines whether the installation should send event calls from endpoints linked to the Data Quality Engine (MQD). If the variable is set to `true`, each route's configuration will be considered to decide whether the event will be sent or not. If the variable is set to `false`, each route's configuration will be ignored, and no event will be generated.

**Possible values:** `true` or `false`

#### opentelemetry_tracer_exporter_url_http

Address of the distributed tracing analysis tool. **Important:** This variable
must be filled with the **HTTP** address provided by the tool to receive the
tracing information. Generally, for HTTP, the endpoint for sending tracking
information is the path `<protocol>://<host>:<port>/v1/traces`. However, it is
recommended to confirm whether the chosen tool actually uses this address or
provides another one for this purpose.

**Attention:** The variable above works in conjunction with two other Kong
environment variables: `KONG_TRACING_INSTRUMENTATIONS` and
`KONG_TRACING_SAMPLING_RATE`.

- `KONG_TRACING_INSTRUMENTATIONS`: Defines the level of instrumentation that
will be applied to Kong's requests. **Recommended value:** `all`. The complete
list of possible values can be found at [this link](https://docs.konghq.com/gateway/latest/production/tracing/).
- `KONG_TRACING_SAMPLING_RATE`: Defines the sampling rate for distributed
tracing, i.e., the proportion of requests that will be collected and sent for
analysis. Possible values: `0` to `1`. For example, a value of `0.5` means that
50% of the requests will be sampled. **Important**: If you wish to completely
disable the sending of traces to the receiving tool, simply set this variable
to `0`.

It is necessary to set these environment variables **directly in Kong** with
the appropriate values for the desired instrumentation to function properly.

#### log_request_response_enabled

Defines whether the installation should log regulatory requests and responses
made in the product. If the variable is set to `true`, the configuration of
each route will be taken into account to decide whether the request and
response will be logged or not. If the variable is set to `false`, the
configuration of each route will be ignored, and no regulatory requests or
responses will be logged.

**Possible values:** `true` or `false`

#### log_request_response_collector_url_http

Address of the log collector tool responsible for receiving the logs of
regulatory requests and responses. Due to the size and nature of the requests
and responses, it is not possible to use Kong's standard logging, as it has a
size limitation. Therefore, a log collector is necessary to ensure that no
information from the request/response set is lost.

This variable is mandatory if the variable `log_request_response_enabled` is
set to `true`.

#### ocsp_validation_enabled

Defines whether the installation should perform OCSP validation or not.
When enabled, a plugin in Kong will be created and linked to route services,
and for every request that has a client certificate attached, OCSP verification
will be performed.

**Possible values**: `true` or `false`

**Default**: `false`

#### ocsp_cache_ms_duration

Defines the cache duration in milliseconds for the OCSP validation performed
by the custom Kong plugin `oob-ocsp-validation`.

**Default:** `600000`

#### ocsp_server_request_ms_timeout

Defines the maximum number of milliseconds the product will wait for the
response from the OCSP server when checking the certificate status. When set
to `0`, the product will not perform a synchronous check to the OCSP server,
only an asynchronous one.

**Default:** `0`

#### ocsp_per_cert_server_request_ms_timeout

Similar to the `ocsp_server_request_ms_timeout` variable, but in this case, it
defines the maximum wait time, in milliseconds, the product will wait for a
response from the OCSP server when checking the status of specific certificates.
With this variable, it is possible to define different wait times for different
certificates. This variable should follow the following structure: `<certificateIdentifier>|<waitTime>`.
You can specify multiple certificates by separating them with a semicolon (`;`),
for example: `<certificateIdentifier>|<waitTime>;<certificateIdentifier2>|<waitTime2>`.
This configuration takes precedence over the `ocsp_server_request_ms_timeout`
variable. Therefore, if a certificate has this setting defined, this timeout
will be used instead of the one specified in the
`ocsp_server_request_ms_timeout` variable.

Field Completion Instructions:

- `<certificateIdentifier>`: Composed of the **Common Name (CN)** of the
issuer (concatenated, no spaces) + the **Serial Number** of the certificate in
decimal format. Example:
  - Issuer Common Name (CN): `AC SOLUTI SSL EV G4`
  - Serial Number: `11:DE:25:02:26:7D:F0:B6:44:A1 (84378074129399197090977)`
  - **Correct identifier configuration**: `ACSOLUTISSLEVG484378074129399197090977`
- `<waitTime>`: The amount of time (in milliseconds) the product should wait
for the OCSP server response for **this specific certificate**.

Some **examples** of valid configuration below:

- `ACSOLUTISSLEVG484378074129399197090977|1000`
- `ACSOLUTISSLEVG484378074129399197090977|1000;ACSOLUTISSLEVG484378074129399197090978|2000`

**Note:** Filling in this variable is **optional**.

#### operational_limits_enabled

Defines whether the installation will perform operational limits validation or
not. When enabled, the validation of operational limits will track the calls
made, checking whether these calls are within the limits defined by the
initiative. It will also add some custom headers in the response with
information about the validation, which are:

- `x-operational-limits`: indicates how many calls have been made out of the
total allowed (for example: `2/4`);
- `x-operational-limits-result`: populated when it's necessary to indicate any
validation/processing error during the call tracking process;
- `Retry-After`: in case the operational limit is reached, indicates the date
when the call can be performed again.

**Possible values**: `true` or `false`

**Default**: `false`

#### operational_limits_allow_when_over_limit

Variable used by the product when operational limits validation is active in
the installation. If this variable is set to `true`, even when the operational
limit for a request has been reached, the product will allow the request to
proceed. If it is set to `false` and the operational limit has been reached,
the product will block the request and return HTTP status `423`.

**Possible values**: `true` or `false`

**Default**: `false`

#### operational_limits_check_limit_timeout_ms

Variable used by the product when operational limits validation is active in
the installation. It defines the maximum number of milliseconds the product
will wait for a response from the call made to the operational limits service
to perform the request accounting.

**Default:** `100`

## Grafana Configuration

Grafana configuration is optional. If enabled, a dashboard will be created with information about Kong's status. By default, this configuration is disabled, so the parameters listed below only need to be provided if Grafana configuration is required.

This configuration can be done by enabling the `configure_kong_grafana_dashboard` flag in the kubernetes (or kubernetes_multibrand) module or by running the Grafana module separately with the same parameters.

### Configuration

#### configure_kong_grafana_dashboard

Enables the creation of the Kong dashboard in Grafana

**Example:** true

#### grafana_uri

URI for accessing Grafana

**Example:** "<https://grafana-oob.endpoint.com>"

#### grafana_username

Grafana admin user

#### grafana_password

Grafana admin user's password

#### prometheus_uri

URI for accessing Prometheus

**Example:** "<https://prometheus-oob.endpoint.com>"

## Running Terraform Scripts

The best way to use the provided Terraform scripts is to create a new script that calls the delivered modules and defines the state storage location. This script can also include the variables defined for the environment where the installation is being performed, so the same configurations will be used in future executions.

The suggested structure includes three files:

- `main.tf`: consumes configurations and calls OOB's Terraform modules
- `variables.tf`: Defines the variables that will be set per environment (production, homologation, etc.) when running the script
- `ambiente.tfvars`: Defines variable values for an environment. Several files of this type can be created to define configurations for different environments. This file should be specified in the Terraform script execution command.

It is highly recommended that these files be stored in a version control system, such as a GIT server, always being mindful of the presence of sensitive data.

Examples:

### main.tf

```HCL
## The example below uses AWS S3 for state persistence, but any persistence mechanism can be used.
## It is important that the same mechanism is used in all script executions and that the data generated in the previous
## execution is available in this mechanism for the next.
terraform {
  backend "s3" {
    bucket = "oob-terraform-env2"
    region = "sa-east-1"
    profile = "opus-labs"
    key = "state"
  }
}

module "kubernetes" {
  source = "./kubernetes"
  kong_admin_uri = var.kong_admin_uri
  kong_admin_tls_skip_verify = var.kong_admin_tls_skip_verify

  ...

  public_fqdn = var.public_fqdn
  public_fqdn_mtls = var.public_fqdn_mtls
  supported_features = var.supported_features
  brand_id = var.brand_id
}
```

### variables.tf

```HCL
variable "kong_admin_uri" {
  description = "Kong Admin URL"
}

variable "kong_admin_tls_skip_verify" {
  description = "Whether to skip tls certificate verification for the kong api when using https"
}

...

variable "public_fqdn" {
  description = "Public FQDN where the openbanking APIs can be accessed"
  type        = string
}

variable "public_fqdn_mtls" {
  description = "Public FQDN where the open finance APIs can be accessed with mTLS"
  type        = string
}

variable "supported_features" {
  description = "Features supported by institution"
  type        = list(string)
}

variable "brand_id" {
  description = "Brand id"
  type        = string
}
```

### environment.tfvars

```HCL
kong_admin_uri = "http://kong-admin.bank.com.br"
kong_admin_tls_skip_verify = "true"

...

public_fqdn = "openbanking.bank.com.br"
public_fqdn_mtls = "mtls-openbanking.bank.com.br"
supported_features = ["core", "payments"]
brand_id="cbank"
```
