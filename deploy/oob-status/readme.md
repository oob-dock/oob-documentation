# Instalação do OOB Status

## Instalação

A instalação do módulo é feita via Helm Chart

## Configuração

### db

Configuração de acesso ao banco

* name: Nome da base
* username: Nome do usuário de acesso ao banco
* password: Senha do usuário de acesso ao banco
* host: Host do banco

### liquibase/contexts

Contexto que deve ser utilizado para criar a base de dados. Utilizar "demo" para
criar dados de exemplo na base. Utilizar "default" para ambientes de homologação
ou produção.

### services

Configuração dos endereços dos serviços monitorados/utilizados pela API

* prometheus/baseAddress: Endereço base do prometheus

**Ex:** `http://prometheus-server` #Apontamento interno no K8s

* channels/baseAddress: Endereço base da API de canais (fase 1)

**Ex:** `http://oob-channels-catalog` #Apontamento interno no K8s

* productsServices/baseAddress: Endereço base da API de produtos e serviços
(fase 1)

**Ex:** `http://oob-products-services-catalog` #Apontamento interno no K8s

* financialData/baseAddress: Endereço base da API de dados financeiros
(fase 2)

**Ex:** `http://oob-financial-data` #Apontamento interno no K8s

* payment/baseAddress: Endereço base da api de pagamentos
(fase 3)

**Ex:** `http://oob-payment` #Apontamento interno no K8s

* consent/baseAddress: Endereço base da API de consentimento

**Ex:** `http://oob-consent` #Apontamento interno no K8s

### features

Define as features da instalação

**Ex:** core,open-data,financial-data,payments

### plugins/metrics/brandId

Identificação da marca da instalação

**Ex:** cbanco
