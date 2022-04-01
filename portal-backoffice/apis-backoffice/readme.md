# APIs de Backoffice
Esta seção descreve as APIs de consentimento a serem utilizadas para vizualização e revogação por meio do Portal Backoffice do Opus Open Banking (OOB ou O2B) e que podem ser utilizadas como auxiliares para outros sistemas da Instituição.

## Listagem de consentimento

        GET /open-banking/oob-consents/v1/consents

A API de listagem de consentimentos permite a busca apenas relacionadas a um único dono, o qual deve ser identificado em uma das seguintes formas:

- **cpf**: Pessoa física responsável pela criação do consentimento.

- **consent-owner**: Combinação de um conjunto de informações usadas pela Instituição para identificar o dono. Pode ser formada, por exemplo, por agência, conta, CPF, CNPJ etc.

Além disso, as seguintes informações podem ser utilizadas para filtrar o resultado:

- **createdOnBegin**: Indica a data de criação mínima a ser considerada para consulta de consentimentos.

- **createdOnEnd**: Indica a data de criação máxima a ser considerada para consulta de consentimentos.

- **type**: Limita a consulta a consentimentos de pagamento ou de compartilhamento de dados.

- **status**: Limita a consulta a consentimentos no status informado.

- **modalityType**<code><b>\*</b></code>: Limita a consulta a consentimentos de pagamento imediato ou agendado.

- **paymentType**<code><b>\*</b></code>: Limita a consulta a consentimentos de pagamento do tipo PIX, TED ou TEF.

><code><b>\*</b></code>Podem ser utilizados apenas para consultas de consentimentos de pagamento.

## Detalhamento do consentimento

        GET /open-banking/oob-consents/v1/consents/{consentId}

Esta API é responsável por recuperar todas as informações de um consentimento, incluindo um histórico das mudanças de status realizadas. A consulta é feita através do consentID interno no formato UUID.

## Revogação de consentimento

        PATCH /open-banking/oob-consents/v1/consents/{consentId}

Esta API é responsável pela revogação do consentimento relacionado ao consentId informado. É importante ressaltar que esta operação segue todas as regras do Open Banking, permitindo apenas revogação de consentimentos de pagamento agendado até o dia anterior a data de efetivação do mesmo.

## Open API Specification

As definições da API Rest estão definidas em Open API Specification 3.0 [aqui](./oas-oob-consents.yaml).

## Autenticação

Para acessar os endpoints listados aqui deve-se utilizar um token gerado a partir do fluxo *Client Credentials* no Authorization Server não-regulatório. 

A configuração do AS, assim como os detalhes para criação de clients podem ser encontrados na seção de [deploy](../../deploy/oob-authorization-server/readme.md).

Os escopos necessários para acesso estão listados na seção de [segurança](../../segurança/apis/readme.md#oob-consents).


