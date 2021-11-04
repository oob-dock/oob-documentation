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

### liquibase/contexts

Controle de execução do banco de dados

Utilizar "demo" para criar dados de exemplo na base.
Utilizar "default para ambientes de homologação ou produção."

### oidc

Protocolo de identidade para verificação de usuário

* authServerUrl: Apontamento interno no K8s
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

As configurações que podem ser definidas neste formato estão listadas em 
[consent](../../integração-plugin/consent/readme.md) na seção `Arquivo de rota implementado pela OPUS`

