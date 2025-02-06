# Instalação do OFB MQD Client

## Pré-requisitos

### Proxy reverso

Deve ser configurado um proxy reverso que tenha a capacidade de rodar em modo
transparente e injetar os arquivos de certificados (cert e key) da
instituição financeira para permitir o estabelecimento de uma conexão segura
com o servidor de mqd (Motor de Qualidade de Dados).

Para essa função é aconselhado subir um container com nginx configurado
com os volumes de `/etc/nginx/conf.d/default.conf`, `/etc/ssl` e `/etc/nginx/nginx.conf`
sendo respectivamente a conf default das locations do nginx, o local de onde essa
conf vai buscar o certificado e a key da instalação e a config do nginx.

Além disso, o container desse proxy deve ser acessível no cluster internamente de
modo que a variável de ambiente `proxyUrl` a ser explicada mais a frente represente
a url interna de acesso desse container.

*Exemplo de arquivo de Deployment do nginx*:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app.kubernetes.io/name: nginx-mqd
  name: nginx-mqd
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: nginx-mqd
  template:
    metadata:
      labels:
        app.kubernetes.io/name: nginx-mqd
    spec:
      containers:
        - name: nginx-mqd
          image: nginx:latest
          ports:
            - containerPort: 80
          resources:
            requests:
              cpu: 0.5
              memory: 512Mi
            limits:
              cpu: 2
              memory: 1Gi
          imagePullPolicy: Always
          volumeMounts:
            - mountPath: /etc/ssl
              name: secret-nginx-mqd
            - mountPath: /etc/nginx/nginx.conf
              name: nginx-config
              subPath: nginx.conf
            - mountPath: /etc/nginx/conf.d/default.conf
              name: default-config
              subPath: default.conf
      volumes:
      - configMap:
          items:
          - key: nginx.conf
            path: nginx.conf
          name: nginx-mqd
        name: nginx-config
      - configMap:
          items:
          - key: default.conf
            path: default.conf
          name: nginx-mqd
        name: default-config
      - name: secret-nginx-mqd
        secret:
          secretName: mqd-client-secret
          items:
          - key: client.crt
            path: client.crt
          - key: client.key
            path: client.key
```

**Importante:** Se atentar para o fato que o exemplo a seguir apresenta
endpoints de sandbox, os endpoints para fins produtivos são do formato:
`https://mqd.openfinancebrasil.org.br`

