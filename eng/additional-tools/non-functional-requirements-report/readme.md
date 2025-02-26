# Non-Functional Requirements Report

Opus is providing some SQL scripts that will assist clients in collecting data to create the non-functional requirements report for Open Finance Brazil **OFB**.

**NOTE:** It is the responsibility of our clients to run the scripts and format the information according to the form and period required by OFB.

## Phase 3 - Payments

### Scripts - Response Time

**Important**: The SQL script provided in this section should be executed in the metrics collection service database for **PCM**.

You need to create the *payments_response_time* function by executing the following [script](attachments/payments_response_time.sql).

To retrieve the data, execute the function using the following command:

```sql
SELECT * FROM payments_response_time('<end_date>');
```

The *end_date* parameter refers to the Friday prior to the report's issuance in the format yyyy-MM-dd, for example:

```sql
select * from payments_response_time('2023-08-18');
```

**Important**: When generating the report, you should disregard the *metric_date* field, which is provided for reference only.

**Note**: The calculation considers the time difference between the arrival of the request and the response at the API gateway layer provided by Opus Open Finance - Kong. Only calls responded to with HTTP Codes other than 423, 429, and 529 are considered.

## Scripts - Availability

**Important**: The SQL script provided in this section should be executed in the **OOB-Status** service database.

You need to create the *status_function_availability* function by executing the following [script](attachments/status_function_availability.sql).

To retrieve the data, execute the function using the following command:

```sql
SELECT * FROM status_function_availability('<end_date>');
```

The *end_date* parameter refers to the Friday prior to the report's issuance in the format yyyy-MM-dd, for example:

```sql
select * from status_function_availability('2023-08-18');
```

**Note**: The availability calculation takes into account the intervals of service instability in seconds, considering server error returns (HTTP Code 5XX) and the service health check. The formulas used are:

- Last three months (90 days):

```text
777600 - <total unavailability in seconds> / 777600
```

- Daily:

```text
86400 - <total unavailability in seconds> / 86400
```

## Execution of Reports with Data Consolidation by Organization

If the organization has two or more brands, for queries that need to be performed on the **OOB-Status** service database, it is necessary to use scripts with the prefix "organization_". In addition to the original parameters (start date and/or end date), a connection string must be provided to enable communication with the databases of the other brands.

For this purpose, the "dblink" component must be installed in the main databases using the following command:

```sql
CREATE EXTENSION IF NOT EXISTS "dblink";
```

The connection string should be formatted as follows:

host={db_target_host} dbname={db_target_dbname} user={db_target_user} password={db_target_password}
