# Instalação do OOB Financial Data

## Instalação

- A instalação do módulo é feita via Helm Chart

## Configuração

1. ### internalApis/consentServer

    Endereço base do serviço de consentimento. Pode ser utilizado um apontamento
    interno no Kubernetes

    > **Ex:** `http://oob-consent`

2. ### tokenValidationService

    Configuração de validação do token de autenticação

    - **host:** Endereço base do authorization server. Pode ser utilizado um apontamento
        interno no Kubernetes

        > **Ex:** `http://oob-authorization-server`

    - **path:** Caminho do endpoint de introspection

        > **Ex:** `/auth/token/introspection`

    - **clientId:** Cliente criado na configuração do oob-authorization-server
  
    - **clientSecret:** *Secret* do cliente criado na configuração do obb-authorization-server

3. ### additionalVars

    Utilizado para definir configurações opcionais na aplicação. Essa configuração
    permite definir uma lista de propriedades a serem passadas para a aplicação
    no formato:

    ```yaml
    additionalVars:
     - name: FIRST_PROPERTY
       value: "FIRST_VALUE"
     - name: SECOND_PROPERTY
       value: "SECOND_VALUE"
    ```

    As configurações que podem ser definidas neste formato estão listadas abaixo:

   - **QUARKUS_LOG_LEVEL**

        Define o nível de detalhe do log da aplicação. É recomendável ativar o
        nível DEBUG somente em ambientes de desenvolvimento/homologação, ou para
        facilitar a análise de erros em produção. Em produção é aconselhável
        utilizar o nível INFO.

        > **Formato:** `DEBUG`, `INFO`, `TRACE`, `WARNING` ou `ERROR`
        >
        > **Default:** `INFO`
        >
        > **Ex:**
        >
        > ```yaml
        > additionalVars:
        >   - name: QUARKUS_LOG_LEVEL
        >     value: "DEBUG"
        > ```

   - **APIS_VALIDATION_JSON-SCHEMA**

        Habilita a validação dos objetos de request/response envidados/recebidos
        pelo plugin com as specs definidas (afeta performance). Em produção é
        aconselhável desativar.

        > **Formato:** `true` ou `false`
        >
        > **Default:** `false`
        >
        > **Ex:**
        >
        > ```yaml
        > additionalVars:
        >   - name: APIS_VALIDATION_JSON
        >     value: "true"
        > ```

   - **APIS_VALIDATION_OPENAPI_ENABLED-REQUEST**

        Habilita a validação dos objetos de request recebidos pela API com a especificação
        do Open Banking Brasil. É aconselhável sempre estar ativo.

        > **Formato:** `true` ou `false`
        >
        > **Default:** `true`
        >
        > **Ex:**
        >
        > ```yaml
        > additionalVars:
        >   - name: APIS_VALIDATION_OPENAPI_ENABLED-REQUEST
        >     value: "true"
        > ```

   - **APIS_VALIDATION_OPENAPI_ENABLED-RESPONSE**

        Habilita a validação dos objetos de response devolvidos pela API com a especificação
        do Open Banking Brasil (afeta performance). Em produção é aconselhável desativar.

        > **Formato:** `true` ou `false`
        >
        > **Default:** `false`
        >
        > **Ex:**
        >
        > ```yaml
        > additionalVars:
        >   - name: APIS_VALIDATION_OPENAPI_ENABLED-RESPONSE
        >     value: "true"
        > ```
