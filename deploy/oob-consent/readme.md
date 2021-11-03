# Instalação do OOB Consent

## Instalação

A instalação do módulo é feita via Helm Chart

## Configuração

### db

Configuração de acesso ao banco

* name: Nome da base
* username: Nome do usuário de acesso ao banco
* password: Senha do usuário de acesso ao banco
* port: Porta do banco
* kind: Tipo do banco. Default: "postgres"
* dialect: Dialeto do banco. Default: "org.hibernate.dialect.PostgreSQLDialect"
* host: Host do banco

### liquibase/contexts

Contexto que deve ser utilizado para criar a base de dados. Utilizar "demo" para
criar dados de exemplo na base. Utilizar "default" para ambientes de homologação
ou produção.

### oidc

Configuração

### signature

Lista de chaves privadas utilizadas para encriptar ou assinar mensagens. A lista
deve conter pelo menos uma chave com use = sig (assinatura).

* kid: Identificador da chave (Obtido do diretório de participantes)
* certSecretName: Nome do secret que contém a chave privada. Default: "oob-as-keys"
* certSecretKey: Nome da propriedade do secret que contém a chave privada. Default:
"sig.key"

Exemplo:

```yaml
  privateKeys:
    certSecretName: "oob-as-keys"
    certSecretKey: "sig.key"
    kid: "uGe7YNnhE83esu86xeqGJMIQi8IamA8FTSaLd1pkXy8"
```

### organisation/id

Deve ser preenchido com o organisationId da instituição cadastrada no diretório
de participantes.
Utilizar o id de sandbox para ambientes não produtivos, e o valor de produção
para ambientes produtivos.

#### additionalVars

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

### quarkus_oidc_discovery_enabled

Define se o discovery do open id connect deve ser habilitado.

**Formato:** `true` ou `false`

**Ex:**

```yaml
additionalVars:
  - name: quarkus_oidc_discovery_enabled
    value: "false"
```

### quarkus_oidc_introspection_path

Define o caminho para realizar o instrospection do token de autenticação

**Formato:** path URL

**Ex:**

```yaml
additionalVars:
  - name: quarkus_oidc_introspection_path
    value: "/auth/token/introspection"
```
