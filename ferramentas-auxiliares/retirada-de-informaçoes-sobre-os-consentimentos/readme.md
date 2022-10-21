# Scripts SQL - informações dos consentimentos

- [Scripts SQL - informações dos consentimentos](#scripts-sql---informações-dos-consentimentos)
  - [Introdução](#introdução)
  - [Scripts - Consentimento Transmissor](#scripts---consentimento-transmissor)
    - [Consentimento Transmissor - Autorização do Cliente](#consentimento-transmissor---autorização-do-cliente)
    - [Consentimento transmissor - informações do authorization server](#consentimento-transmissor---informações-do-authorization-server)
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

### Consentimento Transmissor - Autorização do Cliente

Primeiramente é necessário criar a função consentimento_authorizacao_cliente
executando o seguinte [script](attachments/consentimento_authorizacao_cliente.sql).

Para obter os dados, deve-se chamar a função usando o seguinte comando:

```sql
SELECT * FROM extract_report_data('<data_inicio>','<data_fim>');
```

Sendo que os parâmetros devem ser preenchidos no formato yyyy-MM-dd, por exemplo:

```sql
SELECT * FROM extract_report_data('2022-01-02','2022-10-08');
```

## Scripts - Consentimento transmissor

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

Primeiramente é necessário criar a função executando:

```sql
CREATE OR REPLACE FUNCTION estoque_consentimento_consolidado()
    RETURNS TABLE (
        Clientes_Unicos_PF_Total INT,
        Clientes_Unicos_PJ_Total INT
)
LANGUAGE SQL
AS $$
SELECT  SUM(CASE WHEN c.sha_business_document_number IS NULL THEN 1 ELSE 0 END) AS Clientes_Unicos_PF_Total,
        SUM(CASE WHEN c.sha_business_document_number IS NOT NULL THEN 1 ELSE 0 END) AS Clientes_Unicos_PJ_Total
FROM   consent c
WHERE status = 1 
AND   tp_consent = 1$$;
```

Depois ele pode ser chamado usando:

```sql
SELECT * FROM estoque_consentimento_consolidado();
```

### Estoque de consentimentos - informação por receptor

Primeiramente é necessário criar a função executando:

```sql
CREATE OR REPLACE FUNCTION estoque_consentimento_receptor()
    RETURNS TABLE (
        org_name VARCHAR,
        qtd_Estoque_Consentimentos_Ativos INT
) 
LANGUAGE SQL
AS $$
SELECT  t.org_name,
        COUNT(c.*) qtd_Estoque_Consentimentos_Ativos
FROM  consent c, 
      tpp t
WHERE c.id_tpp  = t.id
AND   c.status = 1
AND   c.tp_consent = 1
AND   c.dt_expiration > CURRENT_TIMESTAMP
GROUP BY t.org_name$$;
```

Depois ele pode ser chamado usando:

```sql
SELECT * FROM estoque_consentimento_receptor();
```
