# Scripts SQL - informações dos consentimentos

- [Scripts SQL - informações dos consentimentos](#scripts-sql---informações-dos-consentimentos)
  - [Introdução](#introdução)
  - [Parâmetros de entrada](#parâmetros-de-entrada)
  - [Scripts - Estoque de consentimentos](#scripts---estoque-de-consentimentos)
    - [Estoque de consentimentos - informação consolidada](#estoque-de-consentimentos---informação-consolidada)
    - [Estoque de consentimentos - informação por receptor](#estoque-de-consentimentos---informação-por-receptor)

## Introdução

A Opus está fornecendo alguns scripts SQL que ajudarão os clientes na coleta
de dados relacionados aos consentimentos gerados e guardados no ecossistema Opus Open Banking **OOB**.

As informações que poderão ser obtidas com eles são:

- Estoque de consentimentos

**OBS:** fica a cargo de nossos clientes
rodar os scripts e formatar as informações da forma e no período exigido pelo Open Banking Brasil **OBB**.

## Parâmetros de entrada

Antes de utilizar os scripts SQL fornecidos pela Opus, deve-se alterar os campos
'<data_inicial>', '<data_final>'
pelos valores do período dos serviços que se deseja obter as informações.

A formatação para dos campos é **YYYY-MM-DD**.

- YYYY: ano da data desejada
- MM: mês da data desejada
- DD: dia da data desejada

Exemplo de uso:

```sql
@set initial_date = '2022-01-01'
@set final_date = '2022-06-30'
```

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