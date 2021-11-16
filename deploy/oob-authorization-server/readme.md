# Instalação do OOB Authorization Server

## Pré-requisitos

### Criação do(s) secret(s) para armazenar as chaves privadas

As chaves privadas do AS devem ser persistidas de forma segura, é altamente
recomendado utilizar um cofre de senhas para essa persistência.
Caso isso não seja possível, secrets tradicionais podem ser criados no Kubernetes
para persistir essas informações.
O procedimento abaixo descreve uma das formas para se criar este secret.

O comando abaixo pode ser utilizado para se criar um secret com o conteúdo de um
diretório:

```shell
kubectl -n <NOME_DO_NAMESPACE> create secret generic <NOME_DO_SECRET> --from-file=<CAMINHO_DO_DIRETORIO>
```

Considere, por exemplo que as chaves estejam previamente criadas e armazenadas
em um diretório local:

```shell
ls /tmp/as
enc.key  sig.key
```

Ao executar o comando abaixo, o secret é criado:

```shell
kubectl -n oob create secret generic oob-as-keys --from-file=/tmp/as
secret/oob-as-keys created
```

Para descrever o conteúdo do secret o comando abaixo pode ser utilizado:

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

## Instalação

A instalação do módulo é feita via Helm Chart

## Configuração

### db

Configuração de acesso ao banco

* name: Nome da base
* username: Nome do usuário de acesso ao banco
* password: Senha do usuário de acesso ao banco
* host: Host do banco
* type: Tipo do banco. Default: "postgres"
  
Exemplo:

```yaml
  db:
    name: "authorization_server"
    username: "authorization_server"
    password: "authorization_server"
    host: "postgres.local"
    type: "postgres"
```
  
### api/baseUrlOobConsents

- Endereço base do serviço de consentimento

Apontamento interno no K8s

Ex: `http://oob-consent`

### customer/federationJwksUrl

*Para instalações com autenticação de clientes através de aplicativo próprio da
instituição.*

Endereço onde o serviço deve buscar o JWKS com a chave pública para validar os
tokens JWT emitidos pelo aplicativo responsável pela autenticação dos clientes
do banco.

Ex: `https://idp.bank.com.br/jwks.jwks`

### privateKeys

Lista de chaves privadas utilizadas para encriptar ou assinar mensagens. A lista
deve conter pelo menos uma chave com use = sig (assinatura) e uma com use = enc (encriptação).

* certSecretName: Nome do secret que contém a chave privada
* certSecretKey: Nome da propriedade do secret que contém a chave privada
* kid: Identificador da chave (Obtido do diretório de participantes)
* alg: Algoritmo a ser utilizado com a chave
* use: Finalidade de uso da chave pelo authorization server. Os valores
possíveis são `sig` (assinatura) ou `enc` (encriptação)

Exemplo:

```yaml
  privateKeys:
    - certSecretName: "oob-as-keys"
      certSecretKey: "sig.key"
      kid: "MPguImG0DEQwu9ZUvwDzw_0xybh1yAETY9VBLdYXibo"
      alg: "PS256"
      use: "sig"
    - certSecretName: "oob-as-keys"
      certSecretKey: "enc.key"
      kid: "95NrL0TaTttM2-Awq0uCPqqE1gRYN9PRfYleHPlMv1w"
      alg: "RSA-OAEP"
      use: "enc"
```

As chaves devem ser geradas no diretório de participantes:

* BRSEAL=chave de assinatura
* BRCAC=chave de encriptação

### clients

Configura os clientes estáticos (não registrados dinâmicamente) no authorization
server. Deve ser utilizado para cadastrar sistemas internos do banco que irão
gerar tokens para acessar à plataforma OOB.

* clientSecretName: Nome do secret que contém o secret de acesso do cliente
* clientSecretKey: Nome da propriedade do secret que contém o secret de acesso
do cliente
* clientId: ClientId de acesso do cliente
* redirectUris: URLs do cliente autorizadas para redirect em fluxos de
autenticação web
* responseTypes: ResponseType para o cliente
* grantTypes: Grant types permitidos para o cliente
* tokenEndpointAuthMethod: Tipo de autorização para o cliente
* allowedScopes: Escopos permitidos para o cliente

Exemplo:

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

Pelo menos um cliente deve ser configurado no authorization server para ser
usado nos módulos que fazem introspection do token.

### as

Diversas configurações gerais do Authorization Server (AS):

#### issuer

FQDN público do AS para fins de divulgação da configuração no endereço
`openid-configuration`. Utilizar o FQDN sem MTLS.

Ex: `https://auth.bank.com.br`

#### authBasePath

Base path do AS para instalações que utilizam mesmo FQDN para exposição do AS e
das APIs Open Banking, diminuindo então a quantidade de certificados necessários.

Essa configuração sempre deve terminar com `/`, para casos que o AS está exposto
num FQDN exclusivo, configurar com o valor `/`.

Ex: `/auth/`

#### central_directory_jwks

Endereço do JWKS do diretório de participantes. Ambientes não-produtivos devem
utilizar o endereço de sandbox do diretório de participantes.

| Ambiente | Endereço                                                                       |
| -------- | ------------------------------------------------------------------------------ |
| Sandbox  | <https://keystore.sandbox.directory.openbankingbrasil.org.br/openbanking.jwks> |
| Produção | <https://keystore.directory.openbankingbrasil.org.br/openbanking.jwks>         |

