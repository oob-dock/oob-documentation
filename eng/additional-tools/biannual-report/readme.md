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

Example for obtaining services from phase 1 - Open paymentData::

```sql
--UNTIL 2024 FIRST SEMESTER
@set endpoints_services = array ['/products-services/v1/personal-accounts', '/products-services/v1/business-accounts', '/products-services/v1/personal-loans', '/products-services/v1/business-loans', '/products-services/v1/personal-financings', '/products-services/v1/business-financings', '/products-services/v1/personal-invoice-financings', '/products-services/v1/business-invoice-financings', '/products-services/v1/personal-credit-cards', '/products-services/v1/business-credit-cards', '/products-services/v1/personal-unarranged-account-overdraft', '/products-services/v1/business-unarranged-account-overdraft', '/channels/v1/branches', '/channels/v1/electronic-channels', '/channels/v1/phone-channels', '/channels/v1/banking-agents', '/channels/v1/shared-automated-teller-machines', '/channels/v2/banking-agents', '/channels/v2/branches', '/channels/v2/electronic-channels', '/channels/v2/phone-channels', '/channels/v2/shared-automated-teller-machines', '/opendata-accounts/v1/business-accounts', '/opendata-accounts/v1/personal-accounts', '/opendata-creditcards/v1/business-credit-cards', '/opendata-creditcards/v1/personal-credit-cards', '/opendata-financings/v1/business-financings', '/opendata-financings/v1/personal-financings', '/opendata-invoicefinancings/v1/business-invoice-financings', '/opendata-invoicefinancings/v1/personal-invoice-financings', '/opendata-loans/v1/business-loans', '/opendata-loans/v1/personal-loans', '/opendata-unarranged/v1/business-unarranged-account-overdraft', '/opendata-unarranged/v1/personal-unarranged-account-overdraft']

--AS OF 2024 SECOND SEMESTER
@set endpoints_services = array ['/channels/v2/banking-agents', '/channels/v2/branches', '/channels/v2/electronic-channels', '/channels/v2/phone-channels', '/channels/v2/shared-automated-teller-machines', '/opendata-accounts/v1/business-accounts', '/opendata-accounts/v1/personal-accounts', '/opendata-creditcards/v1/business-credit-cards', '/opendata-creditcards/v1/personal-credit-cards', '/opendata-financings/v1/business-financings', '/opendata-financings/v1/personal-financings', '/opendata-invoicefinancings/v1/business-invoice-financings', '/opendata-invoicefinancings/v1/personal-invoice-financings', '/opendata-loans/v1/business-loans', '/opendata-loans/v1/personal-loans', '/opendata-unarranged/v1/business-unarranged-account-overdraft', '/opendata-unarranged/v1/personal-unarranged-account-overdraft']
```

Example for obtaining services from phase 2 - Consent, Resources and Customer Data:

```sql
@set endpoints_services = array ['/consents/v2/consents', '/consents/v2/consents/{consentId}','/resources/v2/resources', '/consents/v3/consents', '/consents/v3/consents/{consentId}','/resources/v3/resources', '/customers/v2/business/financial-relations','/customers/v2/business/identifications','/customers/v2/business/qualifications','/customers/v2/personal/financial-relations','/customers/v2/personal/identifications','/customers/v2/personal/qualifications']
```

Example for obtaining services from phase 2 - Transactional Data:

```sql
@set endpoints_services = array ['/credit-cards-accounts/v2/accounts', '/credit-cards-accounts/v2/accounts/{creditCardAccountId}', '/credit-cards-accounts/v2/accounts/{creditCardAccountId}/limits', '/credit-cards-accounts/v2/accounts/{creditCardAccountId}/transactions', '/credit-cards-accounts/v2/accounts/{creditCardAccountId}/bills', '/credit-cards-accounts/v2/accounts/{creditCardAccountId}/bills/{billId}/transactions', '/credit-cards-accounts/v2/accounts/{creditCardAccountId}/transactions-current', '/accounts/v2/accounts', '/accounts/v2/accounts/{accountId}', '/accounts/v2/accounts/{accountId}/balances', '/accounts/v2/accounts/{accountId}/transactions', '/accounts/v2/accounts/{accountId}/transactions-current', '/accounts/v2/accounts/{accountId}/overdraft-limits', '/loans/v2/contracts', '/loans/v2/contracts/{contractId}', '/loans/v2/contracts/{contractId}/warranties', '/loans/v2/contracts/{contractId}/payments', '/loans/v2/contracts/{contractId}/scheduled-instalments', '/financings/v2/contracts', '/financings/v2/contracts/{contractId}', '/financings/v2/contracts/{contractId}/warranties', '/financings/v2/contracts/{contractId}/payments', '/financings/v2/contracts/{contractId}/scheduled-instalments', '/unarranged-accounts-overdraft/v2/contracts', '/unarranged-accounts-overdraft/v2/contracts/{contractId}', '/unarranged-accounts-overdraft/v2/contracts/{contractId}/warranties', '/unarranged-accounts-overdraft/v2/contracts/{contractId}/payments', '/unarranged-accounts-overdraft/v2/contracts/{contractId}/scheduled-instalments', '/invoice-financings/v2/contracts', '/invoice-financings/v2/contracts/{contractId}', '/invoice-financings/v2/contracts/{contractId}/warranties', '/invoice-financings/v2/contracts/{contractId}/payments', '/invoice-financings/v2/contracts/{contractId}/scheduled-instalments']
```

