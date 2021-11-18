# Instalação do OOB Portal Back Office

## Instalação

A instalação do módulo é feita via Helm Chart

## Configuração

### baseApiUrl

Endereço público pelo qual o portal (que roda no browser do usuário) consegue
acessar as APIs do OOB.

Ex: `https://kong.bank.com.br`

## Exposição

Como o acesso ao Portal Back Office não é feito através do Kong, um ingress
precisa ser criado. [Mais detalhes aqui](../readme.md#criação-de-ingresses)

```yaml
ingress:
  enabled: true # Indica se o ingress deve ser criado
  annotations: # Define as anotações para o ingress
    kubernetes.io/ingress.class: nginx
  hosts:
    - host: portal-backoffice.bank.com.br # Define o hostname utilizado para acessar o ingress
      paths:
        - / # Define o path utilizado para acessar o ingress, geralmente "/"
  tls: 
    - secretName: portal-backoffice-tls # Define o secret que contém o certificado caso o ingress aceite conexões HTTPS
      hosts:
        - portal-backoffice.bank.com.br # Define o hostname da rota relacionada a essa configuração de tls
```
