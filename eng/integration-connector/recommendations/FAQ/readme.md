# Integration - Frequently Asked Questions

## About Resource Discovery

Questions regarding [resource discovery in Opus Open Finance](/eng/integration-connector/consent/readme.md#Resource-Discovery-in-Opus-Open-Finance)

**What is a "resource"?**

In Open Finance, "resources" are data or service components that can be accessed via APIs, respecting security and consent requirements.
In practice, a "resource" can be a transacting account, a card, an investment, among others.

**What should I return in the `key` fields of `resourceLegacyId` and `resourceName`?**

The `resourceLegacyId` and `resourceName` fields act as internal identifiers in the financial institution's back-end and must be defined for use at this layer. Both are structured as lists of *key-value* pairs to support composite identifiers.

For `resourceLegacyId`, if the ID is simple, it is enough to return something like:

```json
"resourceLegacyId": [
    { "key": "id", "value": "<id value>" }
]
```

For `resourceName`, it is important to return values that help the end user recognize the resource. For example, for a bank account, you could return something like:

```json
"resourceName": [
    { "key": "branch", "value": "<branch number>" },
    { "key": "account", "value": "<account number>" }
]
```

**The user has no accounts to return. Should I return an error or an empty list?**

If the user has no accounts, the response should be a success (HTTP 200) with an empty resource list (`{ "data": { "resources": [] } }`).

**In the account discovery for the payment flow, which account should come as "default selected"?**

If the `debtorAccount` field in the consent is filled with a valid account for payments, that account should be marked as "default selected" (`"defaultSelected": true`). Regardless of that, all accounts available for payment must be returned.

## About Payment Data Validation

**What should be validated on the specific endpoint for payment data validation?**

Check the [mandatory payment validations](/eng/integration-connector/recommendations/payment-validations/readme.md).

## About Payment Creation Requests

**How to identify the account selected by the user to perform the debit?**

After the payment consent approval, the `consent.resources` list included in the payment request payload will always contain only a single resource, representing the selected account.  
The `consent.debtorAccount` field will also always be filled with the information of the chosen account.

**Where can I find the payment date for each scenario or payment type?**

Check [how to identify the payment settlement date](/eng/integration-connector/recommendations/payment-scenarios/readme.md#How-to-Identify-the-Payment-Settlement-Date).

**Does the financial institution's back-end need to handle Recurring Scheduling?**

No. The product will send a separate request for each recurrence date.

For example, when receiving a recurring scheduling request for 5 months (one debit per month), the product will send 5 independent scheduling requests to the financial institution's back-end.  
The date of each scheduling must be determined as described in [how to identify the payment settlement date](/eng/integration-connector/recommendations/payment-scenarios/readme.md#How-to-Identify-the-Payment-Settlement-Date).