Example for obtaining services from phase 3 - Payment Initiation:

```sql
@set endpoints_services = array ['/payments/v3/consents','/payments/v3/consents/{consentId}','/payments/v3/pix/payments','/payments/v3/pix/payments/{paymentId}','/payments/v4/consents','/payments/v4/consents/{consentId}','/payments/v4/pix/payments','/payments/v4/pix/payments/{paymentId}','/payments/v4/pix/payments/consents/{consentId}','/automatic-payments/v1/recurring-consents','/automatic-payments/v1/recurring-consents/{recurringConsentId}','/automatic-payments/v1/pix/recurring-payments','/automatic-payments/v1/pix/recurring-payments/{recurringPaymentId}']
```

Example for obtaining services from fase 4A - Open Data

```sql
@set endpoints_services = array ['/opendata-capitalization/v1/bonds', '/opendata-investments/v1/funds', '/opendata-investments/v1/bank-fixed-incomes', '/opendata-investments/v1/credit-fixed-incomes', '/opendata-investments/v1/variable-incomes', '/opendata-investments/v1/treasure-titles', '/opendata-exchange/v1/online-rates', '/opendata-exchange/v1/vet-values', '/opendata-acquiring-services/v1/personals', '/opendata-acquiring-services/v1/businesses', '/opendata-pension/v1/risk-coverages', '/opendata-pension/v1/survival-coverages', '/opendata-insurance/v1/personals', '/opendata-insurance/v1/automotives', '/opendata-insurance/v1/homes']
```

Example for obtaining services from phase 4B - Investments:

```sql
@set endpoints_services = array ['/bank-fixed-incomes/v1/investments', '/bank-fixed-incomes/v1/investments/{investmentId}', '/bank-fixed-incomes/v1/investments/{investmentId}/balances', '/bank-fixed-incomes/v1/investments/{investmentId}/transactions', '/bank-fixed-incomes/v1/investments/{investmentId}/transactions-current', '/credit-fixed-incomes/v1/investments', '/credit-fixed-incomes/v1/investments/{investmentId}', '/credit-fixed-incomes/v1/investments/{investmentId}/balances', '/credit-fixed-incomes/v1/investments/{investmentId}/transactions', '/credit-fixed-incomes/v1/investments/{investmentId}/transactions-current', '/variable-incomes/v1/investments', '/variable-incomes/v1/investments/{investmentId}', '/variable-incomes/v1/investments/{investmentId}/balances', '/variable-incomes/v1/investments/{investmentId}/transactions', '/variable-incomes/v1/investments/{investmentId}/transactions-current', '/treasure-titles/v1/investments', '/treasure-titles/v1/investments/{investmentId}', '/treasure-titles/v1/investments/{investmentId}/balances', '/treasure-titles/v1/investments/{investmentId}/transactions', '/treasure-titles/v1/investments/{investmentId}/transactions-current', '/funds/v1/investments', '/funds/v1/investments/{investmentId}', '/funds/v1/investments/{investmentId}/balances', '/funds/v1/investments/{investmentId}/transactions', '/funds/v1/investments/{investmentId}/transactions-current']
```

Example for obtaining services from phase 4B - Exchange:

```sql
@set endpoints_services = array ['/exchanges/v1/operations', '/exchanges/v1/operations/{operationId}', '/exchanges/v1/operations/{operationId}/events']
```

Below are tables listing all endpoints divided into subgroups to facilitate the listing of service URLs provided.

Endpoints - Phase 1 Open Data

