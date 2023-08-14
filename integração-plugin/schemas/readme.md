# Definição de interfaces de conectores (Schemas)

Definição do formato das mensagem enviadas e recebidas pelos conectores no
formato json schema.

As definições seguem a estrutura de pastas **versão**/**nome_módulo**/**endpoint**

Onde:

- **versão**: Versão da interface (detalhada abaixo).

- **nome_módulo**: Nome do módulo da plataforma OOB onde o conector deve ser inserido.

- **endpoint**: Nome do endpoint que representa uma rota ou ponto de integração
  entre o OOB e os sistemas internos.

Dentro de cada um desses diretórios estão presentes a definição do objeto de
request (que será enviado para o conector), do objeto de response (que deve ser
retornado pelo conector em caso de sucesso ao realizar a operação) e do objeto de
erro (que deve ser retornado pelo conector em caso de falha). Nos casos onde o
retorno de erro não está definido, deve-se usar o formado padrão, descrito no
arquivo `response-error-schema.json`.

Os diretórios `common` possuem a definição de objetos utilizados em mais de um
ponto de integração.

## Definição de versão dos artefatos

Os artefatos são versionados no padrão semantic versioning (SemVer):

\<**Major**\>.\<**Minor**\>.\<**Patch**\>

Onde:

- **Major**: Incrementado quando a versão das interfaces possui incompatibilidades
  com a versão anterior. Ou seja, os conectores precisarão sem alterados para
  trabalhar com a nova versão do OOB. Para cada nova versão major um diretório é
  criado, dessa forma é possível acessar as versões anteriores.

- **Minor**: Incrementado quando a interface foi alterada mas ainda é compatível
  com as versões anteriores dentro da mesma Major. Os conectores podem ser
  alterado para utilizar as alterações, mas não é obrigatório.

- **Patch**: Incrementado quando uma alteração é feita nos documentos sem
  alterar a interface, como a correção em uma descrição, exemplo de preenchimento
  ou detalhamento do formato. Os conectores podem ser alterado para utilizar as
  alterações, mas não é obrigatório.

## Changelog

### 2023-08-14 - v3.2.0

- Inclusão dos schemas de investments versão 1
  - bank-fixed-incomes
  - credit-fixed-incomes
  - variable-incomes
  - funds
  - treasure-titles

### 2023-07-28 - v3.1.0

- Consent
  - Incluisão das rotas para a versão 2 de discovery da fase 3
    - discoverPayments_v2: Discovery de pagamento

### 2023-07-20 - v3.0.0

- Adição de schemas de iniciação de pagamentos versão 3
  - Payment
    - Alteração de enum de erros
    - Alteração de enum de rejectionReason
  - Consent
    - Alteração de enum de erros
    - Alteração de pattern em creditor.name
    - Adição de enum rejectionReason

### 2022-11-30 - v2.10.0

- Consent
  - Criação da rota paymentsGetPixPaymentsPaymentId_v2 com os novos objetos de
   erro da versão 2 das apis de pagamento
  - Remoção da rota revokeConsentPayment
- Payment
  - Atualização do pattern dos campos de requisição e resposta
  - Incluisão das rotas para a versão 2 da fase 3:
    - paymentsGetPixPaymentsPaymentId_v2: Consulta de pagamento
    - paymentsPatchPixPayments_v2: Cancelamento do pagamento
    - paymentsPostPixPayments_v2: Criação da iniciação do pagamento

### 2022-10-06 - v2.9.0

- Payment
  - Torna obrigatório o campo endToEndId no schema de criação de pagamento

### 2022-09-02 - v2.8.0

- Payment
  - Inclusão do campo endToEndId no schema de criação de pagamento

### 2022-04-27 - v2.7.0

- Consent
  - Inclusão do campo externalId no schema de revogação de consentimento

### 2022-04-12 - v2.6.2

- Consent
  - Inclusão do campo consentOwner no schema comum do consentimento
  - Inclusão do campo consentOwner no schema consentimento de pagamento
  - Inclusão do campo consentOwner no request de exemplo do discovery de pagamento

### 2022-03-16 - v2.6.1

- Geral
  - Adicionadas novas definições compartilhadas
- Consent
  - Alteração dos schemas para utilizar as novas definições compartilhadas
- Payment
  - Alteração dos schemas para utilizar as novas definições compartilhadas

### 2022-03-07 - v2.6

- Consent
  - Inclusão do schema de consentimento para TED/TEF
- Payment
  - Inclusão dos schemas para criar solicitação e consulta de status de pagamento
  TED/TEF

### 2022-03-03 - v2.5.3

- Geral
  - Correção de inconsistências nos schemas compartilhados
- Consent
  - Ajustes no schema da rota checkPaymentStatus para utilizar definições compartilhadas
  - Ajustes na resposta da rota revokeConsentPayment para utilizar o enum correto
   no campo action
- Payment
  - Ajustes no schema compartilhado de payment para criar definições compartilhadas

