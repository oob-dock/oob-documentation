# SQL Scripts - Semiannual Report

- [Introduction](#introduction)
- [Input Parameters](#input-parameters)
  - [Data Period](#data-period)
  - [Desired Services](#desired-services-list)
- [Scripts - API Calls](#scripts---api-calls)
  - [API Call Count - First Semester](#api-call-count---first-semester-data-extraction)
  - [API Call Count - Second Semester](#api-call-count---second-semester-data-extraction)
  - [Average Availability - First Semester](#average-availability---first-semester-data-extraction)
  - [Average Availability - Second Semester](#average-availability---second-semester-data-extraction)

## Introduction

Opus is providing some SQL scripts that will assist clients in gathering data for the preparation of the semiannual report required by Open Finance Brasil **OFB**.

The information that can be obtained with these scripts includes:

- the number of API calls each month, for each endpoint
- the average availability during the period

**NOTE:** It is up to our clients to run the scripts and format the information according to the form and period required by OFB.

## Input Parameters

Before using the SQL scripts provided by Opus, you must replace the fields
'<data_inicial>', '<data_final>', and '<service_1_url>'
with the appropriate period values and the URLs of the services for which you want to retrieve information.

In this section, the formatting and possible values for each parameter will be presented.

### Data Period

The fields '<data_inicial>' and '<data_final>' define the period for which you want to retrieve information.

The format for both fields is **YYYY-MM-DD**.

- YYYY: year of the desired date
- MM: month of the desired date
- DD: day of the desired date

Example usage for call count:

```sql
@set initial_date = '2022-01-01 00:00:00.000 -0300'
@set final_date = '2022-06-30 23:59:59.999 -0300'
```

Example usage for average availability:

```sql
@set initial_date = '2022-01-01'
@set final_date = '2022-06-30'
```

### Desired Services List

The 'endpoints_services' parameter is an array[string] type parameter, and you need to replace the '<service_1_url>' field with all the URLs of the services provided by the partner entity.

Example for obtaining services from phase 3 - Payment Initiation:

```sql
@set endpoints_services = array ['/payments/v3/consents','/payments/v3/consents/{consentId}','/payments/v3/pix/payments','/payments/v3/pix/payments/{paymentId}','/payments/v4/consents','/payments/v4/consents/{consentId}','/payments/v4/pix/payments','/payments/v4/pix/payments/{paymentId}','/payments/v4/pix/payments/consents/{consentId}','/automatic-payments/v1/recurring-consents','/automatic-payments/v1/recurring-consents/{recurringConsentId}','/automatic-payments/v1/pix/recurring-payments','/automatic-payments/v1/pix/recurring-payments/{recurringPaymentId}']
```

Example for obtaining services from phase 2 - Customer Data:

```sql
@set endpoints_services = array ['/consents/v2/consents', '/consents/v2/consents/{consentId}','/resources/v2/resources','/customers/v2/business/financial-relations','/customers/v2/business/identifications','/customers/v2/business/qualifications','/customers/v2/personal/financial-relations','/customers/v2/personal/identifications','/customers/v2/personal/qualifications']
```

Below are tables listing all endpoints divided into subgroups to facilitate the listing of service URLs provided.

Endpoints - Phase 3 Payment Initiation

| Endpoint                                                            | Category                  |
| ------------------------------------------------------------------- | ------------------------- |
| /payments/v3/consents                                               | PAYMENT CONSENT           |
| /payments/v3/consents/\{consentId\}                                 | PAYMENT CONSENT           |
| /payments/v4/consents                                               | PAYMENT CONSENT           |
| /payments/v4/consents/\{consentId\}                                 | PAYMENT CONSENT           |
| /automatic-payments/v1/recurring-consents                           | PAYMENT CONSENT           |
| /automatic-payments/v1/recurring-consents/{recurringConsentId}      | PAYMENT CONSENT           |
| /payments/v3/pix/payments                                           | PIX PAYMENT               |
| /payments/v3/pix/payments/\{paymentId\}                             | PIX PAYMENT               |
| /payments/v4/pix/payments                                           | PIX PAYMENT               |
| /payments/v4/pix/payments/\{paymentId\}                             | PIX PAYMENT               |
| /payments/v4/pix/payments/consents/{consentId}                      | PIX PAYMENT               |
| /automatic-payments/v1/pix/recurring-payments                       | PIX PAYMENT               |
| /automatic-payments/v1/pix/recurring-payments/{recurringPaymentId}  | PIX PAYMENT               |

Endpoints - Phase 2 Consent and Customer Data:

| Endpoint                                   | Category                         |
| ------------------------------------------ | -------------------------------- |
| /consents/v2/consents                      | SHARING CONSENT                  |
| /consents/v2/consents/\{consentId\}        | SHARING CONSENT                  |
| /customers/v2/personal/identifications     | CUSTOMER DATA                    |
| /customers/v2/business/identifications     | CUSTOMER DATA                    |
| /customers/v2/personal/qualifications      | CUSTOMER DATA                    |
| /customers/v2/business/qualifications      | CUSTOMER DATA                    |
| /customers/v2/personal/financial-relations | CUSTOMER DATA                    |
| /customers/v2/business/financial-relations | CUSTOMER DATA                    |
| /resources/v2/resources                    | RESOURCES                        |

Endpoints - Phase 2 Financial Data

| Endpoint                                                                                 | Category             |
| ---------------------------------------------------------------------------------------- | -------------------- |
| /credit-cards-accounts/v2/accounts                                                       | CREDIT CARDS         |
| /credit-cards-accounts/v2/accounts/\{creditCardAccountId\}                               | CREDIT CARDS         |
| /credit-cards-accounts/v2/accounts/\{creditCardAccountId\}/limits                        | CREDIT CARDS         |
| /credit-cards-accounts/v2/accounts/\{creditCardAccountId\}/transactions                  | CREDIT CARDS         |
| /credit-cards-accounts/v2/accounts/\{creditCardAccountId\}/bills                         | CREDIT CARDS         |
| /credit-cards-accounts/v2/accounts/\{creditCardAccountId\}/bills/\{billId\}/transactions | CREDIT CARDS         |
| /credit-cards-accounts/v2/accounts/\{creditCardAccountId\}/transactions-current          | CREDIT CARDS         |
| /accounts/v2/accounts                                                                    | ACCOUNTS             |
| /accounts/v2/accounts/\{accountId\}                                                      | ACCOUNTS             |
| /accounts/v2/accounts/\{accountId\}/balances                                             | ACCOUNTS             |
| /accounts/v2/accounts/\{accountId\}/transactions                                         | ACCOUNTS             |
| /accounts/v2/accounts/\{accountId\}/transactions-current                                 | ACCOUNTS             |
| /accounts/v2/accounts/\{accountId\}/overdraft-limits                                     | ACCOUNTS             |
| /loans/v2/contracts                                                                      | LOANS                |
| /loans/v2/contracts/\{contractId\}                                                       | LOANS                |
| /loans/v2/contracts/\{contractId\}/warranties                                            | LOANS                |
| /loans/v2/contracts/\{contractId\}/payments                                              | LOANS                |
| /loans/v2/contracts/\{contractId\}/scheduled-instalments                                 | LOANS                |
| /financings/v2/contracts                                                                 | FINANCINGS           |
| /financings/v2/contracts/\{contractId\}                                                  | FINANCINGS           |
| /financings/v2/contracts/\{contractId\}/warranties                                       | FINANCINGS           |
| /financings/v2/contracts/\{contractId\}/payments                                         | FINANCINGS           |
| /financings/v2/contracts/\{contractId\}/scheduled-instalments                            | FINANCINGS           |
| /unarranged-accounts-overdraft/v2/contracts                                              | OVERDRAFTS           |
| /unarranged-accounts-overdraft/v2/contracts/\{contractId\}                               | OVERDRAFTS           |
| /unarranged-accounts-overdraft/v2/contracts/\{contractId\}/warranties                    | OVERDRAFTS           |
| /unarranged-accounts-overdraft/v2/contracts/\{contractId\}/payments                      | OVERDRAFTS           |
| /unarranged-accounts-overdraft/v2/contracts/\{contractId\}/scheduled-instalments         | OVERDRAFTS           |
| /invoice-financings/v2/contracts                                                         | RECEIVABLES          |
| /invoice-financings/v2/contracts/\{contractId\}                                          | RECEIVABLES          |
| /invoice-financings/v2/contracts/\{contractId\}/warranties                               | RECEIVABLES          |
| /invoice-financings/v2/contracts/\{contractId\}/payments                                 | RECEIVABLES          |
| /invoice-financings/v2/contracts/\{contractId\}/scheduled-instalments                    | RECEIVABLES          |

Endpoints - Phase 1 Open Data

| Endpoint                                                    | Category              |
| ----------------------------------------------------------- | --------------------- |
| /products-services/v1/personal-accounts                     | PRODUCTS AND SERVICES |
| /products-services/v1/business-accounts                     | PRODUCTS AND SERVICES |
| /products-services/v1/personal-loans                        | PRODUCTS AND SERVICES |
| /products-services/v1/business-loans                        | PRODUCTS AND SERVICES |
| /products-services/v1/personal-financings                   | PRODUCTS AND SERVICES |
| /products-services/v1/business-financings                   | PRODUCTS AND SERVICES |
| /products-services/v1/personal-invoice-financings           | PRODUCTS AND SERVICES |
| /products-services/v1/business-invoice-financings           | PRODUCTS AND SERVICES |
| /products-services/v1/personal-credit-cards                 | PRODUCTS AND SERVICES |
| /products-services/v1/business-credit-cards                 | PRODUCTS AND SERVICES |
| /products-services/v1/personal-unarranged-account-overdraft | PRODUCTS AND SERVICES |
| /products-services/v1/business-unarranged-account-overdraft | PRODUCTS AND SERVICES |
| /channels/v1/branches                                       | SERVICE CHANNELS      |
| /channels/v1/electronic-channels                            | SERVICE CHANNELS      |
| /channels/v1/phone-channels                                 | SERVICE CHANNELS      |
| /channels/v1/banking-agents                                 | SERVICE CHANNELS      |
| /channels/v1/shared-automated-teller-machines               | SERVICE CHANNELS      |

Endpoints - Phase 4A Open Data

| Endpoint                                      | Category                |
| --------------------------------------------- | ----------------------- |
| /opendata-capitalization/v1/bonds             | CAPITALIZATION BONDS    |
| /opendata-investments/v1/funds                | INVESTMENTS             |
| /opendata-investments/v1/bank-fixed-incomes   | INVESTMENTS             |
| /opendata-investments/v1/credit-fixed-incomes | INVESTMENTS             |
| /opendata-investments/v1/variable-incomes     | INVESTMENTS             |
| /opendata-investments/v1/treasure-titles      | INVESTMENTS             |
| /opendata-exchange/v1/online-rates            | EXCHANGE                |
| /opendata-exchange/v1/vet-values              | EXCHANGE                |
| /opendata-acquiring-services/v1/personals     | ACQUIRING SERVICES      |
| /opendata-acquiring-services/v1/businesses    | ACQUIRING SERVICES      |
| /opendata-pension/v1/risk-coverages           | PENSION                 |
| /opendata-pension/v1/survival-coverages       | PENSION                 |
| /opendata-insurance/v1/personals              | INSURANCE               |

Endpoints - Phase 4B Investments

| Endpoint                                                                 | Category             |
| ------------------------------------------------------------------------ | -------------------- |
| /bank-fixed-incomes/v1/investments                                       | BANK FIXED INCOME    |
| /bank-fixed-incomes/v1/investments/\{investmentId\}                      | BANK FIXED INCOME    |
| /bank-fixed-incomes/v1/investments/\{investmentId\}/balances             | BANK FIXED INCOME    |
| /bank-fixed-incomes/v1/investments/\{investmentId\}/transactions         | BANK FIXED INCOME    |
| /bank-fixed-incomes/v1/investments/\{investmentId\}/transactions-current | BANK FIXED INCOME    |

## Scripts - API Calls

The SQL scripts provided in this section should be operated in the **OOB-Status database** and should be used according to the period (first or second semester) and the type of information desired (call count and average availability). If any doubts arise regarding the formatting of the input parameters, check the [Input Parameters](#input-parameters) section.

### API Call Count - First Semester Data Extraction

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

### API Call Count - Second Semester Data Extraction

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

### Average Availability - First Semester Data Extraction

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

### Average Availability - Second Semester Data Extraction

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