*Exemplo de arquivo de ConfigMap para a conf de nginx*:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-mqd
data:
  nginx.conf: |
    user  nginx;
    worker_processes  auto;

    error_log  /var/log/nginx/error.log notice;
    pid        /var/run/nginx.pid;


    events {
        worker_connections  1024;
    }


    http {
        include       /etc/nginx/mime.types;
        default_type  application/octet-stream;

        server_tokens off;

        log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                          '$status $body_bytes_sent "$http_referer" '
                          '"$http_user_agent" "$http_x_forwarded_for"';

        access_log  /var/log/nginx/access.log  main;

        sendfile        on;
        #tcp_nopush     on;

        keepalive_timeout  65;

        #gzip  on;

        include /etc/nginx/conf.d/*.conf;
    }

  default.conf: |
    server {
      listen                  80;
      server_name             localhost;

      location /token {       
          proxy_pass https://mqd.sandbox.openfinancebrasil.org.br/token;
          proxy_ssl_server_name on;
          proxy_http_version 1.1;
          proxy_ssl_certificate       /etc/ssl/client.crt;
          proxy_ssl_certificate_key   /etc/ssl/client.key;
          proxy_ssl_session_reuse on;
          ######
          ## Settings specific to a Docker container mapped to non-80/443 port on host
          absolute_redirect off;
      }

      location /report {
          proxy_pass https://mqd.sandbox.openfinancebrasil.org.br/report;
          proxy_ssl_server_name on;
          proxy_http_version 1.1;
          proxy_ssl_certificate       /etc/ssl/client.crt;
          proxy_ssl_certificate_key   /etc/ssl/client.key;
          proxy_ssl_session_reuse on;
          ######
          ## Settings specific to a Docker container mapped to non-80/443 port on host
          absolute_redirect off;
      }

      location /settings {
          proxy_pass https://mqd.sandbox.openfinancebrasil.org.br/settings;
          proxy_ssl_server_name on;
          proxy_http_version 1.1;
          proxy_ssl_certificate       /etc/ssl/client.crt;
          proxy_ssl_certificate_key   /etc/ssl/client.key;
          proxy_ssl_session_reuse on;
          ######
          ## Settings specific to a Docker container mapped to non-80/443 port on host
          absolute_redirect off;
      }
    }
```

*Exemplo de Service de configuração do nginx para acesso interno do cluster via
`http://nginx-mqd`*:

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app.kubernetes.io/name: nginx-mqd
  name: nginx-mqd
spec:
  selector:
    app.kubernetes.io/name: nginx-mqd
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: ClusterIP

```

### Criação do(s) secret(s) para armazenar as chaves privadas

Os certificados e chaves privadas das organizações configuradas no OFB MQD
Client devem ser persistidos de forma segura, é altamente recomendado utilizar
um cofre de senhas para essa persistência. Caso isso não seja possível, secrets
tradicionais podem ser criados no Kubernetes para persistir essas informações.
O procedimento abaixo descreve uma das formas para se criar este secret.

```shell
kubectl -n <NOME_DO_NAMESPACE> create secret generic <NOME_DO_SECRET> --from-file=<CAMINHO_DO_DIRETORIO>
```

Considere, por exemplo que o certificado e chave da organização estejam
previamente criados e armazenados em um diretório local:

```shell
ls /tmp/mqd-client
client.crt  client.key
```

Ao executar o comando abaixo, o secret é criado:

```shell
kubectl -n oob create secret generic mqd-client-secret --from-file=/tmp/mqd-client
secret/mqd-client-secret created
```

Para descrever o conteúdo do secret o comando abaixo pode ser utilizado:

```yaml
apiVersion: v1
data:
  client.crt: LS0...S0=
  client.key: LS0...S0=
kind: Secret
metadata:
  name: mqd-client-secret
type: Opaque
```

### Configuração do service do MQD Client no cluster

Vale ressaltar que o MQD Client receberá as chamadas de Validate Response
do MQD Dispatcher internamente no cluster pelo endpoint configurado como
`http://mqd-client-<transmitter|receiver>-serverOrgId`.
Sendo o transmitter/receiver o applicationMode da instalação do mqd-client
e o serverOrgId o ID da organização da IF onde o motor está sendo
instalado.

## Instalação

A instalação do módulo é feita via Helm Chart.

## Configuração

Configurações das variáveis de ambiente.

### env

### apiPort

Porta que será usada para expor os endpoints da API.

Valores: `":" + porta`

### serverOrgId

 ID da organização da instituição financeira. A configuração como variável
de ambiente deve indicar o ID da organização da IF onde o motor está sendo
instalado (ex.: ID da Instituição Financeira no Diretório Central).

Valores: `Organisation Id Válido`

### reportExecutionWindow

 Indica a janela de execução para envio de relatórios,
**é um campo opcional, caso não esteja definido seu valor será carregado automaticamente**.

Valores: `> 0, < 60`

### reportExecutionNumber

Indica a quantidade de relatórios que devem ser processados
​​antes do envio, caso a quantidade de relatórios atinja o limite, o relatório
é enviado automaticamente e o timer da janela de tempo é reiniciado **é um campo
opcional, caso não esteja definido seu valor será carregado automaticamente**.

Valores: `>0, < 2000000`

### environment

Indica o ambiente em que o aplicativo está sendo instalado.

Valores:

* `PROD`
* `SANDBOX`
* `DEV`

### loggingLevel

Indica o nível de rastreio que será utilizado na aplicação.

Valores:

* `DEBUG`
* `INFO`
* `WARNING`
* `ERROR`
* `FATAL`

### applicationMode

Indica a forma como será executada a aplicação, isso
dependerá se se trata de uma instituição do tipo transmissora ou receptora.
Caso a instituição cumpra os dois papéis dois deploys devem ser realizados,
um como TRANSMITTER e o outro como RECEIVER.

Valores:

* `TRANSMITTER`
* `RECEIVER`

### proxyUrl

Indica a url onde será encontrado o Proxy que estabelece conexão
segura com o servidor.

Valores: `URL válida`

### enableHttps

Indica se o HTTPS deve ser habilitado. Se habilitado, será montado um volume com o
secret contendo os certificados a serem usados, chamado **mqd-server-secret**. As chaves desse secret devem chamar:
**server.crt** e **server.key**.

Valores: `true` ou `false`

### resultEnabled

Indica se os resultados devem ser salvos localmente. Se habilitado, será montado um volume conforme [resultVolumeMetadata](#resultVolumeMetadata) e será levado em conta as configurações com o prefixo result.

Valores: `true` ou `false`

### resultFilesPerDay

Indica o número de arquivos que devem ser criados a cada dia.

Valores: `Número inteiro positivo`

### resultDaysToStore

Indica o número de dias que os resultados serão armazenados pela aplicação.

Valores: `Número inteiro positivo`

### resultSamplesPerError

Indica o número de resultados que serão salvos para cada tipo de erro.

Valores: `Número inteiro positivo`

### resultMaskPrivateContent

Indica se informações privilegiadas devem ser mascaradas antes de gravar os dados de log.

Valores: `true` ou `false`

### resultVolumeMetadata

Indica a configuração de volume do Kubernetes que está sendo usada para armazenar dados de log.

Valores: 

```yaml
resultVolumeMetadata:
  - name: data-logs
    emptyDir: {}
```

**Exemplo:**

```yaml
env:
  apiPort: ":8080"
  serverOrgId: "27aea8f6-2119-55f8-9553-5ad4b08eeb17"
  reportExecutionWindow: "30"
  reportExecutionNumber: "200000"
  environment: "DEV"
  loggingLevel: "DEBUG"
  applicationMode: "TRANSMITTER"
  proxyUrl: "http://nginx-mqd"
  enableHttps: "false"
  resultEnabled: "false"
  resultFilesPerDay: "10"
  resultDaysToStore: "30"
  resultSamplesPerError: "5"
  resultMaskPrivateContent: "false"
  resultVolumeMetadata:
    - name: data-logs
      emptyDir: {}
```
