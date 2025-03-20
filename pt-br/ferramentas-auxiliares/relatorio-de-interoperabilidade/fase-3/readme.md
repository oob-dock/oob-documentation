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
SELECT * FROM payment_consent_count('<data_inicio>','<data_fim>', <automatic_payment>);
```

O parâmetro *automatic_payment* indica se a consulta deve consultar apenas pagamentos automáticos ou desconsiderá-los
e deve ser preenchido com *true* ou *false*. Os parâmetros de data devem ser preenchidos no formato yyyy-MM-dd,
por exemplo:

```sql
SELECT * FROM payment_consent_count('2023-01-02','2023-01-08', false);
```

Após execução, consulte o ParentOrganization Reference através dos passos
descritos em [ParentOrg Iniciador](#parentorg-iniciador).

### Funil Detentor - Autenticação e redirecionamento

**Importante:** Os scripts SQL fornecidos nessa seção devem ser operados no
**banco de dados do OOB-Authorization-Server**

Na primeira execução deve-se criar a função *decode_base64url* executando o
seguinte [script](attachments/as_function_decode_base64url.sql).

Depois, deve-se criar a função *payment_consent_extract_authorization_data* executando
o seguinte [script](attachments/payment_consent_extract_authorization_data.sql).

Para obter os dados, execute a função usando o seguinte comando:

```sql
SELECT * FROM payment_consent_extract_authorization_data('<data_inicio>','<data_fim>', <automatic_payment>);
```

O parâmetro *automatic_payment* indica se a consulta deve consultar apenas pagamentos automáticos ou desconsiderá-los
e deve ser preenchido com *true* ou *false*. Os parâmetros de data devem ser preenchidos no formato yyyy-MM-dd,
por exemplo:

```sql
SELECT * FROM payment_consent_extract_authorization_data('2022-10-02','2022-10-08', false);
```

### Funil Detentor - Conclusão da autenticação e autorização do cliente

**Importante:** Os scripts SQL fornecidos nessa seção devem ser
operados no **banco de dados do OOB-Consent**.

Na primeira execução é necessário criar a função *payment_consent_client_authorization*
executando o seguinte [script](attachments/payment_consent_client_authorization.sql).

Para obter os dados, deve-se chamar a função usando o seguinte comando:

```sql
SELECT * FROM payment_consent_client_authorization('<data_inicio>','<data_fim>', <automatic_payment>);
```

O parâmetro *automatic_payment* indica se a consulta deve consultar apenas pagamentos automáticos ou desconsiderá-los
e deve ser preenchido com *true* ou *false*. Os parâmetros de data devem ser preenchidos no formato yyyy-MM-dd,
por exemplo:

```sql
SELECT * FROM payment_consent_client_authorization('2022-01-02','2022-10-08', false);
```

### Funil Detentor - Pagamentos recebidos e ids gerados

**Importante:** Os scripts SQL fornecidos nessa seção devem ser
operados no **banco de dados do OOB-Consent**.

Na primeira execução é necessário criar a função *payment_consent_payment_id*
executando o seguinte [script](attachments/payment_consent_payment_id.sql).

Para obter os dados, deve-se chamar a função usando o seguinte comando:

```sql
SELECT * FROM payment_consent_payment_id('<data_inicio>','<data_fim>', <automatic_payment>);
```

O parâmetro *automatic_payment* indica se a consulta deve consultar apenas pagamentos automáticos ou desconsiderá-los
e deve ser preenchido com *true* ou *false*. Os parâmetros de data devem ser preenchidos no formato yyyy-MM-dd,
por exemplo:

```sql
SELECT * FROM payment_consent_payment_id('2022-01-02','2022-10-08', false);
```

**Importante**: As quantidades de pagamentos agendados e finalizados retornadas pela query
só devem ser utilizadas caso a instituição implemente corretamente a [API de notificação](../../../portal-backoffice/apis-backoffice/readme.md#notificação-de-mudança-de-status-de-pagamento)
de mudança de status do pagamento.

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

## Scripts - Validações síncronas

**Importante:** Os scripts SQL fornecidos nessa seção devem ser
operados no **banco de dados do PCM**.

Na primeira execução é necessário criar a função *payment_sync_validation*
executando o seguinte [script](attachments/payment_sync_validation.sql).

Para obter os dados, deve-se chamar a função usando o seguinte comando:

```sql
SELECT * FROM payment_sync_validation('<data_inicio>','<data_fim>');
```

Sendo que os parâmetros devem ser preenchidos no formato yyyy-MM-dd, por exemplo:

```sql
SELECT * FROM payment_sync_validation('2022-01-02','2022-10-08');
```

Após execução, consulte o ParentOrganization Reference através dos passos
descritos em [ParentOrg Iniciador](#parentorg-iniciador).

## Scripts - Validações assíncronas

**Importante:** Os scripts SQL fornecidos nessa seção devem ser
operados no **banco de dados do OOB-Consent**.

Na primeira execução é necessário criar a função *payment_async_validation*
executando o seguinte [script](attachments/payment_async_validation.sql).

Para obter os dados, deve-se chamar a função usando o seguinte comando:

```sql
SELECT * FROM payment_async_validation('<data_inicio>','<data_fim>');
```

Sendo que os parâmetros devem ser preenchidos no formato yyyy-MM-dd, por exemplo:

```sql
SELECT * FROM payment_async_validation('2022-01-02','2022-10-08');
```

Após execução, consulte o ParentOrganization Reference do ITP_ID através dos passos
descritos em [ParentOrg Iniciador](#parentorg-iniciador).

## ParentOrg Iniciador e nome do ITP

Para obter a organização principal e o nome do ITP, deve-se executar o script [getParentOrganization](../../parent-org-reference-script/getParentOrganization.js)
informando os IDs das organizações retornados pelas consultas *payment_consent_count*
e *payment_sync_validation*.

Será necessário instalar a versão do [Node.js](https://nodejs.org/en/download)
correspondente ao seu Sistema Operacional.

Com o Node.js instalado, execute o seguinte comando da raiz desse projeto:

```bash
node ferramentas-auxiliares/parent-org-reference-script/getParentOrganization.js [IDs das Orgs Iniciadoras]
```

Os IDs das organizações iniciadoras devem ser separados por espaço,
conforme exemplo abaixo:

```bash
$ node ferramentas-auxiliares/parent-org-reference-script/getParentOrganization.js f83bee4f-26df-53d7-8335-a8a6edd7e340 fd0ea3e7-aeca-55f9-a0a2-ec56980059fb fd0ea3e7-aeca-55f9-a0a2-ec56980059fc
----------------------------------------------
Org ID: f83bee4f-26df-53d7-8335-a8a6edd7e340
Name: AYMORE CFI S.A.
Parent Organization: 90400888000142
----------------------------------------------
Org ID: fd0ea3e7-aeca-55f9-a0a2-ec56980059fb
Name: BCO WOORI BANK DO BRASIL S.A.
Parent Organization: N/A
----------------------------------------------
Org ID fd0ea3e7-aeca-55f9-a0a2-ec56980059fc Not found
----------------------------------------------
```

Caso a iniciadora não possua uma Parent Organization, o retorno do script para
ela será *N/A*. Caso ela não exista, o retorno será *Not found*.

## Execução de relatórios com consolidação de dados por organização

Caso a organização possua duas ou mais marcas, para as consultas que devem ser realizadas nas bases de dados dos serviços **OOB-Authorization-Server** e **OOB-Consent** é necessário utilizar os scrips com prefixo "organization_", nas quais além dos parâmetros originais (data de início e/ou data final), é preciso informar uma string de conexão para que a comunicação com as bases das outras marcas seja realizada.
Para tal, é necessário que o componente "dblink" seja instalado nas bases principais, por meio do comando:

```sql
CREATE EXTENSION IF NOT EXISTS "dblink";
```

a string de conexão deve ser formatada da seguinte maneira:

host={db_target_host} dbname={db_target_dbname} user={db_target_user} password={db_target_password}