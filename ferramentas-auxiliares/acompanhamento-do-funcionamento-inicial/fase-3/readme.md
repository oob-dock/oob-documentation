# Acompanhamento do funcionamento inicial da fase 3

- [Introdução](#introdução)
- [Scripts - Detentor de contas](#scripts---detentor-de-conta)
  - [Redirecionamentos de solicitações de pagamento recebidos do Iniciador](#redirecionamentos-de-solicitações-de-pagamento-recebidos-do-iniciador)
  - [Solicitações de Pagamentos confirmadas pelo cliente](#solicitações-de-pagamentos-confirmadas-pelo-cliente)
  - [Redirecionamentos ao Iniciador com a confirmação do pagamento](#redirecionamentos-ao-iniciador-com-a-confirmação-do-pagamento)
  - [Número de clientes atendidos desde 29/10/21 até as datas indicadas](#número-de-clientes-atendidos-desde-291021-até-as-datas-indicadas)
  - [Valor acumulado desde 29/10/21 até as datas indicadas](#valor-acumulado-desde-291021-até-as-datas-indicadas)

## Introdução

A Opus está fornecendo alguns scripts SQL que ajudarão os clientes na hora da coleta
de dados para o acompanhamento do funcionamento inicial da fase 3 exigido pelo
Open Banking Brasil **OBB**.

As informações que poderão ser obtidas com eles são os casos de **sucesso** para:

- a quantidade de redirecionamentos de solicitações de pagamento
recebidas do Iniciador desde uma data inicial até a data desejada
- a quantidade de solicitações de pagamentos confirmadas pelo cliente desde uma
data inicial até a data desejada
- o total de redirecionamentos ao Iniciador com a confirmação do pagamento desde
uma data inicial até a data desejada
- o número de clientes atendidos desde uma data inicial até a data desejada
- o valor acumulado desde uma data inicial até a data desejada

**OBS:** fica a cargo de nossos clientes
rodar os scripts e formatar as informações da forma e no período exigido pelo OBB.

## Scripts - Detentor de conta

Os scripts SQL fornecidos nessa secção devem ser operados no
**banco de dados do OOB-Consents**.
Antes de utilizá-los, deve-se alterar os campos '<data_inicial>' e '<data_final>'
pelos valores do período em que se deseja obter as informações.

A formatação para ambos os campos é **YYYY-MM-DD**.

- YYYY: ano da data desejada
- MM: mês da data desejada
- DD: dia da data desejada

Exemplo de uso:

```sql
@set initial_date = '2021-10-29 00:00:00'
@set final_date = '2022-05-28 23:59:59'
```

Vale a pena ressaltar que o script atual obtém os resultados
de acordo com o fuso horário GMT-0. Caso deseje utilizar um
fuso diferente, é necessário ajustar as datas de acordo com
o horário desejado.

Fórmula para obtenção da 'data-inicial' e 'data-final' para um GMT+x :
    'data-desejada' - x (horas)

Exemplo de cálculo para se obter 'data-inicial' e 'data-final' do dia 22/05/2022
no fuso Brasil - Brasília (GMT-3):

- 'data-inicial-desejada' = 2022-05-22 00:00:00
- 'data-final-desejada' = 2022-05-22 23:59:59
- x = -3 [horas]
- 'data-inicial' = 'data-inicial-desejada' - x [horas] = 2022-05-22 00:00:00 -
(- 3) [horas] = 22-05-2022 00:00:00 + 3 [horas] = 2022-05-22 03:00:00
- 'data-final' = 'data-final-desejada' - x [horas] = 2022-05-22 23:59:59 -
(- 3) [horas] = 22-05-2022 23:59:59 + 3 [horas] = 2022-05-23 02:59:59

### Redirecionamentos de solicitações de pagamento recebidos do Iniciador

```sql
@set initial_date = '<data_inicial> 00:00:00'
@set final_date = '<data_final> 23:59:59'
SELECT to_char(history_status.updated_on, 'YYYY-MM-DD') AS date,
count (DISTINCT history_status.id_consent) FROM history_status
INNER JOIN consent ON consent.id = history_status.id_consent 
WHERE status_consent = 2 
AND consent.tp_payment = 1
AND dt_creation >= :initial_date AND dt_creation <= :final_date
GROUP BY date
ORDER BY date;
```

### Solicitações de Pagamentos confirmadas pelo cliente

```sql
@set initial_date = '<data_inicial> 00:00:00'
@set final_date = '<data_final> 23:59:59'
SELECT to_char(history_status.updated_on, 'YYYY-MM-DD') AS date,
count (DISTINCT history_status.id_consent) FROM history_status
INNER JOIN consent ON consent.id = history_status.id_consent 
WHERE status_consent = 1
AND consent.tp_payment = 1
AND dt_creation >= :initial_date AND dt_creation <= :final_date
GROUP BY date
ORDER BY date;
```

### Redirecionamentos ao Iniciador com a confirmação do pagamento

```sql
@set initial_date = '<data_inicial> 00:00:00'
@set final_date = '<data_final> 23:59:59'
SELECT to_char(history_status.updated_on, 'YYYY-MM-DD') AS date,
COUNT (DISTINCT consent_translation_id.id_consent)
FROM consent_translation_id
INNER JOIN consent ON consent.id = consent_translation_id.id_consent
INNER JOIN history_status ON history_status.id_consent = consent.id
WHERE dt_creation >= :initial_date AND dt_creation <= :final_date
AND consent.tp_payment = 1
AND consent.status = 6
AND history_status.status_consent = 6
AND consent_translation_id.tp_openbanking_id = 8
GROUP BY date
ORDER BY date;
```

### Número de clientes atendidos desde 29/10/21 até as datas indicadas

```sql
@set initial_date = '<data_inicial> 00:00:00'
@set final_date = '<data_final> 23:59:59'
WITH base_table AS (
    SELECT
        DISTINCT ON (sha_person_document_number) sha_person_document_number, tp_payment,
        date, ordinal
        FROM
        (
            SELECT
                to_char(consent.dt_creation, 'YYYY-MM-DD') AS date,
                *,
                ROW_NUMBER() OVER (PARTITION BY consent.sha_person_document_number
                                        ORDER BY consent.dt_creation)  AS ordinal
            FROM
                consent
        )
            AS sorted_example
        WHERE dt_creation >= :initial_date AND dt_creation <= :final_date
        AND tp_payment = 1
)
SELECT DISTINCT (table_a.date) date, (
    SELECT count(table_b.sha_person_document_number)
    FROM base_table table_b
    WHERE table_b.date <= table_a.date
) AS total_clients
FROM base_table table_a 
ORDER BY table_a.date
```

### Valor acumulado desde 29/10/21 até as datas indicadas

```sql
@set initial_date = '<data_inicial> 00:00:00'
@set final_date = '<data_final> 23:59:59'
WITH values_table as (
    SELECT
    DISTINCT ON (consent_translation_id.id_consent)
    *
    FROM consent_translation_id
    WHERE consent_translation_id.tp_openbanking_id = 8
),
base_table AS (
    SELECT
    to_char(history_status.updated_on, 'YYYY-MM-DD') AS date,
    sum (consent.vl_payment) AS daily_sum
    FROM consent
    INNER JOIN history_status ON history_status.id_consent = consent.id
    INNER JOIN values_table ON
    values_table.id_consent = consent.id
    WHERE dt_creation >= :initial_date AND dt_creation <= :final_date
    AND consent.tp_payment = 1
    AND history_status.status_consent = 6
    GROUP BY DATE
)
SELECT table_a.date, table_a.daily_sum, (
    SELECT sum (table_b.daily_sum)
    FROM base_table table_b
    WHERE table_b.date <= table_a.date
) AS accum_value
FROM base_table table_a 
ORDER BY table_a.date
```

### Script para a obtenção de todas as colunas

Para facilitar a geração da primeira versão do histórico, foi criado um script
que obtém os valores de todas as colunas exigidas pelo OBB para os casos de sucesso.
Ele tem como resultado uma tabela com todos os dados desde a '<data-inicial>' até
a '<data-final>' definida.

```sql
@set initial_date = '<data_inicial> 00:00:00'
@set final_date = '<data_final> 23:59:59'
WITH base_table AS (
    WITH table_a AS (
        WITH red_table AS 
            (
                SELECT to_char(history_status.updated_on, 'YYYY-MM-DD') AS date,
                count (DISTINCT history_status.id_consent) AS red_count FROM history_status
                INNER JOIN consent ON consent.id = history_status.id_consent 
                WHERE status_consent = 2 
                AND consent.tp_payment = 1
                AND dt_creation >= :initial_date AND dt_creation <= :final_date
                GROUP BY date
                ORDER BY date
            ),
            pag_table AS (
                SELECT to_char(history_status.updated_on, 'YYYY-MM-DD') AS date,
                count (DISTINCT history_status.id_consent) AS pag_count FROM history_status
                INNER JOIN consent ON consent.id = history_status.id_consent 
                WHERE status_consent = 1
                AND consent.tp_payment = 1
                AND dt_creation >= :initial_date AND dt_creation <= :final_date
                GROUP BY date
                ORDER BY date
            ),
            con_table AS (
                SELECT to_char(history_status.updated_on, 'YYYY-MM-DD') AS date,
                COUNT (DISTINCT consent_translation_id.id_consent) AS con_count
                FROM consent_translation_id
                INNER JOIN consent ON consent.id = consent_translation_id.id_consent
                INNER JOIN history_status ON history_status.id_consent = consent.id
                WHERE dt_creation >= :initial_date AND dt_creation <= :final_date
                AND consent.tp_payment = 1
                AND consent.status = 6
                AND history_status.status_consent = 6
                AND consent_translation_id.tp_openbanking_id = 8
                GROUP BY date
                ORDER BY date
            ),
            num_client_table AS (
                WITH base_table AS (
                    SELECT
                        DISTINCT ON (sha_person_document_number) sha_person_document_number,
                        tp_payment,
                        date,
                        ordinal
                        FROM
                        (
                            SELECT
                                to_char(consent.dt_creation, 'YYYY-MM-DD') AS date,
                                *,
                                ROW_NUMBER() OVER (PARTITION BY consent.sha_person_document_number
                                                        ORDER BY consent.dt_creation)
                                                        AS ordinal
                            FROM
                                consent
                        )
                            AS sorted_example
                        WHERE dt_creation >= :initial_date AND dt_creation <= :final_date
                        AND tp_payment = 1
                    )
                    SELECT DISTINCT (table_a.date) date, (
                        SELECT count(table_b.sha_person_document_number)
                        FROM base_table table_b
                        WHERE table_b.date <= table_a.date
                    ) AS num_client_count
                    FROM base_table table_a 
                    ORDER BY table_a.date
                ),
                accum_value_table AS (
                    WITH values_table as (
                        SELECT
                        DISTINCT ON (consent_translation_id.id_consent)
                        *
                        FROM consent_translation_id
                        WHERE consent_translation_id.tp_openbanking_id = 8
                    ),
                    base_table AS (
                        SELECT
                        to_char(history_status.updated_on, 'YYYY-MM-DD') AS date,
                        sum (consent.vl_payment) AS daily_sum
                        FROM consent
                    INNER JOIN history_status ON history_status.id_consent = consent.id
                        INNER JOIN values_table ON
                        values_table.id_consent = consent.id
                        WHERE dt_creation >= :initial_date AND dt_creation <= :final_date
                        AND consent.tp_payment = 1
                        AND history_status.status_consent = 6
                        GROUP BY DATE
                    )
                    SELECT table_a.date, table_a.daily_sum, (
                        SELECT sum (table_b.daily_sum)
                        FROM base_table table_b
                        WHERE table_b.date <= table_a.date
                    ) AS accum_value
                    FROM base_table table_a 
                    ORDER BY table_a.date
                ),
                date_table AS (
                    WITH date_trunc_table AS (
                        SELECT date_trunc('day', dd):: date
                        FROM generate_series
                            ( :initial_date::timestamp 
                            , :final_date::timestamp
                            , '1 day'::interval) dd
                    )
                    SELECT to_char(date_trunc, 'YYYY-MM-DD') as date
                    FROM date_trunc_table
                )
        SELECT  date_table.date,
                coalesce(red_table.red_count, 0) AS red_count,
                coalesce(pag_table.pag_count, 0) AS pag_count,
                coalesce(con_table.con_count, 0) AS con_count,
                num_client_table.num_client_count,
                accum_value_table.accum_value
        FROM red_table
        FULL OUTER JOIN date_table on date_table.date = red_table.date
        FULL OUTER JOIN pag_table ON pag_table.date = red_table.date
        FULL OUTER JOIN con_table ON con_table.date = red_table.date
        FULL OUTER JOIN num_client_table ON num_client_table.date = red_table.date
        FULL OUTER JOIN accum_value_table ON accum_value_table.date = red_table.date
    )
    SELECT date, red_count, pag_count, con_count,
            (
                SELECT num_client_count 
                FROM table_a AS table_b 
                WHERE table_b.num_client_count IS NOT NULL
                and table_b.date <= original.date
                ORDER BY table_b.date DESC
                LIMIT 1
            ) AS num_client_count,
            (
                SELECT accum_value 
                FROM table_a AS table_b 
                WHERE table_b.accum_value IS NOT NULL
                and table_b.date <= original.date
                ORDER BY table_b.date DESC
                LIMIT 1
            ) AS accum_value
    FROM table_a AS original
    ORDER BY date
)
SELECT date, red_count, 0 as red_error, pag_count, 0 as pag_error, con_count,
0 as con_error,
coalesce(base_table.accum_value, 0) AS accum_value,
coalesce(base_table.num_client_count, 0) AS num_client_count
FROM base_table
```

Legenda das colunas apresentadas na tabela

| Nome da coluna   | Definição                                                                             |
| ---------------- | ------------------------------------------------------------------------------------- |
| date             | Dia aos quais os demais valores pertencem                                             |
| red_count        | Redirecionamentos de solicitações de pagamento recebidos do Iniciador                 |
| red_error        | Falha de redirecionamentos de solicitações de pagamento recebidos do Iniciador        |
| pag_count        | Solicitações de Pagamentos confirmadas pelo cliente                                   |
| pag_error        | Falha de solicitações de Pagamentos confirmadas pelo cliente                          |
| con_count        | Redirecionamentos ao Iniciador com a confirmação do pagamento                         |
| con_error        | Falha de redirecionamentos ao Iniciador com a confirmação do pagamento                |
| num_client_count | Número de clientes atendidos desde a '<data-inicial>' definida até as datas indicadas |
| accum_value      | Valor acumulado desde a '<data-inicial>' até as datas indicadas                       |

### (NOVA ADEQUADAÇÃO) Quantidade de clientes PF/PJ, valor total e quantidade de operações em um dado período.

- Quantidade de clientes únicos pessoas físicas que tiveram ao menos uma operação, de qualquer tipo/modalidade, com sucesso.
- Valor, em R$, acumulado, de todas as operações com sucesso.
Quantidade de operações realizadas com sucesso.

```sql
-- Consulta avulsa
SELECT count(distinct sha_person_document_number)   "Clientes únicos PF total",
       count(distinct sha_business_document_number) "Clientes únicos PJ",
       sum(c.vl_payment) AS                         "Valor das operações",
       count(c.id)                                  "Qtde de operações"
FROM consent c
WHERE dt_creation >= :initial_date
  AND dt_creation <= :final_date
  AND c.tp_payment = 1
  AND EXISTS(SELECT 1 FROM history_status hs WHERE c.id = hs.id_consent and hs.status_consent = 6);
```

```sql
-- Função
CREATE OR REPLACE FUNCTION RELATORIO_SEMANAL_DETENTOR_FASE3_2(start_date DATE, end_date DATE)
    RETURNS TABLE
            (
                "Clientes únicos PF total" BIGINT,
                "Clientes únicos PJ"       BIGINT,
                "Valor das operações"      DECIMAL,
                "Qtde de operações"        BIGINT
            )
as
$$
BEGIN
    RETURN QUERY SELECT count(distinct sha_person_document_number)   "Clientes únicos PF total",
                        count(distinct sha_business_document_number) "Clientes únicos PJ",
                        sum(c.vl_payment) AS                         "Valor das operações",
                        count(c.id)                                  "Qtde de operações"
                 FROM consent c
                 WHERE dt_creation >= start_date
                   AND dt_creation <= end_date
                   AND c.tp_payment = 1
                   AND EXISTS(SELECT 1 FROM history_status hs WHERE c.id = hs.id_consent and hs.status_consent = 6);
END
$$ LANGUAGE plpgsql;

SELECT *
FROM RELATORIO_SEMANAL_DETENTOR_FASE3_2(:initial_date, :final_date);
```

