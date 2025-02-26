# Settlement, Rejection, and Cancellation Report for Phase 3

Opus is providing some SQL scripts to assist clients in collecting
data for the creation of the Open Finance Brasil **OFB** payment report.

**NOTE:** It is the responsibility of our clients to run the scripts
and format the information according to the requirements and timeframe
specified by OFB.

## Scripts - Settled, canceled, or rejected payments

You need to create the function *payment_ascs_rjct_canc*
by executing the following [script](attachments/payment_ascs_rjct_canc.sql).

To retrieve the data, execute the function with the following command:

```sql
SELECT * FROM payment_ascs_rjct_canc('<start_date>','<end_date>');
```

The date parameters must be provided in the format yyyy-MM-dd, for example:

```sql
SELECT * FROM payment_ascs_rjct_canc('2024-11-04','2024-11-10');
```

## Scripts - Rejection by reason

It is necessary to create the function *payment_rjct_reason*
by executing the following [script](attachments/payment_rjct_reason.sql).

To retrieve the data, execute the function with the following command:

```sql
SELECT * FROM payment_rjct_reason('<start_date>','<end_date>');
```

The date parameters must be filled in the format yyyy-MM-dd, for example:

```sql
SELECT * FROM payment_rjct_reason('2024-11-04','2024-11-10');
```

## Execution of Reports with Data Consolidation by Organization

If the organization has two or more brands, for queries that need to be performed on the **OOB-Consent** service database, it is necessary to use scripts with the prefix "organization_". In addition to the original parameters (start date and/or end date), a connection string must be provided to enable communication with the databases of the other brands.

For this purpose, the "dblink" component must be installed in the main databases using the following command:

```sql
CREATE EXTENSION IF NOT EXISTS "dblink";
```

The connection string should be formatted as follows:

host={db_target_host} dbname={db_target_dbname} user={db_target_user} password={db_target_password}
