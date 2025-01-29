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

  - **host**: Endereço base do authorization server. Pode ser utilizado um apontamento
interno no Kubernetes

    > **Ex:** `http://oob-authorization-server`

  - **path**: Caminho do endpoint de introspection

    > **Ex:** /auth/token/introspection

  - **clientId**: Client criado na configuração do oob-authorization-server

  - **clientSecret**: Secret do client criado na configuração do oob-authorization-server

  - **jwksPath**: Non-regulatory Authorization Server JWKS endpoint path - [NON FAPI](../oob-authorization-server/readme.md#authnonfapibasepath)

    > **Ex:** `/auth-nonFapi/jwks`

### signature

Chave privada utilizada para assinar mensagens. Deve conter uma chave de assinatura.
Vide a [definição](../shared-definitions.md#formatos-de-chave-privada-suportados)
para detalhes sobre os formatos de chaves suportados.

* certSecretName: Nome do secret que contém a chave privada. Default: "oob-as-keys"
* certSecretKey: Nome da propriedade do secret que contém a chave privada. Default:
"sig.key"
* kid: Identificador da chave (Obtido do diretório de participantes)
* passphraseSecretName: Nome do secret que contém a senha para a chave privada
  (opcional)
* passphraseSecretKey: Nome da propriedade do secret que contém a senha para a
  chave privada (opcional)

As propriedades `passphraseSecretName` e `passphraseSecretKey` só devem ser
definidas para chaves criptografadas. Se elas não forem informadas assume-se que
as chaves são abertas.

Exemplo:

```yaml
  signature:
    certSecretName: "oob-as-keys"
    certSecretKey: "sig.key"
    passphraseSecretName: "oob-as-keys"
    passphraseSecretKey: "sig.key.passphrase"
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

#### cron/scheduled/participantDirectory

* Aplica um `cron binding` para atualização das roles do diretório
de participantes de forma periódica.

* O valor definido é referente ao intervalo em que é feito a chamada para
a API do diretório de participantes.

Unidades aceitas:

* S - segundos
* M - minutos
* H - horas
* D - dias

Exemplo:

```yaml
  cron:
    scheduled:
      participantDirectory: 240M
```

## opentelemetry

Este módulo é instrumentado via [Open Telemetry](https://opentelemetry.io/),
logando informações de trace (quando disponíveis) e as exportando para uma
ferramenta como o [Tempo](https://grafana.com/oss/tempo/), que é utilizado na
visualização e análise de rastreamento distribuído dos requests realizados.

Configurações:

* `opentelemetry.tracer.exporter.url.grpc`: Endereço da ferramenta de
análise. **Importante:** Esta variável deverá estar preenchida com o valor
do endereço **GRPC** disponibilizado pela ferramenta para receber as
informações de rastreamento.
* `opentelemetry.sample.rate`: Define a taxa de amostragem (sampling rate)
para o rastreamento distribuído, ou seja, a proporção de solicitações que
serão coletadas e enviadas para análise. Possíveis valores: `0` a `1`. Por
exemplo, um valor de `0.5` significa que 50% dos requests serão amostrados.
**Importante:** Caso deseje desabilitar totalmente o envio de traces para a
ferramenta receptora basta definir o valor desta variável como `0`.

Exemplo:

```yaml
env:
  opentelemetry:
    tracer:
      exporter:
        url:
          grpc: "http://127.0.0.1:4317"
    sample:
      rate: "1"
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

### OOB_ALLOWAUTHCODETOKEN_LIMITDATE

Habilita o bloqueio de chamadas GET e PATCH de pagamento utilizando o token
do fluxo authorization code. Essa variável deve receber uma data em que deve
começar a realizar esse bloqueio.

O valor padrão é '2023-07-18' conforme especificação.

**Formato:** `yyyy-MM-dd`

**Default:** `2023-07-18`

```yaml
additionalVars:
  - name: OOB_ALLOWAUTHCODETOKEN_LIMITDATE
    value: "2023-07-18"
```

### CAMEL_CONNECTOR_MTLS_CERT

Utilizado para definir o certificado mtls para chamadas ao endpoint de legado.

**IMPORTANTE**: Caso planeje utilizar o camelUtils de makePostCall and makeGetCall,
essa variável se torna obrigatória.

**Ex:**

Colocar o certificado completo, apenas uma parte da chave foi colocada como exemplo.

```yaml
additionalVars:
  - name: CAMEL_CONNECTOR_MTLS_CERT
    value: -----BEGIN CERTIFICATE-----\nMIIEyzCCArMCAQEwDQYJKoZIhvcNAQELBQAwgasxCzAJBgNVBAYTAkJSMRIwEAYD(...)\n-----ENDCERTIFICATE-----
```

### CAMEL_CONNECTOR_MTLS_KEY

Utilizado para definir a chave privada mtls para chamadas ao endpoint de legado.

**IMPORTANTE**: Caso planeje utilizar o camelUtils de makePostCall and makeGetCall,
essa variável se torna obrigatória.

**Ex:**

Colocar a chave completa, apenas uma parte da chave foi colocada como exemplo.

```yaml
additionalVars:
  - name: CAMEL_CONNECTOR_MTLS_KEY
    value: -----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDFjalN4Lvam2AX(...)\n-----END PRIVATE KEY-----
```
