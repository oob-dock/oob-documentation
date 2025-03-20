# Relatório de Liquidação, Rejeição e Cancelamento da Fase 3

A Opus está fornecendo alguns scripts SQL que ajudarão os
clientes na hora da coleta de dados para criação do relatório
de pagamentos do Open Finance Brasil **OFB**.

**OBS:** fica a cargo de nossos clientes
rodar os scripts e formatar as informações da forma e no período exigido pelo OFB.

## Scripts - Aba LiquidacaoCancelamentoRejeicao

É necessário criar a função *payment_ascs_rjct_canc*
executando o seguinte [script](attachments/payment_ascs_rjct_canc.sql).

Para obter os dados, execute função com o seguinte comando:

```sql
SELECT * FROM payment_ascs_rjct_canc('<data_inicio>','<data_fim>');
```

Os parâmetros de data devem ser preenchidos no formato yyyy-MM-dd,
por exemplo:

```sql
SELECT * FROM payment_ascs_rjct_canc('2024-11-04','2024-11-10');
```

## Scripts - Aba Rejeicao_por_motivo

É necessário criar a função *payment_rjct_reason*
executando o seguinte [script](attachments/payment_rjct_reason.sql).

Para obter os dados, execute função com o seguinte comando:

```sql
SELECT * FROM payment_rjct_reason('<data_inicio>','<data_fim>');
```

Os parâmetros de data devem ser preenchidos no formato yyyy-MM-dd,
por exemplo:

```sql
SELECT * FROM payment_rjct_reason('2024-11-04','2024-11-10');
```

## Execução de relatórios com consolidação de dados por organização

Caso a organização possua duas ou mais marcas, para as consultas que devem ser realizadas na base de dados do serviço **OOB-Consent** é necessário utilizar os scrips com prefixo "organization_", nas quais além dos parâmetros originais (data de início e/ou data final), é preciso informar uma string de conexão para que a comunicação com as bases das outras marcas seja realizada.
Para tal, é necessário que o componente "dblink" seja instalado nas bases principais, por meio do comando:

```sql
CREATE EXTENSION IF NOT EXISTS "dblink";
```

a string de conexão deve ser formatada da seguinte maneira:

host={db_target_host} dbname={db_target_dbname} user={db_target_user} password={db_target_password}