### 2022-02-25 - v2.5.2

- Consent
  - Inclusão do campo purpose no schema comum do consentimento
  - Inclusão do campo purposeAdditionalInfo no schema comum do consentimento

### 2022-02-15 - v2.5.1

- Consent
  - Adicionado código de erro AGENDAMENTO_INVALIDO na criação do consentimento
  - Ajustes nas descrições dos erros para revogação de consentimento

### 2022-01-13 - v2.5.0

- Geral
  - Inclusão do campo schedule no consentimento de pagamento
- Payment
  - Adicionado status SASP e SASC para pix agendado e rejectionReason CONSENT_REVOKED

### 2022-01-26 - v2.4.2

- Consent
  - Inclusão do campo authExtraData no schema comum do consentimento
  - Inclusão do campo authExtraData no schema consentimento de pagamento
  - Inclusão do campo authExtraData no request de exemplo do discovery de pagamento

### 2022-01-05 - v2.4.1

- Payment
  - Alteração do campo transactionIdentification para ter tamanho máximo de 35 caracteres

### 2021-11-03 - v2.4.0

- Consent
  - Inclusão do campo restrictionType no retorno de erro do approvePaymentConsentCreation

### 2021-10-18 - v2.3.0

- Consent
  - Inclusão de um novo ponto de integração para aprovar a criação de
    consentimentos de pagamento (approvePaymentConsentCreation)

### 2021-10-14 - v2.2.0

- Consent
  - Adição do campo FailingResources no schema comum do consentimento
  - Adição do campo FailingResources no schema do consentimento para integração
    com o aplicativo da instituição.
  - Adição do campo defaultSelected na definição AvailableResources no schema
    comum do consentimento

### 2021-10-06 - v2.2.0

- Consent
  - Adição do campo authorizers na definição AcceptedResources no schema comum do
    consentimento

### 2021-10-01 - v2.1.1

- Consent
  - Adição dos campos balanceCurrency e balanceAmount no schema do consentimento
    para integração com o aplicativo da instituição

### 2021-09-30 - v2.1.0

- Geral
  - Correção da url do schema utilizado para o draft 07
- Consent
  - Ajuste de erro de sintaxe no exemplo de request de discoverPayments
- Payment
  - Ajuste nas quantidades mínima e máxima de itens no campo PaymentId para
    1 e 10 respectivamente
  - Inclusão dos campos abaixo como obrigatórios no schema de request da operação
    paymentsPostPixPayments:
    - requestMeta
  - Remoção dos campos abaixo como obrigatórios no schema de request da operação
    paymentsPostPixPayments:
    - correlationId
    - brandId
  - Ajuste do campo code da definição ResponseErrorCreatePixPayment no schema de
    erro da operação paymentsPostPixPayments
  - Inclusão dos campos abaixo como obrigatórios no schema de request da operação
    paymentsGetPixPaymentsPaymentId:
    - requestMeta
  - Remoção dos campos abaixo como obrigatórios no schema de request da operação
    paymentsGetPixPaymentsPaymentId:
    - correlationId
    - brandId

### 2021-09-21 - v2.0.0

- Geral
  - Reestruturação dos arquivos de schema
  - Reestruturação do objeto de consentimento
    - Separação dos schemas de consentimento de compartilhamento de dados e pagamentos
    - Criação do consent-customer-acceptance para ser utilizado na interface de
      consentimento para o cliente (não utilizado nos conectores)
    - Alteração na estrutura de dados para se aproximar do formato da especificação
      do Open Banking Brasil
    - Substituição do campo tppName pelo campo tpp contendo um objeto com dados do
      tpp
  - Inclusão do campos abaixo no consentimento de pagamento:
    - details
    - ibgeTownCode
- Consent
  - Inclusão do campo data no retorno do discovery de pagamento, onde estará o
    objeto de resposta, **tornando essa versão incompatível com interfaces na
    versão 1.x.x**
  - Inclusão do campo requestMeta nos requests. Os campos correlationId e brandId
    foram movidos para este novo objeto **tornando essa versão incompatível com
    interfaces na versão 1.x.x**
- Payment
  - Remoção dos campos abaixo nos reponses:
    - consentId
    - correlationId
  - Remoção dos campos abaixo nos requests:
    - brandName
  - Remoção do header consent dos requests, **tornando essa versão incompatível
    com interfaces na versão 1.x.x**
  - Inclusão do campo consent nos requests
  - Inclusão dos campos abaixo no request de iniciação de pagamento PIX:
    - transactionIdentification
    - ibgeTownCode
  - Inclusão dos campos abaixo nos responses de iniciação e consulta de
    pagamento PIX:
    - transactionIdentification
    - ibgeTownCode
  - Inclusão do campo requestMeta nos requests. Os campos correlationId e brandId
    foram movidos para este novo objeto **tornando essa versão incompatível com
    interfaces na versão 1.x.x**
