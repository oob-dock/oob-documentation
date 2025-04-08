# Phase 3 Interoperability Report

Opus is providing some SQL scripts that will assist clients in collecting data to create the interoperability report for Open Finance Brazil **OFB**.

**NOTE:** It is the responsibility of our clients to run the scripts and format the information according to the form and period required by OFB.

## Scripts - Holder Funnel

### Holder Funnel - Consents Generated

**Important:** The SQL scripts provided in this section should be operated in the **OOB-Consent database**.

First, the *get_conglomerate_name* function must be created by executing the following [script](../../commons/attachments/function_get_conglomerate_name.sql).

Then, create the *payment_consent_count* function by executing the following [script](attachments/payment_consent_function_count.sql).

To retrieve the data, execute the function with the following command:

```sql
SELECT * FROM payment_consent_count('<data_inicio>','<data_fim>', <automatic_payment>);
```

The *automatic_payment* parameter indicates whether the query should include only automatic payments or exclude them. It should be filled with *true* or *false*. The date parameters should be filled in the format yyyy-MM-dd, for example:

```sql
SELECT * FROM payment_consent_count('2023-01-02','2023-01-08', false);
```

After execution, refer to the ParentOrganization Reference by following the steps described in [ParentOrg Initiator](#parentorg-iniciador).

### Holder Funnel - Authentication and Redirection

**Important:** The SQL scripts provided in this section should be operated in the **OOB-Authorization-Server database**.

First, the *get_conglomerate_name* function must be created by executing the following [script](../../commons/attachments/function_get_conglomerate_name.sql).

Then, you must create the *decode_base64url* function by running the following [script](attachments/as_function_decode_base64url.sql).

After, you must create the *get_consent_product_flow* function by running the following [script](attachments/as_get_consent_product_flow.sql).

At last, create the *payment_consent_extract_authorization_data* function by running the following [script](attachments/payment_consent_extract_authorization_data.sql).

To retrieve the data, execute the function using the following command:

```sql
SELECT * FROM payment_consent_extract_authorization_data('<data_inicio>','<data_fim>', <automatic_payment>);
```

The *automatic_payment* parameter indicates whether the query should include only automatic payments or exclude them. It should be filled with *true* or *false*. The date parameters should be filled in the format yyyy-MM-dd, for example:

```sql
SELECT * FROM payment_consent_extract_authorization_data('2022-10-02','2022-10-08', false);
```

### Holder Funnel - Completion of Client Authentication and Authorization

**Important:** The SQL scripts provided in this section should be operated in the **OOB-Consent database**.

During the first execution, you need to create the *payment_consent_client_authorization* function by running the following [script](attachments/payment_consent_client_authorization.sql).

To retrieve the data, you should call the function using the following command:

```sql
SELECT * FROM payment_consent_client_authorization('<data_inicio>','<data_fim>', <automatic_payment>);
```

The *automatic_payment* parameter indicates whether the query should include only automatic payments or exclude them. It should be filled with *true* or *false*. The date parameters should be filled in the format yyyy-MM-dd, for example:

```sql
SELECT * FROM payment_consent_client_authorization('2022-01-02','2022-10-08', false);
```

### Holder Funnel - Payments Received and IDs Generated

**Important:** The SQL scripts provided in this section should be operated in the **OOB-Consent database**.

During the first execution, you need to create the *payment_consent_payment_id* function by running the following [script](attachments/payment_consent_payment_id.sql).

To retrieve the data, you should call the function using the following command:

```sql
SELECT * FROM payment_consent_payment_id('<data_inicio>','<data_fim>', <automatic_payment>);
```

The *automatic_payment* parameter indicates whether the query should include only automatic payments or exclude them. It should be filled with *true* or *false*. The date parameters should be filled in the format yyyy-MM-dd, for example:

```sql
SELECT * FROM payment_consent_payment_id('2022-01-02','2022-10-08', false);
```

**Important**: The counts of scheduled and completed payments returned by the query should only be used if the institution correctly implements the [Payment Status Change Notification API](../../../backoffice-portal/apis-backoffice/readme.md#notificação-de-mudança-de-status-de-pagamento).

## API - Holder Funnel

### Holder Funnel - Payment Completed

Since the Opus Open Finance solution does not store the payment status, we provide an API to list *Payment IDs* generated within a date range:

```GET /open-banking/oob-consents/v1/tpps/payment-legacy-ids```

The API receives two query parameters as input to define the range:

- *startDate*: Start date of the range in the format *yyyy-MM-dd*;
- *endDate*: End date (inclusive) of the range in the format *yyyy-MM-dd*;

The account holder should check the status of each of the returned payments to determine how many of them were completed.

More information about the API can be found in [apis-backoffice](../../../backoffice-portal/apis-backoffice/readme.md).

## Scripts - Synchronous Validations

**Important:** The SQL scripts provided in this section should be operated in the **PCM database**.

During the first execution, you need to create the *payment_sync_validation* function by running the following [script](attachments/payment_sync_validation.sql).

To retrieve the data, you should call the function using the following command:

```sql
SELECT * FROM payment_sync_validation('<data_inicio>','<data_fim>');
```

The parameters should be filled in the format yyyy-MM-dd, for example:

```sql
SELECT * FROM payment_sync_validation('2022-01-02','2022-10-08');
```

After execution, refer to the ParentOrganization Reference by following the steps described in [ParentOrg Initiator](#parentorg-iniciador).

## Scripts - Asynchronous Validations

**Important:** The SQL scripts provided in this section should be operated in the **OOB-Consent database**.

During the first execution, you need to create the *payment_async_validation* function by running the following [script](attachments/payment_async_validation.sql).

To retrieve the data, you should call the function using the following command:

```sql
SELECT * FROM payment_async_validation('<data_inicio>','<data_fim>');
```

The parameters should be filled in the format yyyy-MM-dd, for example:

```sql
SELECT * FROM payment_async_validation('2022-01-02','2022-10-08');
```

After execution, refer to the ParentOrganization Reference for the ITP_ID by following the steps described in [ParentOrg Initiator](#parentorg-iniciador).

## ParentOrg Initiator and ITP Name

To obtain the parent organization and ITP name, you should run the [getParentOrganization](../../parent-org-reference-script/getParentOrganization.js) script, providing the IDs of the organizations returned by the *payment_consent_count* and *payment_sync_validation* queries.

You will need to install the appropriate version of [Node.js](https://nodejs.org/en/download) for your Operating System.

With Node.js installed, run the following command from the root of this project:

```bash
node ferramentas-auxiliares/parent-org-reference-script/getParentOrganization.js [IDs das Orgs Iniciadoras]
```

The initiator organization IDs should be separated by spaces, as shown in the example below:

```bash
$ node ferramentas-auxiliares/parent-org-reference-script/getParentOrganization.js f83bee4f-26df-53d7-8335-a8a6edd7e340 fd0ea3e7-aeca-55f9-a0a2-ec56980059fb fd0ea3e7-aeca-55f9-a0a2-ec56980059fc
----------------------------------------------
Org ID: f83bee4f-26df-53d7-8335-a8a6edd7e340
Name: AYMORE CFI S.A.
Parent Organization: 90400888000142
----------------------------------------------
Org ID: fd0ea3e7-aeca-55f9-a0a2-ec56980059fb
Name: BCO WOORI BANK DO BRASIL S.A.
Parent Organization: N/A
----------------------------------------------
Org ID fd0ea3e7-aeca-55f9-a0a2-ec56980059fc Not found
----------------------------------------------
```

If the initiator does not have a Parent Organization, the script will return *N/A* for it. If the initiator does not exist, the script will return *Not found*.

## Execution of Reports with Data Consolidation by Organization

If the organization has two or more brands, for queries that need to be performed on the **OOB-Authorization-Server** and **OOB-Consent** service databases, it is necessary to use scripts with the prefix "organization_". In addition to the original parameters (start date and/or end date), a connection string must be provided to enable communication with the databases of the other brands.

For this purpose, the "dblink" component must be installed in the main databases using the following command:

```sql
CREATE EXTENSION IF NOT EXISTS "dblink";
```

The connection string should be formatted as follows:

host={db_target_host} dbname={db_target_dbname} user={db_target_user} password={db_target_password}
