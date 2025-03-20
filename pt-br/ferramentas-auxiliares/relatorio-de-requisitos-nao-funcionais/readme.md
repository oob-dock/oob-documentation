# Relatório de requisitos não funcionais

A Opus está fornecendo alguns scripts SQL que ajudarão os clientes na hora da coleta
de dados para criação do relatório de requisitos não funcionais do
Open Finance Brasil **OFB**.

**OBS:** fica a cargo de nossos clientes
rodar os scripts e formatar as informações da forma e no período exigido pelo OFB.

## Fase 3

### Scripts - Tempo de resposta

**Importante**: O script SQL fornecido nessa seção deve ser executado no banco de
dados do serviço de coleta de métricas para **PCM**.

É necessário criar a função payments_response_time executando o seguinte script [script](attachments/payments_response_time.sql).

Para obter os dados, execute função com o seguinte comando:

```sql
SELECT * FROM payments_response_time('<data_fim>');
```

Sendo que o parâmetro *data_fim* se refere a sexta-feira anterior a emissão do relatório
no formato yyyy-MM-dd, por exemplo:

```sql
select * from payments_response_time('2023-08-18');
```

**Importante**: Para emissão do relatório deve-se desconsiderar o campo *data_metrica*,
enviado apenas para referência.

**Observação**: O cálculo considera a diferença de tempo entre a chegada da
requisição e a resposta na camada do gateway fornecido pela Opus Open Finance -
o Kong. São consideradas apenas as chamadas respondidas com HTTP Code diferente
de 423, 429 e 529.

## Scripts - Disponibilidade

**Importante**: O script SQL fornecido nessa seção deve ser executado no banco de
dados do serviço *OOB-Status*.

É necessário criar a função status_function_availability executando o seguinte script
[script](attachments/status_function_availability.sql).

Para obter os dados, execute função com o seguinte comando:

```sql
SELECT * FROM status_function_availability('<data_fim>');
```

Sendo que o parâmetro *data_fim* se refere a sexta-feira anterior a emissão do relatório
no formato yyyy-MM-dd, por exemplo:

```sql
select * from status_function_availability('2023-08-18');
```

**Observação**: O cálculo de disponibilidade leva em consideração os intervalos
de segundos de instabilidade do serviço, considerando retornos de erro no servidor
(HTTP Code 5XX) e o health check do serviço. As fórmulas utilizadas são:

- Últimos três meses (90 dias):

```text
777600 - <total de indisponibilidade em segundos> / 777600
```

- Diário:

```text
86400 - <total de indisponibilidade em segundos> / 86400
```

## Execução de relatórios com consolidação de dados por organização

Caso a organização possua duas ou mais marcas, para as consultas que devem ser realizadas na base de dados do serviço **OOB-Status** é necessário utilizar os scrips com prefixo "organization_", nas quais além dos parâmetros originais (data de início e/ou data final), é preciso informar uma string de conexão para que a comunicação com as bases das outras marcas seja realizada.
Para tal, é necessário que o componente "dblink" seja instalado nas bases principais, por meio do comando:

```sql
CREATE EXTENSION IF NOT EXISTS "dblink";
```

a string de conexão deve ser formatada da seguinte maneira:

host={db_target_host} dbname={db_target_dbname} user={db_target_user} password={db_target_password}