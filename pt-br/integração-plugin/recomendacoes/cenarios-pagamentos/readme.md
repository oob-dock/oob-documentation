# Cenários de Pagamentos a Serem Cobertos pela Integração

Na implementação da integração de pagamentos, é necessário cobrir a criação e a consulta de pagamentos em cada um dos cenários a seguir.

Para pagamentos retidos para análise (status "PDNG" no Open Finance) ou agendados, também é necessário contemplar a possibilidade de revogação do pagamento.

## Cenários por Tipo de Usuário Logado

- **Pessoa Física (PF)**
- **Pessoa Jurídica (PJ)** *(quando suportado pela retaguarda da instituição financeira)*

## Cenários por Data de Efetivação do Pagamento

- **Instantâneo**: Pagamentos a serem efetivados no mesmo dia da solicitação.
- **Agendado**: Pagamentos a serem efetivados em data futura.

## Cenários por Forma de Iniciação do Pagamento

- **MANU**: Iniciado por inserção manual dos dados bancários.
- **INIC**: Iniciado pelo recebedor (*creditor*).
- **DICT**: Iniciado por uso de chave Pix.
- **QRES**: Iniciado por QR Code Estático.
- **QRDN**: Iniciado por QR Code Dinâmico.

## Cenários por Tipo de Tentativa de Pagamento

O Arranjo Pix possibilita rententativas para pagamentos específicos, como o Pix automático.  
Ao realizar um Pix pelo Open Finance, a integração deve tratar adequadamente as seguintes tentativas de pagamento:

- **Solicitação Original:** A primeira tentativa de execução do pagamento, que acontece para todos os pagamentos.
- **Retentativa Extradia:** Apenas suportada para pagamentos específicos (ex.: Pix automático). É uma nova tentativa realizada em um dia diferente da tentativa original.

**⚠️ Importante:** A retentativa intradia (realizada no mesmo dia), quando aplicável, deve ser identificada e tratada pelo sistema de retaguarda da instituição financeira.

---

## Como Identificar os Cenários

A seguir, é apresentada uma visão mais técnica das regras de identificação os cenários de pagamentos descritos anteriormente.

A análise de campos abaixo é feita para o payload da requisição de criação de pagamentos.

### Como Identificar o Tipo de Usuário Logado

| Campo `consent.businessDocumentType.document.identification` | Interpretação |
| ------------------------------------------------------------ | ------------- |
| Ausente                                                      | Usuário PF    |
| Preenchido                                                   | Usuário PJ    |

**ℹ️ Observação:** Independentemente do tipo de usuário, o CPF dele estará disponível no campo `consent.loggedUser.document.identification`.

### Como Identificar a Data de Efetivação do Pagamento

O campo que define a data do pagamento varia conforme o tipo de pagamento (campo `paymentType`):

- Caso `paymentType` seja `PAYMENT_CONSENT`

| Campo `consent.payment.schedule`          | Cenário     | Data de Pagamento                      |
| ----------------------------------------- | ----------- | -------------------------------------- |
| **Ausente**                               | Instantâneo | Data atual                             |
| Possui subcampo `single`                  | Agendado    | `consent.payment.schedule.single.date` |
| Possui subcampo **diferente** de `single` | Agendado    | `requestBody.data.date`                |

- Caso `paymentType` seja `PAYMENT_RECURRING_CONSENT`

| Campo `requestBody.data.date` | Cenário     | Data de Pagamento       |
| ----------------------------- | ----------- | ----------------------- |
| É data **atual**              | Instantâneo | Data atual              |
| É data **futura**             | Agendado    | `requestBody.data.date` |

### Como Identificar a Forma de Iniciação e o Recebedor (creditor)

A **forma de iniciação** do pagamento é determinada pelo valor do campo `requestBody.data.localInstrument`.  
A forma de identificação do **recebedor (creditor)** varia conforme o tipo de iniciação informado.

A tabela abaixo resume os campos para a identificação cada cenário:

| Forma de Iniciação | Campos utilizados para identificar o recebedor                     |
| :----------------: | ------------------------------------------------------------------ |
|        MANU        | `creditorAccount` (Objeto com informações bancárias)               |
|        INIC        | `creditorAccount` + `proxy` (Chave Pix)                            |
|        DICT        | `creditorAccount` + `proxy`                                        |
|        QRES        | `creditorAccount` + `proxy` + `qrCode` (String com o QR Code lido) |
|        QRDN        | `creditorAccount` + `proxy` + `qrCode`                             |

**⚠️ Importante:** Quando houver mais de uma forma de identificação, deve-se validar a consistência entre elas.
Exemplo: a chave Pix deve se referir à mesma conta indicada no campo creditorAccount.

**ℹ️ Observação:** Todos os campos mencionados na tabela acima estão localizados dentro de `requestBody.data`.

### Como Identificar a Tentativa de Pagamento

| Campo `requestBody.data.originalRecurringPaymentId` | Interpretação        |
| --------------------------------------------------- | -------------------- |
| Ausente                                             | Tentativa Original   |
| Preenchido com o ID do pagamento original           | Retentativa Extradia |
