# Credit Portabilty API

This document presents the **Camel Routes** and **Supported Configurations** for the
Credit Portability service, which corresponds to
the [Credit Portability APIs](https://openfinancebrasil.atlassian.net/wiki/spaces/DraftOF/pages/764510211/Portabilidade+de+Cr+dito+-+PC)
of Open Banking Brazil.

&nbsp;

In order for this service to work properly for each of
the endpoints of the APIs mentioned above, you must create
one or more plugins that contain routes for each of
the [Camel Routes](#rotas-do-camel) presented here.

&nbsp;

## Supported Configuration Variables

&nbsp;

By default, the application allows the modification of some settings via environment variables,
which can be injected via `Dockerfile`, `docker build`, or when running the image (via `docker run`).

The table below contains a list of the currently supported variables.

| Variable                                 | Purpose                                                                                                                        | Default Value |
|------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|---------------|
| camel.main.routes-include-pattern        | Indicates the locations where Camel should look for routes                                                                     |               |
| apis.validation.json-schema.enabled      | Enables validation of the request/response objects sent/received by the plugin against defined specs (affects performance)     | false         |
| apis.validation.openapi.enabled-request  | Enables validation of request objects received by the API against the Open Finance Brazil specification                        | true          |
| apis.validation.openapi.enabled-response | Enables validation of response objects returned by the API against the Open Finance Brazil specification (affects performance) | false         |

&nbsp;

**In addition to the variables presented above, depending on the Quarkus
Camel component(s) that the plugin uses, there may be others according to
what is specified in the component's own documentation. Furthermore,
the plugin can create its own environment variables to be injected.

&nbsp;

## Camel Routes

The following subsections contain all the `endpoints` that need
to have routes defined in Camel and for which the creation of one or
more plugins is necessary.

For the `/account-data` endpoint, for example, the route must be

defined in the plugin as:

```xml
<from uri="direct:creditPortabilityGetAccountData"/>
```

&nbsp;

### Account Data

&nbsp;

| Method | Version | Endpoint                                                  | Camel Route                                  |
| ------ | ------- | --------------------------------------------------------- | -------------------------------------------- |
| GET    | v1      | /account-data                                             | ```direct:creditPortabilityGetAccountData``` |

&nbsp;

### Concurrency Management

&nbsp;

| Method | Version | Endpoint                                                  | Camel Route                                                                      |
| ------ | ------- | --------------------------------------------------------- | -------------------------------------------------------------------------------- |
| GET    | v1      | /credit-operations/\{contractId\}/portability-elegibility | ```direct:creditPortabilityGetCreditOperationsContratIdPortabilityEligibility``` |

&nbsp;

### Credit Portability

&nbsp;

| Method   | Version | Endpoint                                | Camel Route                                                         |
| -------- | ------- | --------------------------------------- | ------------------------------------------------------------------- |
| POST     | v1      | /portabilities                          | ```direct:creditPortabilityPostPortabilities```                     |
| PATCH    | v1      | /portabilities/\{portabilityId\}/cancel | ```direct:creditPortabilityPatchPortabilitiesPortabilityIdCancel``` |

&nbsp;

### Payments

&nbsp;

| Method   | Version | Endpoint                                 | Camel Route                                                         |
| -------- | ------- | ---------------------------------------- | ------------------------------------------------------------------- |
| POST     | v1      | /portabilities/\{portabilityId\}/payment | ```direct:creditPortabilityPostPortabilitiesPortabilityIdPayment``` |
