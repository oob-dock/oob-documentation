# Instalação do OOF MQD Dispatcher

## Pré-requisitos

### Fila de mensagens

Este módulo consome e processa eventos publicados em uma fila de mensagens.
Portanto, é necessário que exista um *message broker* instalado e configurado
corretamente que possa ser utilizado pelo OOF PCM Service e que seja compatível
com o [Dapr](/deploy/shared-definitions.md#dapr).

### Dapr

O módulo OOF MQD Dispatcher  faz uso do Dapr para realizar a subscrição à eventos
de chamadas de API que devem ser reportadas ao Motor de Qualidade de Dados
(MQD). Este módulo também aplica (via Helm) um componente do tipo
[resiliency](https://docs.dapr.io/reference/resource-specs/resiliency-schema/)
utilizado para que as mensagens possuam uma política de retentativas de
processamento em caso de falha em seu consumo por problemas diversos
incluindo falhas de comunicação entre serviços.

Dado este cenário, a instalação do Dapr bem como aplicação do componente
de *resiliency* são requisitos necessários para o correto funcionamento deste
módulo.

## Instalação

A instalação do módulo é feita via Helm Chart.

## Configuração

### dapr

Configurações relacionadas ao Dapr.

* `dapr.enabled`: Habilita o Dapr na aplicação para realizar o consumo de
eventos.
Possíveis valores: `true` ou `false`. **Default:** `true`.

* `dapr.retryPubSubId`: Identificador do componente de pub/sub que implementa
políticas de retentativa. Todas os eventos consumidos por este módulo
possuem suporte à reprocessamento em caso de falhas, sendo assim o componente
pub/sub a ser utilizado pelo módulo como um todo deve ser o componente que
oferece suporte à retentativas.

**Exemplo:**

```yaml
  dapr:
    enabled: "true"
    retryPubSubId: "pub-sub-retry"
```

### organisation.ids

Identificador(es) da(s) organização(ções) para as quais o módulo MQD Dispatcher
irá receber os eventos e enviar os relatórios para o módulo MQD Client. Os
valores devem ser separados por vírgula.

**Exemplo 1:**

```yaml
  brand:
    ids: "organizacaoUnica"
```

**Exemplo 2:**

```yaml
  brand:
    ids: "organizacao1,organizacao2"
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

### LOG_LEVEL

Define qual o nível de mensagens será logado pela aplicação. Os possíveis
valores desta configuração são: `debug`, `info`, `warn`, `erro` e `fatal`.

* `debug`: Exibe mensagens dos níveis `debug`, `info`, `warn`, `error` e `fatal`.
* `info`: **Valor default.** Exibe mensagens dos níveis `info`, `warn`,
`error` e `fatal`.
* `warn`: Exibe mensagens dos níveis `warn`, `error` e `fatal`.
* `error`: Exibe mensagens dos níveis `error` e `fatal`.
* `fatal`: Exibe mensagens apenas do nível `fatal`.

**Exemplo:**

```yaml
additionalVars:
  - name: LOG_LEVEL
    value: "debug"
```

### DAPR_BULK_SUBSCRIBE_MAX_MESSAGES_COUNT

Define o número máximo de mensagens entregues de uma vez pelo Dapr para a
aplicação. Valor padrão definido é `10`.

**Exemplo:**

```yaml
additionalVars:
  - name: DAPR_BULK_SUBSCRIBE_MAX_MESSAGES_COUNT
    value: "10"
```

### DAPR_BULK_SUBSCRIBE_MAX_AWAITING_DURATION_MS

Tempo máximo de espera em milissegundos antes que um lote de mensagens seja
entregue pelo Dapr para a aplicação. Valor padrão definido é `1000`.

**Exemplo:**

```yaml
additionalVars:
  - name: DAPR_BULK_SUBSCRIBE_MAX_AWAITING_DURATION_MS
    value: "1000"
```

### MQD_CLIENT_REQUEST_TIMEOUT_SECONDS

Tempo máximo em segundos em que a aplicação MQD Dispatcher irá aguardar uma
resposta da aplicação MQD Client ao enviar uma requisição com o conteúdo de
uma chamada de API que deve ser reportada. Valor padrão definido é `5`.

**Exemplo:**

```yaml
additionalVars:
  - name: MQD_CLIENT_REQUEST_TIMEOUT_SECONDS
    value: "5"
```
