# Documentação para uso do Connector Tester

Esta documentação tem como objetivo guiar o uso da ferramenta connector tester,
e apresentar um exemplo de montagem de ambiente para execução da mesma.

Índice:

- [Documentação para uso do Connector Tester](#documentação-para-uso-do-connector-tester)
  - [Introdução](#introdução)
  - [Como obter a imagem da ferramenta](#como-obter-a-imagem-da-ferramenta)
  - [Como executar a ferramenta](#como-executar-a-ferramenta)
  - [Como estender a imagem da ferramenta](#como-estender-a-imagem-da-ferramenta)
  - [Changelog](#changelog)

## Introdução

Esta ferramenta tem como finalidade facilitar a construção dos conectores Camel,
que devem fazer a integração com os sistemas de retaguarda, permitindo uma
execução dos conectores desenvolvidos de forma isolada dos contextos de segurança
que o Open Banking exige.

A aplicação possui endpoints REST que representam todos os pontos de integração
de todos os módulos do OOB, e é possível incluir as rotas (os mesmos arquivos Camel
XML que serão usados no ambiente de produção, vide o seguinte [link](../../integração-plugin/readme.md)),
e testar via swagger. Os endpoints não têm lógica de negócio, eles apenas chamam
os conectores exatamente como os módulos do OOB. Os endpoints recebem um json no
formato esperado pelo conector, ou seja, de acordo com a sua especificação. Essa
ferramenta não tem os endpoints no formato openbank que precisam ser transformados
para o formato do conector. Dessa forma, toda informação de input do conector
(consentimento, headers, etc) deve estar presente na chamada do swagger.

A ferramenta é disponibilizada como uma imagem docker, que deve ser estendida com
os templates de mapeamento de request e response e o(s) arquivo(s) de rota(s) que
são responsáveis por direcionar as chamadas aos sistemas de retaguarda da instituição.

## Como obter a imagem da ferramenta

A ferramenta está disponibilizada no ECR da Opus, e pode ser obtida da seguinte maneira:

```sh
docker pull 618430153747.dkr.ecr.sa-east-1.amazonaws.com/opus-open-banking-release/oob-connector-tester:latest
```

![Docker pull connector tester](./images/docker_pull_connector_tester.png)

## Como executar a ferramenta

A imagem da ferramenta pode ser executada sem ser estendida, a partir do seguinte
comando:

```sh
docker run -it -p 8080:8080 618430153747.dkr.ecr.sa-east-1.amazonaws.com/opus-open-banking-release/oob-connector-tester:latest
```

![Docker run connector tester](./images/docker_run_connector_tester.png)

Quando a imagem estiver executando, é possível acessar o swagger da ferramenta a
partir da seguinte URL: <http://localhost:8080/swagger>

![Swagger connector tester](./images/swagger_connector_tester.png)

## Como estender a imagem da ferramenta

No seguinte [link](attachments/connector_tester_environment) está disponibilizado
um ambiente de exemplo da ferramenta. Neste exemplo utilizamos o mockoon como sistema
de retaguarda no teste, usando integrações do Camel fazendo chamadas API Rest. Foi
criada a seguinte estrutura para executar um docker compose, que deverá estender
a imagem original do connector tester e inserir dentro da mesma alguns arquivos de
template e o arquivo de rotas a ser utilizado para direcionar as chamadas.

![Docker compose folder structure](./images/docker_compose_folder_structure.png)

O arquivo dockerfile contém os comandos para copiar os arquivos necessários para
execução da imagem

![Dockerfile](./images/dockerfile.png)

Antes de executar a ambiente é necessário carregar a API mock, utilizando a ferramenta
[mockoon](https://mockoon.com/) para isto, e utilizar o arquivo
[mockoon_api.json](./attachments/connector_tester_environment/mockoon_api.json)
para importar a mesma.

![Mockoon api](./images/mockoon_api.png)

Deve-se alterar também o valor dentro do [arquivo](./attachments/connector_tester_environment/env_variables.env)
de variáveis de ambiente do docker compose, informando a url da API do mockoon
conforme o IP do host do docker.

Para executar o ambiente é necessário acessar o diretório que contém o arquivo
docker-compose.yaml e executar os seguintes comandos:

```sh
docker-compose build
docker-compose up
```

![Docker compose build up](./images/docker-compose_build_up.png)

Acessar o seguinte endereço para carregar o swagger da ferramenta: <http://localhost:8080/swagger>

Para este exemplo, iremos executar o endpoint de criar iniciação de pagamento:

![Swagger post payment](./images/swagger_post_payment.png)

Dentro do exemplo há um arquivo de nome [request_example.json](./attachments/connector_tester_environment/request_example.json)
com o request para esta chamada; o conteúdo do arquivo deve ser enviado no payload
da chamada no swagger, sendo que a resposta para a chamada realizada será:

![Swagger post payment response](./images/swagger_post_payment_response.png)

```json
{
  "data": {
    "paymentId": [
      {
        "key": "instPayId",
        "value": "e33b469a-c121-41b4-87d1-b2c0947c108a"
      }
    ],
    "endToEndId": "E9040088820210128000800123348752",
    "creationDateTime": "2021-10-05T18:00:00Z",
    "statusUpdateDateTime": "2021-10-05T18:00:00Z",
    "localInstrument": "DICT",
    "proxy": "12345678901",
    "status": "PDNG",
    "payment": {
      "amount": "123.45",
      "currency": "BRL"
    },
    "remittanceInformation": "Teste criar pagamento",
    "creditorAccount": {
      "ispb": "12345678",
      "issuer": "1774",
      "number": "6251965162",
      "accountType": "CACC"
    },
    "cnpjInitiator": "00000000000191"
  }
}
```

## Changelog

### 2022-03-04 - v1.2.0

- Novas rotas referentes à funcionalidade de agendamento adicionadas

### 2021-12-23 - v1.1.0

- Complementação do exemplo do uso da ferramenta, implementando
todas as rotas existentes na mesma
- Atualização das imagens da documentação

### 2021-11-05 - v1.0.1

- Correção do bug que concatenava os paths das rotas do Camel XML com os endpoints
de consentimento chamados no swagger
- Correção da URL para baixar a imagem da ferramenta

### 2021-10-07 - v1.0.0

- Versão inicial da documentação
