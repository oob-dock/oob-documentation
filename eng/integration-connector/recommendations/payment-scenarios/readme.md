# Payment Scenarios to be Covered by the Integration

When implementing the payment integration, it is necessary to cover the creation and consultation of payments in each of the following scenarios.

For payments held for analysis (status "PDNG" in Open Finance) or scheduled payments, it is also necessary to include the possibility of revoking the payment.

## Scenarios by Logged User Type

- **Individual (PF)**
- **Legal Entity (PJ)** *(when supported by the financial institution's back-end)*

## Scenarios by Payment Settlement Date

- **Instant**: Payments to be settled on the same day as requested.
- **Scheduled**: Payments to be settled on a future date.

## Scenarios by Payment Initiation Method

- **MANU**: Initiated by manually entering the bank details.
- **INIC**: Initiated by the payee (*creditor*).
- **DICT**: Initiated by using a Pix key.
- **QRES**: Initiated via Static QR Code.
- **QRDN**: Initiated via Dynamic QR Code.

## Scenarios by Type of Payment Attempt

The Pix Arrangement allows retry attempts for specific types of payments, such as automatic Pix.  
When making a Pix through Open Finance, the integration must properly handle the following payment attempts:

- **Original Request:** The first attempt to execute the payment, applicable to all payments.
- **Extra-Day Retry:**  Only supported for specific payments (e.g., automatic Pix). It is a new attempt made on a day different from the original attempt.

**⚠️ Important:** Intra-day retry (performed on the same day), when applicable, must be identified and handled by the financial institution's back-end system.

---

## How to Identify the Scenarios

Below is a more technical view of the rules for identifying the payment scenarios described earlier.

The field analysis below refers to the payload of the payment creation request.

### How to Identify the Logged User Type

| Field `consent.businessDocumentType.document.identification` | Interpretation    |
| ------------------------------------------------------------ | ----------------- |
| Absent                                                       | Individual (PF)   |
| Present                                                      | Legal Entity (PJ) |

**ℹ️ Note:** Regardless of the user type, their CPF will be available in the `consent.loggedUser.document.identification` field.

### How to Identify the Payment Settlement Date

The field that defines the payment date varies depending on the payment type (`paymentType` field):

- If `paymentType` is `PAYMENT_CONSENT`

| Field `consent.payment.schedule`       | Scenario  | Payment Date                           |
| -------------------------------------- | --------- | -------------------------------------- |
| **Absent**                             | Instant   | Current date                           |
| Has `single` subfield                  | Scheduled | `consent.payment.schedule.single.date` |
| Has a subfield **other than** `single` | Scheduled | `requestBody.data.date`                |

- If `paymentType` is `PAYMENT_RECURRING_CONSENT`

| Field `requestBody.data.date` | Scenario  | Payment Date            |
| ----------------------------- | --------- | ----------------------- |
| Is the **current** date       | Instant   | Current date            |
| Is a **future** date          | Scheduled | `requestBody.data.date` |

### How to Identify the Payment Initiation Method and Payee (creditor)

The **payment initiation method** is defined by the value of the field `requestBody.data.localInstrument`.  
The method to identify the **creditor** varies according to the initiation method.

The table below summarizes the fields used to identify each scenario:

| Initiation Method  | Fields used to identify the creditor                               |
| :----------------: | ------------------------------------------------------------------ |
|        MANU        | `creditorAccount` (Object with bank account information)           |
|        INIC        | `creditorAccount` + `proxy` (Pix Key)                              |
|        DICT        | `creditorAccount` + `proxy`                                        |
|        QRES        | `creditorAccount` + `proxy` + `qrCode` (String with QR Code)       |
|        QRDN        | `creditorAccount` + `proxy` + `qrCode`                             |

**⚠️ Important:** When there is more than one identification method, consistency between them must be validated.
Example: the Pix key must refer to the same account indicated in the `creditorAccount` field.

**ℹ️ Note:** All fields mentioned in the table above are located inside `requestBody.data`.

### How to Identify the Payment Attempt

| Field `requestBody.data.originalRecurringPaymentId` | Interpretation   |
| --------------------------------------------------- | ---------------- |
| Absent                                              | Original Attempt |
| Filled with the original payment ID                 | Extra-Day Retry  |
