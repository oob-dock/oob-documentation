# Instalação do OOF Event Service

## Pré-requisitos

### Banco de dados

Este módulo requer uma base de dados própria para seu funcionamento. Atualmente
ele oferece suporte à bases Postgres.

### Fila de mensagens

Este módulo consome e processa eventos publicados em uma fila de mensagens.
Portanto, é necessário que exista um *message broker* instalado e configurado
corretamente que possa ser utilizado pelo OOF Event Service e que seja compatível
com o [Dapr](/deploy/shared-definitions.md#dapr).

### Virtual Actors

Este módulo utiliza os [virtual actors](https://docs.dapr.io/developing-applications/building-blocks/actors/actors-overview/)
do [Dapr](/deploy/shared-definitions.md#dapr).
A utilização dessa funcionalidade depende da inclusão de uma [state store](https://docs.dapr.io/reference/components-reference/supported-state-stores/)
para manter seus estados de funcionamento. Assim, será necessário incluir esta configuração.

### Dapr

O módulo OOF Event Service faz uso do Dapr para realizar a subscrição à eventos
de webhook que devem ser enviados durante a transição de estado do pagamento e consentimento.
Este módulo também aplica (via Helm) um componente do tipo
[cron binding](https://docs.dapr.io/reference/components-reference/supported-bindings/cron/)
utilizado para reprocessamento dos webhooks.

Dado este cenário, a instalação do Dapr bem como aplicação do componente
de *binding* são requisitos necessários para o correto funcionamento deste
módulo.

### Criação do(s) secret(s) para armazenar as chaves privadas

Os certificados e chaves privadas das organizações configuradas no OOF Event
Service devem ser persistidos de forma segura, é altamente recomendado utilizar
um cofre de senhas para essa persistência. Caso isso não seja possível, secrets
tradicionais podem ser criados no Kubernetes para persistir essas informações.
O procedimento abaixo descreve uma das formas para se criar este secret.

```shell
kubectl -n <NOME_DO_NAMESPACE> create secret generic <NOME_DO_SECRET> --from-file=<CAMINHO_DO_DIRETORIO>
```

Considere, por exemplo que o certificado e chave da marca estejam
previamente criados e armazenados em um diretório local:

```shell
ls /tmp/event-service
cert.pem  sig.key
```

Ao executar o comando abaixo, o secret é criado:

```shell
kubectl -n oob create secret generic webhook-certificates --from-file=/tmp/event-service
secret/webhook-certificates created
```

Para descrever o conteúdo do secret o comando abaixo pode ser utilizado:

```shell
apiVersion: v1
data:
  tls.crt: LS0t...tLQ==
  tls.key: LS0t...LS0=
kind: Secret
metadata:
  creationTimestamp: "2023-06-22T10:30:27Z"
  name: webhook-certificates
  namespace: oob
  resourceVersion: "535257094"
  selfLink: /api/v1/namespaces/oob/secrets/webhook-certificates
  uid: ee47ec34-c4b8-45b8-ab95-ad6ed38f4376
type: Opaque
```

## Instalação

A instalação do módulo é feita via Helm Chart.

## Configuração

### db

Configuração de acesso ao banco.

* `host`: Host do banco.
* `port`: Porta do banco (opcional). **Default:** `5432`.
* `name`: Nome do banco.
* `username`: Nome do usuário de acesso ao banco.
* `password`: Senha do usuário de acesso ao banco.

**Exemplo:**

```yaml
  db:
    host: "oof_event_service"
    port: 5432
    name: "oof_event_service"
    username: "oof_event_service"
    password: "oof_event_service"
```

### dapr

Configurações relacionadas ao Dapr.

* `dapr.enabled`: Habilita o Dapr na aplicação para realizar o consumo de
eventos.
Possíveis valores: `true` ou `false`. **Default:** `true`.
* `dapr.daprPubsubId`: Identificador do componente de pub/sub do Dapr a ser
utilizado.

**Exemplo:**

```yaml
  dapr:
    enabled: "true"
    daprPubsubId: "event-service-pub-sub"
```

### config

Configurações básicas do serviço.

* `config.logLevel`: Determina o menor nível dos logs do serviço.

**Exemplo:**

```yaml
  config:
    logLevel: "INFO"
```

### privateKeys

Identificadores das organizações e suas marcas, contendo seus certificados
para realização de chamadas mtls.

* `privateKeys.orgId`: Identificador da organização no diretório central.
* `privateKeys.softwareStatements.brandId`: Identificador da marca da organização.
* `privateKeys.softwareStatements.brcacSecretName`: Nome do secret que contém o
certificado BRCAC.
* `privateKeys.softwareStatements.brcacSecretKey`:  Nome da propriedade do secret
que contém o certificado BRCAC.
* `privateKeys.softwareStatements.brcacSecretName`: Nome do secret que contém a
chave privada do certificado.
* `privateKeys.softwareStatements.brcacSecretKey`:  Nome da propriedade do secret
que contém a chave privada do certificado.

**Exemplo 1:**

```yaml
  privateKeys:
    orgId: "03f9155a-c230-4c87-a051-c63272092030"
    - softwareStatements:
        - brandId: "cbanco"
          brcacSecretName: "webhook-certificates"
          brcacSecretKey: "tls.crt"
          brcacKeySecretName: "webhook-certificates"
          brcacKeySecretKey: "tls.key"
    - softwareStatements:
        - brandId: "dbanco"
          brcacSecretName: "webhook-certificates2"
          brcacSecretKey: "tls.crt"
          brcacKeySecretName: "webhook-certificates2"
          brcacKeySecretKey: "tls.key"
```

## additionalVars

Utilizado para definir configurações opcionais do serviço. Essa configuração
permite definir uma lista de propriedades a serem passadas a ele no formato:

```yaml
additionalVars:
  - name: FIRST_PROPERTY
    value: "FIRST_VALUE"
  - name: SECOND_PROPERTY
    value: "SECOND_VALUE"
```

### OOF_WEBHOOK_PAYMENT_ENABLED

Define se o envio de webhooks de pagamento deve estar habilitado.

**Default**: "false"

**Exemplo:**

```yaml
additionalVars:
  - name: OOF_WEBHOOK_PAYMENT_ENABLED
    value: "true"
```

### VALIDATE_CERTIFICATE

Define se o serviço verificará a validade dos certificados usados
no envio de webhooks.

**Default**: "false"

**Exemplo:**

```yaml
additionalVars:
  - name: VALIDATE_CERTIFICATE
    value: "true"
```

### OOF_WEBHOOK_PAYMENT_DELAY_SECONDS

Configuração de delay do envio de eventos de webhook de pagamento em segundos.

**Exemplo:**

```yaml
additionalVars:
  - name: OOF_WEBHOOK_PAYMENT_DELAY_SECONDS
    value: "10"
```

### OOF_WEBHOOK_PAYMENT_CONSENT_DELAY_SECONDS

Configuração de delay do envio de eventos de webhook de consentimento de pagamento
em segundos.

**Exemplo:**

```yaml
additionalVars:
  - name: OOF_WEBHOOK_PAYMENT_CONSENT_DELAY_SECONDS
    value: "5"
```