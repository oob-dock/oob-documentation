# Installation of Open Finance Brazil MQD Client

The Open Finance Brazil MQD Clien is the module responsible for sending Data Quality Engine periodic reports to the Governance Group of the Open Finance Brazil. The Data Quality Engine (in Portuguese, *Motor de Qualidade de Dados*, hence its acronym *MQD*) is a component provided by the Open Finance Brazil Governance Group and is executed locally by each Open Finance Brazil installation.

Every data record transmitted in response to a client data sharing request sent by another financial institution is submitted to the Data Quality Engine and its result is reported to the Open Finance Brazil Governance Group. So, these reports are sent by Opus Open Finance Platform in batches, and the frequency of these transmitions are configurable.

The details of the installation process of the Open Finance Brasil MQD Client are detaild above.

## Prerequisites

### Reverse Proxy

A reverse proxy must be configured to run in transparent mode and inject the certificate files (cert and key) of the financial institution to allow the establishment of a secure connection with the *mqd server* (that is executed by the Governance Group in a central environment).

For this function, it is recommended to start a container with nginx configured with the volumes of `/etc/nginx/conf.d/default.conf`, `/etc/ssl`, and `/etc/nginx/nginx.conf` being respectively the default conf of nginx locations, the location where this conf will search for the installation certificate and key, and the nginx config.

Additionally, the proxy container must be accessible within the cluster so that the `proxyUrl` environment variable explained later represents the internal access URL of this container.

*Example nginx Deployment file*:

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

**Important:** Note that the following example presents sandbox endpoints, the endpoints for production purposes are in the format: `https://mqd.openfinancebrasil.org.br`

*Example nginx ConfigMap file*:

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

*Example nginx Service configuration file for internal cluster access via `http://nginx-mqd`*:

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

### Creating Secrets to Store Private Keys

The certificates and private keys of the organizations configured in the OFB MQD Client must be securely persisted. It is highly recommended to use a password vault for this persistence. If this is not possible, traditional Kubernetes secrets can be created to persist this information. The procedure below describes one way to create this secret.

```shell
kubectl -n <NAMESPACE_NAME> create secret generic <SECRET_NAME> --from-file=<DIRECTORY_PATH>
```

For example, consider that the organization's certificate and key are already created and stored in a local directory:

```shell
ls /tmp/mqd-client
client.crt  client.key
```

By running the command below, the secret is created:

```shell
kubectl -n oob create secret generic mqd-client-secret --from-file=/tmp/mqd-client
secret/mqd-client-secret created
```

To describe the content of the secret, the command below can be used:

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

### Configuration of the MQD Client Service in the Cluster

It is worth noting that the MQD Client will receive Validate Response calls from the MQD Dispatcher internally in the cluster via the endpoint configured as `http://mqd-client-<transmitter|receiver>-serverOrgId`. The transmitter/receiver is the applicationMode of the mqd-client installation and the serverOrgId is the organization ID of the Financial Institution where the engine is being installed.

## Installation

The module installation is done via Helm Chart.

## Configuration

Configuration of environment variables.

### env

### apiPort

Port that will be used to expose the API endpoints.

Values: `":" + port`

### serverOrgId

ID of the financial institution's organization. The configuration as an environment variable should indicate the ID of the FI organization where the engine is being installed (e.g., Financial Institution ID in the Central Directory).

Values: `Valid Organisation Id`

### reportExecutionWindow

Indicates the execution window for sending reports.
**This is an optional field, if not defined its value will be loaded automatically**.

Values: `> 0, < 60`

### reportExecutionNumber

Indicates the number of reports that should be processed before sending, if the number of reports reaches the limit, the report is automatically sent, and the time window timer is reset.
**This is an optional field, if not defined its value will be loaded automatically**.

Values: `>0, < 2000000`

### environment

Indicates the environment in which the application is being installed.

Values:

* `PROD`
* `SANDBOX`
* `DEV`

### loggingLevel

Indicates the tracking level to be used in the application.

Values:

* `DEBUG`
* `INFO`
* `WARNING`
* `ERROR`
* `FATAL`

### applicationMode

Indicates the way the application will be executed, depending on whether it is a transmitter or receiver type institution. If the institution fulfills both roles, two deployments must be performed, one as TRANSMITTER and the other as RECEIVER.

Values:

* `TRANSMITTER`
* `RECEIVER`

### proxyUrl

Indicates the URL where the Proxy that establishes a secure connection with the server can be found.

Values: `Valid URL`

### enableHttps

Indicates if HTTPS should be enabled. If enabled, a volume will be mounted with the secret containing certificates to be used, called **mqd-server-secret**. The keys of this secret should be named: **server.crt** and **server.key**.

Values: `true` or `false`

### resultEnabled

Indicates if the results should be saved locally. If enabled, a volume will be mounted according to [resultVolumeMetadata](#resultVolumeMetadata) and the configurations with the prefix result will be taken into account.

Values: `true` or `false`

### resultFilesPerDay

Indicates the number of files that should be created each day.

Values: `Positive integer`

### resultDaysToStore

Indicates the number of days that will be stored by the application.

Values: `Positive integer`

### resultSamplesPerError

Indicates the number of results that will be saved for each type of error.

Values: `Positive integer`

### resultMaskPrivateContent

Indicates if privileged information should be masked before writing log data.

Values: `true` or `false`

### resultVolumeMetadata

Metadadata for volume kubernetes configuration being used for storing log data.

Values: 

```yaml
resultVolumeMetadata:
  - name: data-logs
    emptyDir: {}
```

**Example:**

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
