# Instalação do Kong

## Instalação

A instalação do módulo é feita via terraform

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

Host da API de produtos e serviços

**Ex:** "oob-products-services-catalog"

### oob_products_services_catalog_api_port

Porta da API de produtos e serviços

**Ex:** "80"

### oob_channels_catalog_api_host

Host da API de canais

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

Indica se a documentação da API deve ser habilitada ou não

**Formato:** `true` ou `false`

### oob_financial_data_api_host

Host da API de dados financeiros

**Ex:** "oob-financial-data"

### oob_financial_data_api_port

Porta da API de dados financeiros

**Ex:** "80"

### oob_payment_api_host

Host da API de pagamento

**Ex:** "oob-payment"

### oob_payment_api_port

Porta da API de pagamento

**Ex:** "80"

### introspection_client_id

Identificador do cliente para instrospection do token

**Ex:** "oob-internal-client"

### introspection_client_secret

Segredo do cliente para instrospection do token

### auth_server_url

URL para acesso ao servidor de autorização

**Ex:** "<http://oob-authorization-server>"

### auth_server_base_path

Caminho base para acessar o servidor de autorização

**Ex:** "/auth/"

### public_fqdn

FQDN público onde as APIs do open banking podem ser acessadas

**Ex:** "oob.endereco.com.br"

### public_fqdn_mtls

FQDN público onde as APIs do open banking podem ser acessadas com mTLS

**Ex:** "mtls-oob.endereco.com.br"

### supported_features

Módulos suportados pela instituição

**Ex:** ["core", "open-data", "financial-data", "payments"]

### brand_id

Identificador da marca

**Ex:** "cbanco"
