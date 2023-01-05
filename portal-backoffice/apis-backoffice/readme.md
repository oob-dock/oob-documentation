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
incluindo um histórico das mudanças de status realizadas. A consulta é feita através
do identificador interno em formato UUID.

## Revogação de consentimento (Deprecated)

        PATCH /open-banking/oob-consents/v1/consents/{consentId}

A utilização é equivalente a da revogação de consentimento de pagamento abaixo
mas esse endpoint será descontinuado.

## Revogação de consentimento de pagamento

        PATCH /open-banking/oob-consents/payments/v1/consents/{consentId}

Responsável pela revogação do consentimento relacionado ao *consentId* informado.

**Importante**: é permitida revogação de consentimentos de pagamento agendado APENAS
até o dia anterior a data de efetivação dele.

## Revogação de consentimento de compartilhamento de dados

        PATCH /open-banking/oob-consents/consents/v1/consents/{consentId}

Responsável pela revogação do consentimento relacionado ao *consentId* informado.

## Listagem de consentimentos ativos de compartilhamento de dados

        GET /open-banking/oob-consents/consents/v2/active

Responsável pela listagem de consentimentos autorizados.

## Revogação de pagamento

        PATCH /open-banking/oob-payment/v2/pix/payments/{paymentId}

Responsável pela revogação do pagamento relacionado ao *paymentId* informado.
## Autenticação

Para acessar os endpoints listados aqui deve-se utilizar um token gerado a partir
do fluxo *Client Credentials* no caminho base não-regulatório do Authorization Server.

A configuração do AS, assim como os detalhes para criação de clients podem ser
encontrados na seção de [deploy](../../deploy/oob-authorization-server/readme.md).

Os escopos necessários para acesso estão listados na seção de [segurança](../../segurança/apis/readme.md#oob-consents).

## Observações

- `*1`: Podem ser utilizados apenas para consultas de consentimentos de pagamento.
