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

### Suporte a réplica de leitura

O OOB Authorization Server suporta utilização de uma réplica de leitura do banco de
dados. 

A réplica necessita das mesmas configurações da base, com exceção do *type*.
Essas propriedades usam o identificador da base *read-only*, conforme exemplo
a seguir:

```yaml
  db:
    read-only:
      name: "authorization_server"
      username: "readonly-user"
      password: "readonly-password"
      host: "readonly.postgres.local"
```

Para ativar a utilização da réplica de leitura, a propriedade feature/readReplica/enabled
deve ter seu valor alterado para "1", conforme exemplo:

```yaml
  feature:
    readReplica:
      enabled: "1"
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
deve conter pelo menos uma chave com use = sig (assinatura) e uma com use = enc
(encriptação). Vide a [definição](../shared-definitions.md#formatos-de-chave-privada-suportados)
para detalhes sobre os formatos de chaves suportados.

* certSecretName: Nome do secret que contém a chave privada
* certSecretKey: Nome da propriedade do secret que contém a chave privada
* kid: Identificador da chave (Obtido do diretório de participantes)
* alg: Algoritmo a ser utilizado com a chave
* use: Finalidade de uso da chave pelo authorization server. Os valores
possíveis são `sig` (assinatura) ou `enc` (encriptação)
* passphraseSecretName: Nome do secret que contém a senha para a chave privada
  (opcional) - ***deprecated***
* passphraseSecretKey: Nome da propriedade do secret que contém a senha para a
  chave privada (opcional) - ***deprecated***

As propriedades `passphraseSecretName` e `passphraseSecretKey` só devem ser
definidas para chaves criptografadas. Se elas não forem informadas assume-se
que as chaves são abertas. **Atenção:** Par de propriedades **obsoleta**
(***deprecated***). O Opus Open Banking pode parar de oferecer suporte à chaves
criptografadas em versões futuras.

Exemplo:

```yaml
  privateKeys:
    - certSecretName: "oob-as-keys"
      certSecretKey: "sig.key"
      kid: "MPguImG0DEQwu9ZUvwDzw_0xybh1yAETY9VBLdYXibo"
      alg: "PS256"
      use: "sig"
      passphraseSecretName: "oob-as-keys"
      passphraseSecretKey: "sig.key.passphrase"
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

Configura os clientes estáticos (não registrados dinamicamente) no authorization
server. Deve ser utilizado para cadastrar sistemas internos do banco que irão
gerar tokens para acessar à plataforma OOB.

* clientSecretName: Nome do secret que contém o secret de acesso do cliente
* clientSecretKey: Nome da propriedade do secret que contém o secret de acesso
do cliente
* clientId: ClientId de acesso do cliente
* redirectUris: URLs do cliente autorizadas para redirect em fluxos de
autenticação web
* postLogoutRedirectUris: URLs do cliente autorizadas para redirect em cenários
* de logout de fluxos de autenticação web
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

#### authNonFapiBasePath

Base path do AS não regulatório. Essa configuração sempre deve terminar com `/`.

Ex: `/auth-nonfapi/`

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

#### directory_webhook_guid

GUID gerado randomicamente a ser utilizado para registro de webhook no diretório
do Open Finance.

Ex: `13032100-c4ae-4aca-9b73-79366f0519a5`

O registro deve ser realizado no diretório após a atualização do serviço com o
seguinte endereço:

>https://[\<public_fqdn\>](../terraform/readme.md#public_fqdn)/[\<authBasePath\>](readme.md#authbasepath)/webhook/<directory_webhook_guid>

#### application/encryption/key

Valor da chave de encriptação que será utilizada para
criptografar dados sensíveis antes de persisti-los nas tabelas do banco de dados
do Authorization Server. Recomenda-se que a chave possua 256 bits e que o formato
do valor seja em hexadecimal.

Ex: `703273357538782F413F4428472B4B6250655368566D59713374367739792442`

#### application/encryption/salt

Valor do salt a ser utilizado para geração de chave de
criptografia em conjunto com a chave informada na variável anterior. Recomenda-se
que possua 64 bits e que o formato do valor seja em hexadecimal.

Ex: `635166546A576E5A`

>**Atenção**
>
> `Tanto a chave quanto o salt serão armazenados dentro da secret
> oob-authorization-server de forma semelhante a como é configurado o acesso à
> base de dados`

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

### dapr

