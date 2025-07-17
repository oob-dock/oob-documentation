# Instalação do OOB Consent

## Pré-requisitos

### Fila de mensagens

Este módulo produz eventos a serem publicados em uma fila de mensagens.
Portanto, é necessário que exista um *message broker* instalado e configurado
corretamente que possa ser utilizado pelo OOB Consents e que seja compatível
com o [Dapr](/deploy/shared-definitions.md#dapr).

## Instalação

A instalação do módulo é feita via Helm Chart

## Configuração

### db

Configuração de acesso ao banco

* name: Nome da base
* username: Nome do usuário de acesso ao banco
* password: Senha do usuário de acesso ao banco
* kind: Tipo do banco. Default: "postgres"
* dialect: Dialeto que faz a tradução das instruções referentes ao
 banco de dados. Default: "org.hibernate.dialect.PostgreSQLDialect"
* host: Host do banco

Exemplo:

```yaml
  db:
    name: "api_consent"
    username: "api_consent"
    password: "api_consent"
    kind: "postgresql"
    dialect: "org.hibernate.dialect.PostgreSQLDialect"
    host: "postgres.local"
```

### Suporte a réplica de leitura

O OOB Consent suporta utilização de uma réplica de leitura do banco de
dados. A réplica necessita das mesmas configurações da base, mas com o
identificador *read-only*, conforme exemplo a seguir:

```yaml
  db:
    read-only:
      name: "api_consent"
      username: "readonly-user"
      password: "readonly-password"
      kind: "postgresql"
      host: "readonly.postgres.local"
```

Para ativar a utilização da réplica de leitura, a propriedade feature/readReplica/enabled
deve ter seu valor alterado para "1", conforme exemplo:

```yaml
  feature:
    readReplica:
      enabled: "1"
```

**Importante**: Com a ativação da réplica de leitura, todas as configurações do
Quarkus relacionadas a base de dados devem incluir o nome **base** para a instância
principal e **read-only** para a réplica.
Por exemplo, caso seja necessário alterar o pool de conexões das bases de dados, deve-se
adicionar a configuração da seguinte forma:

```yaml
  # Configuração da instância principal (base)
  - name: quarkus.datasource.base.jdbc.max-size
    value: 100
  # Configuração da réplica de leitura
  - name: quarkus.datasource.read-only.jdbc.max-size
    value: 110
```

### Execução de scripts DDL

Vide a [definição](../shared-definitions.md#scripts-ddl)

### liquibase/contexts

Vide a [definição](../shared-definitions.md#liquibase-contexts)

### oidc

Vide a [definição](../shared-definitions.md#oidc)

### signature

Chave de assinatura para mensagens. Devem ser utilizados os mesmos valores do
certificado do authorization server com use = `sig`.
Vide a [definição](../shared-definitions.md#formatos-de-chave-privada-suportados)
para detalhes sobre os formatos de chaves suportados.

* kid: Identificador da chave (Obtido do diretório de participantes)
* certSecretName: Nome do secret que contém a chave privada
* certSecretKey: Nome da propriedade do secret que contém a chave privada
* passphraseSecretName: Nome do secret que contém a senha para a chave privada
  (opcional)
* passphraseSecretKey: Nome da propriedade do secret que contém a senha para a
  chave privada (opcional)

As propriedades `passphraseSecretName` e `passphraseSecretKey` só devem ser
definidas para chaves criptografadas. Se elas não forem informadas assume-se que
as chaves são abertas.

Exemplo:

```yaml
    kid: "MPguImG0DEQwu9ZUvwDzw_0xybh1yAETY9VBLdYXibo"
    certSecretName: "oob-as-keys"
    certSecretKey: "sig.key"
    passphraseSecretName: "oob-as-keys"
    passphraseSecretKey: "sig.key.passphrase"
```

### organisation/id

Deve ser preenchido com o organisationId da instituição cadastrada no diretório
de participantes.

Utilizar o id de sandbox para ambientes não produtivos e o valor de produção para
ambientes produtivos.

Essa propriedade é do tipo UUID.

Ex: `7a176f46-75e6-454f-8d04-408d6beaee37`

### application/encryption/key

Deve ser preenchido com a chave a ser utilizada para criptografar os dados sensíveis
na base de dados. Deve ser utilizada uma chave segura, recomenda-se que possua
256 bits, e que o formato dos valores seja hexadecimal.

> **Atenção**
>
> `É necessário que a mesma seja armazenada de forma segura, pois caso
seja alterada para uma valor diferente do estabelecido inicialmente em produção
os dados sensíveis dos consentimentos anteriores ficarão inacessíveis.`

Ex: `DC28A6ED862722859DD78F4DBF664BBF447C7DC43085C151C7680A80BBF316D4`

### application/encryption/salt

Deve ser preenchido com o salt a ser utilizado para gerar a chave de de criptografia
em conjunto com a chave informada no item anterior; recomenda-se que possua 64 bits,
e que o formato dos valores seja hexadecimal.

> **Atenção**
>
> `É necessário que a mesma seja armazenada de forma segura, pois caso
seja alterada para uma valor diferente do estabelecido inicialmente em produção
os dados sensíveis dos consentimentos anteriores ficarão inacessíveis.`

Ex: `6598C77E29BB822B`

### consent/external/id

Utilizado para definir o id referente ao consentId. O consentId é o identificador
único do consentimento e deverá ser um URN - Uniform Resource Name.

Considerando a string urn:amazingbank como exemplo para consentId temos:

* o namespace(urn), conforme definido na [RFC8141](https://datatracker.ietf.org/doc/html/rfc8141)

* o identificador associado ao namespace da instituição transmissora (amazingbank)

Ex: `urn:amazingbank`

### payments/basePath

Utilizado para definir a uri base do serviço de pagamentos.
Deve ser formado pelo protocolo e host seguido do path `/open-banking`.

Valor default: `http://oob-payment/open-banking`

### fidoServer/basePath

Utilizado para definir a uri base do Fido Server.
Deve ser formado pelo protocolo e host.

Valor default: `http://oof-fido-server`

### dapr/enabled

Habilita o Dapr na aplicação para realizar o envio de eventos.

**Formato:** : `true` ou `false`.

Valor default: `true`

### dapr/daprPubsubId

Identificador do componente de pub/sub do Dapr a ser utilizado.

Ex: `oob-consent-pub-sub`

### dapr/daprRetryPubsubId

Identificador do componente de pub/sub que implementa políticas de retentativa.

Quando um determinado tópico de mensagens precisar de suporte a reprocessamento
de mensagens, este componente será utilizado.

Ex: `oob-consent-pub-sub-retry`

### dapr/appId

Identificador do serviço a ser utilizado caso exista mais de uma instância
para marcas diferentes dentro do mesmo ambiente.
Caso não seja preenchido, utilizará o nome padrão "oob-consent".

Ex: `oob-consent-cbanco`

### brandId

Deve ser obrigatoriamente preenchida com a marca associada a instância do serviço.
Para mais detalhes, consulta a [definição](../shared-definitions.md#brand-id).

Ex: `cbanco`

### dapr/stateStore/introspection/name

Nome da state store a ser utilizada para cache do introspection dos tokens.

Deve receber o mesmo valor atribuído ao [Authorization Server](../oob-authorization-server/readme.md#state-store) na propriedade de mesmo nome.

Ex: `token-state-store`


## dapr/stateStore/accountHolder

Este módulo suporta uso de cache para verificação de correntistas utilizando
uma das state stores [suportadas pelo dapr](https://docs.dapr.io/reference/components-reference/supported-state-stores/).

**Importante**: A state store escolhida deve, obrigatóriamente, suportar TTL.

Configurações:

* name: Nome dado ao componente da state store
* type: Tipo a ser preenchido conforme documentação do [dapr](https://docs.dapr.io/operations/components/setup-state-store/).
* version: Versão a ser utilizada. Por padrão, será utilizada *v1*.
* ttlInSeconds: Tempo de vida da state store em segundos.
* connectionMetadata: Metadados necessários para conexão com a state
store desejada a serem incluídos no formato name/value, conforme exemplo.

**Exemplo:**

```yaml
env:
  dapr:
    stateStore:
      accountHolder:
        name: documentStateStore
        type: state.redis
        version: v1
        ttlInSeconds: 3600
        connectionMetadata:
          - name: redisHost
            value: localhost:6379
          - name: redisPassword
            value: password
```

**Importante:** Para habilitar o uso de cache, deve-se ativar a *feature flag* [accountHolder](#featureaccountholdercacheenabled)

## dapr/schedulerHostAddress

Essa configuração deve apontar para o serviço de agendamento do Dapr para habilitar a funcionalidade da API de Jobs do Dapr.  
Para mais detalhes, consulte a [documentação do Dapr](https://docs.dapr.io/reference/arguments-annotations-overview/).

**Exemplo:**

```yaml
env:
  dapr:
    schedulerHostAddress: dapr-scheduler-server.oob.svc.cluster.local:50006
```

## dapr/job/pcm/schedule

Define o agendamento do relatório de estoque de consentimentos PCM.

**Formato:** String no formato cron (ignorando segundos, apenas 5 campos) ou expressão para agendamento.Baseado na [API de jobs do Dapr](https://docs.dapr.io/reference/api/jobs_api/).

**Valor default:** `disabled` (desativado).

**Exemplo:** Para agendar a execução do relatório diariamente às 1h da manhã se utc (recomendado):

```yaml
env:
  dapr:
    job:
      pcm:
        schedule: "0 4 * * *"
```

## dapr/job/activeConsents/schedule

Utilizado para definir o agendamento da busca de consentimentos ativos no authorization server.

**Formato:** String no formato cron (ignorando segundos, apenas 5 campos) ou expressão para agendamento, baseado na [API de jobs do Dapr](https://docs.dapr.io/reference/api/jobs_api/).

**Valor default:** `disabled` (desativado)

**Exemplo:** Para agendar a execução do job a cada 30 minutos:

```yaml
env:
  dapr:
    job:
      activeConsents: "@every 30m"
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
      rate: 1
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

Utilizado para definir o nível do log da aplicação. Em produção é aconselhável
ser level = `INFO`.

**Valores possíveis:** `OFF`, `FATAL`, `ERROR`, `WARN`, `INFO`, `DEBUG`, `TRACE`,
`ALL`

Valor default: `INFO`

**Ex:**

```yaml
additionalVars:
  - name: QUARKUS_LOG_LEVEL
    value: "INFO"
```

### QUARKUS_LOG_CONSOLE_LEVEL

Utilizado para definir o nível do log para o console da aplicação.

**Valores possíveis:** `OFF`, `FATAL`, `ERROR`, `WARN`, `INFO`, `DEBUG`, `TRACE`,
`ALL`

Valor default: `INFO`

**Ex:**

```yaml
additionalVars:
  - name: QUARKUS_LOG_CONSOLE_LEVEL
    value: "INFO"
```

### QUARKUS_LOG_INITIALIZATION_LEVEL

Define o nível do log das mensagens de inicialização do serviço.
Em produção é aconselhável ser level = `WARN`.

**Valores possíveis:** `DEBUG`, `INFO`, `TRACE`, `WARNING` ou `ERROR`

Valor default: `WARN`

**Ex:**

```yaml
additionalVars:
  - name: QUARKUS_LOG_INITIALIZATION_LEVEL
    value: "WARN"
```

### QUARKUS_LOG_CONSOLE_JSON

Utilizado para definir se o log deve ser no formato JSON.

**Formato:** `true` ou `false`

Valor default: `true`

**Ex:**

```yaml
additionalVars:
  - name: QUARKUS_LOG_CONSOLE_JSON
    value: "true"
```

### APPLICATION_CERTIFICATION_MOCK_RESOURCES_API_TEST_UNAVAILABLE_V2

Utilizado para habilitar os recursos mockados com status UNAVAILABLE, necessários
para o teste de certificação de fase 2 v2 de nome *resources-api-test-unavailable-v2*.

**IMPORTANTE**: Essa funcionalidade deve ser habilitada apenas em ambientes de desenvolvimento/homologação.

**Formato:** `true` ou `false`

Valor default: `false`

**Ex:**

```yaml
additionalVars:
  - name: APPLICATION_CERTIFICATION_MOCK_RESOURCES_API_TEST_UNAVAILABLE_V2
    value: "true"
```

### APPLICATION_VALIDATION_CURRENCY

Utilizado para definir o código da moeda nacional segundo modelo ISO-4217.

Valor default: `BRL`

**Ex:**

```yaml
additionalVars:
  - name: APPLICATION_VALIDATION_CURRENCY
    value: "BRL"
```

### APPLICATION_TEDTEF_ENABLED

Utilizado para habilitar ou desabilitar consentimentos dos tipos TED/TEF.

**Formato:** `true` ou `false`

Valor default: `false`

**Ex:**

```yaml
additionalVars:
  - name: APPLICATION_TEDTEF_ENABLED
    value: "false"
```

### APPLICATION_WEBHOOK_PAYMENT_ENABLED

Utilizado para habilitar ou desabilitar o envio de webhook de pagamentos.

**Formato:** `true` ou `false`

Valor default: `false`

**Ex:**

```yaml
additionalVars:
  - name: APPLICATION_WEBHOOK_PAYMENT_ENABLED
    value: "true"
```

### CONSENT_PERMISSIONS

Utilizado para definir a lista de permissões suportadas pela instituição.

**IMPORTANTE**: Caso sejam utilizados os serviços de `DATA_SHARING`, essa
variável se torna obrigatória.

**Ex:**

Exemplo de configuração para uma instalação que suporta apenas compartilhamento
de dados cadastrais:

```yaml
additionalVars:
  - name: CONSENT_PERMISSIONS
    value: CUSTOMERS_PERSONAL_IDENTIFICATIONS_READ,CUSTOMERS_PERSONAL_ADITTIONALINFO_READ,CUSTOMERS_BUSINESS_IDENTIFICATIONS_READ,CUSTOMERS_BUSINESS_ADITTIONALINFO_READ,RESOURCES_READ
```

### CONSENT_DEBTORACCOUNT_IBGETOWNCODE

Configuração utilizada no contexto de Pagamentos Automáticos. Utilizado para
indicar o código do município de cadastro do usuário pagador na instituição
detentora. Caso a instituição possua todos os cadastros no mesmo município esta
variável pode ser utilizada. No entanto, caso a instituição possua várias
localidades esta informação deverá vir do sistema legado.

**Ex:**

```yaml
additionalVars:
  - name: CONSENT_DEBTORACCOUNT_IBGETOWNCODE
    value: "3550308"
```

### CONSENT_CUSTOMERS_ENABLED

Utilizado para habilitar ou desabilitar o retorno de lista vazia na API de
resources v3.

**IMPORTANTE**: Essa funcionalidade deve ser habilitada somente para instituições
que transmitem apenas dados cadastrais.

**Formato:** `true` ou `false`

Valor default: `false`

**Ex:**

```yaml
additionalVars:
  - name: CONSENT_CUSTOMERS_ENABLED
    value: "false"
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

### APPLICATION_FEATURE_CONSENT_ACCEPTANCE_CREDITOR

Utilizado para definir se retorna ou não o campo **creditor** no command do authorization-server
para fluxos app2as.

**IMPORTANTE**: Essa funcionalidade deve ser desabilitada após a instituição
se adaptar ao novo formato que usa **creditors** (array).

**Formato:** `true` ou `false`

Valor default: `true`

```yaml
additionalVars:
  - name: APPLICATION_FEATURE_CONSENT_ACCEPTANCE_CREDITOR
    value: "true"
```

### APPLICATION_ENCRYPTION_CHARSET

Utilizado para definir o charset usado na criptografia dos campos na base de dados.

Valor default: `UTF-8`

### ENROLLMENT_PERMISSIONS

Utilizado para definir a lista de permissões de vínculo de dispositivo suportadas pela instituição.

**IMPORTANTE**: Obrigatório caso a instituição utilize JSR (Jornada Sem Redirecionamento)

**Ex:**

Exemplo de configuração para uma instalação que suporta JSR para pagamento v4:

```yaml
additionalVars:
  - name: ENROLLMENT_PERMISSIONS
    value: PAYMENTS_INITIATE
```

#### SSL_CERTIFICATE_HEADER_NAME

Define qual será o nome do header utilizado que será enviado o certificado
mTLS do client que fez o request. No contexto de JSR, esse certificado
é utilizado para validar o campo Rellying Party ID enviado durante o
registro FIDO.

**Default:** `X-SSL-Client-Cert`

```yaml
additionalVars:
  - name: SSL_CERTIFICATE_HEADER_NAME
    value: "X-SSL-Client-Cert"
```

### ENROLLMENT_VALIDATE_SCHEDULED_LIMIT

Pode ser ativada (valor `true`) caso a detentora deseje que os limites dos
pagamentos agendados sejam validados no momento de sua iniciação. Não deve
estar ativada para execução da certificação.

Se falso, o daemon que avalia os limites para pagamentos agendados será executado.

**Formato:** `true` ou `false`

Valor default: `false`

**Ex:**

```yaml
additionalVars:
  - name: ENROLLMENT_VALIDATE_SCHEDULED_LIMIT
    value: "true"

### CONSENT_DATA_SHARING_V31_DATE

Define a data em que as modificações necessárias para a Fase 2 v3.1
devem ser ativadas. Deve ser configurada uma vez que a data oficial
seja definida pelo BACEN.

**Formato:**: "YYYY-MM-DD"

**Ex:** Para que as modificações sejam ativadas dia 25/12/2024, basta
configurar conforme a seguir:

```yaml
additionalVars:
  - name: CONSENT_DATA_SHARING_V31_DATE
  - value: "2024-12-25"
```

### ENROLLMENT_V21_DATE

Define a data em que as modificações necessárias para JSR v2.1
devem ser ativadas. Deve ser configurada uma vez que a data oficial
seja definida pelo BACEN.

**Formato:**: "YYYY-MM-DD"

**Ex:** Para que as modificações sejam ativadas dia 10/01/2025, basta
configurar conforme a seguir:

```yaml
additionalVars:
  - name: ENROLLMENT_V21_DATE
  - value: "2025-01-10"
```

### APPLICATION_CONSENT_RECURRING_APPROVAL_DUE_DATE_DAYS

Utilizado para definir o número de dias máximo para a aprovação de consentimentos com multipla aprovação.

**Formato:** Número inteiro

Valor default: `5`

**Ex:**

```yaml
additionalVars:
  - name: APPLICATION_CONSENT_RECURRING_APPROVAL_DUE_DATE_DAYS
    value: "5"
```

### DAPR_JOB_DROPREASON_SCHEDULE

Utilizado para definir o agendamento da publicação de evento de dropreason

**Formato:** String no formato cron (ignorando segundos, apenas 5 campos) ou expressão para agendamento, baseado na [API de jobs do Dapr](https://docs.dapr.io/reference/api/jobs_api/).

**Valor default:** `@every 5m`

**Exemplo:** Para agendar a execução do job a cada 5 minutos:


```yaml
env:
  dapr:
    job:
      dropreason:
        schedule: "@every 5m"
```

### Conectores

Existem additionalVars para utilização do conector de aprovação de consentimento
desenvolvido pela Opus, que estão listadas em
[consent](../../integração-plugin/consent/readme.md) na seção
`Arquivo de rota implementado pela OPUS`

## additionalVarsDaemon

Utilizado para definir configurações opcionais da instância de daemons

### DAEMON_WEBHOOK_PAYMENT_INSTANT_INTERVAL

Utilizado para definir o intervalo de execução do daemon de consulta de status
para envio do webhook de pagamentos instântaneos.

O valor dessa configuração deve ser formado por um valor inteiro seguido unidade
de tempo expressa em `m` para minutos ou `s` para segundos.

Para ativar o daemon também é necessário ativar a funcionalidade de webhook
na instância.

**Ex:**

O exemplo a seguir mostra configuração para execução do daemon em intervalos de
5 segundos:

```yaml
additionalVarsDaemon:
  - name: DAEMON_WEBHOOK_PAYMENT_INSTANT_INTERVAL
    value: "5s"
  - name: APPLICATION_WEBHOOK_PAYMENT_ENABLED
    value: "true"
```

**IMPORTANTE**: A ativação do daemon faz parte da solução paliativa do webhook e
deve ser ativado apenas enquanto a detentora não implementar a
[API de notificação de mudança de status de pagamento](../../portal-backoffice/apis-backoffice/readme.md#notificação-de-mudança-de-status-de-pagamento).

O daemon é desabilitado por padrão, mas caso a detentora opte por utilizá-lo,
o valor recomendado para o interavalo é `1s`, a fim de atender o tempo esperado
pelo regulatório.

Valor default: `disabled`

### DAEMON_WEBHOOK_PAYMENT_SCHEDULED_INTERVAL

Utilizado para definir o intervalo de execução do daemon de consulta de status
para envio do webhook de pagamentos em agendamento (SCHD).

A configuração do daemon segue o mesmo padrão do anterior, sendo considerado também
uma solução paliativa a ser usado enquanto a detentora não implementar a notificação
do status do pagamento via API. Assim como o anterior, a ativação deste daemon
depende da ativação da funcionalidade de webhook na instância.

O daemon é desabilitado por padrão, mas caso a detentora opte por utilizá-lo,
o valor recomendado para o interavalo é `1s`, a fim de atender o tempo esperado
pelo regulatório.

**Ex:**

```yaml
additionalVarsDaemon:
  - name: DAEMON_WEBHOOK_PAYMENT_SCHEDULED_INTERVAL
    value: "5s"
  - name: APPLICATION_WEBHOOK_PAYMENT_ENABLED
    value: "true"
```

Valor default: `disabled`

### DAEMON_WEBHOOK_PAYMENT_PARALLELISM_ENABLED

Para melhorar o desempenho dos daemons de consulta de status para envio do webhook,
a detentora pode habilitar o paralelismo de execução permitindo múltiplas consultas
de status a seu core bancário por vez.

**Formato:** `true` ou `false`

Valor default: `false`

**Ex:**

```yaml
additionalVarsDaemon:
  - name: DAEMON_WEBHOOK_PAYMENT_PARALLELISM_ENABLED
    value: "true"
```

### DAEMON_ENROLLMENT_EXECUTION_HOUR

Configuração do horário no qual o daemon será executado.

**Formato:** Número de 0-23

Valor default: `23`

**Ex:**

```yaml
additionalVarsDaemon:
  - name: DAEMON_ENROLLMENT_EXECUTION_HOUR
    value: "23"
```

## FEATURE FLAGS

### feature/consentusagepersistence/enabled

Utilizado para habilitar ou desabilitar a persistência de último uso e histórico
de uso de consentimentos.

**Formato:** `true` ou `false`

Valor default: `true`

**Ex:**

```yaml
additionalVars:
  - name: FEATURE_CONSENTUSAGEPERSISTENCE_ENABLED
    value: "true"
```

### feature/introspection/cache/enabled

Habilita ou desabilita o cache para introspection no serviço.

Deve ser habilitada **APENAS** se a funcionalidade estiver corretamente configurada
no [Authorization Server](../oob-authorization-server/readme.md#state-store).

Ex: `1`

**Importante**: Depende da configuração do nome da state store a ser realizada
conforme item [introspection state store name](#daprstatestoreintrospectionname)


### feature/accountHolder/cache/enabled

Habilita ou desabilita o cache para verificação de correntista.

Deve ser habilitada **APENAS** se a funcionalidade estiver corretamente configurada
no [Authorization Server](../oob-authorization-server/readme.md#state-store).

Ex: `1`

**Importante**: Depende da configuração do nome da state store a ser realizada
conforme item [accountHolder state store](#daprstatestoreaccountholder)

### feature/fido/enabled

Habilita ou desabilita o registro de uma RP no Fido Server durante o DCR.

Deve ser habilitada **APENAS** se a funcionalidade a Jornada Sem Redirecionamento
estiver habilitada.

Ex: `1`

### feature/cpfCnpjSearchKey/enabled
Habilita ou desabilita a criação de chaves de busca de CPF e CNPJ no momento em que um consentimento é criado.

Ex: `1`

### feature/async-payment-status/enabled

Habilita ou desabilita as requisições assíncronas ao endpoint legado para
obter o status do pagamento.

Essa feature não deve ser habilitada caso a instituição tenha
implementado a [notificação de alteração de status](../../portal-backoffice/apis-backoffice/readme.md#notificação-de-mudança-de-status-de-pagamento)
para ***TODOS*** os tipos de pagamento.

**Formato:** `true` ou `false`

**Valor default**: `false`

```yaml
additionalVars:
  - name: FEATURE_ASYNC_PAYMENT_STATUS_ENABLED
    value: "true"
```