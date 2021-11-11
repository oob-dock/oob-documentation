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

Controle de execução do banco de dados

Utilizar "demo" para criar dados de exemplo na base.
Utilizar "default para ambientes de homologação ou produção."

### oidc

Configuração de segurança para validar os tokens de acesso recebidos
em requests

* authServerUrl: Endereço do oob-authorization-server. O endereço pode 
ser um apontamento interno no K8s
* introspectionPath: Caminho do endpoint de introspection
* clientId: Cliente criado na configuração do oob-authorization-server
* clientSecret: Secret de acesso do cliente

Exemplo:

```yaml
    authServerUrl: "http://oob-authorization-server"
    introspectionPath: "/auth/token/introspection"
    clientId: "oob-internal-client"
    clientSecret: "oob-internal-client" 
```

### signature

Chave de assinatura para mensagens. Devem ser utilizados os mesmos valores do
certificado do authorization server com use = `sig`

* kid: Identificador da chave (Obtido do diretório de participantes)
* certSecretName: Nome do secret que contém a chave privada
* certSecretKey: Nome da propriedade do secret que contém a chave privada

Exemplo:

```yaml
    kid: "MPguImG0DEQwu9ZUvwDzw_0xybh1yAETY9VBLdYXibo"
    certSecretName: "oob-as-keys"
    certSecretKey: "sig.key"
```

### organisation/id

Deve ser preenchido com o organisationId da instituição cadastrada no diretório
de participantes.

Utilizar o id de sandbox para ambientes não produtivos e o valor de produção para 
ambientes produtivos.

Essa propriedade é do tipo UUID.

Ex: `7a176f46-75e6-454f-8d04-408d6beaee37`

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

Utilizado para definir o nível do log da aplicação. Em produção é aconselhável ser level = `INFO`.

**Ex:**

```yaml
additionalVars:
  - name: QUARKUS_LOG_LEVEL
    value: "INFO"
```

### QUARKUS_LOG_CONSOLE_LEVEL

Utilizado para definir o nível do log para o console da aplicação.

**Ex:**

```yaml
additionalVars:
  - name: QUARKUS_LOG_CONSOLE_LEVEL
    value: "DEBUG"
```

### QUARKUS_LOG_CONSOLE_JSON

Utilizado para definir se o log deve ser no formato JSON.

**Formato:** `true` ou `false`

**Ex:**

```yaml
additionalVars:
  - name: QUARKUS_LOG_CONSOLE_JSON
    value: "false"
```

### APPLICATION_VALIDATION_CURRENCY

Utilizado para definir o código da moeda nacional segundo modelo ISO-4217.

**Ex:**

```yaml
additionalVars:
  - name: APPLICATION_VALIDATION_CURRENCY
    value: "BRL"
```

### CONSENT_EXTERNAL_ID

Utilizado para definir o id referente ao consentId. O consentId é o identificador único do 
consentimento e deverá ser um URN - Uniform Resource Name.

Considerando a string urn:bancoex como exemplo para consentId temos:
 - o namespace(urn), conforme definido na [RFC8141](https://datatracker.ietf.org/doc/html/rfc8141) 
 - o identificador associado ao namespace da instituição transnmissora (bancoex) 

**Ex:**

```yaml
additionalVars:
  - name: CONSENT_EXTERNAL_ID
    value: "urn:bancoex"
```

Existem additionalVars para utilização do conector de aprovação de consentimento desenvolvido pela Opus, 
que estão listadas em [consent](../../integração-plugin/consent/readme.md) na seção
 `Arquivo de rota implementado pela OPUS`

