# API Payment

This document presents the **Camel Routes** and **Supported Configurations** for the payments service, which corresponds to the [**Pix APIs**](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17375877/Servi+os+-+SV) of Open Finance Brazil.

To ensure this service functions properly for each of the endpoints of the APIs mentioned above, one or more plugins should be created containing routes for each of the [Camel Routes](#rotas-do-camel) presented here.

&nbsp;

## Supported Configuration Variables

&nbsp;

By default, the application allows modification of some configurations via environment variables, which can be injected via `Dockerfile`, `docker build`, or during image execution (via `docker run`).

The table below lists the variables currently supported.

| Variable                                            | Purpose                                                                                                                       | Default Value                                          |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------- |
| camel.main.routes-include-pattern                   | Indicates the locations where Camel should look for routes                                                                    |                                                       |
| apis.validation.json-schema.enabled                 | Enables validation of request/response objects sent/received by the plugin against defined specs (affects performance)        | false                                                 |
| apis.validation.openapi.enabled-request             | Enables validation of request objects received by the API against the Open Finance Brazil specification                       | true                                                  |
| apis.validation.openapi.enabled-response            | Enables validation of response objects returned by the API against the Open Finance Brazil specification (affects performance) | false                                                 |
| cnpjInitiatorValidation.directoryRolesUrl           | Configuration of the URL for consulting the Open Finance Brazil participant directory                                         | https://data.directory.openbankingbrasil.org.br/roles |
| quarkus.cache.caffeine.directory.expire-after-write | Configuration of the cache expiration time for the result of the Open Finance Brazil participant directory query              | 5M                                                    |

&nbsp;

**In addition to the variables listed above, depending on the Quarkus Camel component(s) that the plugin uses, there may be others as specified in the documentation of the component being used. Furthermore, the plugin can create its own environment variables to be injected.

&nbsp;

## Camel Routes

The following subsections contain all the `endpoints` that need to have routes defined in Camel and for which one or more plugins must be created.

For the endpoint `/pix/payments`, for example, the route should be defined in the plugin as:

```xml
<from uri="direct:paymentsPostPixPayments"/>
```

&nbsp;

### Pix

&nbsp;

| Method   | Version | Endpoint                        | Camel Route                                     |
| -------- | ------- | ------------------------------- | ----------------------------------------------- |
| POST     | v1      | /pix/payments                   | ```direct:paymentsPostPixPayments```            |
| GET      | v1      | /pix/payments/\{paymentId\}     | ```direct:paymentsGetPixPaymentsPaymentId```    |
| POST     | v2      | /pix/payments                   | ```direct:paymentsPostPixPayments_v2```         |
| GET      | v2      | /pix/payments/\{paymentId\}     | ```direct:paymentsGetPixPaymentsPaymentId_v2``` |
| PATCH    | v2      | /pix/payments/\{paymentId\}     | ```direct:paymentsPatchPixPaymentsPaymentId_v2```|
| POST     | v3      | /pix/payments                   | ```direct:paymentsPostPixPayments_v3```         |
| GET      | v3      | /pix/payments/\{paymentId\}     | ```direct:paymentsGetPixPaymentsPaymentId_v3``` |
| PATCH    | v3      | /pix/payments/\{paymentId\}     | ```direct:paymentsPatchPixPaymentsPaymentId_v3```|

## What Changes in Version 2 of the Payment Initiation API?

Open Finance Brasil has officially defined support for scheduled payments via PIX in version 2 of the payment initiation service, including a [new state machine](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/24182882/M+quina+de+Estados+-+v2.0.0+-+Pagamentos#Pagamento%3A-Arranjo-Pix) for the resource.

Key changes include the renaming of states and the addition of the **CANC** state to indicate payment cancellation by the user, while maintaining the **RJCT** state for transactions rejected by the detentor or SPI. Both must be reported by the detentor through the new [v2 routes](#pix).

Additionally, the detentor must inform the user's account used for payment in all version 2 routes through the *debtorAccount* field.

## What Changes in Version 3 of the Payment Initiation API?

The main change for payment v3 is the validations performed during the asynchronous processing of consent by the detentor, which must follow the domain specified here: [paymentv3](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/142672139/Informa+es+T+cnicas+-+Pagamentos+-+v3.0.0-beta.2)

## Expected Actions from Connectors

### paymentsPostPixPayments_v3 WIP

- Validate if the proxy is valid and matches the creditorAccount (if sent). [*1](#obs)
- Validate if the proxy belongs to one of the creditors registered in the consent. [*1](#obs)
- Validate if EndToEndId is valid and has not been reused. [*1](#obs)
- Validate if the QRCode is valid. [*2](#obs)
- Validate if source and destination accounts are the same. [*1](#obs)

## Notes

- `*1:` return error 422 - DETALHE_PAGAMENTO_INVALIDO in case of a positive validation.
- `*2:` return error 422 - VALOR_INVALIDO in case of a positive validation.

**Attention**: More validations for all routes will be included.
