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
recebidos do Iniciador desde uma data inicial até a data desejada
- a quantidade de solicitações de Pagamentos confirmadas pelo cliente desde uma
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
pelos valores desejados.

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

- 'data-inicial-desejada' = 22-05-2022 00:00:00
- 'data-final-desejada' = 22-05-2022 23:59:59
- x = -3 [horas]
- 'data-inicial' = 'data-inicial-desejada' - x [horas] = 22-05-2022 00:00:00 -
(- 3) [horas] = 22-05-2022 00:00:00 + 3 [horas] = 22-05-2022 03:00:00
- 'data-final' = 'data-final-desejada' - x [horas] = 22-05-2022 23:59:59 -
(- 3) [horas] = 22-05-2022 23:59:59 + 3 [horas] = 23-05-2022 02:59:59

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

### Solicitações de Pagamentos confirmadAS pelo cliente

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
count (consent_translation_id)
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

### Número de clientes atendidos desde 29/10/21 até AS datAS indicadas

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

### Valor acumulado desde 29/10/21 até AS datAS indicadas

```sql
@set initial_date = '<data_inicial> 00:00:00'
@set final_date = '<data_final> 23:59:59'
WITH base_table AS (
    SELECT 
    to_char(history_status.updated_on, 'YYYY-MM-DD') AS date,
    sum (consent.vl_payment) AS daily_sum
    FROM consent
    INNER JOIN history_status ON history_status.id_consent = consent.id
    INNER JOIN consent_translation_id ON consent_translation_id.id_consent = consent.id
    WHERE dt_creation >= :initial_date AND dt_creation <= :final_date
    AND consent.tp_payment = 1
    AND history_status.status_consent = 6
    AND consent_translation_id.tp_openbanking_id = 8
    GROUP BY DATE
) 
SELECT table_a.date, table_a.daily_sum, (
    SELECT sum (table_b.daily_sum)
    FROM base_table table_b
    WHERE table_b.date <= table_a.date
) AS total_sum
FROM base_table table_a 
ORDER BY table_a.date
```
