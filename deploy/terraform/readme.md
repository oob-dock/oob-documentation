# Configuração das rotas do Kong

## Instalação

A configuração do módulo é feita via terraform, sendo que existem dois módulos
base que podem ser utilizados:

* kubernetes: deve ser utilizado por clientes que possuem uma marca única

* kubernetes_multibrand: deve ser utilizado por clientes que possuem mais de uma
marca listada no diretório de participantes (por exemplo, instituições distintas).
Neste caso várias das configurações estão na estrutura brands, e devem ser
declaradas para cada marca.

## Configuração

### kong_admin_uri

URL do portal de administração do kong

**Ex:** "<https://kong-admin-oob.endereco.com.br/>"

### kong_admin_tls_skip_verify

Indica se deve ignorar a validação de certificado TLS para a API do kong quando
for utilizado https

**Formato:** `true` ou `false`

### oob_status_api_host

Host da API de status

**Ex:** "oob-status"

### oob_status_api_port

Porta da API de status

**Ex:** "80"

### oob_products_services_catalog_api_host

Host da API de produtos e serviços. Deve ser preenchido somente se a feature open-data
(Fase 1 do Open Banking Brasil) estiver habilitada.

**Ex:** "oob-products-services-catalog"

### oob_products_services_catalog_api_port

Porta da API de produtos e serviços

**Ex:** "80"

### oob_channels_catalog_api_host

Host da API de canais. Deve ser preenchido somente se a feature open-data
(Fase 1 do Open Banking Brasil) estiver habilitada.

**Ex:** "oob-channels-catalog"

### oob_channels_catalog_api_port

Porta da API de canais

**Ex:** "80"

### oob_consent_api_host

Host da API de consentimento

**Ex:** "oob-consent"

### oob_consent_api_port

Porta da API de consentimento

**Ex:** "80"

### cors_origins

Indica origens permitidas nos cabeçalhos do CORS

**Ex:** "*"

### transaction_limit_global_per_second

Limite de transações por segundo compartilhado por todos os clientes

**Ex:** "300"

### transaction_limit_per_ip_per_minute

Limite de transações por segundo por IP de cliente

**Ex:** "500"

### grafana_uri

URI para acesso ao grafana

**Ex:** "<https://grafana-oob.endereco.com.br>"

### grafana_username

Usuário administrador do grafana

### grafana_password

Senha do usuário administrador do grafana

### prometheus_uri

URI para acesso ao prometheus

**Ex:** "<https://prometheus-oob.endereco.com.br>"

### api_docs_enabled

Indica se a documentação da API deve ser habilitada ou não, sendo útil somente
para desenvolvimento. Não é recomendada para produção.

**Formato:** `true` ou `false`

### oob_financial_data_api_host

Host da API de dados financeiros. Deve ser preenchido somente se a feature financial-data
(Fase 2 do Open Banking Brasil) estiver habilitada.

**Ex:** "oob-financial-data"

### oob_financial_data_api_port

Porta da API de dados financeiros

**Ex:** "80"

### oob_payment_api_host

Host da API de pagamento. Deve ser preenchido somente se a feature payments
(Fase 3 do Open Banking Brasil) estiver habilitada.

**Ex:** "oob-payment"

### oob_payment_api_port

Porta da API de pagamento

**Ex:** "80"

### introspection_client_id

Vide a [definição](../shared-definitions.md#introspection_client_id)

### introspection_client_secret

Vide a [definição](../shared-definitions.md#introspection_client_secret)

### auth_server_url

Vide a [definição](../shared-definitions.md#auth_server_url)

### auth_server_base_path

Vide a [definição](../shared-definitions.md#auth_server_base_path)

### public_fqdn

FQDN público onde as APIs do open banking podem ser acessadas

**Ex:** "oob.endereco.com.br"

### public_fqdn_mtls

FQDN público onde as APIs do open banking podem ser acessadas com mTLS

**Ex:** "mtls-oob.endereco.com.br"

### supported_features

Vide a [definição](../shared-definitions.md#suporte-a-features-do-opus-open-banking)

**Ex:** ["core", "open-data", "financial-data", "payments"]

### brand_id

Vide a [definição](../shared-definitions.md#brand-id)
