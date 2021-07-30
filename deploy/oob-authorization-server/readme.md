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
* port: Porta do banco
* type: Tipo do banco. Default: "postgres"
  
### api/baseUrlOobConsents

Endereço do serviço de consentimento

### customer/federationJwksUrl

Endereço onde o serviço deve buscar o JWKS com a chave pública para validar os
tokens JWT emitidos para clientes do banco.

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
* clientSecretKey: Nome da propriedade do secret que contém o secret de acesso do cliente
* clientId: ClientId de acesso do cliente
* redirectUris: URLs do cliente autorizadas para redirect em fluxos de autenticação web
* responseTypes: ResponseType para o cliente
* grantTypes: Grant types permitidos para o cliente
* tokenEndpointAuthMethod: Tipo de autorização para o cliente
* allowedScopes: Escopos permitidos para o cliente

Exemplo:

```yaml
  clients:
    - clientSecretName: "oob-as-clients"
      clientSecretKey: "backend-x-secret"
      clientId: "backend-x"
      redirectUris: ""
      responseTypes: ""
      grantTypes: "client_credentials"
      tokenEndpointAuthMethod: "client_secret_post"
      allowedScopes: "openid"
```

Pelo menos um cliente deve ser configurado no authorization server para ser
usado nos módulos que fazem introspection do token.
