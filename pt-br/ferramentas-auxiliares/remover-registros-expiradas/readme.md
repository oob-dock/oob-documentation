# Expurgo de dados da base de dados

A Opus disponibiliza um script para a remoção de registros expirados
ou obsoletos no banco de dados do Authorization Server, garantindo 
a manutenção da integridade e eficiência do sistema.

**Importante**: A execução do script pode impactar o desempenho do
banco de dados. Portanto, recomenda-se que sua execução ocorra
fora dos períodos de alta demanda do sistema.

## Authorization Server

### Script - Expurgo dos dados expirados

Para realizar a remoção dos registros expirados, é necessário criar
a stored procedure *as_delete_expired_records* executando o seguinte
[script](attachments/as_delete_expired_records.sql).

Após a criação da procedure, a remoção dos dados pode ser iniciada
com o seguinte comando SQL:

```sql  
call as_delete_expired_records();
```

**Importante**: A execução do script não libera o espaço em disco,
pois o PostgreSQL mantém os registros nas tabelas.

**Importante**: É recomendado verificar se a execução automática do
comando *VACUUM* está habilitada no banco de dados para garantir a
otimização do armazenamento.