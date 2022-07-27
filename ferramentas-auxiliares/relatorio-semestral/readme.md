# Scripts SQL - Relatório semestral

- [Introdução](#introdução)
- [Parâmetros de entrada](#parâmetros-de-entrada)
  - [Período dos dados](#período-dos-dados)
  - [Serviços desejados](#lista-dos-serviços-desejados)
- [Scripts - Chamadas de APIs](#scripts---chamadas-de-apis)
  - [Quantidade de chamadas de API - Primeiro semestre](#quantidade-de-chamadas-de-api---extração-de-dados-do-primeiro-semestre)
  - [Quantidade de chamadas de API - Segundo semestre](#quantidade-de-chamadas-de-api---extração-de-dados-do-segundo-semestre)
  - [Disponibilidade média - Primeiro semestre](#disponibilidade-média---extração-de-dados-do-primeiro-semestre)
  - [Disponibilidade média - Segundo semestre](#disponibilidade-média---extração-de-dados-do-segundo-semestre)

## Introdução

A Opus está fornecendo alguns scripts SQL que ajudarão os clientes na hora da coleta
de dados para a elaboração do relatório semestral exigido pelo
Open Banking Brasil **OBB**.

As informações que poderão ser obtidas com eles são:

- a quantidade de chamadas de API em cada mês, para cada endpoint
- a disponibilidade média no período

**OBS:** fica a cargo de nossos clientes
rodar os scripts e formatar as informações da forma e no período exigido pelo OBB.

## Parâmetros de entrada

Antes de utilizar os scripts SQL fornecidos pela Opus, deve-se alterar os campos
'<data_inicial>', '<data_final>' e '<service_1_url>'
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

Exemplo de uso para quantidade de chamadas:

```sql
@set initial_date = '2022-01-01 00:00:00.000 -0300'
@set final_date = '2022-06-30 23:59:59.999 -0300'
```

Exemplo de uso para disponibilidade média:

```sql
@set initial_date = '2022-01-01'
@set final_date = '2022-06-30'
```

### Lista dos serviços desejados

O parâmetro 'endpoints_services' é um parâmetro do tipo array[string], sendo necessário
alterar o campo '<service_1_url>' por todas as URLs dos serviços disponibilizados
pela entidade parceira.

Exemplo para obtenção dos serviços da fase 3 - Iniciação de Pagamento:

```sql
@set endpoints_services = array ['/consents/v1/consents','/consents/v1/consents/{consentId}', '/payments/v1/consents', '/payments/v1/consents/{consentId}', '/payments/v1/pix/payments', '/payments/v1/pix/payments/{paymentId}', '/resources/v1/resources']
```

Exemplo para obtenção dos serviços da fase 2 - Dados Cadastrais:

```sql
@set endpoints_services = array ['/customers/v1/personal/identifications','/customers/v1/business/identifications', '/customers/v1/personal/qualifications', '/customers/v1/business/qualifications', '/customers/v1/personal/financial-relations', '/customers/v1/business/financial-relations']
```

Logo abaixo são apresentadas tabelas com todos os endpoints divididos em subgrupos
a fim de facilitar a listagem das URLs dos serviços disponibilizados.

Endpoints - Fase 3 Iniciação de Pagamento

| Endpoint                              | Categoria                         |
| ------------------------------------- | --------------------------------- |
| /consents/v1/consents                 | CONSENTIMENTO DE COMPARTILHAMENTO |
| /consents/v1/consents/{consentId}     | CONSENTIMENTO DE COMPARTILHAMENTO |
| /payments/v1/consents                 | CONSENTIMENTO DE PAGAMENTO        |
| /payments/v1/consents/{consentId}     | CONSENTIMENTO DE PAGAMENTO        |
| /payments/v1/pix/payments             | PAGAMENTO PIX                     |
| /payments/v1/pix/payments/{paymentId} | PAGAMENTO PIX                     |
| /resources/v1/resources               | RECURSOS                          |

Endpoints - Fase 2 Dados Financeiros

| Endpoint                                                                             | Categoria            |
| ------------------------------------------------------------------------------------ | -------------------- |
| /customers/v1/personal/identifications                                               | DADOS CADASTRAIS     |
| /customers/v1/business/identifications                                               | DADOS CADASTRAIS     |
| /customers/v1/personal/qualifications                                                | DADOS CADASTRAIS     |
| /customers/v1/business/qualifications                                                | DADOS CADASTRAIS     |
| /customers/v1/personal/financial-relations                                           | DADOS CADASTRAIS     |
| /customers/v1/business/financial-relations                                           | DADOS CADASTRAIS     |
| /credit-cards-accounts/v1/accounts                                                   | CARTÕES DE CRÉDITO   |
| /credit-cards-accounts/v1/accounts/{creditCardAccountId}                             | CARTÕES DE CRÉDITO   |
| /credit-cards-accounts/v1/accounts/{creditCardAccountId}/limits                      | CARTÕES DE CRÉDITO   |
| /credit-cards-accounts/v1/accounts/{creditCardAccountId}/transactions                | CARTÕES DE CRÉDITO   |
| /credit-cards-accounts/v1/accounts/{creditCardAccountId}/bills                       | CARTÕES DE CRÉDITO   |
| /credit-cards-accounts/v1/accounts/{creditCardAccountId}/bills/{billId}/transactions | CARTÕES DE CRÉDITO   |
| /accounts/v1/accounts                                                                | CONTAS               |
| /accounts/v1/accounts/{accountId}                                                    | CONTAS               |
| /accounts/v1/accounts/{accountId}/balances                                           | CONTAS               |
| /accounts/v1/accounts/{accountId}/transactions                                       | CONTAS               |
| /accounts/v1/accounts/{accountId}/overdraft-limits                                   | CONTAS               |
| /loans/v1/contracts                                                                  | EMPRÉSTIMOS          |
| /loans/v1/contracts/{contractId}                                                     | EMPRÉSTIMOS          |
| /loans/v1/contracts/{contractId}/warranties                                          | EMPRÉSTIMOS          |
| /loans/v1/contracts/{contractId}/payments                                            | EMPRÉSTIMOS          |
| /loans/v1/contracts/{contractId}/scheduled-instalments                               | EMPRÉSTIMOS          |
| /financings/v1/contracts                                                             | FINANCIAMENTOS       |
| /financings/v1/contracts/{contractId}                                                | FINANCIAMENTOS       |
| /financings/v1/contracts/{contractId}/warranties                                     | FINANCIAMENTOS       |
| /financings/v1/contracts/{contractId}/payments                                       | FINANCIAMENTOS       |
| /financings/v1/contracts/{contractId}/scheduled-instalments                          | FINANCIAMENTOS       |
| /unarranged-accounts-overdraft/v1/contracts                                          | ADIANTAMENTOS        |
| /unarranged-accounts-overdraft/v1/contracts/{contractId}                             | ADIANTAMENTOS        |
| /unarranged-accounts-overdraft/v1/contracts/{contractId}/warranties                  | ADIANTAMENTOS        |
| /unarranged-accounts-overdraft/v1/contracts/{contractId}/payments                    | ADIANTAMENTOS        |
| /unarranged-accounts-overdraft/v1/contracts/{contractId}/scheduled-instalments       | ADIANTAMENTOS        |
| /invoice-financings/v1/contracts                                                     | DIREITOS CREDITÓRIOS |
| /invoice-financings/v1/contracts/{contractId}                                        | DIREITOS CREDITÓRIOS |
| /invoice-financings/v1/contracts/{contractId}/warranties                             | DIREITOS CREDITÓRIOS |
| /invoice-financings/v1/contracts/{contractId}/payments                               | DIREITOS CREDITÓRIOS |
| /invoice-financings/v1/contracts/{contractId}/scheduled-instalments                  | DIREITOS CREDITÓRIOS |

Endpoints - Fase 1 Dados Abertos

| Endpoint                                                    | Categoria             |
| ----------------------------------------------------------- | --------------------- |
| /products-services/v1/personal-accounts                     | PRODUTOS E SERVIÇOS   |
| /products-services/v1/business-accounts                     | PRODUTOS E SERVIÇOS   |
| /products-services/v1/personal-loans                        | PRODUTOS E SERVIÇOS   |
| /products-services/v1/business-loans                        | PRODUTOS E SERVIÇOS   |
| /products-services/v1/personal-financings                   | PRODUTOS E SERVIÇOS   |
| /products-services/v1/business-financings                   | PRODUTOS E SERVIÇOS   |
| /products-services/v1/personal-invoice-financings           | PRODUTOS E SERVIÇOS   |
| /products-services/v1/business-invoice-financings           | PRODUTOS E SERVIÇOS   |
| /products-services/v1/personal-credit-cards                 | PRODUTOS E SERVIÇOS   |
| /products-services/v1/business-credit-cards                 | PRODUTOS E SERVIÇOS   |
| /products-services/v1/personal-unarranged-account-overdraft | PRODUTOS E SERVIÇOS   |
| /products-services/v1/business-unarranged-account-overdraft | PRODUTOS E SERVIÇOS   |
| /channels/v1/branches                                       | CANAIS DE ATENDIMENTO |
| /channels/v1/electronic-channels                            | CANAIS DE ATENDIMENTO |
| /channels/v1/phone-channels                                 | CANAIS DE ATENDIMENTO |
| /channels/v1/banking-agents                                 | CANAIS DE ATENDIMENTO |
| /channels/v1/shared-automated-teller-machines               | CANAIS DE ATENDIMENTO |

## Scripts - Chamadas de APIs

Os scripts SQL fornecidos nessa seção devem ser operados no
**banco de dados do OOB-Status** e devem ser utilizados de acordo com o período
(primeiro ou segundo semestre) e o tipo de informação desejada (quantidade de
chamadas e disponibilidade média). Caso surja alguma dúvida da formatação dos
parâmetros de entrada, verificar seção [Parâmetros de Entrada](#parâmetros-de-entrada).

### Quantidade de chamadas de API - Extração de dados do primeiro semestre

```sql
@set initial_date = '<data_inicial> 00:00:00.000 -0300'
@set final_date = '<data_final> 23:59:59.999 -0300'
@set endpoints_services = array ['<service_1_url>']

SELECT
    tab.metodo AS "Método",
    tab.url AS "Url",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '01'),0) AS "Janeiro",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '02'),0) AS "Fevereiro",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '03'),0) AS "Março",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '04'),0) AS "Abril",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '05'),0) AS "Maio",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '06'),0) AS "Junho"
FROM 
(SELECT edp.endpoint_url AS url , edp.endpoint_name, substring(edp.endpoint_name, 'GET|POST|PATCH|DELETE') AS metodo, date_trunc('month',"date") AS "date", sum(qty_requests) AS qty
FROM public.endpoint_metric epm
LEFT JOIN public.endpoint edp 
on (epm.id_endpoint = edp.id)
WHERE "date" BETWEEN :initial_date AND :final_date AND edp.endpoint_url = ANY(:endpoints_services)
GROUP BY edp.endpoint_url, edp.endpoint_name, metodo, date_trunc('month',"date")) AS tab
GROUP BY tab.url, tab.metodo, tab.endpoint_name
ORDER BY tab.url, tab.metodo;

```

### Quantidade de chamadas de API - Extração de dados do segundo semestre

```sql
@set initial_date = '<data_inicial> 00:00:00.000 -0300'
@set final_date = '<data_final> 23:59:59.999 -0300'
@set endpoints_services = array ['<service_1_url>']

SELECT
    tab.metodo AS "Método",
    tab.url AS "Url",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '07'),0) AS "Julho",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '08'),0) AS "Agosto",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '09'),0) AS "Setembro",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '10'),0) AS "Outubro",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '11'),0) AS "Novembro",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '12'),0) AS "Dezembro"
FROM 
(SELECT edp.endpoint_url AS url , edp.endpoint_name, substring(edp.endpoint_name, 'GET|POST|PATCH|DELETE') AS metodo, date_trunc('month',"date") AS "date", sum(qty_requests) AS qty
FROM public.endpoint_metric epm
LEFT JOIN public.endpoint edp 
on (epm.id_endpoint = edp.id)
WHERE "date" BETWEEN :initial_date AND :final_date AND edp.endpoint_url = ANY(:endpoints_services)
GROUP BY edp.endpoint_url, edp.endpoint_name, metodo, date_trunc('month',"date")) AS tab
GROUP BY tab.url, tab.metodo, tab.endpoint_name
ORDER BY tab.url, tab.metodo;
```

### Disponibilidade média - Extração de dados do primeiro semestre

```sql
@set initial_date = '<data_inicial>'
@set final_date = '<data_final>'
@set endpoints_services = array ['<service_1_url>']
WITH
result_tab AS (
  WITH
  month_totaltime_table AS (
    WITH days_table AS (
      SELECT date_trunc('day', dd):: date AS metric_date, 86386 AS daily_seconds
      FROM generate_series
            ( :initial_date::timestamp 
            , :final_date::timestamp
            , '1 day'::interval) dd
    )
    SELECT
    to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AS year,
    to_char(days_table.metric_date, 'Mon') AS month,
    sum (days_table.daily_seconds) AS total_time
    FROM days_table
    GROUP BY month
  ),
  month_downtime_table AS (
    WITH month_downtime_table AS (
      SELECT 
      to_char(daily_metric_endpoint.metric_date, 'YYYY') AS year,
      to_char(daily_metric_endpoint.metric_date, 'Mon') AS month,
      endpoint.id,
      sum (seconds_downtime) AS seconds_downtime
      FROM endpoint
      FULL OUTER JOIN daily_metric_endpoint on daily_metric_endpoint.id_endpoint = endpoint.id
      WHERE daily_metric_endpoint.metric_date BETWEEN :initial_date AND :final_date
      GROUP BY id, year, month
    )
    SELECT coalesce (year, to_char(to_date(:initial_date, 'YYYY'), 'YYYY')) AS year, coalesce(month, to_char(to_date(:initial_date, 'YYYY-MM-DD'), 'Mon')) AS month, endpoint.id AS id_endpoint, seconds_downtime FROM month_downtime_table
    FULL OUTER JOIN endpoint on month_downtime_table.id = endpoint.id
    WHERE endpoint_url = ANY(:endpoints_services)
  )
  SELECT
  month_downtime_table.year,
  month_downtime_table.month,
  (SELECT sum(total_time) AS total FROM month_totaltime_table) AS total_period,
  month_totaltime_table.total_time,
  month_downtime_table.seconds_downtime,
  endpoint.endpoint_url,
  substring(endpoint.endpoint_name, 'GET|POST|PATCH|DELETE') AS metodo,
  ((month_totaltime_table.total_time - month_downtime_table.seconds_downtime)/month_totaltime_table.total_time::float) AS perc_online
  FROM month_downtime_table
  INNER JOIN endpoint on endpoint.id = month_downtime_table.id_endpoint
  FULL OUTER JOIN month_totaltime_table on month_totaltime_table.month = month_downtime_table.month AND month_totaltime_table.year = month_downtime_table.year
  ORDER BY year, month
)
SELECT
year AS "Ano",
endpoint_url AS "url",
metodo AS "Método",
coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Jan'),1) AS "Janeiro",
coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Feb'),1) AS "Fevereiro",
coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Mar'),1) AS "Março",
coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Apr'),1) AS "Abril",
coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='May'),1) AS "Maio",
coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Jun'),1) AS "Junho",
coalesce (1 - sum(seconds_downtime)/max(total_period) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY')),1) AS "Média período"
FROM result_tab
GROUP BY year,endpoint_url,metodo
having num_nulls(min(year) FILTER (WHERE year = to_char(to_date(:initial_date, 'YYYY'), 'YYYY'))) = 0
```

### Disponibilidade média - Extração de dados do segundo semestre

```sql
@set initial_date = '<data_inicial>'
@set final_date = '<data_final>'
@set endpoints_services = array ['<service_1_url>']
with
result_tab AS (
  with
month_totaltime_table AS (
    WITH days_table AS (
      SELECT date_trunc('day', dd):: date AS metric_date, 86386 AS daily_seconds
      FROM generate_series
            ( :initial_date::timestamp 
            , :final_date::timestamp
            , '1 day'::interval) dd
    )
    SELECT
    to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AS year,
    to_char(days_table.metric_date, 'Mon') AS month,
    sum (days_table.daily_seconds) AS total_time
    FROM days_table
    GROUP BY month
  ),
  month_downtime_table AS (
    WITH month_downtime_table AS (
      SELECT 
      to_char(daily_metric_endpoint.metric_date, 'YYYY') AS year,
      to_char(daily_metric_endpoint.metric_date, 'Mon') AS month,
      endpoint.id,
      sum (seconds_downtime) AS seconds_downtime
      FROM endpoint
      FULL OUTER JOIN daily_metric_endpoint on daily_metric_endpoint.id_endpoint = endpoint.id
      WHERE daily_metric_endpoint.metric_date BETWEEN :initial_date AND :final_date
      GROUP BY id, year, month
    )
    SELECT coalesce (year, to_char(to_date(:initial_date, 'YYYY'), 'YYYY')) AS year, coalesce(month, to_char(to_date(:initial_date, 'YYYY-MM-DD'), 'Mon')) AS month, endpoint.id AS id_endpoint, seconds_downtime FROM month_downtime_table
    FULL OUTER JOIN endpoint on month_downtime_table.id = endpoint.id
    WHERE endpoint_url = ANY(:endpoints_services)
  )
  SELECT
  month_downtime_table.year,
  month_downtime_table.month,
  (SELECT sum(total_time) AS total FROM month_totaltime_table) AS total_period,
  month_totaltime_table.total_time,
  month_downtime_table.seconds_downtime,
  endpoint.endpoint_url,
  substring(endpoint.endpoint_name, 'GET|POST|PATCH|DELETE') AS metodo,
  ((month_totaltime_table.total_time - month_downtime_table.seconds_downtime)/month_totaltime_table.total_time::float) AS perc_online
  FROM month_downtime_table
 INNER JOIN endpoint on endpoint.id = month_downtime_table.id_endpoint
  FULL OUTER JOIN month_totaltime_table on month_totaltime_table.month = month_downtime_table.month AND month_totaltime_table.year = month_downtime_table.year
  ORDER BY year, month
)
SELECT
year AS "Ano",
endpoint_url AS "url",
metodo AS "Método",
coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Jul'),1) AS "Julho",
coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Aug'),1) AS "Agosto",
coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Sep'),1) AS "Setembro",
coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Oct'),1) AS "Outubro",
coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Nov'),1) AS "Novembro",
coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Dec'),1) AS "Dezembro",
coalesce (1 - sum(seconds_downtime)/max(total_period) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY')),1) AS "Média período"
FROM result_tab
GROUP BY year,endpoint_url,metodo
having num_nulls(min(year) FILTER (WHERE year = to_char(to_date(:initial_date, 'YYYY'), 'YYYY'))) = 0
```