| Endpoint                                                      | Category              |
| ------------------------------------------------------------- | --------------------- |
| /channels/v2/banking-agents                                   | SERVICE CHANNELS      |
| /channels/v2/branches                                         | SERVICE CHANNELS      |
| /channels/v2/electronic-channels                              | SERVICE CHANNELS      |
| /channels/v2/phone-channels                                   | SERVICE CHANNELS      |
| /channels/v2/shared-automated-teller-machines                 | SERVICE CHANNELS      |
| /opendata-accounts/v1/business-accounts                       | ACCOUNTS              |
| /opendata-accounts/v1/personal-accounts                       | ACCOUNTS              |
| /opendata-creditcards/v1/business-credit-cards                | CREDIT CARDS          |
| /opendata-creditcards/v1/personal-credit-cards                | CREDIT CARDS          |
| /opendata-financings/v1/business-financings                   | FINANCINGS            |
| /opendata-financings/v1/personal-financings                   | FINANCINGS            |
| /opendata-invoicefinancings/v1/business-invoice-financings    | RECEIVABLES           |
| /opendata-invoicefinancings/v1/personal-invoice-financings    | RECEIVABLES           |
| /opendata-loans/v1/business-loans                             | LOANS                 |
| /opendata-loans/v1/personal-loans                             | LOANS                 |
| /opendata-unarranged/v1/business-unarranged-account-overdraft | OVERDRAFTS            |
| /opendata-unarranged/v1/personal-unarranged-account-overdraft | OVERDRAFTS            |

Endpoints - Phase 2 Consent, Resources and Customer Data:

| Endpoint                                   | Category        |
| ------------------------------------------ | --------------- |
| /consents/v2/consents                      | SHARING CONSENT |
| /consents/v2/consents/\{consentId\}        | SHARING CONSENT |
| /consents/v3/consents                      | SHARING CONSENT |
| /consents/v3/consents/\{consentId\}        | SHARING CONSENT |
| /customers/v2/personal/identifications     | CUSTOMER DATA   |
| /customers/v2/business/identifications     | CUSTOMER DATA   |
| /customers/v2/personal/qualifications      | CUSTOMER DATA   |
| /customers/v2/business/qualifications      | CUSTOMER DATA   |
| /customers/v2/personal/financial-relations | CUSTOMER DATA   |
| /customers/v2/business/financial-relations | CUSTOMER DATA   |
| /resources/v2/resources                    | RESOURCES       |
| /resources/v3/resources                    | RESOURCES       |

Endpoints - Phase 2 Transactional Data

| Endpoint                                                                                 | Category      |
| ---------------------------------------------------------------------------------------- | ------------- |
| /credit-cards-accounts/v2/accounts                                                       | CREDIT CARDS  |
| /credit-cards-accounts/v2/accounts/\{creditCardAccountId\}                               | CREDIT CARDS  |
| /credit-cards-accounts/v2/accounts/\{creditCardAccountId\}/limits                        | CREDIT CARDS  |
| /credit-cards-accounts/v2/accounts/\{creditCardAccountId\}/transactions                  | CREDIT CARDS  |
| /credit-cards-accounts/v2/accounts/\{creditCardAccountId\}/bills                         | CREDIT CARDS  |
| /credit-cards-accounts/v2/accounts/\{creditCardAccountId\}/bills/\{billId\}/transactions | CREDIT CARDS  |
| /credit-cards-accounts/v2/accounts/\{creditCardAccountId\}/transactions-current          | CREDIT CARDS  |
| /accounts/v2/accounts                                                                    | ACCOUNTS      |
| /accounts/v2/accounts/\{accountId\}                                                      | ACCOUNTS      |
| /accounts/v2/accounts/\{accountId\}/balances                                             | ACCOUNTS      |
| /accounts/v2/accounts/\{accountId\}/transactions                                         | ACCOUNTS      |
| /accounts/v2/accounts/\{accountId\}/transactions-current                                 | ACCOUNTS      |
| /accounts/v2/accounts/\{accountId\}/overdraft-limits                                     | ACCOUNTS      |
| /loans/v2/contracts                                                                      | LOANS         |
| /loans/v2/contracts/\{contractId\}                                                       | LOANS         |
| /loans/v2/contracts/\{contractId\}/warranties                                            | LOANS         |
| /loans/v2/contracts/\{contractId\}/payments                                              | LOANS         |
| /loans/v2/contracts/\{contractId\}/scheduled-instalments                                 | LOANS         |
| /financings/v2/contracts                                                                 | FINANCINGS    |
| /financings/v2/contracts/\{contractId\}                                                  | FINANCINGS    |
| /financings/v2/contracts/\{contractId\}/warranties                                       | FINANCINGS    |
| /financings/v2/contracts/\{contractId\}/payments                                         | FINANCINGS    |
| /financings/v2/contracts/\{contractId\}/scheduled-instalments                            | FINANCINGS    |
| /unarranged-accounts-overdraft/v2/contracts                                              | OVERDRAFTS    |
| /unarranged-accounts-overdraft/v2/contracts/\{contractId\}                               | OVERDRAFTS    |
| /unarranged-accounts-overdraft/v2/contracts/\{contractId\}/warranties                    | OVERDRAFTS    |
| /unarranged-accounts-overdraft/v2/contracts/\{contractId\}/payments                      | OVERDRAFTS    |
| /unarranged-accounts-overdraft/v2/contracts/\{contractId\}/scheduled-instalments         | OVERDRAFTS    |
| /invoice-financings/v2/contracts                                                         | RECEIVABLES   |
| /invoice-financings/v2/contracts/\{contractId\}                                          | RECEIVABLES   |
| /invoice-financings/v2/contracts/\{contractId\}/warranties                               | RECEIVABLES   |
| /invoice-financings/v2/contracts/\{contractId\}/payments                                 | RECEIVABLES   |
| /invoice-financings/v2/contracts/\{contractId\}/scheduled-instalments                    | RECEIVABLES   |

