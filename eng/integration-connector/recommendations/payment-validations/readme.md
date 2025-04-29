# Mandatory Payment Validations

The following validations must be implemented on the specific endpoint for payment data validation.

For each validation, the error returned by the integration must include the corresponding code in the `code` field, as indicated.

## Maximum Payment Amount Validation

**ℹ️ Notes:**

- Validation applies to payments of type `PAYMENT_CONSENT` (value of the `requestBody.paymentType` field).
- All other fields below are located within `requestBody.data.payment`.

### Rule

The transaction amount (`amount` field) must be less than:

- The limit established by the Account-Holding Institution (if such a limit exists).
- The absolute maximum amount, in BRL, of `999999999.99` (i.e., up to 9 digits before the decimal point and 2 digits after).
    - The value **must not** be equal to the maximum limit.

**Error code:** `VALOR_ACIMA_LIMITE`

## QR Code Validations

**ℹ️ Notes:**

- Validations apply to payments of type `PAYMENT_CONSENT` (value of the `requestBody.paymentType` field).
- All other fields below are located within `requestBody.data.payment`.

### General Rules

1. The QR Code type must be consistent with the payment initiation method (`details.localInstrument` field):
    - If the initiation method is **QRES**, the QR Code must be **Static**.
    - If the initiation method is **QRDN**, the QR Code must be **Dynamic**.
    - **Error code:** `QRCODE_INVALIDO`

### If the QR Code is **Static**

1. The amount present in the Static QR Code must match the amount specified in the payment payload (`amount` field).
    - **Error code:** `VALOR_INVALIDO`

2. The Pix key present in the Static QR Code must be identical to the Pix key provided in the payment payload (`details.proxy` field).
    - **Error code:** `QRCODE_INVALIDO`

### If the QR Code is **Dynamic**

1. The Dynamic QR Code status must be valid for use.
    - **Error code:** `QRCODE_INVALIDO`