Configurações relacionadas ao [Dapr](../shared-definitions.md#Dapr).

* enabled: Habilita o Dapr na aplicação para realizar a produção de
eventos.
Possíveis valores: `true` ou `false`. **Default:** `true`.
* pubSubId: Identificador do componente de pub/sub do Dapr a ser
utilizado.
* appId: O ID exclusivo do aplicativo. Usado para descoberta de serviço,
  encapsulamento de estado e ID do consumidor de pub/sub.

**Exemplo:**

```yaml
  dapr:
    enabled: "true"
    appId: oob-authorization-server
    pubSubId: "oof-pub-sub"
```
### scheduler

Este módulo também aplica (via Helm) um componente do tipo
[cron binding](https://docs.dapr.io/reference/components-reference/supported-bindings/cron/)
utilizado para fazer a sincronização das chaves públicas de assinatura periodicamente.

Dado este cenário, a instalação do Dapr bem como aplicação do componente
de *binding* são requisitos necessários para o correto funcionamento deste
módulo.

Configurações:

* jwks_minutes_interval: Intervalo de atualização das chaves públicas
  de assinatura na base de dados.

**Exemplo:**

```yaml
 scheduler:
    jwks_minutes_interval: "30"
```

## state store

Este módulo suporta uso de cache para introspection utilizando
uma das state stores [suportadas pelo dapr](https://docs.dapr.io/reference/components-reference/supported-state-stores/).

**Importante**: A state store escolhida deve, obrigatóriamente, suportar TTL.

Configurações:

* name: Nome dado ao componente da state store
* type: Tipo a ser preenchido conforme documentação do [dapr](https://docs.dapr.io/operations/components/setup-state-store/).
* version: Versão a ser utilizada. Por padrão, será utilizada *v1*.
* connectionMetadata: Metadados necessários para conexão com a state
store desejada a serem incluídos no formato name/value, conforme exemplo.

**Exemplo:**

```yaml
env:
  dapr:
    stateStore:
      introspection:
        name: token-state-store
        type: state.redis
        version: v1
        connectionMetadata:
          - name: redisHost
            value: localhost:6379
          - name: redisPassword
            value: password
```

**Importante:** Para habilitar o uso de cache, deve-se ativar a *feature flag* a seguir.

### feature/introspection/cache/enabled

Habilita ou desabilita o cache para introspection no Authorization Server.

Deve ser habilitada **APENAS** se a configuração do state store for realizada
nesse serviço e no serviço [OOB-Consents](../oob-consent/readme.md#daprstatestoreintrospectionname);

**Valor default**: `0` (desabilitado)

**Formato:** : `0` ou `1`.

**Exemplo:**
```
env:
  feature:
    introspection:
      cache:
        enabled: "1"
```

## server/org/id

Organization ID utilizado no report de PCM do tipo Hybrid Flow, conforme a [especificação do OF](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/37912663/Documenta+o+da+API).

```yaml
env:
  server:
    org:
      id: "6fd64cd7-a56d-4287-b12c-15bacf242f72"
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

### DIRECTORY_KEYSTORE_BASE

Endereço base da API de chaves públicas do diretório central.
O cadastro deve ser feito sempre com o endereço base da API de
sandbox para o ambiente de homologação e a oficial para o ambiente de produção.

Sandbox: `https://keystore.sandbox.directory.openbankingbrasil.org.br`
Produção: `https://keystore.directory.openbankingbrasil.org.br`

O valor default está configurado para o ambiente de produção.

```yaml
additionalVars:
  - name: DIRECTORY_KEYSTORE_BASE
    value: "https://keystore.sandbox.directory.openbankingbrasil.org.br"
```

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

### AS_LOG_LEVEL

Define o nível do log que será exibido no console da aplicação. Em produção é aconselhável
ser level `info`.

**Valores possíveis:** `emerg`, `error`, `warn`, `info`, `debug`

Valor default: `info`

**Ex:**

```yaml
additionalVars:
  - name: AS_LOG_LEVEL
    value: "debug"
```

### ANDROID_PACKAGE_NAME

application ID declarado no arquivo build.gradle. [Mais detalhes no site do Android](https://developer.android.com/training/app-links/verify-site-associations)

### ANDROID_CERT_FINGERPRINTS

SHA256 fingerprints do certificado de assinatura do seu aplicativo.
Deve-se utilizar vírgula para separar cada um dos fingerprints, assim como no exemplo
a seguir:

**Ex:**

```yaml
additionalVars:
  - name: ANDROID_CERT_FINGERPRINTS
    value: "14:6D:E9:83:C5:73:06:50:D8:EE:B9:95:2F:34:FC:64:16:A0:83:42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:70,14:6D:E9:83:C5:73:06:50:D8:EE:B9:95:2F:34:FC:64:16:A0:83:42:E6:1D:BE:A8:8A:04:96:B2:3F:CF:45"
```

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

### CUSTOM_WEB_APP_AUTH_URL

Template da URL de autenticação customizada definida pela instituição.

Quando essa variável estiver definida a autenticação de usuários acontecerá
via web utilizando a tela de login da instituição. O identificador inicial
do fluxo de autenticação será mesclado na URL definida nessa variável no lugar
do `<IDENTIFICADOR>`.

**Formato:**

A mescla permite a instituição receber o identificador através da `query string`,
`fragment` ou `url`, como exibido na tabela abaixo:

| Formato      | URL Exemplo                                            |
| ------------ | -------------------------------------------------------|
| Query string | `https://ev.instituicao.com.br?codigo=<IDENTIFICADOR>` |
| Fragment     | `https://ev.instituicao.com.br#<IDENTIFICADOR>`        |
| URL          | `https://ev.instituicao.com.br/<IDENTIFICADOR>`        |

É recomendado o uso de fragment sempre que possível, dado que ele também remove
o identificador do histórico de navegação.

**Ex:**

```yaml
additionalVars:
  - name: CUSTOM_WEB_APP_AUTH_URL
    value: "https://ev.instituicao.com.br#<IDENTIFICADOR>"
```

### CUSTOM_WEB_APP_CONSENT_ENABLED

Esta variável funciona em conjunto à variável `CUSTOM_WEB_APP_AUTH_URL`. Uma vez
que a URL de autenticação customizada tenha sido definida, esta configuração
determina se o fluxo de autenticação web utilizará telas customizadas para o
fluxo de geração de consentimentos ou se usará as telas padrão fornecidas pelo
Opus Open Banking. Quando seu valor for definido como `0` as telas padrão serão
utilizadas, quando definido como `1` as telas customizadas deverão renderizar
o fluxo da geração do consentimento.

**Formato:** `0` ou `1`

**Valor default:** `0`

**Ex:**

```yaml
additionalVars:
  - name: CUSTOM_WEB_APP_CONSENT_ENABLED
    value: "1"
```

### HANDOFF_RESOURCE_URL

Template da URL da página de handoff implementada pela instituição,
utilizando a biblioteca javascript hospedada no authorization server.

Quando essa variável estiver definida o fluxo de handoff estará ativo
e se a instituição não possui tela de login via web configurada então o handoff
será utilizado. O identificador inicial do fluxo de handoff será mesclado
na URL definida nessa variável no lugar do `<IDENTIFICADOR>`.

**IMPORTANTE**: Caso não queira habilitar o fluxo de handoff, não preencha a variável.
Se ele estiver preenchido com um valor incorreto, o fluxo será interrompido por erro.

**Formato:**

A mescla permite a instituição receber o identificador através da `query string`,
`fragment` ou `url`, como exibido na tabela abaixo:

| Formato      | URL Exemplo                                                                |
| ------------ | -------------------------------------------------------------------------- |
| Query string | `https://ev.instituicao.com.br/pagina_handoff.html?codigo=<IDENTIFICADOR>` |
| Fragment     | `https://ev.instituicao.com.br/pagina_handoff.html#<IDENTIFICADOR>`        |
| URL          | `https://ev.instituicao.com.br/pagina_handoff.html/<IDENTIFICADOR>`        |

É recomendado o uso de fragment sempre que possível, dado que ele também remove
o identificador do histórico de navegação.

**Ex:**

```yaml
additionalVars:
  - name: HANDOFF_RESOURCE_URL"
    value: "https://ev.instituicao.com.br/pagina_handoff.html#<IDENTIFICACAO>"
```

### HANDOFF_TYPECODE_CHARSET

Conjunto de caracteres a serem utilizados na geração de typeCode para o handoff.
Se esta configuração não estiver presente a geração do typeCode não será realizada.

**Ex:**

```yaml
additionalVars:
  - name: HANDOFF_TYPECODE_CHARSET"
    value: "BCDFGHJKLMNPQRSTVWXZ"
```

### HANDOFF_TYPECODE_FORMAT

Formato utilizado para a geração do typeCode para o handoff, '*' representa
onde será colocado o caracter definido no charset. Recomenda-se utilizar de 6
a mais caracteres para evitar repetição.

**Ex:**

```yaml
additionalVars:
  - name: HANDOFF_TYPECODE_FORMAT"
    value: "********"
```

### INTERNAL_USERS_FEDERATION_DISCOVERY_ENDPOINT

Endereço do endpoint de *discovery* do Servidor de Autorização externo onde os
usuários finais do Portal Back Office estão cadastrados.

**Ex:**

```yaml
additionalVars:
  - name: INTERNAL_USERS_FEDERATION_DISCOVERY_ENDPOINT"
    value: "https://external-idp.com.br/auth/.well-known/openid-configuration"
```

### INTERNAL_USERS_FEDERATION_ALLOWED_CLIENT_IDS

Define qual a lista de identificadores de *clients* que serão permitidos para
iniciar o processo de autenticação da aplicação de Portal Backoffice junto ao
Authorization Server do OOB. Caso o processo de autenticação de usuários de
Back Office seja iniciado por um *client* cujo identificador não esteja nessa
lista, um erro será retornado pelo Authorization Server.

**Ex:**

```yaml
additionalVars:
  - name: INTERNAL_USERS_FEDERATION_ALLOWED_CLIENT_IDS"
    value: "portal-backoffice"
```

### INTERNAL_USERS_FEDERATION_CLIENT_ID

Define o identificador do *client* que será utilizado pelo Authorization Server
do OOB para iniciar o processo de autenticação junto ao Servidor de Autorização
externo onde os usuários finais do Portal Back Office estão cadastrados.

**Ex:**

```yaml
additionalVars:
  - name: INTERNAL_USERS_FEDERATION_CLIENT_ID"
    value: "internal-users-federation"
```

### INTERNAL_USERS_FEDERATION_SECRET

Contém o *secret* do *client* definido na variável anterior. Sugerimos que seja
definido como uma referência a um [*secret* do kubernetes](https://kubernetes.io/pt-br/docs/concepts/configuration/secret/).

**Ex:**

```yaml
additionalVars:
  - name: INTERNAL_USERS_FEDERATION_SECRET"
    valueFrom:
      secretKeyRef:
        name: oob-users
        key: internal-users-federation-secret
```

### PORTAL_BACKOFFICE_URL

Endereço do Portal de Back Office. É necessário definir essa variável para
evitar problemas de CORS na comunicação entre o Portal de Back Office e o
Authorization Server do OOB.

**Ex:**

```yaml
additionalVars:
  - name: PORTAL_BACKOFFICE_URL"
    value: "https://instituicao-portal-backoffice.com.br"
```

### BOT_VERIFICATION_ENABLED

Esta variável determina se a verificação de utilização de bots/crawlers está ou
não habilitada. Quando seu valor for definido como `0` a verificação é desativada,
quando definido como `1` é ativada.

**Formato:** `0` ou `1`

**Valor default:** `1`

**Ex:**

```yaml
additionalVars:
  - name: BOT_VERIFICATION_ENABLED
    value: "1"
```

### OOB_ALLOWAUTHCODETOKEN_LIMITDATE

Habilita o bloqueio de refresh tokens de tokens do fluxo authorization code após
o consentimento de pagamento ser consumido. Essa variável deve receber uma data
em que deve começar a realizar esse bloqueio.

O valor padrão é '2023-07-18' conforme especificação.

**Formato:** `yyyy-MM-dd`

**Default:** `2023-07-18`

```yaml
additionalVars:
  - name: OOB_ALLOWAUTHCODETOKEN_LIMITDATE
    value: "2023-07-18"
```

### UNIQUE_PROFILE_START_DATE

Habilita a validação para o período de adaptação do perfil único FAPI
do Open Finance Brasil.

O valor padrão é '2024-03-27' conforme especificação. Para executar os testes
de segurança, deve-se alterar para uma data no passado.

**Formato:** `yyyy-MM-dd`

**Default:** `2024-03-27`

### UNIQUE_PROFILE_MANDATORY_DATE

Habilita o bloqueio dos clients que não estão de acordo com o perfil único FAPI
do Open Finance Brasil.

O valor padrão é '2024-05-22' conforme especificação. Para executar os testes
de segurança, deve-se alterar para uma data no passado.

**Formato:** `yyyy-MM-dd`

**Default:** `2024-05-22`

## Exposição

Como o acesso ao Authorization Server não é feito através do Kong, um ingress
precisa ser criado. [Mais detalhes aqui](../readme.md)

## Ambiente de Certificação

### Senha para autenticação (tela de mock do login)

testeOpenBanking

## SERVER_ORG_ID

Organization ID utilizado no report de PCM do tipo Hybrid Flow, conforme a [especificação do OF](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/37912663/Documenta+o+da+API).

```yaml
additionalVars:
  - name: SERVER_ORG_ID
    value: "6fd64cd7-a56d-4287-b12c-15bacf242f72"
```