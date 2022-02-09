# Instalação do produto

## Instalação de Helm charts

Os módulos da plataforma OOB são distribuídos através de Helm charts, eles
permitem que as configurações no Kubernetes sejam definidas por arquivos de
configuração yaml.

### Criação de Ingresses

O acesso à maioria dos módulos da plataforma é feito através do Kong, portanto a
criação de ingresses não é necessária. Para os módulos expostos diretamente para
os usuários ou outros sistemas, o helm chart pode ser configurado para criar um
ingress com as configurações abaixo no arquivo values.yaml

```yaml
ingress:
  enabled: true # Indica se o ingress deve ser criado
  annotations: # Define as anotações para o ingress
    kubernetes.io/ingress.class: nginx
  hosts:
    - host: auth.bank.com.br # Define o hostname utilizado para acessar o ingress
      paths:
        - / # Define o path utilizado para acessar o ingress, geralmente "/"
  tls: 
    - secretName: auth-tls # Define o secret que contém o certificado caso o ingress aceite conexões HTTPS
      hosts:
        - auth.bank.com.br # Define o hostname da rota relacionada a essa configuração de tls
```

## Configuração do autoscaling

Todos os módulos do sistema (com exceção dos daemons) suportam configuração de
autoscaling. Essa configuração permite definir quando o Kubernetes deve criar novas
instâncias de um módulo para suportar uma carga maior de uso temporariamente,
baseado no uso de CPU e memória, por exemplo. Essa configuração é opcional e está
desabilitada por padrão mas é altamente recomendada para o ambiente de produção.

Quando a configuração é habilitada na instalação de um helm chart, um recurso do
tipo HPA (Horizontal Pod Autoscale) será criado no Kubernetes.

A configuração tem o seguinte formato:

```yaml
hpa:
  enabled: true # Habilita a configuração de autoscaling
  minReplicas: 1 # Define o número mínimo de instâncias que serão mantidos em execução
  maxReplicas: 10 # Define o número máximo de instâncias que podem estar em execução
  averageCPUUtilization: 80 # Define o limite de uso de CPU considerado "normal"
                            #   para o módulo, em porcentagem. Novas réplicas serão
                            #   criadas caso este limite seja ultrapassado
  averageMemoryUtilization: 80 # Define o limite de uso de memória considerado "normal"
                               #   para o módulo, em porcentagem. Novas réplicas
                               #   serão criadas caso este limite seja ultrapassado
```

Para cenários mais complexos, o helm chart aceita a definição de estruturas em
yaml a serem adicionadas no HPA criado. Para mais detalhes, consulte a
[documentação oficial](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/):

```yaml
hpa:
  behavior: 
  metrics:
```
