# Instalação do OOB Portal Back Office

## Instalação

A instalação do módulo é feita via Helm Chart

## Configuração

### baseApiUrl

Endereço público pelo qual o portal (que roda no browser do usuário) consegue
acessar as APIs do OOB.

Ex: `https://kong.bank.com.br`

### authDiscoveryDocumentUrl

Endereço do endpoint de *discovery **non-fapi*** do Authorization Server do
OOB, no qual o Portal Back Office irá realizar a autenticação dos usuários
durante o processo de login.

Ex: `https://oob.authorization-server.com.br/auth-nonfapi/.well-known/openid-configuration`

### authIssuer

*Issuer* do Authorization Server do OOB. Essa informação pode ser
encontrada dentro no retorno do endpoint de *discovery* cujo endereço é definido
na variável `authDiscoveryDocumentUrl` descrita mais acima.

Ex: `https://oob.authorization-server.com.br`

### authClientId

Identificação do *client* que será utilizado no processo de autenticação junto
ao Servidor de Autorização. A identificação definida nessa variável deve ser a
mesma identificação definida na configuração do *client* no [Authorization Server](../../deploy/oob-authorization-server/readme.md#clients).

Ex: `portal-backoffice`

### authClientSecretName

Contém o nome do *secret* do kubernetes onde será armazenado o *secret* do
*client* definido na variável anterior.

Ex: `auth-clients`

### authClientSecretKey

Contém a **chave** presente no *secret* definido acima que possui de fato o valor
do *secret* definido para o `authClientId` configurado. Recomendamos a geração
de um *secret* forte para ser definido aqui (um UUID por exemplo).

Ex: `portal-backoffice-client-secret`

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
