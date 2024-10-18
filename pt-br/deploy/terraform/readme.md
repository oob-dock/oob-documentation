# Configurações via Terraform

- [Configurações via Terraform](#configurações-via-terraform)
  - [Configuração das rotas do Kong](#configuração-das-rotas-do-kong)
    - [Configuração](#configuração)
      - [kong\_admin\_uri](#kong_admin_uri)
      - [kong\_admin\_tls\_skip\_verify](#kong_admin_tls_skip_verify)
      - [kong\_admin\_token](#kong_admin_token)
      - [kong\_admin\_username](#kong_admin_username)
      - [kong\_admin\_password](#kong_admin_password)
      - [kong\_api\_key](#kong_api_key)
      - [oob\_status\_api\_host](#oob_status_api_host)
      - [oob\_status\_api\_port](#oob_status_api_port)
      - [oob\_consent\_api\_host](#oob_consent_api_host)
      - [oob\_consent\_api\_port](#oob_consent_api_port)
      - [cors\_origins](#cors_origins)
      - [transaction\_limit\_global\_per\_second](#transaction_limit_global_per_second)
      - [transaction\_limit\_per\_ip\_per\_minute](#transaction_limit_per_ip_per_minute)
      - [api\_docs\_enabled](#api_docs_enabled)
      - [oob\_financial\_data\_api\_host](#oob_financial_data_api_host)
      - [oob\_financial\_data\_api\_port](#oob_financial_data_api_port)
      - [oob\_payment\_api\_host](#oob_payment_api_host)
      - [oob\_payment\_api\_port](#oob_payment_api_port)
      - [introspection\_client\_id](#introspection_client_id)
      - [introspection\_client\_secret](#introspection_client_secret)
      - [auth\_server\_url](#auth_server_url)
      - [auth\_server\_base\_path](#auth_server_base_path)
      - [public\_fqdn](#public_fqdn)
      - [public\_fqdn\_mtls](#public_fqdn_mtls)
      - [internal\_fqdn](#internal_fqdn)
      - [supported\_features](#supported_features)
      - [brand\_id](#brand_id)
      - [x\_forwarded\_for\_header\_name](#x_forwarded_for_header_name)
      - [ssl\_certificate\_header\_name](#ssl_certificate_header_name)
      - [server\_org\_id](#server_org_id)
      - [pubsub\_id](#pubsub_id)
      - [route\_block\_enabled](#route_block_enabled)
      - [mqd\_event\_enabled](#mqd_event_enabled)
      - [opentelemetry\_tracer\_exporter\_url\_http](#opentelemetry_tracer_exporter_url_http)
  - [Configuração do Grafana](#configuração-do-grafana)
    - [Configuração](#configuração-1)
      - [configure\_kong\_grafana\_dashboard](#configure_kong_grafana_dashboard)
      - [grafana\_uri](#grafana_uri)
      - [grafana\_username](#grafana_username)
      - [grafana\_password](#grafana_password)
      - [prometheus\_uri](#prometheus_uri)
  - [Executando os scripts Terraform](#executando-os-scripts-terraform)
    - [main.tf](#maintf)
    - [variables.tf](#variablestf)
    - [ambiente.tfvars](#ambientetfvars)

A configuração dos sistemas externos aos OOB é feita via terraform, sendo que
existem dois módulos base que podem ser utilizados:

- kubernetes: deve ser utilizado por clientes que possuem uma marca única

- kubernetes_multibrand: deve ser utilizado por clientes que possuem mais de uma
marca listada no diretório de participantes (por exemplo, instituições distintas).
Neste caso várias das configurações estão na estrutura brands, e devem ser
declaradas para cada marca.

## Configuração das rotas do Kong

A configuração das rotas no Kong é obrigatória para o funcionamento do sistema

### Configuração

#### kong_admin_uri

URL do portal de administração do kong

**Ex:** "<https://kong-admin-oob.endereco.com.br/>"

#### kong_admin_tls_skip_verify

Indica se deve ignorar a validação de certificado TLS para a API do kong quando
for utilizado https

**Formato:** `true` ou `false`

#### kong_admin_token

Parâmetro opcional com o token utilizado para acessar a API de admin do Kong

**Ex:** "eyJhbGciOiJIUzI1NiJ9.MQ._Eo4szTYEfg90An06hX4C2tUAQcDucX_9xxFb19IJJv"

#### kong_admin_username

Parâmetro opcional com o username utilizado para acessar a API de admin do Kong

**Ex:** "admin"

#### kong_admin_password

Parâmetro opcional com a senha utilizada para acessar a API de admin do Kong

**Ex:** "P@sswOrd"

#### kong_api_key

Parâmetro opcional com a API Key utilizada para acessar a API de admin do Kong

**Ex:** "26b00dcb-fdb8-4682-87cd-660ee9b9210f"

#### oob_status_api_host

Host da API de status

**Ex:** "oob-status"

#### oob_status_api_port

Porta da API de status

**Ex:** "80"

#### oob_consent_api_host

Host da API de consentimento

**Ex:** "oob-consent"

#### oob_consent_api_port

Porta da API de consentimento

**Ex:** "80"

#### cors_origins

Indica origens permitidas nos cabeçalhos do CORS

**Ex:** "*"

#### transaction_limit_global_per_second

Limite de transações por segundo compartilhado por todos os clientes

**Ex:** "300"

#### transaction_limit_per_ip_per_minute

Limite de transações por segundo por IP de cliente

**Ex:** "500"

#### api_docs_enabled

Indica se a documentação da API deve ser habilitada ou não, sendo útil somente
para desenvolvimento. Não é recomendada para produção.

**Formato:** `true` ou `false`

#### oob_financial_data_api_host

Host da API de dados financeiros. Deve ser preenchido somente se a feature financial-data
(Fase 2 do Open Banking Brasil) estiver habilitada.

**Ex:** "oob-financial-data"

#### oob_financial_data_api_port

Porta da API de dados financeiros

**Ex:** "80"

#### oob_payment_api_host

Host da API de pagamento. Deve ser preenchido somente se a feature payments
(Fase 3 do Open Banking Brasil) estiver habilitada.

**Ex:** "oob-payment"

#### oob_payment_api_port

Porta da API de pagamento

**Ex:** "80"

#### introspection_client_id

Vide a [definição](../shared-definitions.md#introspection_client_id)

#### introspection_client_secret

Vide a [definição](../shared-definitions.md#introspection_client_secret)

#### auth_server_url

Vide a [definição](../shared-definitions.md#auth_server_url)

#### auth_server_base_path

Vide a [definição](../shared-definitions.md#auth_server_base_path)

#### public_fqdn

FQDN público onde as APIs do open banking podem ser acessadas

**Ex:** "oob.endereco.com.br"

#### public_fqdn_mtls

FQDN público onde as APIs do open banking podem ser acessadas com mTLS

**Ex:** "mtls-oob.endereco.com.br"

#### internal_fqdn

Parâmetro opcional para inclusão de um FQDN interno onde as APIs de Backoffice
do open banking podem ser acessadas

**Ex:** "internal.endereco.com.br"

#### supported_features

Vide a [definição](../shared-definitions.md#suporte-a-features-do-opus-open-banking)

**Ex:** ["core", "open-data", "financial-data", "payments"]

#### brand_id

Vide a [definição](../shared-definitions.md#brand-id)

#### x_forwarded_for_header_name

Define qual será o nome do header utilizado para identificar o endereço IP
originário do request. No contexto de PCM este header é utilizado para
preencher o campo `additionalInfo.clientIp` no evento gerado pelo plugin
`oob-api-event` do Kong.

**Default:** `X-Forwarded-For`

#### ssl_certificate_header_name

Define qual será o nome do header utilizado que será enviado o certificado
mTLS do client que fez o request. No contexto de PCM e MQD este header é
utilizado para obter o clientOrgId da receptora de dados ou iniciadora
de pagamentos para ser utilizado pelos plugins `oob-api-event` e
`oob-mqd-event` do Kong.

**Default:** `X-SSL-Client-Cert`

#### server_org_id

Identificador da organização no diretório de participantes.

#### pubsub_id

Identificador do componente de publish/subscribe do [Dapr](../shared-definitions.md#dapr).

**Ex:** `event-publisher`

#### route_block_enabled

Define se as rotas do Kong devem ou não ser bloqueadas de acordo com as datas regulatórias.
Essa variável deve ser mantida como `true` nos ambientes produtivos, mas configurada
como `false` nos ambientes de homologação para execução da certificação.

**Default:** `true`
**Valores possíveis:** `true` ou `false`

#### mqd_event_enabled

Define se a instalação deverá ou não enviar eventos de chamadas dos endpoints
vinculados ao Motor de Qualidade de Dados (MQD). Caso a variável seja definida
com o valor `true` a configuração de cada rota será levada em conta para
decidir se o evento será enviado ou não. Caso a variável seja definda com o
valor `false` a configuração de cada rota será ignorada e nenhum evento será
gerado.

**Valores possíveis:** `true` ou `false`

#### opentelemetry_tracer_exporter_url_http

Endereço da ferramenta de análise de rastreamento distribuído. **Importante:**
Esta variável deverá estar preenchida com o valor do endereço **HTTP**
disponibilizado pela ferramenta para receber as informações de rastreamento.

**Atenção:** A variável acima trabalha em conjunto com duas outras variáveis de
ambiente do kong: `KONG_TRACING_INSTRUMENTATIONS` e `KONG_TRACING_SAMPLING_RATE`.

- `KONG_TRACING_INSTRUMENTATIONS`: Define qual o nível de instrumentação será
aplicado aos requests do Kong. **Valor recomendado:** `all`. A lista completa
de valores possíveis pode ser conferida [neste link](https://docs.konghq.com/gateway/latest/production/tracing/).
- `KONG_TRACING_SAMPLING_RAGE`: Define a taxa de amostragem (sampling rate)
para o rastreamento distribuído, ou seja, a proporção de solicitações que
serão coletadas e enviadas para análise. Possíveis valores: `0` a `1`. Por
exemplo, um valor de `0.5` significa que 50% dos requests serão amostrados.
**Importante:** Caso deseje desabilitar totalmente o envio de traces para a
ferramenta receptora basta definir o valor desta variável como `0`.

Necessário definir estas variáveis de ambiente **diretamente no Kong** com os
valores apropriados para que o funcionamento desejado da instrumentação
aconteça.

## Configuração do Grafana

A configuração do Grafana é opcional. Caso ela seja ativada, um dashboard será
criado com informações sobre o status do Kong. Por padrão, essa configuração
está desativada então os parâmetros listados abaixo só precisam ser informados caso
a configuração do Grafana seja necessária.

Essa configuração pode ser feita ativando a flag `configure_kong_grafana_dashboard`
no módulo kubernetes (ou kubernetes_multibrand) ou executando o módulo grafana
separadamente, com os mesmos parâmetros.

### Configuração

#### configure_kong_grafana_dashboard

Ativa a criação do dashboard do Kong no Grafana

**Ex:** true

#### grafana_uri

URI para acesso ao grafana

**Ex:** "<https://grafana-oob.endereco.com.br>"

#### grafana_username

Usuário administrador do grafana

#### grafana_password

Senha do usuário administrador do grafana

#### prometheus_uri

URI para acesso ao prometheus

**Ex:** "<https://prometheus-oob.endereco.com.br>"

## Executando os scripts Terraform

A melhor forma de utilizar os scripts Terraform enviados é criar um novo script
que chama os módulos entregues e define o local de armazenamento do estado. Esse
script pode conter também as variáveis definidas para o ambiente onde a instalação
está sendo feita, assim as mesmas configurações serão utilizadas nas próximas execuções.

A estrutura sugerida possui três arquivos:

- `main.tf`: consome as configurações e chama os módulos Terraform do OOB
- `variables.tf`: Define as variáveis que serão definidas por ambiente (produção,
homologação, etc) na execução do script)
- `ambiente.tfvars`: Define os valores das variáveis para um ambiente. Vários
arquivos desse tipo pode ser criados para definir configurações de ambientes distintos.
Esse arquivo deve ser especificado no comando de execução do script Terraform.

É altamente recomendável que esses arquivos sejam persistidos em algum mecanismos
de versionamento, como um servidor GIT, sempre se atentando à presença de dados sensíveis.

Exemplos:

### main.tf

```HCL
## O exemplo abaixo utiliza o AWS S3 para persistência do estado, entretanto qualquer
## mecanismo de persistência pode ser utilizado. É importante que o mesmo mecanismo
## seja utilizado em todas as execuções do script e que os dados gerados na execução
## anterior estejam disponíveis nesse mecanismo para a próxima.
terraform {
  backend "s3" {
    bucket = "oob-terraform-env2"
    region = "sa-east-1"
    profile = "opus-labs"
    key = "state"
  }
}

module "kubernetes" {
  source = "./kubernetes"
  kong_admin_uri = var.kong_admin_uri
  kong_admin_tls_skip_verify = var.kong_admin_tls_skip_verify

  ...

  public_fqdn = var.public_fqdn
  public_fqdn_mtls = var.public_fqdn_mtls
  supported_features = var.supported_features
  brand_id = var.brand_id
}
```

### variables.tf

```HCL
variable "kong_admin_uri" {
  description = "Kong Admin URL"
}

variable "kong_admin_tls_skip_verify" {
  description = "Whether to skip tls certificate verification for the kong api when using https"
}

...

variable "public_fqdn" {
  description = "Public FQDN where the openbanking APIs can be accessed"
  type        = string
}

variable "public_fqdn_mtls" {
  description = "Public FQDN where the openbanking APIs can be accessed with mTLS"
  type        = string
}

variable "supported_features" {
  description = "Features supported by institution"
  type        = list(string)
}

variable "brand_id" {
  description = "Brand id"
  type        = string
}
```

### ambiente.tfvars

```HCL
kong_admin_uri = "http://kong-admin.bank.com.br"
kong_admin_tls_skip_verify = "true"

...

public_fqdn = "openbanking.bank.com.br"
public_fqdn_mtls = "mtls-openbanking.bank.com.br"
supported_features = ["core", "payments"]
brand_id="cbanco"
```
