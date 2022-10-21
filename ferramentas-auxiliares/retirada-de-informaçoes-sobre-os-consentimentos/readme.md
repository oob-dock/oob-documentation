# Scripts SQL - informações dos consentimentos

- [Scripts SQL - informações dos consentimentos](#scripts-sql---informações-dos-consentimentos)
  - [Introdução](#introdução)
  - [Scripts - Consentimento Transmissor](#scripts---consentimento-transmissor)
    - [Consentimento transmissor - Autorização do Cliente](#consentimento-transmissor---autorização-do-cliente)
    - [Consentimento transmissor - informações do authorization server](#consentimento-transmissor---informações-do-authorization-server)
    - [Consentimento transmissor - informações do consent](#consentimento-transmissor---informações-do-consent)
  - [Scripts - Estoque de consentimentos](#scripts---estoque-de-consentimentos)
    - [Estoque de consentimentos - informação consolidada](#estoque-de-consentimentos---informação-consolidada)
    - [Estoque de consentimentos - informação por receptor](#estoque-de-consentimentos---informação-por-receptor)

## Introdução

A Opus está fornecendo alguns scripts SQL que ajudarão os clientes na coleta
de dados relacionados aos consentimentos gerados e guardados no ecossistema Opus
Open Banking **OOB**.

As informações que poderão ser obtidas com eles são:

- Estoque de consentimentos
- Consentimento Transmissor

**OBS:** fica a cargo de nossos clientes
rodar os scripts e formatar as informações da forma e no período exigido pelo Open
Banking Brasil **OBB**.

## Scripts - Consentimento Transmissor

Os scripts SQL fornecidos nessa seção devem ser operados no
**banco de dados do OOB-Consent**

### Consentimento transmissor - Autorização do Cliente

Primeiramente é necessário criar a function consent_authorization_client
executando o seguinte [script](attachments/consent_function_authorization_client.sql).

Para obter os dados, deve-se chamar a função usando o seguinte comando:

```sql
SELECT * FROM extract_report_data('<data_inicio>','<data_fim>');
```

Sendo que os parâmetros devem ser preenchidos no formato yyyy-MM-dd, por exemplo:

```sql
SELECT * FROM extract_report_data('2022-01-02','2022-10-08');
```

### Consentimento transmissor - informações do authorization server

Os scripts SQL fornecidos nessa seção devem ser operados no
**banco de dados do OOB-Authorization-Server**

Primeiramente é necessário criar a function decode_base64url executando o
seguinte [script](attachments/as_function_decode_base64url.sql).

Depois, deve ser criada a function extract_report_data executando o seguinte [script](attachments/as_function_extract_report_data.sql).

Para obter os dados, deve-se chamar a função usando o seguinte comando:

```sql
SELECT * FROM extract_report_data('<data_inicio>','<data_fim>');
```

Sendo que os parâmetros devem ser preenchidos no formato yyyy-MM-dd, por exemplo:

```sql
SELECT * FROM extract_report_data('2022-10-02','2022-10-08');
```

### Consentimento transmissor - informações do consent

Os scripts SQL fornecidos nessa seção devem ser operados no
**banco de dados do OOB-Consent**

Primeiramente, deve ser criada a function extract_report_data executando o seguinte [script](attachments/consent_function_extract_usage_report.sql).

Para obter os dados, deve-se chamar a função usando o seguinte comando:

```sql
SELECT * FROM CONSENT_USAGE_REPORT('<data_inicio>','<data_fim>', <offset?>, <size?>);
```

Sendo que os parâmetros devem ser preenchidos no formato yyyy-MM-dd, por exemplo:

```sql
SELECT * FROM CONSENT_USAGE_REPORT('2022-10-02','2022-10-08');
```

Os parâmetros `<offset?>` e `<size?>` são opcionais, servem para paginação e indicam quantas linhas devem
ser puladas e capturadas, respectivamente.

## Scripts - Estoque de consentimentos

Os scripts SQL fornecidos nessa seção devem ser operados no
**banco de dados do OOB-Consent**

### Estoque de consentimentos - informação consolidada

Primeiramente é necessário criar a function consent_consolidated_stock executando o
seguinte [script](attachments/consent_function_consolidated_stock.sql).

Para obter os dados, deve-se chamar a função usando o seguinte comando:

```sql
SELECT * FROM consent_consolidated_stock();
```

### Estoque de consentimentos - informação por receptor

Primeiramente é necessário criar a function consent_consolidated_stock executando o
seguinte [script](attachments/consent_function_receptor_stock.sql).

Para obter os dados, deve-se chamar a função usando o seguinte comando:

```sql
SELECT * FROM consent_receptor_stock();
```
