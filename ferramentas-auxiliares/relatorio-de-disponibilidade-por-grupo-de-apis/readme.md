# Scripts SQL - Relatório semanal

- [Introdução](#introdução)
- [Parâmetros de entrada](#parâmetros-de-entrada)
  - [Período dos dados](#período-dos-dados)
  - [Serviços desejados](#lista-dos-serviços-desejados)
- [Scripts - Uso de APIs por agrupamento](#scripts---uso-de-apis-por-agrupamento)
  - [Quantidade de chamadas por grupo de APIs](#quantidade-de-chamadas-por-grupo-de-apis)
  - [Disponibilidade média do conjunto de APIs](#disponibilidade-média---extração-de-dados-do-segundo-semestre)

## Introdução

A Opus está fornecendo alguns scripts SQL que ajudarão os clientes na hora da coleta
de dados para a elaboração do relatório semanal exigido pelo
Open Finance Brasil **OFB**.

As informações que poderão ser obtidas com eles são:

- a quantidade de chamadas de API em cada mês, para um agrupamento de endpoints
- a disponibilidade média no período

**OBS:** fica a cargo de nossos clientes
rodar os scripts e formatar as informações da forma e no período exigido pelo OFB.

## Parâmetros de entrada

Antes de utilizar os scripts SQL fornecidos pela Opus, deve-se alterar os campos
'<data_inicial>', '<data_final>' e '<services_urls>'
pelos valores do período e pelas urls dos serviços que se deseja obter as informações.

Nesta seção, serão apresentados a formatação e os valores possíveis para cada um
dos parâmetros.

### Período dos dados

Os campos '<data_inicial>' e '<data_final>' definem o período em que se deseja
obter as informações.

A formatação para ambos os campos é **YYYY-MM-DD**.

- YYYY: ano da data desejada
- MM: mês da data desejada
- DD: dia da data desejada

Exemplo de uso:

```sql
@set initial_date = '2022-01-01'
@set final_date = '2022-06-30'
```

### Lista dos serviços desejados

O parâmetro 'endpoints_services' é um parâmetro do tipo array[string], sendo necessário
alterar o campo '<services_urls>' por todas as URLs dos serviços disponibilizados
pela entidade parceira.

Exemplo para obtenção dos serviços da fase 1 - Produtos e Serviços:

```sql
@set endpoints_services = array ['/products-services/v1/personal-accounts', '/products-services/v1/business-accounts', '/products-services/v1/personal-loans', '/products-services/v1/business-loans', '/products-services/v1/personal-financings', '/products-services/v1/business-financings', '/products-services/v1/personal-invoice-financings', '/products-services/v1/business-invoice-financings', '/products-services/v1/personal-credit-cards', '/products-services/v1/business-credit-cards', '/products-services/v1/personal-unarranged-account-overdraft', '/products-services/v1/business-unarranged-account-overdraft']
```

Exemplo para obtenção dos serviços da fase 1 - Canais:

```sql
@set endpoints_services = array ['/channels/v1/branches', '/channels/v1/electronic-channels', '/channels/v1/phone-channels', '/channels/v1/banking-agents', '/channels/v1/shared-automated-teller-machines']
```

Logo abaixo são apresentadas tabelas com todos os endpoints divididos em subgrupos
a fim de facilitar a listagem das URLs dos serviços disponibilizados.

Endpoints - Fase 1 Produtos e Serviços

| Endpoint                                                    | Categoria             |
| ----------------------------------------------------------- | --------------------- |
| /products-services/v1/personal-accounts                     | PRODUTOS E SERVIÇOS   |
| /products-services/v1/business-accounts                     | PRODUTOS E SERVIÇOS   |
| /products-services/v1/personal-loans                        | PRODUTOS E SERVIÇOS   |
| /products-services/v1/business-loans                        | PRODUTOS E SERVIÇOS   |
| /products-services/v1/personal-financings                   | PRODUTOS E SERVIÇOS   |
| /products-services/v1/business-financings                   | PRODUTOS E SERVIÇOS   |
| /products-services/v1/personal-invoice-financings           | PRODUTOS E SERVIÇOS   |
| /products-services/v1/business-invoice-financings           | PRODUTOS E SERVIÇOS   |
| /products-services/v1/personal-credit-cards                 | PRODUTOS E SERVIÇOS   |
| /products-services/v1/business-credit-cards                 | PRODUTOS E SERVIÇOS   |
| /products-services/v1/personal-unarranged-account-overdraft | PRODUTOS E SERVIÇOS   |
| /products-services/v1/business-unarranged-account-overdraft | PRODUTOS E SERVIÇOS   |

Endpoints - Fase 1 Canais

| Endpoint                                                    | Categoria             |
| ----------------------------------------------------------- | --------------------- |
| /channels/v1/branches                                       | CANAIS DE ATENDIMENTO |
| /channels/v1/electronic-channels                            | CANAIS DE ATENDIMENTO |
| /channels/v1/phone-channels                                 | CANAIS DE ATENDIMENTO |
| /channels/v1/banking-agents                                 | CANAIS DE ATENDIMENTO |
| /channels/v1/shared-automated-teller-machines               | CANAIS DE ATENDIMENTO |

## Scripts - Uso de APIs por agrupamento

Os scripts SQL fornecidos nessa seção devem ser operados no
**banco de dados do OOB-Status** e devem ser utilizados de acordo com o intervalo de
datas desejadas.
Caso surja alguma dúvida da formatação dos
parâmetros de entrada, verificar seção [Parâmetros de Entrada](#parâmetros-de-entrada).

### Quantidade de chamadas do grupo de APIs

```sql
@set initial_date = '<data_inicial>'
@set final_date = '<data_final>'
@set endpoints_services = array ['<services_urls>']

SELECT
  :initial_date as initial_date,
  :final_date as final_date,
  SUM(qty_requests) as qty_requests
FROM
  endpoint_metric epm on (edp.id = epm.id_endpoint)
LEFT JOIN "endpoint" edp
WHERE "date" BETWEEN :initial_date AND :final_date AND edp.endpoint_url = ANY(:endpoints_services);
```

### Disponibilidade média do grupo de APIs

```sql
@set initial_date = '<data_inicial>';
@set final_date = '<data_final>';
@set endpoints_services = array ['<services_urls>'];

SELECT
  :initial_date as initial_date,
  :final_date as final_date,
  ((86386 * (:final_date::date - :initial_date::date + 1)) - (sum (seconds_downtime))) / (86386 * (:final_date::date - :initial_date::date + 1))::decimal as perc_online
FROM
  daily_metric_endpoint dme
LEFT JOIN "endpoint" edp on dme.id_endpoint = edp.id
WHERE
  dme.metric_date BETWEEN :initial_date AND :final_date
  AND edp.endpoint_url = ANY(:endpoints_services);
```
