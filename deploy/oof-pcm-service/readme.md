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
