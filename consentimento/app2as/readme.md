# Integração via aplicativo mobile para Geração de Consentimento

A integração por aplicativo mobile para a geração do consentimento é a melhor
experiência de uso para o cliente da instituição, permitindo a inclusão das
funcionalidades de Open Banking dentro do aplicativo mobile da instituição já
familiar ao cliente final.

A Geração do Consentimento é um momento crítico, inserido no meio do fluxo de
OIDC e exigindo integrações não tradicionais, em especial o início da Geração do
Consentimento que é justamente o início do fluxo de redirects do hybrid flow OIDC.

## Open API Specification

As definições da API Rest estão definidas em Open API Specification 3.0 [aqui](../oas-webapp2as.yaml).

## Deep Link e Universal Link

O aplicativo da instituição precisa interceptar as chamadas dos TPPs ao
Authorization Server quando essas ocorrem no celular do usuário, permitindo
dessa forma realizar a geração do consentimento no aplicativo.

O aplicativo também pode ser acionado durante fluxo hybrid flow com Hand-off,
onde o usuário está utilizando o TPP no desktop e a instituição só possui
autenticação através do seu aplicativo. Nesse cenário o Authorization Server
(AS) do Opus Open Banking (OOB) exibirá um QR-code com uma URL que também deve
ser interceptada pelo aplicativo. Utilizar uma URL interceptável pelo aplicativo
permite o usuário realizar a leitura do QR-code através de qualquer aplicativo
além do próprio da instituição.

Desta forma, temos dois padrões de URLs que precisam ser interceptados pelo
aplicativo da instituição como vemos na tabela abaixo:

| Origem                       | URL                                                    |
| ---------------------------- | ------------------------------------------------------ |
| Mesmo dispositivo            | `https://<EV-FQDN-open-banking>/auth/auth`             |
| Outro dispositivo (Hand-Off) | `https://<EV-FQDN-open-banking>/auth/handoff/{id}`     |

### O que fazer ao interceptar uma URL?

Uma vez que a aplicação está interceptando as URLs e sendo acionada durante uma
solicitação de consentimento, o próximo passo é realizar todo tratamento da
geração do consentimento de fato.

De posse de uma URL interceptada, o primeiro passo é realizar o request `GET`
de fato na URL acionada, incluindo todos os parâmetros de query-string que
possam existir, adicionado o header `Accept` com o valor
`application/json`, esse header informa o AS que a chamada está sendo realizada
pelo aplicativo e não pelo navegador.

O AS sabendo que a chamada foi realizada pelo aplicativo através do header
`Accept` passará a funcionar como uma API Rest, respondendo os requests
sempre no formato JSON. A adição do header é obrigatória em todas as chamadas
entre o aplicativo da instituição e o AS do OOB.

A resposta do `GET` inicial é o primeiro de uma série de comandos que o
aplicativo deve executar durante um loop de eventos vindos do AS. A definição
deste loop de eventos pode ser conferida [neste link](../loop-comandos.md).

## Diagrama de sequência

O diagrama de sequência a seguir ilustra de forma resumida o funcionamento entre
o aplicativo mobile da instituição e o AS conforme descrito no loop de comandos.

![Diagrama de sequência](images/sequencia-app2as.svg)

## Mock para integração

O mock para auxiliar no desenvolvimento da integração está disponível na
ferramenta [Mockoon](https://mockoon.com/) e definido nesse [arquivo JSON](./mockoon.json).

Vários cenários estão mockados e são acionados através das respectivas URLs iniciais:

| Cenário                                     | URL para iniciar processo                         |
| ------------------------------------------- | ------------------------------------------------- |
| Hybrid-flow / Pagamento                     | <http://localhost:3301/auth/auth?id=standard>     |
| Hybrid-flow hand-off / Pagamento            | <http://localhost:3301/auth/app/commands/handoff> |
| Hybrid-flow / CPF_MISMATCH na autenticação  | <http://localhost:3301/auth/auth?id=cpf>          |
| Hybrid-flow / CONSENT_EXPIRED no link inicial | <http://localhost:3301/auth/auth?id=expired>      |
| Hybrid-flow / GENERIC_ERROR no link inicial | <http://localhost:3301/auth/auth?id=generic>      |

Para executar o mock basta importar o JSON na ferramenta Mockoon e iniciar o
servidor do _environment_ "OOB Authroization Server Apps API".

## Changelog

### 2022-01-11 - v2.1.5

- Isolando a definição do loop de comandos em uma outra página.

### 2021-12-13 - v2.1.4

- Alteração do caminho de envio da solicitação de autenticação do usuário.

### 2021-11-30 - v2.1.3

- Adição das informações da propriedade redirectTo para casos de erro.

### 2021-10-15 - v2.1.2

- Adição da estrutura do Jwt recebido no comando authenticate ao [oas-webapp2as.yaml](../oas-webapp2as.yaml).

### 2021-10-01 - v2.1.1

- Mock da nova interface
- Adição das informações do TPP (nome e logotipo) em todos os comandos
- Remoção das inforamções do TPP do ConsentCommand
