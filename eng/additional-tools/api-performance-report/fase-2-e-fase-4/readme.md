# Transmitter API Performance Report for Phase 2 (Data Sharing)

Opus is providing some SQL scripts that will assist customers in collecting data to create the performance report of the Open Finance Brazil **OFB** APIs.

**NOTE:** It is up to our customers to run the scripts and format the information in the manner and for the period required by OFB.

## Scripts - Transmitter Metrics

**Important:** The SQL scripts provided in this section should be operated in the **OOB-Status database**.

You must create the *api_metrics* function by executing the following [script](attachments/api_metrics.sql). To obtain the data, execute the function with the following command:

\```sql
SELECT * FROM api_metrics('<initial_date>','<final_date>');
\```

The parameters must be filled in the format yyyy-MM-dd, for example:

\```sql
SELECT * FROM api_metrics('2023-01-02','2023-01-08');
\```

This function will return most of the data needed to fill in the report, except for the *Average Response Time* field, which should use the following query.

### Average Response Time - 95th Percentile

**Important:** The SQL scripts provided in this section should be operated in the **PCM service database**.

You must create the *percentile_p95* function by executing the following [script](attachments/percentile_p95.sql). To obtain the data, execute the function with the following command:

\```sql
SELECT * FROM percentile_p95('<initial_date>','<final_date>');
\```

The parameters must be filled in the format yyyy-MM-dd, for example:

\```sql
SELECT * FROM percentile_p95('2023-01-02','2023-01-08');
\```

**NOTE:** To compile the final report, it will be necessary to group the results of both queries based on the day, method, and *endpoint* returned by them.

## Execution of Reports with Data Consolidation by Organization

If the organization has two or more brands, for queries that need to be performed on the **OOB-Status** service database, it is necessary to use scripts with the prefix "organization_". In addition to the original parameters (start date and/or end date), a connection string must be provided to enable communication with the databases of the other brands.

For this purpose, the "dblink" component must be installed in the main databases using the following command:

```sql
CREATE EXTENSION IF NOT EXISTS "dblink";
```

The connection string should be formatted as follows:

host={db_target_host} dbname={db_target_dbname} user={db_target_user} password={db_target_password}
