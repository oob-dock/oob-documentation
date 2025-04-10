# Definições compartilhadas

## Brand Id

Nome simplificado da marca, só pode conter letras minúsculas e hífen ( - ).
O tamanho máximo é de 36 caracteres. Essa informação é utilizada para identificar
a marca dentro do sistema e integrações, ela não será exibida ao cliente.
Deve ser único por marca em instituições que possuem mais de uma marca.

***

**:warning: ATENÇÃO**: O valor da propriedade Brand Id é utilizada na criação da
estrutura de banco de dados em alguns módulos, isso significa que este valor não
pode ser alterado depois da primeira execução da aplicação. Em caso de configuração
errada entre em contato com a Opus.

***

Ex: `cbanco`

## Scripts DDL

Os scripts DDL serão aplicados em um processo separado da execução do serviço.
Para configurar a execução destes scripts será necessário ajustar os valores
das seguintes propriedades:

```yaml
  db:
    ddl:
      username: "ddl-username"
      password: "ddl-password"
      logLevel: "info"
```

**Observação**: a configuração de `logLevel` pode assumir um
dos seguintes valores: `emerg`, `error`, `warn`, `info` ou `debug`.

## Liquibase Contexts

Contexto que deve ser utilizado para criar a base de dados.

Utilizar "demo" para criar dados de exemplo na base.

Utilizar "default" para ambientes de homologação ou produção.

**Formato:** `demo` ou `default`

## oidc

Configuração de segurança para validar os tokens de acesso recebidos
em requests

* authServerUrl: Endereço do oob-authorization-server. O endereço pode ser um
apontamento interno no K8s
* introspectionPath: Caminho do endpoint de introspection
* clientId: Cliente criado na configuração do oob-authorization-server
* clientSecret: Secret de acesso do cliente
* jwksPath: Caminho para o endpoint de jwks NON FAPI. Deve ser formado pela
concatenação do [auth_server_nonfapi_base_path](#auth_server_nonfapi_base_path)
com `jwks`

Exemplo:

```yaml
    authServerUrl: "http://oob-authorization-server"
    introspectionPath: "/auth/token/introspection"
    clientId: "oob-internal-client"
    clientSecret: "oob-internal-client"
    jwksPath: /auth-nonfapi/jwks
```

## auth_server_url

URL para acesso ao servidor de autorização

**Ex:** "<http://oob-authorization-server>"

## auth_server_base_path

Caminho base para acessar o servidor de autorização

**Ex:** "/auth/"

## auth_server_nonfapi_base_path

Caminho base para acessar o servidor de autorização nos endpoints não FAPI

**Ex:** "/auth-nonfapi/"

## introspection_client_id

Identificador do cliente para instrospection

**Ex:** "oob-internal-client"

## introspection_client_secret

Segredo do cliente para instrospection

**Ex:** "secret123"

## Suporte a features do Opus Open Finance

Com o objetivo de otimizar o uso de recursos, monitorar e expor endpoints
suportados pela instituição, implementamos o suporte a features.

Todos os endpoints que são expostos no Kong estão obrigatoriamente atrelados a
uma feature.

### Features suportadas

Abaixo temos a lista de features suportadas pelo Opus Open Finance:

| Feature        | Descrição                                                                            |
| -------------- | ------------------------------------------------------------------------------------ |
| core           | Funções básicas e obrigatórias do Opus Open Finance                                  |
| open-data      | Compartilhamento de dados abertos (Fase 1 do Open Finance Brasil)                    |
| financial-data | Compartilhamento de dados que requerem consentimento (Fase 2 do Open Finance Brasil) |
| payments       | Pagamentos (Fase 3 do Open Finance Brasil)                                           |
| enrollments    | Jornada sem redirecionamento (Fase 3 do Open Finance Brasil)                         |

### Features x Scopes

Cada feature definida na tabela acima suporta os seguintes escopos:

| Feature        | Scopes                                                                                                                                       |
| -------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| core           | openid, oob_customer, oob_consents:read, oob_opendata:read, oob_opendata:write, oob_outages:read, oob_outages:write, profile, offline_access |
| open-data      | openid                                                                                                                                       |
| financial-data | openid, resources                                                                                                                            |
| payments       | openid, payments, recurring-payments                                                                                                         |
| enrollments    | openid, payments, nrp-consents                                                                                                               |

**IMPORTANTE**: Para a feature financial-data não é necessário utilizar os
seguintes escopos de acesso: accounts, credit-cards-accounts, customers, invoice-financings,
financings, loans, unarranged-accounts-overdraft.

## Formatos de chave privada suportados

No produto são suportados os formatos de chave PKCS1 e PKCS8. O suporte a PKCS1
é feito principalmente sobre o uso do algoritmo RSA para criptografia. Já o
suporte a PKCS8 é devido ao fato de ser um padrão que permite manipular chaves
privadas para todos os algoritmos, não apenas para o RSA.

Para ambos formatos há suporte de uso de senha, a fim de aumentar a segurança no
uso de chaves, dificultando o uso da mesma por partes não autorizadas.

## Dapr

O [Dapr](https://dapr.io/) é um *Runtime* de Aplicações Distribuídas que visa
simplificar a conectividade entre microsserviços através de vários
[blocos de construção](https://docs.dapr.io/concepts/building-blocks-concept/).

O Opus Open Finance faz uso do seguinte bloco de construção do Dapr:

* Publish and Subscribe: Utilizado para publicar e consumir eventos de chamadas
de APIs que devem ser reportados para a PCM (Plataforma de Coleta de Métricas),
para o envio de webhooks de pagamento e para publicar eventos que permite
acompanhar o comportamento geral da solução.

* Virtual Actors: Utilizado para reprocessamento dos webhooks de pagamento que
falharam na primeira tentativa de envio.