Referência: [Open Banking Brasil SSA Key Store and Issuer Details](https://openbanking-brasil.github.io/specs-seguranca/open-banking-brasil-dynamic-client-registration-1_ID1.html#name-open-banking-brasil-ssa-key)

#### regulatory_ttl

TTL em segundos dos tokens emitidos pelo AS aos TPPs. O item [5.2.2-13](https://openbanking-brasil.github.io/specs-seguranca/open-banking-brasil-financial-api-1_ID2.html#section-5.2.2-3.13.1)
da regulamentação do Open Banking Brasil define que o TTL deve ser entre 300 e
900 segundos. Qualquer valor fora dessa faixa irá gerar erro de certificação.

Configuração sugerida `300`

#### mtls_fqdn_regex

Configuração composta por `find` e `replace` para substituição do endereço
não-MTLS do AS para o endereço MTLS. Os campos são utilizados por uma função de
expressão regular (RegEx) de replace com a URL de cada endpoint do AS.

Para caso de adição de `mtls-` nas URLs de endpoint do AS utilizar os valores
`find`: "^(https://)(.*)$" e `replace`: "https://mtls-$2". Note que as URLs
devem ser HTTPS.

#### consent.channels

Tipo de canal suportado para autenticação no AS. Valores suportados: `web`,
`mobile` e `web,mobile`.

#### consent.unsupportedRedirectUrl

URL que o cliente será redirecionado caso não haja suporte `web` na configuração

Ex: `https://play.google.com/store/apps/details?id=com.google.android.apps.maps`

#### brand.id

Vide a [definição](../shared-definitions.md#brand-id)

#### brand.name

Nome da marca. Essa variável será utilizada para mostrar o nome da marca na tela
de redirecionamento do cliente durante o uso do fluxo web, e também é retornada na
integração APP2AS.

Ex: `C Banco`

#### brand.logo

URL contendo o logotipo da marca, a ser utilizado nas telas de redirecionamento
do consentimento.

Ex: `https://www.opus-software.com.br/wp-content/uploads/2019/01/opus_logo.png`

### features

Indica as [features](../shared-definitions.md) suportadas pela instalação,
fazendo uma restrição de segurança aos serviços Open Banking suportados nas features.

**Ex:**

```yaml
features: "core,payments"
```

## additionalVars

Utilizado para definir configurações opcionais na aplicação. Essa configuração
permite definir uma lista de propriedades a serem passadas para a aplicação no formato:

```yaml
additionalVars:
  - name: FIRST_PROPERTY
    value: "FIRST_VALUE"
  - name: SECOND_PROPERTY
    value: "SECOND_VALUE"
```

As configurações que podem ser definidas neste formato estão listadas abaixo:

### AS_LOG_REQUESTS

Define se a aplicação deve logar os requests recebidos. É recomendável ativar
somente em ambientes de desenvolvimento. Em produção é desaconselhável.

**Formato:** `0` ou `1`

**Ex:**

```yaml
additionalVars:
  - name: AS_LOG_REQUESTS
    value: "1"
```

#### CONSENT_LOGIN_SCREEN_MOCK_ENABLED

Habilita ou desabilita a exibiçao da tela de login mockada. Utilizar apenas em
ambientes não produtivos.

**Formato:** `0`ou `1`
Valor default: `0`

**Ex:**

```yaml
additionalVars:
  - name: CONSENT_LOGIN_SCREEN_MOCK_ENABLED
    value: "0"
```

### AUTH_JWT_JTI_VALIDATION

Define se o processo de autenticação definido na integração
[APP2AS](../../consentimento/app2as/readme.md) deve realizar a validação do 
`jti` informado no payload durante o request.

**Formato:** `0` ou `1`

**Ex:**

```yaml
additionalVars:
  - name: AUTH_JWT_JTI_VALIDATION
    value: "1"
```

### APPLE_APP_ID

AppId da aplicação IOS, utilizada no universal link. [Mais detalhes no site da Apple](https://developer.apple.com/library/archive/documentation/General/Conceptual/AppSearch/UniversalLinks.html)

**Ex:**

```yaml
additionalVars:
  - name: APPLE_APP_ID
    value: "9999999999.com.apple.wwdc"
```

### ANDROID_PACKAGE_NAME

application ID declarado no arquivo build.gradle. [Mais detalhes no site do Android](https://developer.android.com/training/app-links/verify-site-associations)

### ANDROID_CERT_FINGERPRINTS

SHA256 fingerprints do certificado de assinatura do seu aplicativo

O seguinte comando gera o fingerprint via Java keytool:

`
keytool -list -v -keystore my-release-key.keystore
`

### Configuração dos headers de certificado SSL

Configuração dos headers onde o certificado utilizado pelo cliente no mTLS é
enviado para a aplicação. Essa configuração pode ser omitida caso os headers
padrão sejam utilizados (X-SSL-*)

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

## Exposição

Como o acesso ao Authorization Server não é feito através do Kong, um ingress
precisa ser criado. [Mais detalhes aqui](../readme.md)

## Ambiente de Certificação

### Senha para autenticação (tela de mock do login)

testeOpenBanking
