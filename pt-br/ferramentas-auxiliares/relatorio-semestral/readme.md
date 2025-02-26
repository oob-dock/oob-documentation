# Scripts SQL - Relatório semestral

- [Introdução](#introdução)
- [Parâmetros de entrada](#parâmetros-de-entrada)
  - [Período dos dados](#período-dos-dados)
  - [Serviços desejados](#lista-dos-serviços-desejados)
- [Scripts - Chamadas de APIs](#scripts---chamadas-de-apis)
  - [Quantidade de chamadas de API - Primeiro semestre](#quantidade-de-chamadas-de-api---extração-de-dados-do-primeiro-semestre)
  - [Quantidade de chamadas de API - Segundo semestre](#quantidade-de-chamadas-de-api---extração-de-dados-do-segundo-semestre)
  - [Disponibilidade média - Primeiro semestre](#disponibilidade-média---extração-de-dados-do-primeiro-semestre)
  - [Disponibilidade média - Segundo semestre](#disponibilidade-média---extração-de-dados-do-segundo-semestre)

## Introdução

A Opus está fornecendo alguns scripts SQL que ajudarão os clientes na hora da coleta
de dados para a elaboração do relatório semestral exigido pelo
Open Finance Brasil **OFB**.

As informações que poderão ser obtidas com eles são:

- a quantidade de chamadas de API em cada mês, para cada endpoint
- a disponibilidade média no período

**OBS:** fica a cargo de nossos clientes
rodar os scripts e formatar as informações da forma e no período exigido pelo OFB.

## Parâmetros de entrada

Antes de utilizar os scripts SQL fornecidos pela Opus, deve-se alterar os campos
'<data_inicial>', '<data_final>' e '<service_1_url>'
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

Exemplo de uso para quantidade de chamadas:

```sql
@set initial_date = '2022-01-01 00:00:00.000 -0300'
@set final_date = '2022-06-30 23:59:59.999 -0300'
```

Exemplo de uso para disponibilidade média:

```sql
@set initial_date = '2022-01-01'
@set final_date = '2022-06-30'
```

### Lista dos serviços desejados

O parâmetro 'endpoints_services' é um parâmetro do tipo array[string], sendo necessário
alterar o campo '<service_1_url>' por todas as URLs dos serviços disponibilizados
pela entidade parceira.

Exemplo para obtenção dos serviços da fase 1 - Dados Abertos:

```sql
--ATÉ O PRIMEIRO SEMESTRE DE 2024
@set endpoints_services = array ['/products-services/v1/personal-accounts', '/products-services/v1/business-accounts', '/products-services/v1/personal-loans', '/products-services/v1/business-loans', '/products-services/v1/personal-financings', '/products-services/v1/business-financings', '/products-services/v1/personal-invoice-financings', '/products-services/v1/business-invoice-financings', '/products-services/v1/personal-credit-cards', '/products-services/v1/business-credit-cards', '/products-services/v1/personal-unarranged-account-overdraft', '/products-services/v1/business-unarranged-account-overdraft', '/channels/v1/branches', '/channels/v1/electronic-channels', '/channels/v1/phone-channels', '/channels/v1/banking-agents', '/channels/v1/shared-automated-teller-machines', '/channels/v2/banking-agents', '/channels/v2/branches', '/channels/v2/electronic-channels', '/channels/v2/phone-channels', '/channels/v2/shared-automated-teller-machines', '/opendata-accounts/v1/business-accounts', '/opendata-accounts/v1/personal-accounts', '/opendata-creditcards/v1/business-credit-cards', '/opendata-creditcards/v1/personal-credit-cards', '/opendata-financings/v1/business-financings', '/opendata-financings/v1/personal-financings', '/opendata-invoicefinancings/v1/business-invoice-financings', '/opendata-invoicefinancings/v1/personal-invoice-financings', '/opendata-loans/v1/business-loans', '/opendata-loans/v1/personal-loans', '/opendata-unarranged/v1/business-unarranged-account-overdraft', '/opendata-unarranged/v1/personal-unarranged-account-overdraft']

--À PARTIR DO SEGUNDO SEMESTRE DE 2024
@set endpoints_services = array ['/channels/v2/banking-agents', '/channels/v2/branches', '/channels/v2/electronic-channels', '/channels/v2/phone-channels', '/channels/v2/shared-automated-teller-machines', '/opendata-accounts/v1/business-accounts', '/opendata-accounts/v1/personal-accounts', '/opendata-creditcards/v1/business-credit-cards', '/opendata-creditcards/v1/personal-credit-cards', '/opendata-financings/v1/business-financings', '/opendata-financings/v1/personal-financings', '/opendata-invoicefinancings/v1/business-invoice-financings', '/opendata-invoicefinancings/v1/personal-invoice-financings', '/opendata-loans/v1/business-loans', '/opendata-loans/v1/personal-loans', '/opendata-unarranged/v1/business-unarranged-account-overdraft', '/opendata-unarranged/v1/personal-unarranged-account-overdraft']
```

Exemplo para obtenção dos serviços da fase 2 - Consentimento, Recursos e Dados Cadastrais:

```sql
@set endpoints_services = array ['/consents/v2/consents', '/consents/v2/consents/{consentId}','/resources/v2/resources', '/consents/v3/consents', '/consents/v3/consents/{consentId}','/resources/v3/resources', '/customers/v2/business/financial-relations','/customers/v2/business/identifications','/customers/v2/business/qualifications','/customers/v2/personal/financial-relations','/customers/v2/personal/identifications','/customers/v2/personal/qualifications']
```

Exemplo para obtenção dos serviços da fase 2 - Dados Transacionais:

```sql
@set endpoints_services = array ['/credit-cards-accounts/v2/accounts', '/credit-cards-accounts/v2/accounts/{creditCardAccountId}', '/credit-cards-accounts/v2/accounts/{creditCardAccountId}/limits', '/credit-cards-accounts/v2/accounts/{creditCardAccountId}/transactions', '/credit-cards-accounts/v2/accounts/{creditCardAccountId}/bills', '/credit-cards-accounts/v2/accounts/{creditCardAccountId}/bills/{billId}/transactions', '/credit-cards-accounts/v2/accounts/{creditCardAccountId}/transactions-current', '/accounts/v2/accounts', '/accounts/v2/accounts/{accountId}', '/accounts/v2/accounts/{accountId}/balances', '/accounts/v2/accounts/{accountId}/transactions', '/accounts/v2/accounts/{accountId}/transactions-current', '/accounts/v2/accounts/{accountId}/overdraft-limits', '/loans/v2/contracts', '/loans/v2/contracts/{contractId}', '/loans/v2/contracts/{contractId}/warranties', '/loans/v2/contracts/{contractId}/payments', '/loans/v2/contracts/{contractId}/scheduled-instalments', '/financings/v2/contracts', '/financings/v2/contracts/{contractId}', '/financings/v2/contracts/{contractId}/warranties', '/financings/v2/contracts/{contractId}/payments', '/financings/v2/contracts/{contractId}/scheduled-instalments', '/unarranged-accounts-overdraft/v2/contracts', '/unarranged-accounts-overdraft/v2/contracts/{contractId}', '/unarranged-accounts-overdraft/v2/contracts/{contractId}/warranties', '/unarranged-accounts-overdraft/v2/contracts/{contractId}/payments', '/unarranged-accounts-overdraft/v2/contracts/{contractId}/scheduled-instalments', '/invoice-financings/v2/contracts', '/invoice-financings/v2/contracts/{contractId}', '/invoice-financings/v2/contracts/{contractId}/warranties', '/invoice-financings/v2/contracts/{contractId}/payments', '/invoice-financings/v2/contracts/{contractId}/scheduled-instalments']
```

Exemplo para obtenção dos serviços da fase 3 - Detentora de conta:

```sql
@set endpoints_services = array ['/payments/v3/consents','/payments/v3/consents/{consentId}','/payments/v3/pix/payments','/payments/v3/pix/payments/{paymentId}','/payments/v4/consents','/payments/v4/consents/{consentId}','/payments/v4/pix/payments','/payments/v4/pix/payments/{paymentId}','/payments/v4/pix/payments/consents/{consentId}','/automatic-payments/v1/recurring-consents','/automatic-payments/v1/recurring-consents/{recurringConsentId}','/automatic-payments/v1/pix/recurring-payments','/automatic-payments/v1/pix/recurring-payments/{recurringPaymentId}']
```

Exemplo para obtenção dos serviços da fase 4A - Dados Abertos

```sql
@set endpoints_services = array ['/opendata-capitalization/v1/bonds', '/opendata-investments/v1/funds', '/opendata-investments/v1/bank-fixed-incomes', '/opendata-investments/v1/credit-fixed-incomes', '/opendata-investments/v1/variable-incomes', '/opendata-investments/v1/treasure-titles', '/opendata-exchange/v1/online-rates', '/opendata-exchange/v1/vet-values', '/opendata-acquiring-services/v1/personals', '/opendata-acquiring-services/v1/businesses', '/opendata-pension/v1/risk-coverages', '/opendata-pension/v1/survival-coverages', '/opendata-insurance/v1/personals', '/opendata-insurance/v1/automotives', '/opendata-insurance/v1/homes']
```

Exemplo para obtenção dos serviços da fase 4B - Investimentos:

```sql
@set endpoints_services = array ['/bank-fixed-incomes/v1/investments', '/bank-fixed-incomes/v1/investments/{investmentId}', '/bank-fixed-incomes/v1/investments/{investmentId}/balances', '/bank-fixed-incomes/v1/investments/{investmentId}/transactions', '/bank-fixed-incomes/v1/investments/{investmentId}/transactions-current', '/credit-fixed-incomes/v1/investments', '/credit-fixed-incomes/v1/investments/{investmentId}', '/credit-fixed-incomes/v1/investments/{investmentId}/balances', '/credit-fixed-incomes/v1/investments/{investmentId}/transactions', '/credit-fixed-incomes/v1/investments/{investmentId}/transactions-current', '/variable-incomes/v1/investments', '/variable-incomes/v1/investments/{investmentId}', '/variable-incomes/v1/investments/{investmentId}/balances', '/variable-incomes/v1/investments/{investmentId}/transactions', '/variable-incomes/v1/investments/{investmentId}/transactions-current', '/treasure-titles/v1/investments', '/treasure-titles/v1/investments/{investmentId}', '/treasure-titles/v1/investments/{investmentId}/balances', '/treasure-titles/v1/investments/{investmentId}/transactions', '/treasure-titles/v1/investments/{investmentId}/transactions-current', '/funds/v1/investments', '/funds/v1/investments/{investmentId}', '/funds/v1/investments/{investmentId}/balances', '/funds/v1/investments/{investmentId}/transactions', '/funds/v1/investments/{investmentId}/transactions-current']
```

Exemplo para obtenção dos serviços da fase 4B - Câmbio:

```sql
@set endpoints_services = array ['/exchanges/v1/operations', '/exchanges/v1/operations/{operationId}', '/exchanges/v1/operations/{operationId}/events']
```

Logo abaixo são apresentadas tabelas com todos os endpoints divididos em subgrupos
a fim de facilitar a listagem das URLs dos serviços disponibilizados.

Endpoints - Fase 1 Dados Abertos

| Endpoint                                                      | Categoria                        |
| ------------------------------------------------------------- | -------------------------------- |
| /channels/v2/banking-agents                                   | CANAIS DE ATENDIMENTO            |
| /channels/v2/branches                                         | CANAIS DE ATENDIMENTO            |
| /channels/v2/electronic-channels                              | CANAIS DE ATENDIMENTO            |
| /channels/v2/phone-channels                                   | CANAIS DE ATENDIMENTO            |
| /channels/v2/shared-automated-teller-machines                 | CANAIS DE ATENDIMENTO            |
| /opendata-accounts/v1/business-accounts                       | CONTAS                           |
| /opendata-accounts/v1/personal-accounts                       | CONTAS                           |
| /opendata-creditcards/v1/business-credit-cards                | CARTÃO DE CRÉDITO                |
| /opendata-creditcards/v1/personal-credit-cards                | CARTÃO DE CRÉDITO                |
| /opendata-financings/v1/business-financings                   | FINANCIAMENTO                    |
| /opendata-financings/v1/personal-financings                   | FINANCIAMENTO                    |
| /opendata-invoicefinancings/v1/business-invoice-financings    | DIREITOS CREDITÓRIOS DESCONTADOS |
| /opendata-invoicefinancings/v1/personal-invoice-financings    | DIREITOS CREDITÓRIOS DESCONTADOS |
| /opendata-loans/v1/business-loans                             | EMPRÉSTIMO                       |
| /opendata-loans/v1/personal-loans                             | EMPRÉSTIMO                       |
| /opendata-unarranged/v1/business-unarranged-account-overdraft | ADIANTAMENTO A DEPOSITANTES      |
| /opendata-unarranged/v1/personal-unarranged-account-overdraft | ADIANTAMENTO A DEPOSITANTES      |

Endpoints - Fase 2 Consentimento e Dados Cadastrais:

| Endpoint                                   | Categoria                         |
| ------------------------------------------ | --------------------------------- |
| /consents/v2/consents                      | CONSENTIMENTO DE COMPARTILHAMENTO |
| /consents/v2/consents/\{consentId\}        | CONSENTIMENTO DE COMPARTILHAMENTO |
| /consents/v3/consents                      | CONSENTIMENTO DE COMPARTILHAMENTO |
| /consents/v3/consents/\{consentId\}        | CONSENTIMENTO DE COMPARTILHAMENTO |
| /customers/v2/personal/identifications     | DADOS CADASTRAIS                  |
| /customers/v2/business/identifications     | DADOS CADASTRAIS                  |
| /customers/v2/personal/qualifications      | DADOS CADASTRAIS                  |
| /customers/v2/business/qualifications      | DADOS CADASTRAIS                  |
| /customers/v2/personal/financial-relations | DADOS CADASTRAIS                  |
| /customers/v2/business/financial-relations | DADOS CADASTRAIS                  |
| /resources/v2/resources                    | RECURSOS                          |
| /resources/v3/resources                    | RECURSOS                          |

Endpoints - Fase 2 Dados Transacionais

| Endpoint                                                                                 | Categoria            |
| ---------------------------------------------------------------------------------------- | -------------------- |
| /credit-cards-accounts/v2/accounts                                                       | CARTÕES DE CRÉDITO   |
| /credit-cards-accounts/v2/accounts/\{creditCardAccountId\}                               | CARTÕES DE CRÉDITO   |
| /credit-cards-accounts/v2/accounts/\{creditCardAccountId\}/limits                        | CARTÕES DE CRÉDITO   |
| /credit-cards-accounts/v2/accounts/\{creditCardAccountId\}/transactions                  | CARTÕES DE CRÉDITO   |
| /credit-cards-accounts/v2/accounts/\{creditCardAccountId\}/bills                         | CARTÕES DE CRÉDITO   |
| /credit-cards-accounts/v2/accounts/\{creditCardAccountId\}/bills/\{billId\}/transactions | CARTÕES DE CRÉDITO   |
| /credit-cards-accounts/v2/accounts/\{creditCardAccountId\}/transactions-current          | CARTÕES DE CRÉDITO   |
| /accounts/v2/accounts                                                                    | CONTAS               |
| /accounts/v2/accounts/\{accountId\}                                                      | CONTAS               |
| /accounts/v2/accounts/\{accountId\}/balances                                             | CONTAS               |
| /accounts/v2/accounts/\{accountId\}/transactions                                         | CONTAS               |
| /accounts/v2/accounts/\{accountId\}/transactions-current                                 | CONTAS               |
| /accounts/v2/accounts/\{accountId\}/overdraft-limits                                     | CONTAS               |
| /loans/v2/contracts                                                                      | EMPRÉSTIMOS          |
| /loans/v2/contracts/\{contractId\}                                                       | EMPRÉSTIMOS          |
| /loans/v2/contracts/\{contractId\}/warranties                                            | EMPRÉSTIMOS          |
| /loans/v2/contracts/\{contractId\}/payments                                              | EMPRÉSTIMOS          |
| /loans/v2/contracts/\{contractId\}/scheduled-instalments                                 | EMPRÉSTIMOS          |
| /financings/v2/contracts                                                                 | FINANCIAMENTOS       |
| /financings/v2/contracts/\{contractId\}                                                  | FINANCIAMENTOS       |
| /financings/v2/contracts/\{contractId\}/warranties                                       | FINANCIAMENTOS       |
| /financings/v2/contracts/\{contractId\}/payments                                         | FINANCIAMENTOS       |
| /financings/v2/contracts/\{contractId\}/scheduled-instalments                            | FINANCIAMENTOS       |
| /unarranged-accounts-overdraft/v2/contracts                                              | ADIANTAMENTOS        |
| /unarranged-accounts-overdraft/v2/contracts/\{contractId\}                               | ADIANTAMENTOS        |
| /unarranged-accounts-overdraft/v2/contracts/\{contractId\}/warranties                    | ADIANTAMENTOS        |
| /unarranged-accounts-overdraft/v2/contracts/\{contractId\}/payments                      | ADIANTAMENTOS        |
| /unarranged-accounts-overdraft/v2/contracts/\{contractId\}/scheduled-instalments         | ADIANTAMENTOS        |
| /invoice-financings/v2/contracts                                                         | DIREITOS CREDITÓRIOS |
| /invoice-financings/v2/contracts/\{contractId\}                                          | DIREITOS CREDITÓRIOS |
| /invoice-financings/v2/contracts/\{contractId\}/warranties                               | DIREITOS CREDITÓRIOS |
| /invoice-financings/v2/contracts/\{contractId\}/payments                                 | DIREITOS CREDITÓRIOS |
| /invoice-financings/v2/contracts/\{contractId\}/scheduled-instalments                    | DIREITOS CREDITÓRIOS |

Endpoints - Fase 3 Detentora de conta

| Endpoint                                                            | Categoria                   |
| ------------------------------------------------------------------- | --------------------------- |
| /payments/v3/consents                                               | CONSENTIMENTO DE PAGAMENTO  |
| /payments/v3/consents/\{consentId\}                                 | CONSENTIMENTO DE PAGAMENTO  |
| /payments/v4/consents                                               | CONSENTIMENTO DE PAGAMENTO  |
| /payments/v4/consents/\{consentId\}                                 | CONSENTIMENTO DE PAGAMENTO  |
| /automatic-payments/v1/recurring-consents                           | CONSENTIMENTO DE PAGAMENTO  |
| /automatic-payments/v1/recurring-consents/{recurringConsentId}      | CONSENTIMENTO DE PAGAMENTO  |
| /payments/v3/pix/payments                                           | PAGAMENTO PIX               |
| /payments/v3/pix/payments/\{paymentId\}                             | PAGAMENTO PIX               |
| /payments/v4/pix/payments                                           | PAGAMENTO PIX               |
| /payments/v4/pix/payments/\{paymentId\}                             | PAGAMENTO PIX               |
| /payments/v4/pix/payments/consents/{consentId}                      | PAGAMENTO PIX               |
| /automatic-payments/v1/pix/recurring-payments                       | PAGAMENTO PIX               |
| /automatic-payments/v1/pix/recurring-payments/{recurringPaymentId}  | PAGAMENTO PIX               |
 
Endpoints - Fase 4A Dados Abertos

| Endpoint                                      | Categoria                |
| --------------------------------------------- | ------------------------ |
| /opendata-capitalization/v1/bonds             | TÍTULOS DE CAPITALIZAÇÃO |
| /opendata-investments/v1/funds                | INVESTIMENTOS            |
| /opendata-investments/v1/bank-fixed-incomes   | INVESTIMENTOS            |
| /opendata-investments/v1/credit-fixed-incomes | INVESTIMENTOS            |
| /opendata-investments/v1/variable-incomes     | INVESTIMENTOS            |
| /opendata-investments/v1/treasure-titles      | INVESTIMENTOS            |
| /opendata-exchange/v1/online-rates            | CÂMBIO                   |
| /opendata-exchange/v1/vet-values              | CÂMBIO                   |
| /opendata-acquiring-services/v1/personals     | CREDENCIAMENTO           |
| /opendata-acquiring-services/v1/businesses    | CREDENCIAMENTO           |
| /opendata-pension/v1/risk-coverages           | PREVIDÊNCIA              |
| /opendata-pension/v1/survival-coverages       | PREVIDÊNCIA              |
| /opendata-insurance/v1/personals              | SEGUROS                  |
| /opendata-insurance/v1/automotives            | SEGUROS                  |            
| /opendata-insurance/v1/homes                  | SEGUROS                  |      

Endpoints - Fase 4B Investimentos

| Endpoint                                                                   | Categoria                 |
| -------------------------------------------------------------------------- | ------------------------- |
| /bank-fixed-incomes/v1/investments                                         | RENDA FIXA BANCÁRIA       |
| /bank-fixed-incomes/v1/investments/\{investmentId\}                        | RENDA FIXA BANCÁRIA       |
| /bank-fixed-incomes/v1/investments/\{investmentId\}/balances               | RENDA FIXA BANCÁRIA       |
| /bank-fixed-incomes/v1/investments/\{investmentId\}/transactions           | RENDA FIXA BANCÁRIA       |
| /bank-fixed-incomes/v1/investments/\{investmentId\}/transactions-current   | RENDA FIXA BANCÁRIA       |
| /credit-fixed-incomes/v1/investments                                       | RENDA FIXA CRÉDITO        |
| /credit-fixed-incomes/v1/investments/\{investmentId\}                      | RENDA FIXA CRÉDITO        |
| /credit-fixed-incomes/v1/investments/\{investmentId\}/balances             | RENDA FIXA CRÉDITO        |
| /credit-fixed-incomes/v1/investments/\{investmentId\}/transactions         | RENDA FIXA CRÉDITO        |
| /credit-fixed-incomes/v1/investments/\{investmentId\}/transactions-current | RENDA FIXA CRÉDITO        |
| /variable-incomes/v1/investments                                           | RENDA VARIÁVEL            |
| /variable-incomes/v1/investments/\{investmentId\}                          | RENDA VARIÁVEL            |
| /variable-incomes/v1/investments/\{investmentId\}/balances                 | RENDA VARIÁVEL            |
| /variable-incomes/v1/investments/\{investmentId\}/transactions             | RENDA VARIÁVEL            |
| /variable-incomes/v1/investments/\{investmentId\}/transactions-current     | RENDA VARIÁVEL            |
| /variable-incomes/v1/broker-notes/\{brokerNoteId\}                         | RENDA VARIÁVEL            |
| /treasure-titles/v1/investments                                            | TÍTULOS DO TESOURO DIRETO |
| /treasure-titles/v1/investments/\{investmentId\}                           | TÍTULOS DO TESOURO DIRETO |
| /treasure-titles/v1/investments/\{investmentId\}/balances                  | TÍTULOS DO TESOURO DIRETO |
| /treasure-titles/v1/investments/\{investmentId\}/transactions              | TÍTULOS DO TESOURO DIRETO |
| /treasure-titles/v1/investments/\{investmentId\}/transactions-current      | TÍTULOS DO TESOURO DIRETO |
| /funds/v1/investments                                                      | FUNDOS DE INVESTIMENTO    |
| /funds/v1/investments/\{investmentId\}                                     | FUNDOS DE INVESTIMENTO    |
| /funds/v1/investments/\{investmentId\}/balances                            | FUNDOS DE INVESTIMENTO    |
| /funds/v1/investments/\{investmentId\}/transactions                        | FUNDOS DE INVESTIMENTO    |
| /funds/v1/investments/\{investmentId\}/transactions-current                | FUNDOS DE INVESTIMENTO    |

Endpoints - Fase 4B Câmbio

| Endpoint                                        | Categoria |
| ----------------------------------------------- | --------- |
| /exchanges/v1/operations                        | CÂMBIO    |
| /exchanges/v1/operations/\{operationId\}        | CÂMBIO    |
| /exchanges/v1/operations/\{operationId\}/events | CÂMBIO    |

## Scripts - Chamadas de APIs

Os scripts SQL fornecidos nessa seção devem ser operados no
**banco de dados do OOB-Status** e devem ser utilizados de acordo com o período
(primeiro ou segundo semestre) e o tipo de informação desejada (quantidade de
chamadas e disponibilidade média). Caso surja alguma dúvida da formatação dos
parâmetros de entrada, verificar seção [Parâmetros de Entrada](#parâmetros-de-entrada).

### Quantidade de chamadas de API - Extração de dados do primeiro semestre

```sql
@set initial_date = '<data_inicial> 00:00:00.000 -0300'
@set final_date = '<data_final> 23:59:59.999 -0300'
@set endpoints_services = array ['<service_1_url>']

SELECT
    tab.metodo AS "Método",
    tab.url AS "Url",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '01'),0) AS "Janeiro",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '02'),0) AS "Fevereiro",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '03'),0) AS "Março",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '04'),0) AS "Abril",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '05'),0) AS "Maio",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '06'),0) AS "Junho"
FROM 
(SELECT edp.endpoint_url AS url , edp.endpoint_name, substring(edp.endpoint_name, 'GET|POST|PATCH|DELETE') AS metodo, date_trunc('month',"date") AS "date", sum(qty_requests) AS qty
FROM public.endpoint_metric epm
LEFT JOIN public.endpoint edp 
on (epm.id_endpoint = edp.id)
WHERE "date" BETWEEN :initial_date AND :final_date AND edp.endpoint_url = ANY(:endpoints_services)
GROUP BY edp.endpoint_url, edp.endpoint_name, metodo, date_trunc('month',"date")) AS tab
GROUP BY tab.url, tab.metodo, tab.endpoint_name
ORDER BY tab.url, tab.metodo;
```

### Quantidade de chamadas de API - Extração de dados do segundo semestre

```sql
@set initial_date = '<data_inicial> 00:00:00.000 -0300'
@set final_date = '<data_final> 23:59:59.999 -0300'
@set endpoints_services = array ['<service_1_url>']

SELECT
    tab.metodo AS "Método",
    tab.url AS "Url",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '07'),0) AS "Julho",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '08'),0) AS "Agosto",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '09'),0) AS "Setembro",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '10'),0) AS "Outubro",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '11'),0) AS "Novembro",
    coalesce(SUM(tab.qty) FILTER (WHERE date_part('month', tab."date") = '12'),0) AS "Dezembro"
FROM 
(SELECT edp.endpoint_url AS url , edp.endpoint_name, substring(edp.endpoint_name, 'GET|POST|PATCH|DELETE') AS metodo, date_trunc('month',"date") AS "date", sum(qty_requests) AS qty
FROM public.endpoint_metric epm
LEFT JOIN public.endpoint edp 
on (epm.id_endpoint = edp.id)
WHERE "date" BETWEEN :initial_date AND :final_date AND edp.endpoint_url = ANY(:endpoints_services)
GROUP BY edp.endpoint_url, edp.endpoint_name, metodo, date_trunc('month',"date")) AS tab
GROUP BY tab.url, tab.metodo, tab.endpoint_name
ORDER BY tab.url, tab.metodo;
```

### Disponibilidade média - Extração de dados do primeiro semestre

```sql
@set initial_date = '<data_inicial>'
@set final_date = '<data_final>'
@set endpoints_services = array ['<service_1_url>']
WITH
result_tab AS (
  WITH
  month_totaltime_table AS (
    WITH days_table AS (
      SELECT date_trunc('day', dd):: date AS metric_date, 86386 AS daily_seconds
      FROM generate_series
            ( :initial_date::timestamp 
            , :final_date::timestamp
            , '1 day'::interval) dd
    )
    SELECT
    to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AS year,
    to_char(days_table.metric_date, 'Mon') AS month,
    sum (days_table.daily_seconds) AS total_time
    FROM days_table
    GROUP BY month
  ),
  month_downtime_table AS (
    WITH month_downtime_table AS (
      SELECT 
      to_char(daily_metric_endpoint.metric_date, 'YYYY') AS year,
      to_char(daily_metric_endpoint.metric_date, 'Mon') AS month,
      endpoint.id,
      sum (seconds_downtime) AS seconds_downtime
      FROM endpoint
      FULL OUTER JOIN daily_metric_endpoint on daily_metric_endpoint.id_endpoint = endpoint.id
      WHERE daily_metric_endpoint.metric_date BETWEEN :initial_date AND :final_date
      GROUP BY id, year, month
    )
    SELECT coalesce (year, to_char(to_date(:initial_date, 'YYYY'), 'YYYY')) AS year, coalesce(month, to_char(to_date(:initial_date, 'YYYY-MM-DD'), 'Mon')) AS month, endpoint.id AS id_endpoint, seconds_downtime FROM month_downtime_table
    FULL OUTER JOIN endpoint on month_downtime_table.id = endpoint.id
    WHERE endpoint_url = ANY(:endpoints_services)
  )
  SELECT
  month_downtime_table.year,
  month_downtime_table.month,
  (SELECT sum(total_time) AS total FROM month_totaltime_table) AS total_period,
  month_totaltime_table.total_time,
  month_downtime_table.seconds_downtime,
  endpoint.endpoint_url,
  substring(endpoint.endpoint_name, 'GET|POST|PATCH|DELETE') AS metodo,
  ((month_totaltime_table.total_time - month_downtime_table.seconds_downtime)/month_totaltime_table.total_time::float) AS perc_online
  FROM month_downtime_table
  INNER JOIN endpoint on endpoint.id = month_downtime_table.id_endpoint
  FULL OUTER JOIN month_totaltime_table on month_totaltime_table.month = month_downtime_table.month AND month_totaltime_table.year = month_downtime_table.year
  ORDER BY year, month
)
SELECT
year AS "Ano",
endpoint_url AS "url",
metodo AS "Método",
trunc(coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Jan')*100,100)::decimal, 2) AS "Janeiro",
trunc(coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Feb')*100,100)::decimal, 2) AS "Fevereiro",
trunc(coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Mar')*100,100)::decimal, 2) AS "Março",
trunc(coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Apr')*100,100)::decimal, 2) AS "Abril",
trunc(coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='May')*100,100)::decimal, 2) AS "Maio",
trunc(coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Jun')*100,100)::decimal, 2) AS "Junho",
trunc(coalesce (1 - sum(seconds_downtime)/max(total_period) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY')),1)*100::decimal, 2) AS "Média período"
FROM result_tab
GROUP BY year,endpoint_url,metodo
having num_nulls(min(year) FILTER (WHERE year = to_char(to_date(:initial_date, 'YYYY'), 'YYYY'))) = 0
```

### Disponibilidade média - Extração de dados do segundo semestre

```sql
@set initial_date = '<data_inicial>'
@set final_date = '<data_final>'
@set endpoints_services = array ['<service_1_url>']
with
result_tab AS (
  with
month_totaltime_table AS (
    WITH days_table AS (
      SELECT date_trunc('day', dd):: date AS metric_date, 86386 AS daily_seconds
      FROM generate_series
            ( :initial_date::timestamp 
            , :final_date::timestamp
            , '1 day'::interval) dd
    )
    SELECT
    to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AS year,
    to_char(days_table.metric_date, 'Mon') AS month,
    sum (days_table.daily_seconds) AS total_time
    FROM days_table
    GROUP BY month
  ),
  month_downtime_table AS (
    WITH month_downtime_table AS (
      SELECT 
      to_char(daily_metric_endpoint.metric_date, 'YYYY') AS year,
      to_char(daily_metric_endpoint.metric_date, 'Mon') AS month,
      endpoint.id,
      sum (seconds_downtime) AS seconds_downtime
      FROM endpoint
      FULL OUTER JOIN daily_metric_endpoint on daily_metric_endpoint.id_endpoint = endpoint.id
      WHERE daily_metric_endpoint.metric_date BETWEEN :initial_date AND :final_date
      GROUP BY id, year, month
    )
    SELECT coalesce (year, to_char(to_date(:initial_date, 'YYYY'), 'YYYY')) AS year, coalesce(month, to_char(to_date(:initial_date, 'YYYY-MM-DD'), 'Mon')) AS month, endpoint.id AS id_endpoint, seconds_downtime FROM month_downtime_table
    FULL OUTER JOIN endpoint on month_downtime_table.id = endpoint.id
    WHERE endpoint_url = ANY(:endpoints_services)
  )
  SELECT
  month_downtime_table.year,
  month_downtime_table.month,
  (SELECT sum(total_time) AS total FROM month_totaltime_table) AS total_period,
  month_totaltime_table.total_time,
  month_downtime_table.seconds_downtime,
  endpoint.endpoint_url,
  substring(endpoint.endpoint_name, 'GET|POST|PATCH|DELETE') AS metodo,
  ((month_totaltime_table.total_time - month_downtime_table.seconds_downtime)/month_totaltime_table.total_time::float) AS perc_online
  FROM month_downtime_table
 INNER JOIN endpoint on endpoint.id = month_downtime_table.id_endpoint
  FULL OUTER JOIN month_totaltime_table on month_totaltime_table.month = month_downtime_table.month AND month_totaltime_table.year = month_downtime_table.year
  ORDER BY year, month
)
SELECT
year AS "Ano",
endpoint_url AS "url",
metodo AS "Método",
trunc(coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Jul')*100, 100)::decimal, 2) AS "Julho",
trunc(coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Aug')*100, 100)::decimal, 2) AS "Agosto",
trunc(coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Sep')*100, 100)::decimal, 2) AS "Setembro",
trunc(coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Oct')*100, 100)::decimal, 2) AS "Outubro",
trunc(coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Nov')*100, 100)::decimal, 2) AS "Novembro",
trunc(coalesce (min(perc_online) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY') AND month='Dec')*100, 100)::decimal, 2) AS "Dezembro",
trunc(coalesce (1 - sum(seconds_downtime)/max(total_period) FILTER (WHERE year=to_char(to_date(:initial_date, 'YYYY'), 'YYYY')), 1)*100::decimal, 2) AS "Média período"
FROM result_tab
GROUP BY year,endpoint_url,metodo
having num_nulls(min(year) FILTER (WHERE year = to_char(to_date(:initial_date, 'YYYY'), 'YYYY'))) = 0
```
