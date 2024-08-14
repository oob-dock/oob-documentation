# Product Installation

## Installation of Helm charts

The modules of the Opus Open Finance platform are distributed via Helm charts, allowing the configurations in Kubernetes to be defined by YAML configuration files.

### Creating Ingresses

Access to most of the platform modules is done through the Kong API Gateway, so creating ingresses is not necessary. For modules exposed directly to users or other systems, the Helm chart can be configured to create an ingress with the configurations below in the `values.yaml` file.

```yaml
ingress:
  enabled: true # Indicates if the ingress should be created
  annotations: # Defines annotations for the ingress
    kubernetes.io/ingress.class: nginx
  hosts:
    - host: auth.bank.com.br # Defines the hostname used to access the ingress
      paths:
        - / # Defines the path used to access the ingress, usually "/"
  tls: 
    - secretName: auth-tls # Defines the secret containing the certificate if the ingress accepts HTTPS connections
      hosts:
        - auth.bank.com.br # Defines the hostname of the route related to this TLS configuration
```

## Autoscaling Configuration

All system modules (except daemons) support autoscaling configuration. This configuration allows Kubernetes to create new instances of a module to temporarily support higher usage loads, based on CPU and memory usage, for example. This configuration is optional and disabled by default but is highly recommended for production environments.

When the configuration is enabled during the installation of a Helm chart, a resource of type HPA (Horizontal Pod Autoscale) will be created in Kubernetes.

The configuration has the following format:

```yaml
hpa:
  enabled: true # Enables the autoscaling configuration
  minReplicas: 1 # Defines the minimum number of instances that will be kept running
  maxReplicas: 10 # Defines the maximum number of instances that can be running
  averageCPUUtilization: 80 # Defines the CPU usage limit considered "normal"
                            # for the module, in percentage. New replicas will be
                            # created if this limit is exceeded
  averageMemoryUtilization: 80 # Defines the memory usage limit considered "normal"
                               # for the module, in percentage. New replicas
                               # will be created if this limit is exceeded
```

For more complex scenarios, the Helm chart accepts the definition of YAML structures to be added to the created HPA. For more details, refer to the [official documentation](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/):

```yaml
hpa:
  behavior: 
  metrics:
```