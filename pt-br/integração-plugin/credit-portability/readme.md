# API Credit Portabilty

Esse documento apresenta as **Rotas do Camel** e **Configurações Suportadas** para
o serviço de Portabilidade de crédito, o qual equivale às [APIs de Portabilidade de Crédito](https://openfinancebrasil.atlassian.net/wiki/spaces/DraftOF/pages/764510211/Portabilidade+de+Cr+dito+-+PC) do
Open Banking Brasil.

&nbsp;

A fim de que esse serviço funcione propriamente para cada um dos endpoints das APIs
acima citadas, deve-se criar um ou mais plugins que contenham rotas para cada uma
das [Rotas do Camel](#rotas-do-camel) aqui apresentadas.

&nbsp;

## Variáveis de Configuração Suportadas

&nbsp;

Por padrão, a aplicação permite a modificação de algumas configurações via variáveis
de ambiente, as quais podem ser injetadas via `Dockerfile`, `docker build` ou exeção
da imagem (via `docker run`).

A tabela abaixo contém uma lista das variáveis suportadas atualmente.

| Variável                                 | Objetivo                                                                                                                        | Valor Padrão |
|------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------|--------------|
| camel.main.routes-include-pattern        | Indica os locais onde o Camel deve procurar por rotas                                                                           |              |
| apis.validation.json-schema.enabled      | Habilita a validação dos objetos de request/response envidados/recebidos pelo plugin com as specs definidas (afeta performance) | false        |
| apis.validation.openapi.enabled-request  | Habilita a validação dos objetos de request recebidos pela API com a especificação do Open Banking Brasil                       | true         |
| apis.validation.openapi.enabled-response | Habilita a validação dos objetos de response devolvidos pela API com a especificação do Open Banking Brasil (afeta performance) | false        |

&nbsp;

**Além das variáveis acima apresentada, dependendo do(s) componente(s) do quarkus
camel que o plugin venha a utilizar, poderão existir outras de acordo com o que
estiver específicado na própria documentação do componente sendo utilizado. Além
disso, o plugin pode criar suas próprias variáveis de ambiente a serem injetadas.

&nbsp;

## Rotas do Camel

As subseções seguintes contêm todos os `endpoints` que precisam ter rotas defnidas
no camel e para os quais é necessário a criação de um ou mais plugins.

Para o endpoint `/account-data`, por exemplo, a rota deve estar

definida no plugin como:

```xml
<from uri="direct:creditPortabilityGetAccountData"/>
```

&nbsp;

### Account Data

&nbsp;

| Método | Versão | Endpoint                                                  | Rota do Camel                                |
| ------ | ------ | --------------------------------------------------------- | -------------------------------------------- |
| GET    | v1     | /account-data                                             | ```direct:creditPortabilityGetAccountData``` |

&nbsp;

### Concurrency Management

&nbsp;

| Método | Versão | Endpoint                                                  | Rota do Camel                                                                    |
| ------ | ------ | --------------------------------------------------------- | -------------------------------------------------------------------------------- |
| GET    | v1     | /credit-operations/\{contractId\}/portability-elegibility | ```direct:creditPortabilityGetCreditOperationsContratIdPortabilityEligibility``` |

&nbsp;

### Credit Portability

&nbsp;

| Método   | Versão | Endpoint                                | Rota do Camel                                                       |
| -------- | ------ | --------------------------------------- | ------------------------------------------------------------------- |
| POST     | v1     | /portabilities                          | ```direct:creditPortabilityPostPortabilities```                     |
| PATCH    | v1     | /portabilities/\{portabilityId\}/cancel | ```direct:creditPortabilityPatchPortabilitiesPortabilityIdCancel``` |

&nbsp;

### Payments

&nbsp;

| Método   | Versão | Endpoint                                 | Rota do Camel                                                       |
| -------- | ------ | ---------------------------------------- | ------------------------------------------------------------------- |
| POST     | v1     | /portabilities/\{portabilityId\}/payment | ```direct:creditPortabilityPostPortabilitiesPortabilityIdPayment``` |