Endpoints - Phase 3 Payment Initiation

| Endpoint                                                            | Category         |
| ------------------------------------------------------------------- | ---------------- |
| /payments/v3/consents                                               | PAYMENT CONSENT  |
| /payments/v3/consents/\{consentId\}                                 | PAYMENT CONSENT  |
| /payments/v4/consents                                               | PAYMENT CONSENT  |
| /payments/v4/consents/\{consentId\}                                 | PAYMENT CONSENT  |
| /automatic-payments/v1/recurring-consents                           | PAYMENT CONSENT  |
| /automatic-payments/v1/recurring-consents/{recurringConsentId}      | PAYMENT CONSENT  |
| /payments/v3/pix/payments                                           | PIX PAYMENT      |
| /payments/v3/pix/payments/\{paymentId\}                             | PIX PAYMENT      |
| /payments/v4/pix/payments                                           | PIX PAYMENT      |
| /payments/v4/pix/payments/\{paymentId\}                             | PIX PAYMENT      |
| /payments/v4/pix/payments/consents/{consentId}                      | PIX PAYMENT      |
| /automatic-payments/v1/pix/recurring-payments                       | PIX PAYMENT      |
| /automatic-payments/v1/pix/recurring-payments/{recurringPaymentId}  | PIX PAYMENT      |
 
Endpoints - Phase 4A Open Data

| Endpoint                                      | Category        |
| --------------------------------------------- | --------------- |
| /opendata-capitalization/v1/bonds             | CAPITALIZATION  |
| /opendata-investments/v1/funds                | INVESTMENTS     |
| /opendata-investments/v1/bank-fixed-incomes   | INVESTMENTS     |
| /opendata-investments/v1/credit-fixed-incomes | INVESTMENTS     |
| /opendata-investments/v1/variable-incomes     | INVESTMENTS     |
| /opendata-investments/v1/treasure-titles      | INVESTMENTS     |
| /opendata-exchange/v1/online-rates            | EXCHANGE        |
| /opendata-exchange/v1/vet-values              | EXCHANGE        |
| /opendata-acquiring-services/v1/personals     | ACQUIRING       |
| /opendata-acquiring-services/v1/businesses    | ACQUIRING       |
| /opendata-pension/v1/risk-coverages           | PENSION         |
| /opendata-pension/v1/survival-coverages       | PENSION         |
| /opendata-insurance/v1/personals              | INSURANCE       |
| /opendata-insurance/v1/automotives            | INSURANCE       |            
| /opendata-insurance/v1/homes                  | INSURANCE       |      

Endpoints - Phase 4B Investments

