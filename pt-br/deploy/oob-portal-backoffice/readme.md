# Instalação do OOB Portal Back Office

## Instalação

A instalação do módulo é feita via Helm Chart

## Configuração

### baseApiUrl

Endereço público pelo qual o portal (que roda no browser do usuário) consegue
acessar as APIs do OOB.

Ex: `https://kong.bank.com.br`

### authDiscoveryDocumentUrl

Endereço do endpoint de *discovery **nonfapi*** do Authorization Server do
OOB, no qual o Portal Back Office irá realizar a autenticação dos usuários
durante o processo de login.

Ex: `https://oob.authorization-server.com.br/auth-nonfapi/.well-known/openid-configuration`

### authIssuer

FQDN público do Authorization Server do OOB. A configuração dessa variável no
Portal Back Office é similar a variável `issuer` definida na configuração do
[Authorization Server](../../deploy/oob-authorization-server/readme.md#issuer).
O valor correto para essa configuração também pode ser encontrado dentro no
retorno do endpoint de *discovery* cujo endereço é definido na variável
`authDiscoveryDocumentUrl` descrita mais acima.

Ex: `https://oob.authorization-server.com.br`

### authClientId

Identificação do *client* que será utilizado no processo de autenticação junto
ao Servidor de Autorização. A identificação definida nessa variável deve ser a
mesma identificação definida na configuração do *client* no [Authorization Server](../../deploy/oob-authorization-server/readme.md#clients).

Ex: `portal-backoffice`

### webAppConfigUrl

Endereço público do endpoint usado para *customização* do Portal Backoffice.
O retorno dessa API deve ser um objeto JSON com as propriedades definidas na
documentação do [Portal Backoffice](../../portal-backoffice/customizacao/readme.md).

Essa configuração pode ser feita pelo header `Access-Control-Allow-Origin`, configurando
o domínio da URL do portal.

Ex: `https://kong.bank.com.br/backoffice-config`

### webAppConfigJson

JSON usado para *customização* do Portal Backoffice.

O valor dessa variável deve ser um objeto JSON no formato de String com as
propriedades definidas na documentação do [Portal Backoffice](../../portal-backoffice/customizacao/readme.md).

**Observação**: O objeto JSON deve ter aspas simples ao invés de aspas duplas,
caso contrário haverá problema no momento da injeção do valor da variável
durante a inicialização do módulo front-end.

**Importante**: Essa variável tem prioridade em relação a `webAppConfigUrl`, ou seja,
caso `webAppConfigJson` seja definida, `webAppConfigUrl` não será utilizada.

Ex: `"{'app':{'title':'Opus Open Banking | Backoffice','faviconPath':'./backoffice_base_path_placeholder/assets/favicon.ico',
'copyright':'2021 Copyright by Opus Open Banking'},'brand':{'name':'Opus Open Banking','path':
'./backoffice_base_path_placeholder/assets/logo.svg'},'sidebarStatus':'closed','selectedTheme':'default','themes':[{'name':'default','variables':{}}]}"`

**Importante**: Lembrar que se os paths forem para arquivos do projeto será
necessário adicionar o `/backoffice_base_path_placeholder/` como no exemplo acima
para que o base path possa ser modificado via variável [basePath](#basePath).

### authClientSecretName

Contém o nome do *secret* do kubernetes onde será armazenado o *secret* do
*client* definido na variável anterior.

Ex: `auth-clients`

### authClientSecretKey

Contém a **chave** presente no *secret* definido acima que possui de fato o valor
do *secret* definido para o `authClientId` configurado. Recomendamos a geração
de um *secret* forte para ser definido aqui (um UUID por exemplo).

Ex: `portal-backoffice-client-secret`

### basePath

Essa variável define o root path da aplicação do portal-backoffice.

**Importante**: Ao adicionar essa variável alterações tem que ser feitas
nas variáveis de postLogoutRedirectUris e redirectUris do authorization-server
[Mais detalhes aqui](../../portal-backoffice/federation-usuarios-internos/readme.md#configuração-do-client-do-portal-back-office)

Ex: `portal`

O acesso ao portal neste caso seria `<host>/portal`

## Exposição

Como o acesso ao Portal Back Office não é feito através do Kong, um ingress
precisa ser criado. [Mais detalhes aqui](../readme.md#criação-de-ingresses)

```yaml
ingress:
  enabled: true # Indica se o ingress deve ser criado
  annotations: # Define as anotações para o ingress
    kubernetes.io/ingress.class: nginx
  hosts:
    - host: portal-backoffice.bank.com.br # Define o hostname utilizado para acessar o ingress
      paths:
        - / # Define o path utilizado para acessar o ingress, geralmente "/"
  tls: 
    - secretName: portal-backoffice-tls # Define o secret que contém o certificado caso o ingress aceite conexões HTTPS
      hosts:
        - portal-backoffice.bank.com.br # Define o hostname da rota relacionada a essa configuração de tls
```
