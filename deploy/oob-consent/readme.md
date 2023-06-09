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

### dapr/enabled

Habilita o Dapr na aplicação para realizar o envio de eventos.

**Formato:** : `true` ou `false`.

Valor default: `true`

### dapr/pubSubId

Identificador do componente de pub/sub do Dapr a ser utilizado.

Ex: `oob-consent-pub-sub`

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

Utilizado para habilitar ou desabilitar as funcionalidades relacionadas ao webhook
de pagamentos.

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

Existem additionalVars para utilização do conector de aprovação de consentimento
desenvolvido pela Opus, que estão listadas em
[consent](../../integração-plugin/consent/readme.md) na seção
`Arquivo de rota implementado pela OPUS`

### APPLICATION_ENCRYPTION_CHARSET

Utilizado para definir o charset usado na criptografia dos campos na base de dados.

Valor default: `UTF-8`

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

O exemplo a seguir mostra configuração para execução do daemon em interavalos de 5 segundos:

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
