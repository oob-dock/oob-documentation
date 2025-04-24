# Cenários de Pagamentos

Na implementação da integração de pagamentos, é necessário cobrir a criação e a consulta de pagamentos em cada um dos cenários a seguir.

Para pagamentos retidos para análise (status "PDNG" no Open Finance) ou agendados, também é necessário contemplar a possibilidade de revogação do pagamento.

## Cenários por Tipo de Usuário Logado

- **Pessoa Física (PF)**
- **Pessoa Jurídica (PJ)** *(quando suportado pela retaguarda)*

## Cenários por Data

- **Instantâneo**: Pagamentos a serem efetivados no mesmo dia da solicitação.
- **Agendado**: Pagamentos a serem efetivados em data futura.

## Cenários por Forma de Iniciação

- **MANU**: Iniciado por inserção manual dos dados bancários.
- **INIC**: Iniciado pelo recebedor (*creditor*).
- **DICT**: Iniciado por uso de chave Pix.
- **QRES**: Iniciado por QR Code Estático.
- **QRDN**: Iniciado por QR Code Dinâmico.

## Cenários por Tipo de Tentativa

- **Solicitação Original**
- **Retentativa Extradia** *(quando aplicável. Ex.: Pix automático)*

**⚠️ Importante:** A retentativa intradia (quando aplicável) deve ser tratada pelo sistema de retaguarda.

---

## Como Identificar os Cenários

A seguir, são apresentadas as regras para identificar os cenários de pagamentos descritos anteriormente.

A análise de campos abaixo é feita para o payload de solicitação de criação de pagamentos. Ela é válida tanto para integrações intermediadas por uma "Camada de Integração" quanto por um "Conector".

### Como Identificar o Tipo de Usuário Logado

| Campo `consent.businessDocumentType.document.identification` | Interpretação |
| ------------------------------------------------------------ | ------------- |
| Ausente                                                      | Usuário PF    |
| Preenchido                                                   | Usuário PJ    |

**ℹ️ Observação:** Independentemente do tipo de usuário, o CPF dele estará disponível no campo `consent.loggedUser.document.identification`.

### Como Identificar a Data do Pagamento

O campo que define a data do pagamento varia conforme o tipo de pagamento (campo `paymentType`):

#### Caso `paymentType` seja `PAYMENT_CONSENT`

| Campo `consent.payment.schedule`          | Cenário     | Data de Pagamento                      |
| ----------------------------------------- | ----------- | -------------------------------------- |
| **Ausente**                               | Instantâneo | Data atual                             |
| Possui subcampo `single`                  | Agendado    | `consent.payment.schedule.single.date` |
| Possui subcampo **diferente** de `single` | Agendado    | `requestBody.data.date`                |

#### Caso `paymentType` seja `PAYMENT_RECURRING_CONSENT`

| Campo `requestBody.data.date` | Cenário     | Data de Pagamento       |
| ----------------------------- | ----------- | ----------------------- |
| É data **atual**              | Instantâneo | Data atual              |
| É data **futura**             | Agendado    | `requestBody.data.date` |

### Como Identificar a Forma de Iniciação e o Recebedor (creditor)

| Forma de Iniciação (`localInstrument`) | Identificação do Recebedor (creditor)                                 |
| :------------------------------------: | --------------------------------------------------------------------- |
|                  MANU                  | `creditorAccount`                                                     |
|                  INIC                  | Chave Pix (`proxy`)                                                   |
|                  DICT                  | Chave Pix (`proxy`) + `creditorAccount`                               |
|                  QRES                  | Chave Pix (`proxy`) + `creditorAccount` + dados do QR Code (`qrCode`) |
|                  QRDN                  | Chave Pix (`proxy`) + `creditorAccount` + dados do QR Code (`qrCode`) |

**⚠️ Importante:** Quando houver mais de uma forma de identificação, deve-se validar a consistência entre elas.

**ℹ️ Observação:** Todos os campos mencionados na tabela acima estão localizados dentro de `requestBody.data`.

### Como Identificar a Tentativa de Pagamento

| Campo `requestBody.data.originalRecurringPaymentId` | Interpretação        |
| --------------------------------------------------- | -------------------- |
| Ausente                                             | Tentativa Original   |
| Preenchido com o ID do pagamento original           | Retentativa Extradia |
