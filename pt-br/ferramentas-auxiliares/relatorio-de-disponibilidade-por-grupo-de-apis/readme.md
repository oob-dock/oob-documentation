# Scripts SQL - Relatório semanal

- [Introdução](#introdução)
- [Parâmetros de entrada](#parâmetros-de-entrada)
  - [Período dos dados](#período-dos-dados)
  - [Serviços desejados](#lista-dos-serviços-desejados)
- [Scripts - Uso de APIs por agrupamento](#scripts---uso-de-apis-por-agrupamento)
  - [Quantidade de chamadas por grupo de APIs](#quantidade-de-chamadas-por-grupo-de-apis)
  - [Disponibilidade média do conjunto de APIs](#disponibilidade-média---extração-de-dados-do-segundo-semestre)

## Introdução

A Opus está fornecendo alguns scripts SQL que ajudarão os clientes na hora da coleta
de dados para a elaboração do relatório semanal de disponibilidade exigido pelo
Open Finance Brasil **OFB**.

As informações que poderão ser obtidas com eles são:

- a quantidade de chamadas recebidas no período;
- a disponibilidade média no período.

**OBS:** fica a cargo de nossos clientes
rodar os scripts e formatar as informações da forma e no período exigido pelo OFB.

## Parâmetros de entrada

Antes de utilizar os scripts SQL fornecidos pela Opus, deve-se alterar os campos
'<data_inicial>', '<data_final>' e '<services_urls>'
pelos valores do período e pelas urls dos serviços que se deseja obter as informações.

Nesta seção, serão apresentados a formatação e os valores possíveis para cada um
dos parâmetros.

### Período dos dados

Os campos '<data_inicial>' e '<data_final>' definem o período em que se deseja
obter as informações.

A formatação para ambos os campos é **YYYY-MM-DD**.

- YYYY: ano da data desejada
- MM: mês da data desejada
- DD: dia da data desejada

Exemplo de uso:

```sql
@set initial_date = '2022-01-01'
@set final_date = '2022-06-30'
```

### Lista dos serviços desejados

O parâmetro 'endpoints_services' é um parâmetro do tipo array[string], sendo necessário
alterar o campo '<services_urls>' por todas as URLs dos serviços disponibilizados
pela entidade parceira.

Exemplo para obtenção dos serviços da fase 1 - Produtos e Serviços:

```sql
@set endpoints_services = array ['/opendata-accounts/v1/business-accounts', '/opendata-accounts/v1/personal-accounts', '/opendata-creditcards/v1/business-credit-cards', '/opendata-creditcards/v1/personal-credit-cards', '/opendata-financings/v1/business-financings', '/opendata-financings/v1/personal-financings', '/opendata-invoicefinancings/v1/business-invoice-financings', '/opendata-invoicefinancings/v1/personal-invoice-financings', '/opendata-loans/v1/business-loans', '/opendata-loans/v1/personal-loans', '/opendata-unarranged/v1/business-unarranged-account-overdraft', '/opendata-unarranged/v1/personal-unarranged-account-overdraft']
```

Exemplo para obtenção dos serviços da fase 1 - Canais:

```sql
@set endpoints_services = array ['/channels/v2/branches', '/channels/v2/electronic-channels', '/channels/v2/phone-channels', '/channels/v2/banking-agents', '/channels/v2/shared-automated-teller-machines']
```

Logo abaixo são apresentadas tabelas com todos os endpoints divididos em subgrupos
a fim de facilitar a listagem das URLs dos serviços disponibilizados.

Endpoints - Fase 1 Produtos e Serviços

| Endpoint                                                      | Categoria                        |
| /opendata-accounts/v1/business-accounts                       | CONTAS                           |
| /opendata-accounts/v1/personal-accounts                       | CONTAS                           |
| /opendata-creditcards/v1/business-credit-cards                | CARTÃO DE CRÉDITO                |
| /opendata-creditcards/v1/personal-credit-cards                | CARTÃO DE CRÉDITO                |
| /opendata-financings/v1/business-financings                   | FINANCIAMENTO                    |
| /opendata-financings/v1/personal-financings                   | FINANCIAMENTO                    |
| /opendata-invoicefinancings/v1/business-invoice-financings    | DIREITOS CREDITÓRIOS DESCONTADOS |
| /opendata-invoicefinancings/v1/personal-invoice-financings    | DIREITOS CREDITÓRIOS DESCONTADOS |
| /opendata-loans/v1/business-loans                             | EMPRÉSTIMO                       |
| /opendata-loans/v1/personal-loans                             | EMPRÉSTIMO                       |
| /opendata-unarranged/v1/business-unarranged-account-overdraft | ADIANTAMENTO A DEPOSITANTES      |
| /opendata-unarranged/v1/personal-unarranged-account-overdraft | ADIANTAMENTO A DEPOSITANTES      |


Endpoints - Fase 1 Canais

| Endpoint                                                    | Categoria             |
| ----------------------------------------------------------- | --------------------- |
| /channels/v2/branches                                       | CANAIS DE ATENDIMENTO |
| /channels/v2/electronic-channels                            | CANAIS DE ATENDIMENTO |
| /channels/v2/phone-channels                                 | CANAIS DE ATENDIMENTO |
| /channels/v2/banking-agents                                 | CANAIS DE ATENDIMENTO |
| /channels/v2/shared-automated-teller-machines               | CANAIS DE ATENDIMENTO |

## Scripts - Uso de APIs por agrupamento

Os scripts SQL fornecidos nessa seção devem ser operados no
**banco de dados do OOB-Status** e devem ser utilizados de acordo com o intervalo de
datas desejadas.
Caso surja alguma dúvida da formatação dos
parâmetros de entrada, verificar seção [Parâmetros de Entrada](#parâmetros-de-entrada).

### Quantidade de chamadas do grupo de APIs

```sql
@set initial_date = '<data_inicial>'
@set final_date = '<data_final>'
@set endpoints_services = array ['<services_urls>']

SELECT
  :initial_date as initial_date,
  :final_date as final_date,
  SUM(qty_requests) as qty_requests
FROM
  endpoint_metric edm 
LEFT JOIN "endpoint" edp on edp.id = edm.id_endpoint
WHERE TO_CHAR(edm."date", 'YYYY-MM-DD') between :initial_date and :final_date AND edp.endpoint_url = ANY(:endpoints_services);
```

### Disponibilidade média do grupo de APIs

```sql
@set initial_date = '<data_inicial>';
@set final_date = '<data_final>';
@set endpoints_services = array ['<services_urls>'];

SELECT
  :initial_date as initial_date,
  :final_date as final_date,
  ((86386 * (:final_date::date - :initial_date::date + 1)) - (sum (seconds_downtime))) / (86386 * (:final_date::date - :initial_date::date + 1))::decimal as perc_online
FROM
  daily_metric_endpoint dme
LEFT JOIN "endpoint" edp on dme.id_endpoint = edp.id
WHERE
  dme.metric_date BETWEEN :initial_date AND :final_date
  AND edp.endpoint_url = ANY(:endpoints_services);
```

## Execução de relatórios com consolidação de dados por organização

Caso a organização possua duas ou mais marcas, para as consultas que devem ser realizadas na base de dados do serviço **OOB-Status** é necessário utilizar o script abaixo, no qual além dos parâmetros originais (data de início e/ou data final), é preciso informar uma string de conexão para que a comunicação com as bases das outras marcas seja realizada.
Para tal, é necessário que o componente "dblink" seja instalado nas bases principais, por meio do comando:

```sql
CREATE EXTENSION IF NOT EXISTS "dblink";
```

a string de conexão deve ser formatada da seguinte maneira:

host={db_target_host} dbname={db_target_dbname} user={db_target_user} password={db_target_password}

### Quantidade de chamadas do grupo de APIs - organização

```sql
@set initial_date = '<data_inicial>'
@set final_date = '<data_final>'
@set endpoints_services = array ['<services_urls>']
@set dblink_conn = 'host={db_target_host} dbname={db_target_dbname} user={db_target_user} password={db_target_password}'

select 
  :initial_date as initial_date,
  :final_date as final_date,
  SUM(tb1.qty_requests) as qty_requests
 from (
 	SELECT
	  :initial_date as initial_date,
	  :final_date as final_date,
	  SUM(qty_requests) as qty_requests
	FROM
	  endpoint_metric edm 
	LEFT JOIN "endpoint" edp on edp.id = edm.id_endpoint
	WHERE TO_CHAR(edm."date", 'YYYY-MM-DD') between :initial_date and :final_date AND edp.endpoint_url = ANY(:endpoints_services)
	
	union all
	
		SELECT * 
        FROM dblink(
            :dblink_conn,
            FORMAT(
            'SELECT %L as initial_date, %L as final_date, SUM(qty_requests) as qty_requests FROM endpoint_metric edm LEFT JOIN "endpoint" edp on edp.id = edm.id_endpoint WHERE TO_CHAR(edm."date", ''YYYY-MM-DD'') between %L and %L AND edp.endpoint_url = ANY(%L)',
            :initial_date,
            :final_date,
            :initial_date,
            :final_date,
            :endpoints_services
            )
            ) AS t(
                initial_date TEXT,
                final_date TEXT,
                qty_requests BIGINT
            )
 ) tb1;
```

### Disponibilidade média do grupo de APIs  - organização

```sql
@set initial_date = '<data_inicial>';
@set final_date = '<data_final>';
@set endpoints_services = array ['<services_urls>'];
@set dblink_conn = 'host={db_target_host} dbname={db_target_dbname} user={db_target_user} password={db_target_password}'

select 
  :initial_date as initial_date,
  :final_date as final_date,
  MAX(tb1.perc_online) as qty_requests
 from (
 	SELECT
	  :initial_date as initial_date,
	  :final_date as final_date,
	  ((86386 * (:final_date::date - :initial_date::date + 1)) - (sum (seconds_downtime))) / (86386 * (:final_date::date - :initial_date::date + 1))::decimal as perc_online
	FROM
	  daily_metric_endpoint dme
	LEFT JOIN "endpoint" edp on dme.id_endpoint = edp.id
	WHERE
	  dme.metric_date BETWEEN :initial_date AND :final_date
	  AND edp.endpoint_url = ANY(:endpoints_services)
	
	union all
	
		SELECT * 
        FROM dblink(
            :dblink_conn,
            FORMAT(
            'select %L as initial_date, %L as final_date, ((86386 * (%L::date - %L::date + 1)) - (sum (seconds_downtime))) / (86386 * (%L::date - %L::date + 1))::decimal as perc_online from daily_metric_endpoint dme LEFT JOIN "endpoint" edp on dme.id_endpoint = edp.id where dme.metric_date BETWEEN %L AND %L AND edp.endpoint_url = ANY(%L)',
            :initial_date,
            :final_date,
            :final_date,
            :initial_date,
            :final_date,
            :initial_date,
            :initial_date,
            :final_date,
            :endpoints_services
            )
            ) AS t(
                initial_date TEXT,
                final_date TEXT,
                perc_online NUMERIC
            )
 ) tb1;
```
