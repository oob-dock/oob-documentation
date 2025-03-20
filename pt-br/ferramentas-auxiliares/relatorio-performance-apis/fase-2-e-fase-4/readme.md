# Relatório de Performance das APIs da fase 2

A Opus está fornecendo alguns scripts SQL que ajudarão os clientes na hora da coleta
de dados para criação do relatório de performance das APIs do
Open Finance Brasil **OFB**.

**OBS:** fica a cargo de nossos clientes
rodar os scripts e formatar as informações da forma e no período exigido pelo OFB.

## Scripts - Metricas Transmissor

**Importante:** Os scripts SQL fornecidos nessa seção devem ser
operados no **banco de dados do OOB-Status**.

É necessário criar a função *api_metrics* executando o seguinte [script](attachments/api_metrics.sql).
Para obter os dados, execute função com o seguinte comando:

```sql
SELECT * FROM api_metrics('<data_inicio>','<data_fim>');
```

Sendo que os parâmetros devem ser preenchidos no formato yyyy-MM-dd, por exemplo:

```sql
SELECT * FROM api_metrics('2023-01-02','2023-01-08');
```

Essa função será responsável pelo retorno da maior parte dos dados necessários para o preenchimento do relatório, com
exceção do campo *Tempo médio de resposta* que deverá utilizar a consulta a seguir.

### Tempo médio de resposta - Percentil 95

**Importante:** Os scripts SQL fornecidos nessa seção devem ser
operados no **banco de dados do serviço de PCM**.

É necessário criar a função *percentile_p95* executando o seguinte [script](attachments/percentile_p95.sql).
Para obter os dados, execute função com o seguinte comando:

```sql
SELECT * FROM percentile_p95('<data_inicio>','<data_fim>');
```

Sendo que os parâmetros devem ser preenchidos no formato yyyy-MM-dd, por exemplo:

```sql
SELECT * FROM percentile_p95('2023-01-02','2023-01-08');
```

**OBS:**: Para montar o relatório final, será necessário agrupar os resultados de ambas as consultas com base no
dia, metódo e *endpoint* retornados pelas duas consultas.

## Execução de relatórios com consolidação de dados por organização

Caso a organização possua duas ou mais marcas, para as consultas que devem ser realizadas na base de dados do serviço **OOB-Status** é necessário utilizar os scrips com prefixo "organization_", nas quais além dos parâmetros originais (data de início e/ou data final), é preciso informar uma string de conexão para que a comunicação com as bases das outras marcas seja realizada.
Para tal, é necessário que o componente "dblink" seja instalado nas bases principais, por meio do comando:

```sql
CREATE EXTENSION IF NOT EXISTS "dblink";
```

a string de conexão deve ser formatada da seguinte maneira:

host={db_target_host} dbname={db_target_dbname} user={db_target_user} password={db_target_password}