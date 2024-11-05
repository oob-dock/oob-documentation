# Instalação do OOB Open Data

## Instalação

A instalação do módulo é feita via Helm Chart

## opentelemetry

Este módulo é instrumentado via [Open Telemetry](https://opentelemetry.io/),
logando informações de trace (quando disponíveis) e as exportando para uma
ferramenta como o [Jaeger](https://www.jaegertracing.io/), que é utilizado na
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

### OOB_CONNECTOR_SERVICEURI

Define o endereço do serviço de obtenção dos dados abertos a ser acionado via
método http GET pela rota padrão quando o conector não for implementado.

Deve ser informado a URI do serviço sem `query parameters`.

Ao final da variável deve-se concatenar o nome da [rota](../../integração-plugin/open-data/readme.md)
a qual se deseja relacionar o serviço. O exemplo a seguir define uma uri para
as rotas `getFundsInvestments` e `getExchangeOnlineRate`:

**Ex:**

```yaml
additionalVars:
  - name: OOB_CONNECTOR_SERVICEURI_GETFUNDSINVESTMENTS
    value: "https://service.bank.com.br/open-data/investiments-funds"
  - name: OOB_CONNECTOR_SERVICEURI_GETEXCHANGEONLINERATE
    value: "https://service.bank.com.br/open-data/exchange-online-rate"
```