| Endpoint                                                                   | Category            |
| -------------------------------------------------------------------------- | ------------------- |
| /bank-fixed-incomes/v1/investments                                         | BANK FIXED INCOME   |
| /bank-fixed-incomes/v1/investments/\{investmentId\}                        | BANK FIXED INCOME   |
| /bank-fixed-incomes/v1/investments/\{investmentId\}/balances               | BANK FIXED INCOME   |
| /bank-fixed-incomes/v1/investments/\{investmentId\}/transactions           | BANK FIXED INCOME   |
| /bank-fixed-incomes/v1/investments/\{investmentId\}/transactions-current   | BANK FIXED INCOME   |
| /credit-fixed-incomes/v1/investments                                       | CREDIT FIXED INCOME |
| /credit-fixed-incomes/v1/investments/\{investmentId\}                      | CREDIT FIXED INCOME |
| /credit-fixed-incomes/v1/investments/\{investmentId\}/balances             | CREDIT FIXED INCOME |
| /credit-fixed-incomes/v1/investments/\{investmentId\}/transactions         | CREDIT FIXED INCOME |
| /credit-fixed-incomes/v1/investments/\{investmentId\}/transactions-current | CREDIT FIXED INCOME |
| /variable-incomes/v1/investments                                           | VARIABLE INCOME     |
| /variable-incomes/v1/investments/\{investmentId\}                          | VARIABLE INCOME     |
| /variable-incomes/v1/investments/\{investmentId\}/balances                 | VARIABLE INCOME     |
| /variable-incomes/v1/investments/\{investmentId\}/transactions             | VARIABLE INCOME     |
| /variable-incomes/v1/investments/\{investmentId\}/transactions-current     | VARIABLE INCOME     |
| /variable-incomes/v1/broker-notes/\{brokerNoteId\}                         | VARIABLE INCOME     |
| /treasure-titles/v1/investments                                            | TREASURE TITLE      |
| /treasure-titles/v1/investments/\{investmentId\}                           | TREASURE TITLE      |
| /treasure-titles/v1/investments/\{investmentId\}/balances                  | TREASURE TITLE      |
| /treasure-titles/v1/investments/\{investmentId\}/transactions              | TREASURE TITLE      |
| /treasure-titles/v1/investments/\{investmentId\}/transactions-current      | TREASURE TITLE      |
| /funds/v1/investments                                                      | FUNDS               |
| /funds/v1/investments/\{investmentId\}                                     | FUNDS               |
| /funds/v1/investments/\{investmentId\}/balances                            | FUNDS               |
| /funds/v1/investments/\{investmentId\}/transactions                        | FUNDS               |
| /funds/v1/investments/\{investmentId\}/transactions-current                | FUNDS               |

Endpoints - Phase 4B Exchanges

| Endpoint                                        | Category  |
| ----------------------------------------------- | --------- |
| /exchanges/v1/operations                        | EXCHANGE  |
| /exchanges/v1/operations/\{operationId\}        | EXCHANGE  |
| /exchanges/v1/operations/\{operationId\}/events | EXCHANGE  |

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
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '01'),0) AS "January",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '02'),0) AS "February",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '03'),0) AS "March",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '04'),0) AS "April",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '05'),0) AS "May",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '06'),0) AS "June"
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
    tab.metodo AS "Method",
    tab.url AS "Url",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '07'),0) AS "July",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '08'),0) AS "August",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '09'),0) AS "September",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '10'),0) AS "October",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '11'),0) AS "November",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '12'),0) AS "December"
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
year AS "Year",
endpoint_url AS "Url",
metodo AS "Method",
trunc(coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Jan')*100,100)::decimal, 2) AS "January",
trunc(coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Feb')*100,100)::decimal, 2) AS "February",
trunc(coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Mar')*100,100)::decimal, 2) AS "March",
trunc(coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Apr')*100,100)::decimal, 2) AS "April",
trunc(coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='May')*100,100)::decimal, 2) AS "May",
trunc(coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Jun')*100,100)::decimal, 2) AS "June",
trunc(coalesce (1 - sum(seconds_downtime)/max(total_period) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY')),1)*100::decimal, 2) AS "Average period"
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
year AS "Year",
endpoint_url AS "Url",
metodo AS "Method",
trunc(coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Jul')*100, 100)::decimal, 2) AS "July",
trunc(coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Aug')*100, 100)::decimal, 2) AS "August",
trunc(coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Sep')*100, 100)::decimal, 2) AS "September",
trunc(coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Oct')*100, 100)::decimal, 2) AS "October",
trunc(coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Nov')*100, 100)::decimal, 2) AS "November",
trunc(coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Dec')*100, 100)::decimal, 2) AS "December",
trunc(coalesce (1 - sum(seconds_downtime)/max(total_period) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY')), 1)*100::decimal, 2) AS "Average period"
FROM result_tab
GROUP BY year,endpoint_url,metodo
having num_nulls(min(year) FILTER (WHERE year = to_char(to_date(:initial_date, 'YYYY'), 'YYYY'))) = 0
```
