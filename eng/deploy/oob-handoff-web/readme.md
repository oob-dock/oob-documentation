# Opus Open Finance Platform Handoff Web Installation

## Installation

The module is installed via Helm Chart.

## Configuration

### oobCustomHandoffUrlConfig

- Configuration of the API URL that provides the JSON defining the page style (colors, icons, etc.).

The response from this API should be a JSON object with the properties defined in [Handoff Page Content Configuration](#references).

This configuration can be made through the `Access-Control-Allow-Origin` header, configuring the domain of the handoff page URL.

### oobCustomHandoffJsonConfig

- JSON defining the page style (colors, icons, etc.).

This variable should receive a JSON formatted as a String with the properties defined in [Handoff Page Content Configuration](#references).

**Note**: The JSON object should use single quotes instead of double quotes to avoid issues during the injection of the variable value during the front-end module initialization.

**Important**: This variable takes precedence over `oobCustomHandoffUrlConfig`, meaning if `oobCustomHandoffJsonConfig` is defined, `oobCustomHandoffUrlConfig` will not be used.

Example: `"{'logo':'https://ev.instituicao.com.br/logo.png','favicon':'https://ev.instituicao.com.br/icone.png',
'title':'Open Banking','colors':{'primary':'#BA1D36','background':'#EEEEEE',
'fontTitle':'#BA1D36','fontText':'#333333','error':'#B33A3A'},'texts':{'ready':
{'title':'Scan the QR code','codeText':'Validation code','timer':
'Remaining time -','keepOpened':'Attention: keep this page open until you confirm your request.'},'read':
{'title':'Code scanned','description':
'Your code was successfully scanned. Wait for validation.'},'completed':
{'title':'Success!','description':'Your authentication was successfully completed.
You will now be redirected back.'},'timeout':{'title':'Code expired',
'description':'The QR code validation time has expired. Please try again.'},
'error':{'title':'Oops! Something went wrong','description':'You will be redirected
back.'}}}"`

### oobCustomHandoffASPublicUrl

- Configuration of the public address URL of the OOB Authorization Server

### oobCustomHandoffLibPath

- Path of the JavaScript library used in the handoff, which will have the base address defined in the **oobCustomHandoffASPublicUrl** property. It is a standard path and should only be changed in case of a new version of the library.

**Example:**

```yaml
  oobCustomHandoffUrlConfig: "http://ev.instituicao.com.br/config.json"
  oobCustomHandoffASPublicUrl: "https://as.instituicao.com.br"
  oobCustomHandoffLibPath: "/auth/handoff/v1/oob-handoff.js"
```

### oobCustomBasePath

- This variable defines the root path of the handoff application.

Example: `handoff`

Access to the handoff in this case would be `<host>/handoff`

## References

**[AS Configuration for Handoff](../oob-authorization-server/readme.md#HANDOFF_RESOURCE_URL)**

**[Handoff Flow](../../consentimento/app2as-handoff/readme.md)**

**[Handoff Page Content Configuration](../../consentimento/app2as-handoff/custom-handoff-config/readme.md)**
