# Opus Open Finance Back-Office Portal Installation

## Installation

The module is installed via Helm Chart.

## Configuration

### baseApiUrl

Public address through which the portal (running in the user's browser) can access the Opus Open Finance Platform's APIs.

Example: `https://kong.bank.com.br`

### authDiscoveryDocumentUrl

Address of the *discovery nonfapi* endpoint of the Opus Open Finance Platform's Authorization Server, where the Back Office Portal will authenticate users during the login process.

Example: `https://oof.authorization-server.com.br/auth-nonfapi/.well-known/openid-configuration`

### authIssuer

Public FQDN of the Opus Open Finance Platform's Authorization Server. Configuring this variable in the Back Office Portal is similar to the `issuer` variable defined in the [Authorization Server](../../deploy/oob-authorization-server/readme.md#issuer) configuration. The correct value for this configuration can also be found in the *discovery* endpoint response defined in the `authDiscoveryDocumentUrl` variable described above.

Example: `https://oof.authorization-server.com.br`

### authClientId

Identification of the *client* used in the authentication process with the Authorization Server. The identification defined in this variable must be the same as the one defined in the *client* configuration in the [Authorization Server](../../deploy/oob-authorization-server/readme.md#clients).

Example: `backoffice-portal`

### webAppConfigUrl

Public address of the endpoint used for *customization* of the Back Office Portal. The response from this API should be a JSON object with the properties defined in the [Back Office Portal](../../backoffice-portal/customizacao/readme.md) documentation.

This configuration can be made through the `Access-Control-Allow-Origin` header, configuring the domain of the portal URL.

Example: `https://kong.bank.com.br/backoffice-config`

### webAppConfigJson

JSON used for *customization* of the Back Office Portal.

This variable should receive a JSON formatted as a String with the properties defined in the [Back Office Portal](../../backoffice-portal/customizacao/readme.md) documentation.

**Note**: The JSON object should use single quotes instead of double quotes to avoid issues during the injection of the variable value during the front-end module initialization.

**Important**: This variable takes precedence over `webAppConfigUrl`, meaning if `webAppConfigJson` is defined, `webAppConfigUrl` will not be used.

Example: `"{'app':{'title':'Opus Open Finance | Backoffice','faviconPath':'./backoffice_base_path_placeholder/assets/favicon.ico',
'copyright':'2021 Copyright by Opus Open Finance'},'brand':{'name':'Opus Open Finance','path':
'./backoffice_base_path_placeholder/assets/logo.svg'},'sidebarStatus':'closed','selectedTheme':'default','themes':[{'name':'default','variables':{}}]}"`

**Important**: Remember that if the paths are for project files, you need to add `/backoffice_base_path_placeholder/` as in the example above so that the base path can be modified via the [basePath](#basePath) variable.

### authClientSecretName

Contains the name of the Kubernetes *secret* where the *client* secret defined in the previous variable will be stored.

Example: `auth-clients`

### authClientSecretKey

Contains the **key** present in the secret defined above that actually holds the value of the *client* secret defined for the configured `authClientId`. We recommend generating a strong secret to be defined here (for example, a UUID).

Example: `backoffice-portal-client-secret`

### basePath

This variable defines the root path of the backoffice-portal application.

**Important**: When adding this variable, changes need to be made to the postLogoutRedirectUris and redirectUris variables of the authorization-server. [More details here](../../backoffice-portal/federation-usuarios-internos/readme.md#configuração-do-client-do-portal-back-office).

Example: `portal`

Access to the portal in this case would be `<host>/portal`.

## Exposure

Since access to the Back Office Portal is not made through Kong, an ingress needs to be created. [More details here](../readme.md#criação-de-ingresses).

```yaml
ingress:
  enabled: true # Indicates if the ingress should be created
  annotations: # Defines the annotations for the ingress
    kubernetes.io/ingress.class: nginx
  hosts:
    - host: backoffice-portal.bank.com.br # Defines the hostname used to access the ingress
      paths:
        - / # Defines the path used to access the ingress, usually "/"
  tls: 
    - secretName: portal-backoffice-tls # Defines the secret containing the certificate if the ingress accepts HTTPS connections
      hosts:
        - portal-backoffice.bank.com.br # Defines the hostname of the route related to this tls configuration
```
