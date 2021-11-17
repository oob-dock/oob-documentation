# Instalação do OOB Payment

## Instalação

A instalação do módulo é feita via Helm Chart

## Configuração

### internalApis/consentServer

Endereço base do serviço de consentimento. Pode ser utilizado um apontamento interno
no Kubernetes

**Ex:** `http://oob-consent`
  
### tokenValidationService

Configuração de validação do token de autenticação

* host: Endereço base do authorization server. Pode ser utilizado um apontamento
interno no Kubernetes

**Ex:** `http://oob-authorization-server`

* path: Caminho do endpoint de introspection

**Ex:** /auth/token/introspection

* clientId: Client criado na configuração do oob-authorization-server

* clientSecret: Secret do client criado na configuração do oob-authorization-server

### signature

Chave privada utilizada para assinar mensagens. Deve conter uma
chave de assinatura.

* certSecretName: Nome do secret que contém a chave privada. Default: "oob-as-keys"
* certSecretKey: Nome da propriedade do secret que contém a chave privada. Default:
"sig.key"
* kid: Identificador da chave (Obtido do diretório de participantes)

Exemplo:

```yaml
  signature:
    certSecretName: "oob-as-keys"
    certSecretKey: "sig.key"
    kid: "uGe7YNnhE83esu86xeqGJMIQi8IamA8FTSaLd1pkXy8"
```

### organisation/id

Deve ser preenchido com o organisationId da instituição cadastrada no diretório
de participantes.
Utilizar o id de sandbox para ambientes não produtivos, e o valor de produção
para ambientes produtivos.

Exemplo:

```yaml
  organisation:
    id: "d7770ef0-6803-4b29-a5ea-4eac0e6cac0a"
```

#### cnpjInitiatorValidation

* directoryRolesUrl: Endereço do diretório de participantes. Ambientes
não-produtivos devem utilizar o endereço de sandbox do diretório de participantes.

| Ambiente | Endereço                                                        |
| -------- | --------------------------------------------------------------- |
| Sandbox  | <https://data.sandbox.directory.openbankingbrasil.org.br/roles> |
| Produção | <https://data.directory.openbankingbrasil.org.br/roles>         |

* cacheTimeout: Tempo de vida definido para armazenamento do cache do diretório
de participantes.

Unidades aceitas:

* S - segundos
* M - minutos
* H - horas
* D - dias

**Ex:**: 5M (cinco minutos)

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

### QUARKUS_LOG_LEVEL

Define o nível de detalhe do log da aplicação. É recomendável ativar o nível DEBUG
somente em ambientes de desenvolvimento/homologação, ou para facilitar a análise
de erros em produção. Em produção é aconselhável utilizar o nível INFO.

**Formato:** `DEBUG`, `INFO`, `TRACE`, `WARNING` ou `ERROR`

**Default:** `INFO`

**Ex:**

```yaml
additionalVars:
  - name: QUARKUS_LOG_LEVEL
    value: "DEBUG"
```

### APIS_VALIDATION_JSON-SCHEMA

Habilita a validação dos objetos de request/response envidados/recebidos pelo plugin
com as specs definidas (afeta performance). Em produção é aconselhável desativar.

**Formato:** `true` ou `false`

**Default:** `false`

**Ex:**

```yaml
additionalVars:
  - name: APIS_VALIDATION_JSON
    value: "true"
```

### APIS_VALIDATION_OPENAPI_ENABLED-REQUEST

Habilita a validação dos objetos de request recebidos pela API com a especificação
do Open Banking Brasil. É aconselhável sempre estar ativo.

**Formato:** `true` ou `false`

**Default:** `true`

**Ex:**

```yaml
additionalVars:
  - name: APIS_VALIDATION_OPENAPI_ENABLED-REQUEST
    value: "true"
```

### APIS_VALIDATION_OPENAPI_ENABLED-RESPONSE

Habilita a validação dos objetos de response devolvidos pela API com a especificação
do Open Banking Brasil (afeta performance). Em produção é aconselhável desativar.

**Formato:** `true` ou `false`

**Default:** `false`

**Ex:**

```yaml
additionalVars:
  - name: APIS_VALIDATION_OPENAPI_ENABLED-RESPONSE
    value: "true"
```
