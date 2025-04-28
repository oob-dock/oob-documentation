# Integração - Dúvidas Frequentes

## Sobre Descoberta de Contas

**O que devo retornar nos campos `key` de `resourceLegacyId` e `resourceName`?**

Os campos `resourceLegacyId` e `resourceName` funcionam como identificadores internos na retaguarda e devem ser definidos para uso nessa camada. Ambos são estruturados como listas de pares *key-value* para oferecer suporte a identificadores compostos.

Para o `resourceLegacyId`, caso o ID seja simples, é suficiente retornar algo como:

```json
"resourceLegacyId": [
    { "key": "id", "value": "<valor do id>" }
]
```

Já para o `resourceName`, é importante retornar valores que ajudem o usuário final a reconhecer o recurso. Por exemplo, no caso de uma conta bancária, pode-se retornar algo como:

```json
"resourceName": [
    { "key": "Agencia", "value": "<número da agência>" },
    { "key": "Conta", "value": "<número da conta>" }
]
```

**O usuário não possui contas a serem retornadas. Devo retornar erro ou lista vazia?**

Caso o usuário não possua contas, o retorno deve ser sucesso (HTTP 200) com uma lista vazia.

**Na descoberta de contas do fluxo de pagamentos, qual conta deve vir como "selecionada por padrão"?**

Se o campo `debtorAccount` do consentimento estiver preenchido com uma conta válida para pagamentos, essa conta deve ser marcada como "selecionada por padrão" (`"defaultSelected": true`). Independentemente disso, todas as contas disponíveis para pagamento devem ser retornadas.

## Sobre Validação dos Dados de Pagamento

**O que deve ser validado na rota `validatePaymentData` (para integrações do tipo "Conector") ou na chamada ao endpoint `/payment-validation` (para integrações do tipo "Camada de Integração")?**

Conferir as [validações obrigatórias para pagamentos](pt-br/integração-plugin/recomendacoes/validacoes-pagamentos/readme).

## Sobre Solicitações de Criação de Pagamentos

**Como identificar a conta escolhida pelo portador para realizar o débito?**

Após a aprovação do consentimento de pagamento, a lista `consent.resources` sempre contém apenas um único recurso, representando a conta selecionada.
O campo `consent.debtorAccount` estará também sempre preenchido com as informações da conta escolhida.

**Onde encontrar a data do pagamento para cada cenário ou tipo de pagamento?**
Conferir [como identificar a data do pagamento](pt-br/integração-plugin/recomendacoes/cenarios-pagamentos/readme.md#Como%20Identificar%20a%20Data%20do%20Pagamento).

**A retaguarda precisa se preocupar com Agendamentos Recorrentes?**
Por exemplo, ao receber uma requisição de agendamento recorrente por 5 meses, um débito por mês, o produto solicitará para a retaguarda 5 agendamento independentes. A data de cada agendamento deve ser determinada conforme descrito em [como identificar a data do pagamento](pt-br/integração-plugin/recomendacoes/cenarios-pagamentos/readme.md#Como%20Identificar%20a%20Data%20do%20Pagamento).
