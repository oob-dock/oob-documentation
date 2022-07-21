# Relatório semestral

- [Introdução](#introdução)
- [Scripts - Chamadas de APIs](#scripts---chamadas-de-apis)
  - [Extração de dados do primeiro semestre](#extração-de-dados-do-primeiro-semestre)
  - [Extração de dados do segundo semestre](#extração-de-dados-do-segundo-semestre)

## Introdução

A Opus está fornecendo alguns scripts SQL que ajudarão os clientes na hora da coleta
de dados para a elaboração do relatório semestral exigido pelo
Open Banking Brasil **OBB**.

As informações que poderão ser obtidas com eles são:

- a quantidade de chamadas de API em cada mês, para cada endpoint
- a disponibilidade média no período

**OBS:** fica a cargo de nossos clientes
rodar os scripts e formatar as informações da forma e no período exigido pelo OBB.

## Scripts - Chamadas de APIs

Os scripts SQL fornecidos nessa secção devem ser operados no
**banco de dados do OOB-Status**.
Antes de utilizá-los, deve-se alterar os campos '<data_inicial>' e '<data_final>'
pelos valores do período em que se deseja obter as informações.

A formatação para ambos os campos é **YYYY-MM-DD**.

- YYYY: ano da data desejada
- MM: mês da data desejada
- DD: dia da data desejada

Exemplo de uso:

```sql
@set initial_date = '2022-01-01 00:00:00.000 -0300'
@set final_date = '2022-06-30 23:59:59.999 -0300'
```

### Extração de dados do primeiro semestre

```sql
@set initial_date = '<data_inicial> 00:00:00.000 -0300'
@set final_date = '<data_final> 23:59:59.999 -0300'

SELECT
    tab.metodo,
    tab.url,
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '01'),0) AS "Janeiro",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '02'),0) AS "Fevereiro",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '03'),0) AS "Março",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '04'),0) AS "Abril",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '05'),0) AS "Maio",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '06'),0) AS "Junho"
FROM 
(SELECT edp.endpoint_url as url , edp.endpoint_name, substring(edp.endpoint_name, 'GET|POST|PATCH|DELETE') as metodo, date_trunc('month',"date") as "date", sum(qty_requests) as qty
FROM public.endpoint_metric epm
left join public.endpoint edp 
on (epm.id_endpoint = edp.id)
where "date" between :initial_date and :final_date
group by edp.endpoint_url, edp.endpoint_name, metodo, date_trunc('month',"date")) as tab
group by tab.url, tab.metodo, tab.endpoint_name
order by tab.url;
order by tab.metodo,tab.url;

```

### Extração de dados do segundo semestre

```sql
@set initial_date = '<data_inicial> 00:00:00.000 -0300'
@set final_date = '<data_final> 23:59:59.999 -0300'

select
    tab.metodo,
    tab.url,
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '07'),0) AS "Julho",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '08'),0) AS "Agosto",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '09'),0) AS "Setembro",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '10'),0) AS "Outubro",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '11'),0) AS "Novembro",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '12'),0) AS "Dezembro"
FROM 
(SELECT edp.endpoint_url as url , edp.endpoint_name, substring(edp.endpoint_name, 'GET|POST|PATCH|DELETE') as metodo, date_trunc('month',"date") as "date", sum(qty_requests) as qty
FROM public.endpoint_metric epm
left join public.endpoint edp 
on (epm.id_endpoint = edp.id)
where "date" between :initial_date and :final_date
group by edp.endpoint_url, edp.endpoint_name, metodo, date_trunc('month',"date")) as tab
group by tab.url, tab.metodo, tab.endpoint_name
order by tab.url;
```
