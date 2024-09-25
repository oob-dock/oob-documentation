# APIs de Backoffice

Esta seção descreve as APIs de visualização e revogação de consentimento para o
Portal Backoffice do Opus Open Banking.

## Open API Specification

As definições da API Rest em formato Open API Specification 3.0 podem ser encontradas
[aqui](./oas-oob-consents.yaml).

## Listagem de consentimento

        GET /open-banking/oob-consents/v1/consents

A API de listagem de consentimentos permite a listagem dos consentimentos ligados
a um dono, o qual deve ser identificado em uma das seguintes formas:

`cpf`: Identifica a pessoa física responsável pela criação do consentimento.
Deve conter apenas os dígitos.

**Exemplo**: *99999999999*.

`consent-owner`: Conjunto de informações definidas pela Instituição para identificar
o dono do consentimento como, por exemplo, agência, conta, CPF, CNPJ etc.
É representado por um dicionário *chave/valor* em formato *JSON URL Encoded*.

**Exemplo**: Para um identificador formado por agência e conta:

```json
[{"key": "conta", "value": "12345"}, {"key": "agencia", "value": "12345"}]
```

**Json URL encoded**:

```text
%5B%7B%22key%22%3A%20%22conta%22%2C%20%22value%22%3A%20%2212345%22%7D%2C%20%7B%22key%22%3A%20%22agencia%22%2C%20%22value%22%3A%20%2212345%22%7D%5D
```

Além disso, as seguintes informações podem ser utilizadas para filtrar o resultado:

