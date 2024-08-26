# Hybrid-flow with Handoff

Institutions that have user authentication only through applications need to support the Hybrid-flow with handoff to allow consents initiated on devices that do not support the execution of the applications, typically a desktop or laptop.

The Opus Open Banking (OOB) Authorization Server (AS) supports the handoff flow and provides a JavaScript library that allows the institution to fully customize the web page that will be displayed to the client.

The handoff library is designed for the institution to obtain all information related to the handoff flow of a consent, from the data for displaying the QR code to the events related to the flow.

The OOB AS hosts the library at the URL `https://as.institution.com.br/auth/handoff/v1/oob-handoff.js` and should be referenced directly instead of being copied and referenced from another web server.

## OOB Handoff Flow

The TPP is unaware if the Open Banking installation uses handoff or not, and this is not the TPP's responsibility. The OIDC flow initiated by the TPP redirects the client's browser to the OOB AS, which then redirects the browser to the handoff display page created by the institution.

The AS has a configuration that defines the handoff URL template made by the institution, allowing the consent intention identifier to be merged into the URL in any way the institution desires. See [HANDOFF_RESOURCE_URL](../../deploy/oob-authorization-server/readme.md).

The merge allows the institution to receive the identifier via `query string`, `fragment`, or `url`, as shown in the table below:

| Format       | Example URL                                                       |
| ------------ | ----------------------------------------------------------------- |
| Query string | `https://ev.institution.com.br/handoff.html?code=<IDENTIFIER>`    |
| Fragment     | `https://ev.institution.com.br/handoff.html#<IDENTIFIER>`         |
| URL          | `https://ev.institution.com.br/<IDENTIFIER>/handoff.html`         |

The handoff page should retrieve the identifier and use it during the library initialization as we will see below. The example provided in the documentation transfers the identifier through the URL `fragment` and should be the preferred format if possible, as it also removes the identifier from the browser history, avoiding any confusion from the client attempting to use an old consent URL.

The page should also point to the AS installation (public address) when initiating the library through the **oobAsPublicUrl** configuration as instructed below.

## How to Use the Library

After importing the library into the HTML page, the variable `oobHandoff` will contain the entry point of the library, and it needs to be initialized through the `init` method, passing the identifier received during the AS redirect and the event handlers that will be triggered.

```Javascript
oobHandoff.init({
    oobStartCode: '<IDENTIFIER>',
    oobAsPublicUrl: '<OOB_AS_PUBLIC_URL>',
    onHandoffReady: function(handoffReady) {
        // Text for QR and alternative code for typing ready
    },
    onHandoffQRRead: function() {
        // User has read the QR or entered the alternative code
    },
    onHandoffTimedOut: function(handoffError) {
        // Time to complete the consent has expired
    },
    onHandoffCompleted: function(handoffCompleted) {
        // Consent successfully completed
    },
    onHandoffError: function(handoffError) {
        // An error occurred during consent
    }
});
```

Os parâmetros dos eventos contêm informações necessárias para cada momento, os
objetos estão detalhados abaixo.

### handoffReady

Schema:

```json
{
    "qrCode": "<string>",
    "timeoutSeconds": <int>,
    "typeCode": "<string>",
    "tppName": "<string>",
    "tppLogoUrl": "<string>"
}
```
| Property         | Description                                                                                                                          |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `qrCode`         | Value to generate QR code to be displayed to the user                                                                                |
| `timeoutSeconds` | Total time available for the completion of the consent                                                                               |
| `typeCode`       | Alternative code for the client to enter in case of QR code reading failure. Present only if enabled during the OOB installation      |
| `tppName`        | Name of the payment initiating institution                                                                                           |
| `tppLogoUrl`     | Logo of the payment initiating institution                                                                                           |

### handoffCompleted

Schema based on the `completedCommand` of the APP2AS interface:

```json
{
    "tpp": {
        "name": "<string>",
        "logoUrl": "<string>"
    },
    "completedCommand": {
        "redirect": {
            "redirectTo": "<string>"
        }
    }
}
```
| Property                               | Description                                                                 |
| -------------------------------------- | --------------------------------------------------------------------------- |
| `tpp.name`                             | TPP name for display on the return screen                                   |
| `tpp.logoUrl`                          | URL with the TPP logo for display on the return screen                      |
| `completedCommand.redirect.redirectTo` | URL for redirection after displaying the return screen to the user          |

