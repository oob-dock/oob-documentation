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
