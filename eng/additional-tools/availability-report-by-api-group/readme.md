# SQL Scripts - Weekly Report

- [Introduction](#introduction)
- [Input Parameters](#input-parameters)
  - [Data Period](#data-period)
  - [Desired Services](#desired-services)
- [Scripts - API Usage by Grouping](#scripts---api-usage-by-grouping)
  - [API Group Call Quantity](#api-group-call-quantity)
  - [Average API Group Availability](#average-api-group-availability)

## Introduction

Opus is providing some SQL scripts that will help clients collect data for the preparation of the weekly availability report required by Open Finance Brazil **OFB**.

The information that can be obtained with them includes:

- the number of calls received during the period;
- the average availability during the period.

**NOTE:** It is up to our clients to run the scripts and format the information according to the form and period required by OFB.

## Input Parameters

Before using the SQL scripts provided by Opus, you must replace the fields `<initial_date>`, `<final_date>`, and `<services_urls>` with the appropriate values for the period and the service URLs you want to retrieve information from.

This section will present the formatting and possible values for each of the parameters.

### Data Period

The `<initial_date>` and `<final_date>` fields define the period for which you want to obtain the information.

The format for both fields is **YYYY-MM-DD**.

- YYYY: year of the desired date
- MM: month of the desired date
- DD: day of the desired date

Usage example:

```sql
@set initial_date = '2022-01-01'
@set final_date = '2022-06-30'
```

### List of Desired Services

The `endpoints_services` parameter is an array of strings (`array[string]`). You need to replace the `<services_urls>` field with all the service URLs provided by the partner entity.

Example for obtaining services from Phase 1 - Products and Services:

```sql
@set endpoints_services = array ['/products-services/v1/personal-accounts', '/products-services/v1/business-accounts', '/products-services/v1/personal-loans', '/products-services/v1/business-loans', '/products-services/v1/personal-financings', '/products-services/v1/business-financings', '/products-services/v1/personal-invoice-financings', '/products-services/v1/business-invoice-financings', '/products-services/v1/personal-credit-cards', '/products-services/v1/business-credit-cards', '/products-services/v1/personal-unarranged-account-overdraft', '/products-services/v1/business-unarranged-account-overdraft']
```

Example for obtaining services from Phase 1 - Channels:

```sql
@set endpoints_services = array ['/channels/v1/branches', '/channels/v1/electronic-channels', '/channels/v1/phone-channels', '/channels/v1/banking-agents', '/channels/v1/shared-automated-teller-machines']
```

Below are tables with all endpoints divided into subgroups to facilitate the listing of service URLs provided.

Endpoints - Phase 1 Products and Services

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

Endpoints - Phase 1 Channels

| Endpoint                                                    | Category              |
| ----------------------------------------------------------- | --------------------- |
| /channels/v1/branches                                       | SERVICE CHANNELS      |
| /channels/v1/electronic-channels                            | SERVICE CHANNELS      |
| /channels/v1/phone-channels                                 | SERVICE CHANNELS      |
| /channels/v1/banking-agents                                 | SERVICE CHANNELS      |
| /channels/v1/shared-automated-teller-machines               | SERVICE CHANNELS      |

## Scripts - API Usage by Grouping

The SQL scripts provided in this section should be operated in the **OOB-Status database** and used according to the desired date range.
If there are any questions regarding the formatting of the input parameters, refer to the [Input Parameters](#input-parameters) section.

### API Group Call Quantity

```sql
@set initial_date = '<initial_date>'
@set final_date = '<final_date>'
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

### Average API Group Availability

```sql
@set initial_date = '<initial_date>';
@set final_date = '<final_date>';
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
