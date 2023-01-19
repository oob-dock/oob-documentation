# Instalação do OOF PCM Service

## Pré-requisitos

### Banco de dados

Este módulo requer uma base de dados própria para seu funcionamento. Atualmente
ele oferece suporte à bases Postgres.

### Fila de mensagens

Este módulo consome e processa eventos publicados em uma fila de mensagens.
Portanto, é necessário que exsita um *message broker* instalado e configurado
corretamente que possa ser utilizado pelo OOF PCM Service e que seja compatível
com o [Dapr](/deploy/shared-definitions.md#dapr). A lista de *brokers*
compatíveis pode ser conferida [aqui](https://docs.dapr.io/reference/components-reference/supported-pubsub/).

### Dapr

O módulo OOF PCM Service faz uso do [Dapr](/deploy/shared-definitions.md#dapr)
para realizar a subscrição à eventos de chamadas de API que devem ser
reportadas à Plataforma de Coleta de Métricas (PCM). Este módulo também
aplica (via Helm) um componente do tipo [cron binding](https://docs.dapr.io/reference/components-reference/supported-bindings/cron/)
utilizado para sensibilizar o envio dos reportes para a PCM periodicamente.

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

## Instalação

A instalação do módulo é feita via Helm Chart.

## Configuração

### db

Configuração de acesso ao banco.

* `host`: Host do banco.
* `port`: Porta do banco. **Default:** 5432.
* `name`: Nome da base.
* `username`: Nome do usuário de acesso ao banco.
* `password`: Senha do usuário de acesso ao banco.

**Exemplo:**

```yaml
  db:
    host: "oof_pcm_service"
    port: 5432
    name: "oof_pcm_service"
    username: "oof_pcm_service"
    password: "oof_pcm_service"
```

### dapr

Configurações relacionadas ao Dapr.

* `dapr.enabled`: Quando "true", durante a subida do serviço, informa ao Dapr
que esta aplicação deverá ser monitorada por ele e fará uso de seus
componentes. Neste cenário o Dapr sobe um *sidecar* atrelado à aplicação.
Quando "false" não ocorre a subida do *sidecar* e a aplicação não consegue
estabelecer comunicação e fazer uso dos componentes do Dapr. **Default:** "true".
* `dapr.pubSubId`: Nome do componente de pub/sub do Dapr no qual a aplicação
deverá se conectar para receber os eventos desejados.

**Exemplo:**

```yaml
  dapr:
    enabled: "true"
    pubSubId: "pcm-event-pub-sub"
```

### brand.ids

Identificadores das marcas para as quais o serviço irá realizar a subscrição
para recebimento dos eventos. Uma lista com mais de um elemento deve utilizar
vírgula (,) como delimitador.

**Exemplo:**

```yaml
  brand:
    ids: "marca1,marca2"
```

### softwareStatements

Lista de *software statements* composta por: certificado BRCAC, chave privada e
identificador do cliente. Essas informações são necessárias para que o serviço
consiga obter o token de acesso que possibilita o envio de reportes para a PCM.

* `certSecretName`: Nome do secret que contém o certificado BRCAC.
* `certSecretKey`: Nome da propriedade do secret que contém o certificado
BRCAC.
* `privateKeySecretName`: Nome do secret que contém a chave privada.
* `privateKeySecretKey`: Nome da propriedade do secret que contém a chave
privada.
* `clientId`: Identificador do cliente no diretório de participantes.

**Exemplo:**

```yaml
  softwareStatements:
    - certSecretName: "pcm-organization-tls"
      certSecretKey: "tls.crt"
      privateKeySecretName: "pcm-organization-tls"
      privateKeySecretKey: "tls.key"
      clientId: "0b4841d2-773f-4286-92a0-611f6d066545"
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

### PCM_REPORT_BATCH_SIZE

Define quantos eventos serão enviados a cada iteração para cada
*software statement* configurado no serviço. Default: 1000.

**Exemplo:**

```yaml
additionalVars:
  - name: PCM_REPORT_BATCH_SIZE
    value: "500"
```
