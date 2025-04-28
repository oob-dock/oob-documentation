# Payment Scenarios

When implementing the payment integration, it is necessary to cover the creation and consultation of payments in each of the following scenarios.

For payments held for analysis (status "PDNG" in Open Finance) or scheduled payments, it is also necessary to include the possibility of revoking the payment.

## Scenarios by Logged User Type

- **Individual (PF)**
- **Legal Entity (PJ)** *(when supported by the institution’s back-end)*

## Scenarios by Date

- **Instant**: Payments to be completed on the same day as the request.
- **Scheduled**: Payments to be completed on a future date.

## Scenarios by Initiation Method

- **MANU**: Initiated by manually entering the bank details.
- **INIC**: Initiated by the payee (*creditor*).
- **DICT**: Initiated by using a Pix key.
- **QRES**: Initiated via Static QR Code.
- **QRDN**: Initiated via Dynamic QR Code.

## Scenarios by Attempt Type

- **Original Request**
- **Extra-Day Retry** *(when applicable. E.g.: automatic Pix)*

**⚠️ Important:** Intra-day retries (when applicable) must be handled by the institution’s back-end system.

---

## How to Identify the Scenarios

Below are the rules for identifying the payment scenarios described above.

The field analysis below refers to the payload of the payment creation request. It applies both to integrations intermediated by an "Integration Layer" and those made through a "Connector."

### How to Identify the Logged User Type

| Field `consent.businessDocumentType.document.identification` | Interpretation    |
| ------------------------------------------------------------ | ----------------- |
| Absent                                                       | Individual (PF)   |
| Present                                                      | Legal Entity (PJ) |

**ℹ️ Note:** Regardless of the user type, the user's CPF (Individual Taxpayer Registry) will be available in the `consent.loggedUser.document.identification` field.

### How to Identify the Payment Date

The field that defines the payment date varies depending on the payment type (`paymentType` field):

#### If `paymentType` is `PAYMENT_CONSENT`

| Field `consent.payment.schedule`       | Scenario  | Payment Date                           |
| -------------------------------------- | --------- | -------------------------------------- |
| **Absent**                             | Instant   | Current date                           |
| Has `single` subfield                  | Scheduled | `consent.payment.schedule.single.date` |
| Has a subfield **other than** `single` | Scheduled | `requestBody.data.date`                |

#### If `paymentType` is `PAYMENT_RECURRING_CONSENT`

| Field `requestBody.data.date` | Scenario  | Payment Date            |
| ----------------------------- | --------- | ----------------------- |
| Is the **current** date       | Instant   | Current date            |
| Is a **future** date          | Scheduled | `requestBody.data.date` |

### How to Identify the Initiation Method and Payee (creditor)

| Initiation Method (`localInstrument`) | Payee (creditor) Identification                                 |
| :-----------------------------------: | --------------------------------------------------------------- |
|                 MANU                  | `creditorAccount`                                               |
|                 INIC                  | Pix Key (`proxy`)                                               |
|                 DICT                  | Pix Key (`proxy`) + `creditorAccount`                           |
|                 QRES                  | Pix Key (`proxy`) + `creditorAccount` + QR Code data (`qrCode`) |
|                 QRDN                  | Pix Key (`proxy`) + `creditorAccount` + QR Code data (`qrCode`) |

**⚠️ Important:** When there is more than one identification method, consistency between them must be validated.

**ℹ️ Note:** All fields mentioned in the table above are located inside `requestBody.data`.

### How to Identify the Payment Attempt

| Field `requestBody.data.originalRecurringPaymentId` | Interpretation   |
| --------------------------------------------------- | ---------------- |
| Absent                                              | Original Attempt |
| Filled with the original payment ID                 | Extra-Day Retry  |
