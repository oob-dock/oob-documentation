# Relatório de Interoperabilidade da fase 3

A Opus está fornecendo alguns scripts SQL que ajudarão os clientes na hora da coleta
de dados para criação do relatório de interoperabilidade do
Open Finance Brasil **OFB**.

**OBS:** fica a cargo de nossos clientes
rodar os scripts e formatar as informações da forma e no período exigido pelo OFB.

## Scripts - Funil Detentor

### Funil Detentor - Consentimentos Gerados

**Importante:** Os scripts SQL fornecidos nessa seção devem ser
operados no **banco de dados do OOB-Consent**.

É necessário criar a função *payment_consent_count* executando o seguinte [script](attachments/payment_consent_function_count.sql).

Para obter os dados, execute função com o seguinte comando:

```sql
SELECT * FROM payment_consent_count('<data_inicio>','<data_fim>');
```

Sendo que os parâmetros devem ser preenchidos no formato yyyy-MM-dd, por exemplo:

```sql
SELECT * FROM payment_consent_count('2023-01-02','2023-01-08');
```

### Funil Detentor - Autenticação e redirecionamento

**Importante:** Os scripts SQL fornecidos nessa seção devem ser operados no
**banco de dados do OOB-Authorization-Server**

Na primeira execução deve-se criar a função *decode_base64url* executando o
seguinte [script](attachments/as_function_decode_base64url.sql).

Depois, deve-se criar a função *payment_consent_extract_authorization_data* executando
o seguinte [script](attachments/payment_consent_extract_authorization_data.sql).

Para obter os dados, execute a função usando o seguinte comando:

```sql
SELECT * FROM payment_consent_extract_authorization_data('<data_inicio>','<data_fim>');
```

Sendo que os parâmetros devem ser preenchidos no formato yyyy-MM-dd, por exemplo:

```sql
SELECT * FROM payment_consent_extract_authorization_data('2022-10-02','2022-10-08');
```

### Funil Detentor - Conclusão da autenticação e autorização do cliente

**Importante:** Os scripts SQL fornecidos nessa seção devem ser
operados no **banco de dados do OOB-Consent**.

Na primeira execução é necessário criar a função *payment_consent_client_authorization*
executando o seguinte [script](attachments/payment_consent_client_authorization.sql).

Para obter os dados, deve-se chamar a função usando o seguinte comando:

```sql
SELECT * FROM payment_consent_client_authorization('<data_inicio>','<data_fim>');
```

Sendo que os parâmetros devem ser preenchidos no formato yyyy-MM-dd, por exemplo:

```sql
SELECT * FROM payment_consent_client_authorization('2022-01-02','2022-10-08');
```

### Funil Detentor - Pagamentos recebidos e ids gerados

**Importante:** Os scripts SQL fornecidos nessa seção devem ser
operados no **banco de dados do OOB-Consent**.

Na primeira execução é necessário criar a função *payment_consent_payment_id*
executando o seguinte [script](attachments/payment_consent_payment_id.sql).

Para obter os dados, deve-se chamar a função usando o seguinte comando:

```sql
SELECT * FROM payment_consent_payment_id('<data_inicio>','<data_fim>');
```

Sendo que os parâmetros devem ser preenchidos no formato yyyy-MM-dd, por exemplo:

```sql
SELECT * FROM payment_consent_payment_id('2022-01-02','2022-10-08');
```

## API - Funil Detentor

### Funil Detentor - Pagamento Concluído

Como a solução Opus Open Finance não armazena o status do pagamento, fornecemos uma
API de listagem de *Payment IDs* gerados dentro de um intervalo de data:

```GET /open-banking/oob-consents/v1/tpps/payment-legacy-ids```

A API recebe dois query parameters como entrada para definição do intervalo:

- *startDate*: Data inicial do intervalo no formato *yyyy-MM-dd*;
- *endDate*: Data final (inclusa) do intervalo no formato *yyyy-MM-dd*;

A detentora de conta deverá consultar o status de cada um dos pagamentos
retornados a fim de determinar quantos deles foram concluídos.

Mais informações sobre a API podem ser encontradas em [apis-backoffice](../../../portal-backoffice/apis-backoffice/readme.md).
