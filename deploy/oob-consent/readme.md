# Instalação do OOB Consent

## Pré-requisitos

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
