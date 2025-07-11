# Instalação do OOB Status

## Instalação

A instalação do módulo é feita via Helm Chart

## Configuração

### db

Configuração de acesso ao banco

* name: Nome da base
* username: Nome do usuário de acesso ao banco
* password: Senha do usuário de acesso ao banco
* host: Host do banco

### Execução de scripts DDL

Vide a [definição](../shared-definitions.md#scripts-ddl)

### liquibase/contexts

Vide a [definição](../shared-definitions.md#liquibase-contexts)

### services

Configuração dos endereços dos serviços monitorados/utilizados pela API

* prometheus/baseAddress: Endereço base do prometheus. Pode ser utilizado um apontamento
interno no Kubernetes

**Ex:** `http://prometheus-server`

* openData/baseAddress: Endereço base da API de produtos e serviços e canais de atendimento
(fase 1). Pode ser utilizado um apontamento interno no Kubernetes

**Ex:** `http://oob-open-data`

* financialData/baseAddress: Endereço base da API de dados financeiros
(fase 2). Pode ser utilizado um apontamento interno no Kubernetes

**Ex:** `http://oob-financial-data`

* payment/baseAddress: Endereço base da api de pagamentos
(fase 3). Pode ser utilizado um apontamento interno no Kubernetes

**Ex:** `http://oob-payment`

* consent/baseAddress: Endereço base da API de consentimento. Pode ser utilizado
um apontamento interno no Kubernetes

**Ex:** `http://oob-consent`

Configuração dos endereços base dos serviços acessíveis externamente mtls ou não

* publicFqdn: Endereço externo base da API sem mtls

**Ex:** `obb.qa.oob.opus-software.com.br`

* publicFqdnMtls: Endereço externo base da API com mtls

**Ex:** `mtls-obb.qa.oob.opus-software.com.br`

### features

Vide a [definição](../shared-definitions.md#suporte-a-features-do-opus-open-finance)

### plugins/metrics/brandId

Vide a [definição](../shared-definitions.md#brand-id)

### oidc

Vide a [definição](../shared-definitions.md#oidc)

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

### LOGGING_LEVEL_ROOT

Define o nível de detalhe do log da aplicação. É recomendável ativar o nível DEBUG
somente em ambientes de desenvolvimento/homologação, ou para facilitar a análise
de erros em produção. Em produção é aconselhável utilizar o nível INFO.

**Formato:** `DEBUG`, `INFO`, `TRACE`, `WARNING` ou `ERROR`

**Default:** `INFO`

**Ex:**

```yaml
additionalVars:
  - name: LOGGING_LEVEL_ROOT
    value: "DEBUG"
```

### LOGGING_LEVEL_INITIALIZATION

Define o nível do log das mensagens de inicialização do serviço.
Em produção é aconselhável ser level = `WARN`.

**Valores possíveis:** `DEBUG`, `INFO`, `TRACE`, `WARNING` ou `ERROR`

Valor default: `WARN`

**Ex:**

```yaml
additionalVars:
  - name: LOGGING_LEVEL_INITIALIZATION
    value: "WARN"
```

### DAEMON_INCIDENT_ENABLED

Indica se o daemon de incidentes está habilitado. Em produção deve estar ativado.

**Formato:** `true` ou `false`

**Default:** `true`

**Ex:**

```yaml
additionalVars:
  - name: DAEMON_INCIDENT_ENABLED
    value: "true"
```
