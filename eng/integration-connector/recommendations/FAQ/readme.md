# Integration - Frequently Asked Questions

## About Account Discovery

**What should I return in the `key` fields of `resourceLegacyId` and `resourceName`?**

The `resourceLegacyId` and `resourceName` fields act as internal institution’s back-end identifiers and must be defined for use at this layer. Both are structured as lists of *key-value* pairs to support composite identifiers.

For `resourceLegacyId`, if the ID is simple, it is enough to return something like:

```json
"resourceLegacyId": [
    { "key": "id", "value": "<id value>" }
]
```

For `resourceName`, it is important to return values that help the end user recognize the resource. For example, for a bank account, you could return something like:

```json
"resourceName": [
    { "key": "Agency", "value": "<agency number>" },
    { "key": "Account", "value": "<account number>" }
]
```

**The user has no accounts to return. Should I return an error or an empty list?**

If the user has no accounts, the response should be a success (HTTP 200) with an empty resource list.

**In the account discovery for the payment flow, which account should come as "default selected"?**

If the `debtorAccount` field in the consent is filled with a valid account for payments, that account should be marked as "default selected" (`"defaultSelected": true`). Regardless of that, all accounts available for payment must be returned.

## About Payment Data Validation

**What should be validated in the `validatePaymentData` route (for "Connector"-type integrations) or in the `/payment-validation` endpoint call (for "Integration Layer"-type integrations)?**

Check the [mandatory payment validations](eng/integration-connector/recommendations/payment-validations/readme.md).

## About Payment Creation Requests

**How can I identify the account chosen by the user to perform the debit?**

After the payment consent approval, the `consent.resources` list will always contain only a single resource, representing the selected account.
The `consent.debtorAccount` field will also always be filled with the information of the chosen account.

**Where can I find the payment date for each scenario or payment type?**
Check [how to identify the payment date](eng/integration-connector/recommendations/payment-scenarios/readme.md#How%20to%20Identify%20the%20Payment%20Date).

**Does the institution’s back-end need to handle recurring scheduled payments?**

No. The product will make a separate request for each recurrence date.

For example, when receiving a recurring scheduling request for 5 months (one debit per month), the product will submit 5 independent scheduling requests to the institution’s back-end. The date for each scheduled payment must be determined as described in [how to identify the payment date](eng/integration-connector/recommendations/payment-scenarios/readme.md#How%20to%20Identify%20the%20Payment%20Date).
