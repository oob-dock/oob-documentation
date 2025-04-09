# Cenários de Pagamentos

Na implementação da integração de pagamentos é necessário cobrir a criação e consulta de pagamentos em cada um dos cenários a seguir. Para pagamentos agendados soma-se também a necessidade de revogação para cada cenário.

## Cenários por Tipos de Usuário Logado

- Pessoa Física (PF)
- Pessoa Jurídica (PJ) *(se suportado pelo cliente)*

## Cenários por Data

- **Instantâneo**: Criar e consultar pagamentos no mesmo dia que realizados
- **Agendado**: Criar e consultar pagamentos agendados para dias futuros

## Cenários por Formas de Iniciação

- **MANU**: Inserção manual de dados bancários
- **INIC**: Iniciado pelo recebedor (creditor)
- **DICT**: Chave Pix
- **QRES**: QR Code Estático
- **QRDN**: QR Code Dinâmico

## Cenários por Tipo de Tentativa

- **Solicitação Original**
- **Retentativa Extradia** *(quando aplicável. Ex.: pix automático)*

**⚠️ Importante:** A retentativa intradia (quando aplicável) deve ser coberta pelo sistema de retaguarda.

---

## Como Identificar os Cenários

A seguir estão as regras para identificar os cenários de pagamentos. Os campos avaliados são referentes ao payload de solicitação de criação de pagamento.

### Como Identificar o Tipo de Usuário Logado

| Campo `consent.businessDocumentType.document.identification` | Interpretação |
| ------------------------------------------------------------ | ------------- |
| Ausente ou vazio                                             | Usuário PF    |
| Preenchido                                                   | Usuário PJ    |

**ℹ️ Observação:** Independentemente do tipo de usuário, o CPF dele estará disponível no campo `consent.loggedUser.document.identification`.

### Como Identificar a Data do Pagamento

O campo que define a data de pagamento varia conforme o tipo de pagamento (campo `paymentType`):

#### Caso `paymentType` seja `PAYMENT_CONSENT`

| Campo `consent.payment.schedule`       | Cenário     | Data de Pagamento                      |
| -------------------------------------- | ----------- | -------------------------------------- |
| **Não** está presente                  | Instantâneo | Data atual                             |
| Está **presente** e é `single`         | Agendado    | `consent.payment.schedule.single.date` |
| Está **presente** e **não** é `single` | Agendado    | `requestBody.data.date`                |

#### Caso `paymentType` seja `PAYMENT_RECURRING_CONSENT`

| Campo `requestBody.data.date` | Cenário     | Data de Pagamento       |
| ----------------------------- | ----------- | ----------------------- |
| É data **atual**              | Instantâneo | Data atual              |
| É data **futura**             | Agendado    | `requestBody.data.date` |

### Como Identificar a Forma de Iniciação e o Recebedor (creditor)

| Forma de Iniciação (`localInstrument`) | Identificação do Recebedor (creditor)                      |
| :--------------------------------------: | ---------------------------------------------------------- |
| MANU                                   | `creditorAccount`                                          |
| INIC                                   | Chave Pix (`proxy`)                                        |
| DICT                                   | Chave Pix (`proxy`) + `creditorAccount`                    |
| QRES                                   | Chave Pix (`proxy`) + `creditorAccount` + dados do QR Code |
| QRDN                                   | Chave Pix (`proxy`) + `creditorAccount` + dados do QR Code |

**⚠️ Importante:** Quando houver mais de uma forma de identificação, deve-se validar a consistência entre elas.

**ℹ️ Observação:** Todos os campos mencionados na tabela acima estão localizados dentro de `requestBody.data`.

### Como Identificar a Tentativa de Pagamento

| Campo `requestBody.data.originalRecurringPaymentId` | Interpretação        |
| --------------------------------------------------- | -------------------- |
| Ausente ou vazio                                    | Tentativa Original   |
| Preenchido com o ID do pagamento original           | Retentativa Extradia |
