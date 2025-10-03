# Instalação do OOB Status

## Pré-requisitos

### Virtual Actors

Este módulo utiliza os [virtual actors](https://docs.dapr.io/developing-applications/building-blocks/actors/actors-overview/)
do [Dapr](/deploy/shared-definitions.md#dapr).
A utilização dessa funcionalidade depende da inclusão de uma [state store](https://docs.dapr.io/reference/components-reference/supported-state-stores/)
para manter seus estados de funcionamento. Assim, será necessário incluir esta
configuração. **Importante:** Necessário definir na state store uma propriedade
chamada `actorStateStore` com valor `true`.

Segue um exemplo de definição de um componente de state store que utiliza o Redis.

```yaml
apiVersion: dapr.io/v1alpha1
kind: Component
metadata:
  name: statestore
spec:
  type: state.redis
  version: v1
  metadata:
  - name: redisHost
    value: <host>:<port>
  - name: redisPassword
    value: ""
  - name: actorStateStore
    value: "true"

```

**Atenção:** Este é apenas um **exemplo**. Necessário ajustar a tecnologia desejada
e revisar todas as propriedades configuradas.

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

### dapr/enabled

Habilita o Dapr na aplicação para realizar o envio de eventos.

**Formato:** : `true` ou `false`.

Valor default: `true`

### dapr/appId

Identificador do serviço a ser utilizado caso exista mais de uma instância
para marcas diferentes dentro do mesmo ambiente.
Caso não seja preenchido, utilizará o nome padrão "oob-status".

Ex: `oob-status-cbanco`

### dapr/address

Endereço do sidecar do dapr a ser utilizado pelo serviço.

Ex: `localhost:3501`

### dapr/health/timeoutMs

Tempo, em milissegundos, que o serviço irá esperar até que o sidecar do dapr
esteja disponível.

Ex: `10000`

## dapr/schedulerHostAddress

Essa configuração deve apontar para o serviço de agendamento do Dapr
para habilitar a funcionalidade da API de Jobs do Dapr.  
Para mais detalhes, consulte a [documentação do Dapr](https://docs.dapr.io/reference/arguments-annotations-overview/).

**Exemplo:**

```yaml
env:
  dapr:
    schedulerHostAddress: dapr-scheduler-server.oob.svc.cluster.local:50006
```

## dapr/job/dailyMetric/schedule

Define o agendamento do processamento das métricas diárias para exibição
na API de métricas do OF.

**Formato:** String no formato cron (ignorando segundos, apenas 5 campos) ou expressão para agendamento.Baseado na [API de jobs do Dapr](https://docs.dapr.io/reference/api/jobs_api/).

**Valor default:** `@every 300s` (a cada 300 segundos).

**Exemplo:** Para agendar a execução da coleta de métricas diária a cada 300 segundos:

```yaml
env:
  dapr:
    job:
      dailyMetric:
        schedule: "@every 300s"
```

## dapr/job/incident/schedule

Define o agendamento do processamento do status dos serviços e
dados sobre as requisições recebidas nos endpoints regulatórios.

**Formato:** String no formato cron (ignorando segundos, apenas 5 campos) ou expressão para agendamento.Baseado na [API de jobs do Dapr](https://docs.dapr.io/reference/api/jobs_api/).

**Valor default:** `@every 30s` (a cada 30 segundos).

**Exemplo:** Para agendar a execução da coleta dos dados de APIs regulatórias a 30 segundos:

```yaml
env:
  dapr:
    job:
      incident:
        schedule: "@every 30s"
```

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
