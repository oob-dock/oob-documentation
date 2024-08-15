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

