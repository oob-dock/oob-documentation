# Data Purge from Opus Open Finance database

Opus provides a script for removing expired or obsolete
records from the Authorization Server database, ensuring
the maintenance of system integrity and efficiency.

**Important**: Executing the script may impact database
performance. Therefore, it is recommended to run it outside peak
system usage periods.

## Authorization Server

### Script - Purging Expired Data

To remove expired records, you need to create the stored procedure 
*as_delete_expired_records* by executing the following [script](attachments/as_delete_expired_records.sql).

After creating the procedure, data removal can be initiated
with the following SQL command:

```sql  
call as_delete_expired_records();
```

**Important**: Executing the script does not free up disk space,
as PostgreSQL retains records in tables.

**Important**: It is recommended to check whether the automatic execution
of *VACUUM* is enabled in the database to ensure storage optimization.