### handoffError

Schema based on the `errorCommand` of the APP2AS interface:

```json
{
    "tpp": {
        "name": "<string>",
        "logoUrl": "<string>"
    },
    "errorCommand": {
        "type": "<string>",
        "message": "<string>",
        "redirect": {
            "redirectTo": "<string>"
        }
    }
}
```

| Property                            | Description                                                                                                                                                                                                                          |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `tpp.name`                          | TPP name for display on the return screen.                                                                                                                                                                                           |
| `tpp.logoUrl`                       | URL with the TPP logo for display on the return screen                                                                                                 |
| `errorCommand.type`                 | Error type. Same `enum` as APP2AS: `CPF_MISMATCH`, `CNPJ_MISMATCH`, `EXPIRED_CONSENT`, `RESOURCE_MUST_CONTAIN_ID`, `GENERIC_ERROR`, `OIDC_ERROR`, `DISCOVERY_ERROR`, `RESOURCE_MUST_CONTAIN_ID_SELECTABLE_PRODUCTS`, `DISCOVERY_TIMEOUT`, `INVALID_STATUS_CONFIRMATION`, `INVALID_ENROLLMENT_INFORMATION` |
| `errorCommand.message`              | Error message to display to the user on the return screen                                                                                                                                                                            |
| `errorCommand.redirect.redirectTo`  | URL for redirection after displaying the return screen to the user                                                                                                                                                                   |

The `tpp.name`, `tpp.logoUrl`, `errorCommand.message`, and `errorCommand.redirect.redirectTo` information may not be present in the response.

## Cancellation

The handoff screen passively reacts to events occurring in the flow.
At any time, the user can actively abort the handoff flow.
To do this, a "Cancel" button must be provided on the screen.

To cancel the flow, a request must be made to the API `https://as.instituicao.com.br/auth/handoff/v1/<oobStartCode>/abort`,
where **oobStartCode** is the same code used to start the library [here](./readme.md#como-usar-a-biblioteca).

After cancellation, the screen should redirect the user back to the initiator,
and the app should inform the user (e.g., with an error message),
interrupting the handoff flow.

## Example

A functional application example is available in the [src](./src) directory. The
[sample.html](./src/sample.html) page is the sample handoff page handling all the flow events, this sample page is what the
institution should create, host, and configure the URL in the OOB installation.

The sample application uses the mocked version of the library [oob-handoff.js](./src/v1/oob-handoff.js)
which simulates 3 different scenarios through the identifiers listed in the table below.

| Identifier             | Scenario                                         |
| ---------------------- | ------------------------------------------------ |
| L3YxL21vY2svc3VjY2Vzcw== | Consent successfully completed                   |
| L3YxL21vY2svY3BmLWVycm9y | CPF_MISMATCH error                              |
| L3YxL21vY2svdGltZW91dA== | Timeout for consent completion                   |

You can run the sample application by hosting the `src` directory on a web server. To run it locally, we suggest using the [`http-server`](https://www.npmjs.com/package/http-server) package from [Node.js](https://nodejs.org/en/download/):

```bash
cd /src
npx http-server -p 3030 --cors -c-1
```
You can start the mocked scenarios through the following URLs:

| Scenario      | URL                                                       |
| ------------- | --------------------------------------------------------- |
| Success       | <http://lvh.me:3030/sample.html#L3YxL21vY2svc3VjY2Vzcw==> |
| CPF_MISMATCH  | <http://lvh.me:3030/sample.html#L3YxL21vY2svY3BmLWVycm9y> |
| Timeout       | <http://lvh.me:3030/sample.html#L3YxL21vY2svdGltZW91dA==> |

## Customizable handoff page

If the institution prefers not to implement its own handoff page, it is possible
to use the solution provided by Opus Open Banking, a page that configures
the main aesthetic and content characteristics to adapt to the institution's style.

These are the possible [configurations](./custom-handoff-config/readme.md).


