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
Open Finance Brasil **OFB**.

As informações que poderão ser obtidas com eles são os casos de **sucesso** para:

- Quantidade de CPFs distintos que realizaram consentimentos de pagamento em um período;
- Quantidade de CNPJs que realizaram consentimentos de pagamento em um período;
- Quantidade e valor total dos pagamentos por tipo (PIX/TED/TEF) realizados em um período;

**OBS:** fica a cargo de nossos clientes
rodar os scripts e formatar as informações da forma e no período exigido pelo OFB.

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
@set initial_date = '2021-10-29'
@set final_date = '2022-05-28'
```

### Antes da migração para suporte a V4

Caso a migração para a v4 ainda não tenha sido executada na base de dados,
pode-se utilizar a seguinte consulta para obtenção das informações:

```sql
SELECT count(distinct sha_person_document_number)   "Clientes únicos PF total",
       count(distinct sha_business_document_number) "Clientes únicos PJ",
       sum(c.vl_payment) AS                         "Valor das operações",
       count(c.id)                                  "Qtde de operações"
FROM consent c
WHERE dt_creation >= :initial_date
  AND dt_creation <= :final_date
  AND c.tp_payment = 1
  AND EXISTS (SELECT 1 
              FROM history_status hs
              WHERE c.id = hs.id_consent and hs.status_consent = 6)
              and exists (select 1
                          from consent_translation_id cti
                          where c.id = cti.id_consent and cti.tp_openbanking_id = 8);
```

Vale a pena ressaltar que o script obtém os resultados de acordo com o fuso horário GMT-0. Caso deseje utilizar um fuso diferente, é necessário ajustar as datas de acordo com o horário desejado.

Fórmula para obtenção da 'data-inicial' e 'data-final' para um GMT+x : 

```'data-desejada' - x (horas)```

Exemplo de cálculo para se obter 'data-inicial' e 'data-final' do dia 22/05/2022 no fuso Brasil - Brasília (GMT-3):

```
    'data-inicial-desejada' = 2022-05-22 00:00:00
    'data-final-desejada' = 2022-05-22 23:59:59
    x = -3 [horas]
    'data-inicial' = 'data-inicial-desejada' - x [horas] = 2022-05-22 00:00:00 - (- 3) [horas] = 22-05-2022 00:00:00 + 3 [horas] = 2022-05-22 03:00:00
    'data-final' = 'data-final-desejada' - x [horas] = 2022-05-22 23:59:59 - (- 3) [horas] = 22-05-2022 23:59:59 + 3 [horas] = 2022-05-23 02:59:59
```

### Após migração para suporte a v4

#### Detentor - Clientes

Na primeira execução é necessário criar a função *payment_distinct_user*
executando o seguinte [script](attachments/payment_distinct_user.sql)

Para obter os dados, deve-se chamar a função usando o seguinte comando:

```sql
SELECT * FROM payment_distinct_user('<data_inicio>','<data_fim>');
```

Sendo que os parâmetros devem ser preenchidos no formato yyyy-MM-dd, por exemplo:

```sql
SELECT * FROM payment_distinct_user('2021-10-29','2024-04-15');
```

#### Detentor - Operações

Na primeira execução é necessário criar a função *payment_amount_by_type*
executando o seguinte [script](attachments/payment_amount_by_type.sql)

Para obter os dados, deve-se chamar a função usando o seguinte comando:

```sql
SELECT * FROM payment_amount_by_type('<data_inicio>','<data_fim>');
```

Sendo que os parâmetros devem ser preenchidos no formato yyyy-MM-dd, por exemplo:

```sql
SELECT * FROM payment_amount_by_type('2021-10-29','2024-04-15');
```
