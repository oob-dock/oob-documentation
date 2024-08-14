# Web2AS Handoff Example

Example web application for implementing the web authentication flow and custom consent generation screens, as well as an example implementation of the handoff flow screen.

Documentation on the web flow can be found [here](../web2as/readme.md).

Documentation on the handoff flow can be found [here](../app2as-handoff/readme.md).

## Installing

```bash
npm install
```

## Running in development

```bash
npm run dev
```

## Configured environment variables (.env file)

`API_REQUEST_TIMEOUT`: Maximum waiting time for API call responses made to the Authorization Server (AS).

**Example**: `5000`.

`AS_OOB_URL`: Base address of the AS. This URL usually ends with `/auth`.

**Example**: `"https://oob.authorization-server/auth"`.

`JWT_PRIVATE_KEY`: Private key to be used to sign the JWT token.

**Example**: `"-----BEGIN PRIVATE KEY-----\nprivatekey\n-----END PRIVATE KEY-----"`.

`JWT_KID`: Key identifier to be used for creating and signing the JWT tokens. In scenarios with multiple keys, this identifier is necessary so that when decoding the token, it is possible to know which key signed it, in order to validate this signature.

**Example**: `"EUsMHFwXz5zMhkJoi1lcnIM2pCpLc3kc_2WV8YKZCK9"`.
