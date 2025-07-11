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
      - [oob\_authorization\_server\_host](#oob_authorization_server_host)
      - [oob\_authorization\_server\_port](#oob_authorization_server_port)
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
      - [auth\_server\_nonfapi\_base\_path](#auth_server_nonfapi_base_path)
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
      - [log\_request\_response\_enabled](#log_request_response_enabled)
      - [log\_request\_response\_collector\_url\_http](#log_request_response_collector_url_http)
      - [ocsp\_validation\_enabled](#ocsp_validation_enabled)
      - [ocsp\_cache\_ms\_duration](#ocsp_cache_ms_duration)
      - [ocsp\_server\_request\_ms\_timeout](#ocsp_server_request_ms_timeout)
      - [operational\_limits\_enabled](#operational_limits_enabled)
      - [operational\_limits\_allow\_when\_over\_limit](#operational_limits_allow_when_over_limit)
      - [operational\_limits\_check\_limit\_timeout\_ms](#operational_limits_check_limit_timeout_ms)
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

#### oob_authorization_server_host

Host da API do servidor de autorização

**Ex:** "oob-authorization-server"

#### oob_authorization_server_port

Porta da API do servidor de autorização

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

#### auth_server_nonfapi_base_path

Vide a [definição](../shared-definitions.md#auth_server_nonfapi_base_path)

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

Vide a [definição](../shared-definitions.md#suporte-a-features-do-opus-open-finance)

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
Geralmente, para HTTP, o endpoint de envio das informações de rastreamento é o
caminho `<protocolo>://<host>:<porta>/v1/traces`, no entanto é recomendado
confirmar se a ferramenta escolhida de fato utiliza esse endereço ou
disponibiliza outro para esta finalidade.

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

#### log_request_response_enabled

Define se a instalação deverá ou não logar as requisições e respostas
regulatórias chamadas no produto. Caso a variável seja definida com o valor
`true` a configuração de cada rota será levada em conta para decidir se a
requisição e resposta serão logadas ou não. Caso a variável seja definida com o
valor `false` a configuração de cada rota será ignorada e nenhuma requisição e
resposta regulatória será logada.

**Valores possíveis:** `true` ou `false`

#### log_request_response_collector_url_http

Endereço da ferramenta coletora de logs que será responsável por receber os
logs das requisições e respostas regulatórias. Pelo tamanho e característica
das requisições e respostas não é possível utilizar o log padrão do Kong, pois
ele possui uma limitação de tamanho. Sendo assim, o coletor de log é necessário
para que nenhuma informação do conjunto requisição/resposta seja perdida.

Essa variável é de preenchimento obrigatório caso a variável
`log_request_response_enabled` esteja definida como `true`.

#### ocsp_validation_enabled

Define se a instalação deverá ou não realizar a validação de OCSP. Quando
habilitado um plugin no Kong será criado e vinculado aos serviços de rotas
e para todo request que tiver um certificado de cliente atrelado à requisição
será realizada a verificação de OCSP.

**Valores possíveis:** `true` ou `false`

**Default:** `false`

#### ocsp_cache_ms_duration

Define a duração em milissegundos do cache da validação de OCSP feita pelo
plugin do Kong customizado `oob-ocsp-validation`.

**Default:** `600000`

#### ocsp_server_request_ms_timeout

Define quantos milissegundos o produto esperará, no máximo, pela resposta da
chamada feita ao servidor de OCSP para consultar o status do certificado.
Quando definido como `0` o produto não realizará a consulta ao servidor de
OCSP de maneira síncrona, apenas de maneira assíncrona.

**Default:** `0`

#### operational_limits_enabled

Define se a instalação fará ou não a validação de limites operacionais. Quando
habilitada, a validação de limites operacionais contabilizará as chamadas
realizadas validando se essas chamadas estão dentro dos limites definidos pela
iniciativa. Adicionará também alguns cabeçalhos customizados na resposta com
algumas informações sobre a validação, sendo eles:

- `x-operational-limits`: indicando quantas chamadas foram realizadas dentro do
total permitido (por exemplo: `2/4`);
- `x-operational-limits-result`: preenchida quando é necessário indicar algum
erro de validação/processamento durante o processo de contabilização da
chamada;
- `Retry-After`: em caso de limite operacional atingido indica a data na qual a
chamada poderá ser realizada novamente.

**Valores possíveis:** `true` ou `false`

**Default:** `false`

#### operational_limits_allow_when_over_limit

Variável utilizada pelo produto quando a validação de limites operacionais
estiver ativa na instalação. Se esta variável estiver definida como `true`
ainda que o limite operacional de uma chamada tenha sido atingido o produto
irá permitir que a requisição realizada prossiga. Caso ela esteja definida como
`false` e o limite operacional tenha sido atingido, o produto bloqueará a
resposta da requisição retornando o status HTTP `423`.

**Valores possíveis:** `true` ou `false`

**Default:** `false`

#### operational_limits_check_limit_timeout_ms

Variável utilizada pelo produto quando a validação de limites operacionais
estiver ativa na instalação. Define quantos milissegundos o produto esperará,
no máximo, pela resposta da chamada feita ao serviço de limites operacionais
para realizar a contabilização da requisição.

**Default:** `100`

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
