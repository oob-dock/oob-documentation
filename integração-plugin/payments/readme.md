# API Payment

Esse documento apresenta as **Rotas do Camel** e **Configurações Suportadas** para
o serviço de payments, o qual equivale às [APIs de **Pix**](https://openbanking-brasil.github.io/areadesenvolvedor/#fase-3-apis-do-open-banking-brasil-api-pagamentos)
do Open Banking Brasil.

A fim de que esse serviço funcione propriamente para cada um dos endpoints das APIs
acima citadas, deve-se criar um ou mais plugins que contenham rotas para cada uma
das [Rotas do Camel](#rotas-do-camel) aqui apresentadas.

&nbsp;

## Variáveis de Configuração Suportadas

&nbsp;

Por padrão, a aplicação permite a modificação de algumas configurações via variáveis
de ambiente, as quais podem ser injetadas via `Dockerfile`, `docker build` ou execução
da imagem (via `docker run`).

A tabela abaixo contém uma lista das variáveis suportadas atualmente.

| Variável                                            | Objetivo                                                                                                                        | Valor Padrão                                          |
| --------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------- |
| camel.main.routes-include-pattern                   | Indica os locais onde o Camel deve procurar por rotas                                                                           |                                                       |
| apis.validation.json-schema.enabled                 | Habilita a validação dos objetos de request/response envidados/recebidos pelo plugin com as specs definidas (afeta performance) | false                                                 |
| apis.validation.openapi.enabled-request             | Habilita a validação dos objetos de request recebidos pela API com a especificação do Open Banking Brasil                       | true                                                  |
| apis.validation.openapi.enabled-response            | Habilita a validação dos objetos de response devolvidos pela API com a especificação do Open Banking Brasil (afeta performance) | false                                                 |
| cnpjInitiatorValidation.directoryRolesUrl           | Parametrização da URL para consulta do diretório de participantes do Open Banking Brasil                                        | https://data.directory.openbankingbrasil.org.br/roles |
| quarkus.cache.caffeine.directory.expire-after-write | Parametrização do tempo de vida do cache do resultado da consulta do diretório de participantes do Open Banking Brasil          | 5M                                                    |

&nbsp;

**Além das variáveis acima apresentada, dependendo do(s) componente(s) do quarkus
camel que o plugin venha a utilizar, poderão existir outras de acordo com o que estiver
específicado na própria documentação do componente sendo utilizado. Além disso, o
plugin pode criar suas próprias variáveis de ambiente a serem injetadas.

&nbsp;

## Rotas do Camel

As subseções seguintes contêm todos os `endpoints` que precisam ter rotas defnidas
no camel e para os quais é necessário a criação de um ou mais plugins.

Para o endpoint `/pix/payments`, por exemplo, a rota deve estar definida no plugin
como:

```xml
<from uri="direct:paymentsPostPixPayments"/>
```

&nbsp;

### Pix

&nbsp;

| Método   | Versão | Endpoint                        | Rota do Camel                                     |
| -------- | ------ | ------------------------------- | ------------------------------------------------- |
| POST     | v1     | /pix/payments                   | ```direct:paymentsPostPixPayments```              |
| GET      | v1     | /pix/payments/\{paymentId\}     | ```direct:paymentsGetPixPaymentsPaymentId```      |
| POST     | v2     | /pix/payments                   | ```direct:paymentsPostPixPayments_v2```           |
| GET      | v2     | /pix/payments/\{paymentId\}     | ```direct:paymentsGetPixPaymentsPaymentId_v2```   |
| PATCH    | v2     | /pix/payments/\{paymentId\}     | ```direct:paymentsPatchPixPaymentsPaymentId_v2``` |
| POST     | v3     | /pix/payments                   | ```direct:paymentsPostPixPayments_v3```           |
| GET      | v3     | /pix/payments/\{paymentId\}     | ```direct:paymentsGetPixPaymentsPaymentId_v3```   |
| PATCH    | v3     | /pix/payments/\{paymentId\}     | ```direct:paymentsPatchPixPaymentsPaymentId_v3``` |

## O que muda na versão 2 da API de Iniciação de Pagamentos?

O Open Finance Brasil definiu oficialmente suporte a pagamentos agendados via PIX
na versão 2 do serviço de iniciação de pagamentos, incluindo uma
[nova máquina de estados](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/24182882/M+quina+de+Estados+-+v2.0.0+-+Pagamentos#Pagamento%3A-Arranjo-Pix)
para o recurso.

Entre as principais alterações estão a renomeação dos estados e
a inclusão do estado **CANC** para indicar o cancelamento do pagamento
por parte do usuário, mantendo o estado **RJCT** para transações rejeitadas
pela detentora ou SPI. Ambos devem ser informados pela detentora através
das novas [rotas de v2](#pix).

Além disso, a detentora deverá informar em todas as rotas da versão 2 a
conta do usuário utilizada para o pagamento através do campo *debtorAccount*.

## O que muda na versão 3 da API de Iniciação de Pagamentos?

A principal mudança para pagamento v3 são as validações executadas durante
o processamento assíncrono do consentimento pela detentora que devem obedecer um
domínio especificado aqui: [paymentv3](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/142672139/Informa+es+T+cnicas+-+Pagamentos+-+v3.0.0-beta.2)

## Ações esperadas dos conectores

### paymentsPostPixPayments_v3 WIP

- Validar se proxy é válido e bate com o creditorAccount (se enviado).
- Validar se proxy pertence a um dos creditors cadastrados no consentimento.
- Validar se EndToEndId é válido e não foi reutilizado.
- Validar se QRCode é válido.
- Validar se contas origem e destino são iguais.

**Obs:** retornar erro 422 - DETALHE_PAGAMENTO_INVALIDO em caso positivo.
