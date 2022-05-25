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
and not (
    history_status.updated_on > '2022-04-29 23:59:59'
    or history_status.updated_on < '2021-10-29 00:00:00'
)
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
select count (distinct history_status.id_consent)
from history_status
inner join consent on consent.id = history_status.id_consent 
where status_consent = 2
and consent.tp_payment = 1
and not (
    history_status.updated_on > '<data_final> 23:59:59'
    or history_status.updated_on < '<data_inicial> 00:00:00'
)
```

### Solicitações de Pagamentos confirmadas pelo cliente

```sql
select count (history_status) 
from history_status
inner join consent on consent.id = history_status.id_consent 
where status_consent = 1
and consent.tp_payment = 1
and not (
    history_status.updated_on > '<data_final> 23:59:59'
    or history_status.updated_on < '<data_inicial> 00:00:00'
)
```

### Redirecionamentos ao Iniciador com a confirmação do pagamento

```sql
select count (consent_translation_id)
from consent_translation_id
inner join consent on consent.id = consent_translation_id.id_consent
inner join history_status on history_status.id_consent = consent.id
where not (
    history_status.updated_on > '<data_final> 23:59:59'
    or history_status.updated_on < '<data_inicial> 00:00:00'
)
and consent.tp_payment = 1
and consent.status = 6
and history_status.status_consent = 6
and consent_translation_id.tp_openbanking_id = 8
```

### Número de clientes atendidos desde 29/10/21 até as datas indicadas

```sql
select count (distinct consent.sha_person_document_number)
from consent
inner join history_status on history_status.id_consent = consent.id
where not (
    history_status.updated_on > '<data_final> 23:59:59'
    or history_status.updated_on < '<data_inicial> 00:00:00'
)
and consent.tp_payment = 1
```

### Valor acumulado desde 29/10/21 até as datas indicadas

```sql
select sum (consent.vl_payment)
from consent
inner join history_status on history_status.id_consent = consent.id
inner join consent_translation_id on consent_translation_id.id_consent = consent.id
where not (
    history_status.updated_on > '<data_final> 23:59:59'
    or history_status.updated_on < '<data_inicial> 00:00:00'
)
and consent.tp_payment = 1
and history_status.status_consent = 6
and consent_translation_id.tp_openbanking_id = 8
```
