# Definições compartilhadas

## Brand Id

Nome simplificado da marca, só pode conter letras minúsculas e hífen ( - ).
O tamanho máximo é de 36 caracteres. Essa informação é utilizada para identificar
a marca dentro do sistema e integrações, ela não será exibida ao cliente.
Deve ser único por marca em instituições que possuem mais de uma marca.

***

**:warning: ATENÇÃO**: O valor da propriedade Brand Id é utilizada na criação da
estrutura de banco de dados em alguns módulos, isso significa que este valor não
pode ser alterado depois da primeira execução da aplicação. Em caso de configuração
errada entre em contato com a Opus.

***

Ex: `cbanco`

## Suporte a features do Opus Open Banking

Com o objetivo de otimizar o uso de recursos, monitorar e expor endpoints
suportados pela instituição, implementamos o suporte a features.

Todos os endpoints que são expostos no Kong estão obrigatoriamente atrelados a
uma feature.

### Features suportadas

Abaixo temos a lista de features suportadas pelo Opus Open Banking:

| Feature        | Descrição                                                                            |
| -------------- | ------------------------------------------------------------------------------------ |
| core           | Funções básicas e obrigatórias do Opus Open Banking                                  |
| open-data      | Compartilhamento de dados abertos (Fase 1 do Open Banking Brasil)                    |
| financial-data | Compartilhamento de dados que requerem consentimento (Fase 2 do Open Banking Brasil) |
| payments       | Pagamentos (Fase 3 do Open Banking Brasil)                                           |

### Features x Scopes

Cada feature definida na tabela acima suporta os seguintes escopos:

| Feature        | Scopes                                                                                                                                       |
| -------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| core           | openid, oob_customer, oob_consents:read, oob_opendata:read, oob_opendata:write, oob_outages:read, oob_outages:write, profile, offline_access |
| open-data      | openid                                                                                                                                       |
| financial-data | openid, accounts, credit-cards-accounts, customers, invoice-financings, financings, loans, unarranged-accounts-overdraft, resources          |
| payments       | openid, payments, consents, resources                                                                                                        |
