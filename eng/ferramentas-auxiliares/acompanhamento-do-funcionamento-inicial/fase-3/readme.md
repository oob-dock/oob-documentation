# Monitoring the Initial Operation of Phase 3

- [Introduction](#introduction)
- [Scripts - Account Holder](#scripts---account-holder)
  - [Redirections of Payment Requests Received from the Initiator](#redirections-of-payment-requests-received-from-the-initiator)
  - [Payment Requests Confirmed by the Customer](#payment-requests-confirmed-by-the-customer)
  - [Redirections to the Initiator with Payment Confirmation](#redirections-to-the-initiator-with-payment-confirmation)
  - [Number of Customers Served from 10/29/21 to the Indicated Dates](#number-of-customers-served-from-102921-to-the-indicated-dates)
  - [Accumulated Value from 10/29/21 to the Indicated Dates](#accumulated-value-from-102921-to-the-indicated-dates)

## Introduction

Opus is providing some SQL scripts that will assist customers in collecting data for monitoring the initial operation of Phase 3 (Financial Institution holding accounts) required by Open Finance Brazil **OFB**.

To understand the following section of the text, consider:
- `cpf` is the unique identification number of a citizen in Brazilian government registers
- `cnpj` is the unique identification number of a company in Brazilian government registers

The information that can be obtained with these scripts includes successful cases of:

- Number of distinct CPFs that performed payment consents within a period;
- Number of CNPJs that performed payment consents within a period;
- Number and total value of payments by type (PIX/TED/TEF) made within a period;

**NOTE:** It is up to our customers to run the scripts and format the information in the manner and for the period required by Open Finance Brazil.

## Scripts - Financial Institution Holding Accounts

The SQL scripts provided in this section should be operated in the **OOB-Consents database**. Before using them, you must replace the `<initial_date>` and `<final_date>` fields with the values for the desired period.

The format for both fields is **YYYY-MM-DD**.

- YYYY: year of the desired date
- MM: month of the desired date
- DD: day of the desired date

Usage example:

\```sql
@set initial_date = '2021-10-29'
@set final_date = '2022-05-28'
\```

### Financial Institution Holding Accounts - Customers

In the first execution, it is necessary to create the *payment_distinct_user* function by running the following [script](attachments/payment_distinct_user.sql).

To obtain the data, you must call the function using the following command:

\```sql
SELECT * FROM payment_distinct_user('<initial_date>','<final_date>');
\```

The parameters must be filled in the format yyyy-MM-dd, for example:

\```sql
SELECT * FROM payment_distinct_user('2021-10-29','2024-04-15');
\```

### Financial Institution Holding Accounts - Operations

In the first execution, it is necessary to create the *payment_amount_by_type* function by running the following [script](attachments/payment_amount_by_type.sql).

To obtain the data, you must call the function using the following command:

\```sql
SELECT * FROM payment_amount_by_type('<initial_date>','<final_date>');
\```

The parameters must be filled in the format yyyy-MM-dd, for example:

\```sql
SELECT * FROM payment_amount_by_type('2021-10-29','2024-04-15');
\```
