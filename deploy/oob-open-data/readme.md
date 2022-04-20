# Instalação do OOB Open Data

## Instalação

A instalação do módulo é feita via Helm Chart

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
