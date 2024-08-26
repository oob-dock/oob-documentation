# Opus Open Finance Platform Financial Data Module Installation

## Installation

- The module is installed via Helm Chart.

## Configuration

1. ### internalApis/consentServer

    Base address of the consent service. An internal Kubernetes address can be used.

    > **Example:** `http://oob-consent`

2. ### tokenValidationService

    Configuration for authentication token validation

    - **host:** Base address of the authorization server. An internal Kubernetes address can be used.

        > **Example:** `http://oob-authorization-server`

    - **path:** Introspection endpoint path

        > **Example:** `/auth/token/introspection`

    - **clientId:** Client created in the oob-authorization-server configuration
  
    - **clientSecret:** Client secret created in the oob-authorization-server configuration

3. ### additionalVars

    Used to define optional configurations in the application. This configuration allows defining a list of properties to be passed to the application in the following format:

    \```yaml
    additionalVars:
     - name: FIRST_PROPERTY
       value: "FIRST_VALUE"
     - name: SECOND_PROPERTY
       value: "SECOND_VALUE"
    \```

    The settings that can be defined in this format are listed below:

   - **QUARKUS_LOG_LEVEL**

        Defines the log detail level of the application. It is recommended to activate DEBUG level only in development/testing environments or to facilitate error analysis in production. In production, it is advisable to use the INFO level.

        > **Format:** `DEBUG`, `INFO`, `TRACE`, `WARNING`, or `ERROR`
        >
        > **Default:** `INFO`
        >
        > **Example:**
        >
        > \```yaml
        > additionalVars:
        >   - name: QUARKUS_LOG_LEVEL
        >     value: "DEBUG"
        > \```

   - **APIS_VALIDATION_JSON-SCHEMA**

        Enables validation of request/response objects sent/received by the plugin with the defined specs (affects performance). It is advisable to disable it in production.

        > **Format:** `true` or `false`
        >
        > **Default:** `false`
        >
        > **Example:**
        >
        > \```yaml
        > additionalVars:
        >   - name: APIS_VALIDATION_JSON
        >     value: "true"
        > \```

   - **APIS_VALIDATION_OPENAPI_ENABLED-REQUEST**

        Enables validation of request objects received by the API with the Open Banking Brasil specification. It is advisable to always keep it active.

        > **Format:** `true` or `false`
        >
        > **Default:** `true`
        >
        > **Example:**
        >
        > \```yaml
        > additionalVars:
        >   - name: APIS_VALIDATION_OPENAPI_ENABLED-REQUEST
        >     value: "true"
        > \```

   - **APIS_VALIDATION_OPENAPI_ENABLED-RESPONSE**

        Enables validation of response objects returned by the API with the Open Banking Brasil specification (affects performance). It is advisable to disable it in production.

        > **Format:** `true` or `false`
        >
        > **Default:** `false`
        >
        > **Example:**
        >
        > \```yaml
        > additionalVars:
        >   - name: APIS_VALIDATION_OPENAPI_ENABLED-RESPONSE
        >     value: "true"
        > \```