# Instalação do OOF PCM Service

## Pré-requisitos

### Banco de dados

Este módulo requer uma base de dados própria para seu funcionamento. Atualmente
ele oferece suporte à bases Postgres.

### Fila de mensagens

Este módulo consome e processa eventos publicados em uma fila de mensagens.
Portanto, é necessário que exista um *message broker* instalado e configurado
corretamente que possa ser utilizado pelo OOF PCM Service e que seja compatível
com o [Dapr](/deploy/shared-definitions.md#dapr).

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

### Dapr

O módulo OOF PCM Service faz uso do Dapr para realizar a subscrição à eventos
de chamadas de API que devem ser reportadas à Plataforma de Coleta de Métricas
(PCM). Este módulo também aplica (via Helm) um componente do tipo
[cron binding](https://docs.dapr.io/reference/components-reference/supported-bindings/cron/)
utilizado para fazer o envio dos reportes para a PCM periodicamente.

Dado este cenário, a instalação do Dapr bem como aplicação do componente
de *binding* são requisitos necessários para o correto funcionamento deste
módulo.

### Criação do(s) secret(s) para armazenar as chaves privadas

Os certificados e chaves privadas das organizações configuradas no OOF PCM
Service devem ser persistidos de forma segura, é altamente recomendado utilizar
um cofre de senhas para essa persistência. Caso isso não seja possível, secrets
tradicionais podem ser criados no Kubernetes para persistir essas informações.
O procedimento abaixo descreve uma das formas para se criar este secret.

```shell
kubectl -n <NOME_DO_NAMESPACE> create secret generic <NOME_DO_SECRET> --from-file=<CAMINHO_DO_DIRETORIO>
```

Considere, por exemplo que o certificado e chave da organização estejam
previamente criados e armazenados em um diretório local:

```shell
ls /tmp/pcm-service
cert.pem  sig.key
```

Ao executar o comando abaixo, o secret é criado:

```shell
kubectl -n oob create secret generic pcm-organization-tls --from-file=/tmp/pcm-service
secret/pcm-organization-tls created
```

Para descrever o conteúdo do secret o comando abaixo pode ser utilizado:

```shell
apiVersion: v1
data:
  tls.crt: LS0t...tLQ==
  tls.key: LS0t...LS0=
kind: Secret
metadata:
  creationTimestamp: "2023-01-05T13:41:43Z"
  name: pcm-organization-tls
  namespace: oob
  resourceVersion: "535247094"
  selfLink: /api/v1/namespaces/oob/secrets/pcm-organization-tls
  uid: abf5558b-ad5a-478b-8625-bd82328f7f5f
type: Opaque
```

## Configuração adicional

### Header `x-request-start-time`

O OOF PCM Service possui uma funcionalidade extra que permite o uso do header
HTTP `x-request-start-time` para auxiliar no cálculo do tempo de processamento
total de uma requisição. Essa funcionalidade é útil para que possamos ser ainda
mais assertivos no cálculo do tempo total de processamento da requisição a ser
reportada via PCM.

#### Onde definir o header?

Idealmente este header deve ser definido na primeira barreira de entrada de
uma nova requisição no produto. Um bom candidato é um WAF (*Web Application
Firewall*), por exemplo.

O preenchimento e injeção deste header no request **é opcional**. Quando
definido, no momento do cálculo do tempo de processamento do request este
valor será utilizado como o início da requisição. Caso este header não tenha
sido preenchido, o momento da chegada da requisição no API Gateway será utilizado
para o cálculo em questão.

#### Formato

O header `x-request-start-time` deverá ser preenchido no formato Unix epoch,
**preferencialmente em milissegundos**. Os seguintes formatos serão aceitos:

- Milissegundos sem casas decimais. Exemplo: `1671373873945`
- Milissegundos com casas decimais. Exemplo: `1671373873.945`
- Microssegundos ou mais preciso. Exemplo `1671373873945345`. Neste caso o
valor será truncado para milissegundos (13 caracteres).

**Atenção!**

**Não é recomendado enviar o valor em segundos** (10 caracteres) - embora seja
aceito pelo plugin. Neste cenário, caso o evento seja informado em segundos,
no momento do cálculo do tempo de processamento total do request podemos
adicionar até 1 segundo a mais no tempo de resposta informado no evento por
conta do arredondamento da unidade de medida de tempo.

**Garantir que o formato enviado está na lista de formatos aceitos acima!**
Caso seja informado em algum outro formato haverá problema na criação do evento
e portanto a requisição não será reportada à PCM. Isso acarretará em
descumprimento das regras junto à governança do Open Finance Brasil.

## Instalação

A instalação do módulo é feita via Helm Chart.

## Configuração

### db

Configuração de acesso ao banco.

* `host`: Host do banco.
* `port`: Porta do banco (opcional). **Default:** `5432`.
* `name`: Nome do banco.
* `schema`: Schema do banco (opcional). **Default:** `public`.
* `username`: Nome do usuário de acesso ao banco.
* `password`: Senha do usuário de acesso ao banco.

**Exemplo:**

```yaml
  db:
    host: "oof_pcm_service"
    port: 5432
    name: "oof_pcm_service"
    schema: "public"
    username: "oof_pcm_service"
    password: "oof_pcm_service"
```

### dapr

Configurações relacionadas ao Dapr.

* `dapr.enabled`: Habilita o Dapr na aplicação para realizar o consumo de
eventos.
Possíveis valores: `true` ou `false`. **Default:** `true`.
* `dapr.pubSubId`: Identificador do componente de pub/sub do Dapr a ser
utilizado.

**Exemplo:**

```yaml
  dapr:
    enabled: "true"
    pubSubId: "pcm-event-pub-sub"
```

### brand.ids

Identificador(es) da(s) marca(s) da instalação, separados por vírgulas.

**Exemplo 1:**

```yaml
  brand:
    ids: "marca-unica"
```

**Exemplo 2:**

```yaml
  brand:
    ids: "marca1,marca2"
```

### softwareStatements

Lista de *software statements* composta por: certificado BRCAC, chave privada e
identificador do cliente. Essas informações são necessárias para que o serviço
consiga obter o token de acesso que possibilita o envio de reportes para a PCM.

* `certSecretName`: Nome do secret que contém o(s) certificado(s) BRCAC.
* `certSecretKey`: Nome da propriedade do secret que contém o certificado
BRCAC.
* `privateKeySecretName`: Nome do secret que contém a(s) chave(s) privada(s).
* `privateKeySecretKey`: Nome da propriedade do secret que contém a chave
privada.
* `clientId`: Identificador(es) do(s) cliente(s) no diretório de participantes.
* `proxyUrl`: Url opcional para o caso de uso de proxy para endpoints mtls (token endpoint).
O parametro **%s** será substituido pela url que seria chamada originalmente e portanto deve estar presente na configuração.
* `proxyOrg`: Configuração opcional associado ao uso de proxy em caso do certificado não possuir
orgId.

**Exemplo:**

```yaml
  softwareStatements:
    - certSecretName: "pcm-organization-tls"
      certSecretKey: "tls.crt"
      privateKeySecretName: "pcm-organization-tls"
      privateKeySecretKey: "tls.key"
      clientId: "0b4841d2-773f-4286-92a0-611f6d066545"
    - certSecretName: "pcm-organization-tls"
      certSecretKey: "tls2.crt"
      privateKeySecretName: "pcm-organization-tls"
      privateKeySecretKey: "tls2.key"
      clientId: "1dfbae86-ce9b-41d9-bf29-832317f26b31"
      proxyUrl: "https://proxyorg?originalUrl=%s"
      proxyOrg: "e6d4b80f-edd2-4800-a94a-ff7a91bf2f4c"
```

### pcm

Configurações relativas à PCM.

* `apiBaseUrl`: Endereço base das APIs da PCM.
* `authBaseUrl`: Endereço base da API de autenticação da PCM.

Maiores detalhes sobre os endereços de cada ambiente podem ser conferidos
[neste link](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/37945515/Manual+de+Integra+o#Endere%C3%A7os-base).

**Exemplo:**

```yaml
  pcm:
    apiBaseUrl: "https://api.pcm.sandbox.openfinancebrasil.org.br"
    authBaseUrl: "https://auth.pcm.sandbox.openfinancebrasil.org.br"
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

### REPORT_PCM_BATCH_DELAY

Delay para a coleta dos eventos em batch para envio de pcm em minutos.
Valor default é 60 minutos.

**Exemplo:**

```yaml
additionalVars:
  - name: REPORT_PCM_BATCH_DELAY
    value: "60"
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

**Importante**: Atualmente esta configuração só está disponível para
os eventos de monitoramento de métricas internas.

### DAPR_BULK_SUBSCRIBE_MAX_AWAITING_DURATION_MS

Tempo máximo de espera em milissegundos antes que um lote de mensagens seja
entregue pelo Dapr para a aplicação. Valor padrão definido é `1000`.

**Exemplo:**

```yaml
additionalVars:
  - name: DAPR_BULK_SUBSCRIBE_MAX_AWAITING_DURATION_MS
    value: "1000"
```

**Importante**: Atualmente esta configuração só está disponível para
os eventos de monitoramento de métricas internas.

### METRIC_MAX_TIME_SECONDS

Tempo máximo de atraso permitido, em segundos, para que o evento seja
considerado para emissão da métrica. Valor padrão definido é `60` segundos.

**Exemplo:**

```yaml
additionalVars:
  - name: METRIC_MAX_TIME_SECONDS
    value: "60"
```

### DAPR_ACTOR_TYPE

Define o sufixo que será usado nos tipos dos actors utilizados por este módulo
que serão instanciados no ambiente, tipicamente o nome do próprio ambiente;
se vazio nada é acrescentado, ou seja, usa-se o tipo do actor ex:
`pcmDispatcherBatch`. Isso é usado para que o dapr instancie um actor por
ambiente.

**Exemplo:**

```yaml
additionalVars:
  - name: DAPR_ACTOR_TYPE
    value: "Qa"
```

### SOFTWARE_STATEMENT_N_PROXY_URL

O **N** deve corresponder a posição do software statement feita na configuração do helm,
sendo a primeira posição de valor 0.

Configura a url usada pra comunicação com um proxy para endpoints mtls (no momento apenas o de token).
É opcional, a presença dessa variável habilitará o uso do proxy.

Deve ser configurada já com a query string que será usada pelo proxy, deixando o valor como **%s**,
este será substituído pela url orginal, exemplo:

```yaml
additionalVars:
  - name: SOFTWARE_STATEMENT_0_PROXY_URL
    value: "https://proxy.exemplo.com?itproxy_url=%s"
```

### SOFTWARE_STATEMENT_N_PROXY_ORG
 
O **N** deve corresponder a posição do software statement feita na configuração do helm,
sendo a primeira posição de valor 0.

Configura a org do software statement para uso no proxy caso o certificado usado
não contenha a identificação da organização.

```yaml
additionalVars:
  - name: SOFTWARE_STATEMENT_0_PROXY_ORG
    value: "afab9837-1128-4b96-81e8-87f1c6f11597"
```