`createdOnBegin`: Indica a data de criação mínima (inclusa) para consulta de consentimentos.
Deve ser informada com data e hora no formato especificado na [RFC-3339](https://datatracker.ietf.org/doc/html/rfc3339).

**Exemplo**: 2022-12-19T16:39:57Z.

`createdOnEnd`: Indica a data de criação máxima (inclusa) para consulta de consentimentos.
Deve ser informada com data e hora no formato especificado na [RFC-3339](https://datatracker.ietf.org/doc/html/rfc3339).

**Exemplo**: 2023-01-19T16:39:57-01:00.

`type`: Limita a consulta a consentimentos de pagamento ou de compartilhamento de
dados representados, respectivamente, pelos valores *PAYMENT* e *DATA_SHARING*.

`status`: Limita a consulta a consentimentos no status informado. Para consentimentos
de pagamento, suporta os valores definidos na [máquina de estados do Open Banking](https://openbankingbrasil.atlassian.net/wiki/spaces/DraftOB/pages/50346765/M+quina+de+Estados+-+Pagamentos+-+v1.1.0-rc1.0).
Para consentimentos de compartilhamento de dados, suporta os valores *AWAITING_AUTHORISATION*,
*AUTHORISED* e *REJECTED* que variam conforme seu [fluxo básico](https://openbanking-brasil.github.io/areadesenvolvedor/documents/fluxo_basico_consentimento.pdf).

`modalityType`[*1](#observações): Limita a consulta a consentimentos de pagamento
imediato ou agendado representados, respectivamente, pelos valores *IMMEDIATE* e
*SCHEDULED*.

`paymentType`[*1](#observações): Limita a consulta a consentimentos de pagamento.
Suporta os tipos: *PIX*, *TED* ou *TEF*.

## Detalhamento do consentimento

        GET /open-banking/oob-consents/v1/consents/{consentId}

Esta API é responsável por recuperar todas as informações de um consentimento,
incluindo os recursos e um histórico das mudanças de status realizadas. A consulta é feita através
do identificador interno em formato UUID.

## Revogação de consentimento (Deprecated)

        PATCH /open-banking/oob-consents/v1/consents/{consentId}

A utilização é equivalente a da revogação de consentimento de pagamento abaixo
mas esse endpoint será descontinuado.

## Revogação de consentimento de compartilhamento de dados

        PATCH /open-banking/oob-consents/consents/v1/consents/{consentId}

Responsável pela revogação do consentimento relacionado ao *consentId* informado.

## Listagem de consentimentos ativos de compartilhamento de dados

        GET /open-banking/oob-consents/consents/v2/active

Responsável pela listagem de consentimentos autorizados. Possui dois parâmetros opcionais:
- startDate: Caso fornecido, seleciona todos os consentimentos ativos que tenham sido criados após essa data.
- endDate: Caso informado, seleciona todos os consentimentos cuja a expiração seja anterior a data fornecida.
  - Consentimentos indeterminados não serão retornados quando esse parâmetro for informado.
- page: Número da página desjada.
- page-size: Tamanho da página.

## Listagem de pagamentos relacionados a um consentimento

        GET /open-banking/oob-consents/consents/v1/consents/{consentId}/payments

Exibe a lista de todos os pagamentos relacionados ao consentimento identificado pelo *consentId* informado

## Revogação de consentimento de pagamento

        PATCH /open-banking/oob-consents/payments/v1/consents/{consentId}

Responsável pela revogação de consentimentos de pagamento automático identificado pelo *consentId* informado.

## Revogação de pagamento

        PATCH /open-banking/oob-payments/v2/pix/payments/{paymentId}

Responsável pela revogação do pagamento relacionado ao identificador do open-banking *paymentId* informado.

## Listagem de Payment Ids gerados por ITP

        GET /open-banking/oob-consents/v1/tpps/payment-legacy-ids

Lista os payment ids gerados por ITPs dentro de um intervalo de tempo definido pelos
parâmetros:

`startDate`: Indica a data de criação mínima (inclusa) do payment id. Deve ser informada
apenas com data.

**Exemplo**: 2022-12-19.

`endDate`: Indica a data de criação máxima (inclusa) do payment id. Deve ser informada
apenas com data.

**Exemplo**: 2022-12-25.

## Notificação de mudança de status de pagamento

        POST /open-banking/oob-consents/v1/payment-status-notification

Responsável por notificar ao OOB a alteração de status de um pagamento.

## Detalhamento de prorrogação do consentimento

        GET /open-banking/oob-consents/v1/consents/{consentId}/extends

Esta API é responsável por listar todas as prorrogações de um consentimento.
A consulta é feita através do identificador interno em formato UUID.

## Autorização completa de consentimento de pagamento de múltipla alçada

        POST /open-banking/oob-consents/v1/payments/consents/{consentId}/authorisation

Esta API é responsável por autorizar completamente um consentimento de pagamento
de múltipla alçada sinalizando a aprovação dos múltiplos autorizadores deste consentimento.

## Post de search key

        POST /open-banking/oob-consents/consents/v1/consents/{consentId}/search-key/{searchKey}

Esta API é responsável por adicionar um search-key relacionada a um consentimento
permitindo que consentimentos sejam listados com base nessa search-key posteriormente.

## Delete de search key

        DELETE /open-banking/oob-consents/consents/v1/consents/{consentId}/search-key/{searchKey}

Esta API é responsável por deletar uma search-key relacionada a um consentimento.

## Put consent metadata

        PUT /open-banking/oob-consents/consents/v1/consents/{consentId}/meta-data

Esta API é responsável por adicionar um json de metadata vinculado a um consentimento,
substituindo qualquer valor que esteja anteriormente nesse campo de metadata.
Pode ser usado para de adição de informações extras ao consentimento,
por exemplo para adicionar informações pertinentes as telas da aplicação.

## Get consent metadata

        GET /open-banking/oob-consents/consents/v1/consents/{consentId}/meta-data

Esta API é responsável por recuperar o json de informações de metadata previamente
enviado.

## Patch consent metadata

        Patch /open-banking/oob-consents/consents/v1/consents/{consentId}/meta-data

Esta API é responsável por atualizar o json de metadata vinculado a um consentimento,
adicionando informação ao metadata já existente.

## Delete consent metadata

        DELETE /open-banking/oob-consents/consents/v1/consents/{consentId}/meta-data

Esta API é responsável por apagar as informações de metadata relacionada
a um consentimento.

## Revogação de vínculo

        PATCH /open-banking/oob-consents/enrollments/v1/enrollments/{enrollmentId}

Esta API é responsável por revogar um vínculo, retornando os detalhes do mesmo e o histórico de mudanças de status realizadas. A revogação é feita através do identificador interno do vínculo formato UUID.

## Autenticação

Para acessar os endpoints listados aqui deve-se utilizar um token gerado a partir
do fluxo *Client Credentials* no caminho base não-regulatório do Authorization Server.

A configuração do AS, assim como os detalhes para criação de clients podem ser
encontrados na seção de [deploy](../../deploy/oob-authorization-server/readme.md).

Os escopos necessários para acesso estão listados na seção de [segurança](../../segurança/apis/readme.md#oob-consents).

## Observações

- `*1`: Podem ser utilizados apenas para consultas de consentimentos de pagamento.
