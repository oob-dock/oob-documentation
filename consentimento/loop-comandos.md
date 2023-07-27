# Loop de comandos

O aplicativo mobile ou web da instituição será guiado pelo AS do
OOB pelo fluxo do consentimento através da execução de um conjunto de tarefas.
Nesta documentação e nas auxiliares, chamamos essas tarefas de `command`s.

Atualmente, o AS possui os seguintes `command`s:

| Command      | Ação do aplicativo                                                                     | Finaliza o loop |
| ------------ | -------------------------------------------------------------------------------------- | --------------- |
| authenticate | Solicitar autenticação ao usuário                                                      | Não             |
| consent      | Exibir a solicitação do TPP, pedindo o consentimento e escolhas de produtos ao usuário | Não             |
| error        | Exibir mensagem de erro e iniciar fluxo de retorno ao TPP                              | Sim             |
| completed    | Exibir mensagem de sucesso e iniciar fluxo de retorno ao TPP                           | Sim             |

Ao iniciar o fluxo de geração de consentimento, o aplicativo irá receber um dos
comandos acima. O comando seguinte é determinado pela resposta do AS à execução
do anterior, até que um comando que finaliza o loop seja executado.

**Importante**: Não existe uma sequência predeterminada de `command`s
a serem executados.

A definição das APIs utilizadas para execução dos comandos está disponível em
[Open API Specification](./oas-webapp2as.yaml).

## Comando *authenticate*

É enviado pelo AS ao aplicativo para solicitar a autenticação do usuário.

O aplicativo deverá garantir o [requisito mínimo de segurança](https://openbanking-brasil.github.io/specs-seguranca/open-banking-brasil-financial-api-1_ID3-ptbr.html#section-5.2.2.4)
definido pelo AS através do campo `acr` do comando, conforme exemplo abaixo:

```json
{
    "command": "authenticate",
    "commandId": "identifier",
    "tpp": {
        "name": "Nome TPP",
        "logoUrl": "https://upload.wikimedia.org/wikipedia/commons/4/4f/SVG_Logo.svg"
    },
    "type": "PAYMENT",
    "authenticateCommand": {
        "acr": "urn:brasil:openbanking:loa3",
        "jti": "94a328c2-c72a-4cab-84a2-2df2b106b2af"
    }
}
```

O *ACR* pode ter os seguintes valores:

- `urn:brasil:openbanking:loa2`: LoA2 (Level of Assurance 2) que exige que usuário
seja autenticado com no mínimo um fator de autenticação.

- `urn:brasil:openbanking:loa3`: Exige o uso de no mínimo dois fatores de autenticação.

Caso o usuário tenha se autenticado corretamente, a instituição deve emitir um
token JWT assinado e envia-lo ao AS através da API
`PUT /app/commands/{id}/authentication`, onde o `id` é o `commandId` do comando executado.

**Importante**: O token JWT não deve ser assinado no aplicativo, evitando a exposição
da chave privada de assinatura. A chave pública utilizada deve ser exposta via
URL contendo o *JWKS* a ser configurada através da propriedade [`customer/federationJwksUrl`](../deploy/oob-authorization-server/readme.md#customerfederationjwksurl).

O JWT deve possuir as claims abaixo, sendo obrigatórias aquelas marcadas com asterisco:

- `cpf`**\***: CPF do usuário logado contendo apenas dígitos.

- `name`**\***: Nome do usuário logado.

- `cnpj`: CNPJ da instituição relacionada ao usuário logado contendo apenas dígitos.

- `iat`**\***: Data e hora de emissão do JWT no formato *EPOCH*.

- `jti`**\***: Identificador único do token em formato *UUID* utilizado para evitar
*replay-attacks*. Deve ser preenchido com o mesmo valor recebido do AS no comando.

- `authExtraData`: Cojunto de informações extras relacionadas ao usuário logado
representadas por um array de dicionários *chave/valor* com dois campos obrigatórios,
`key` e `value`. Deve ser usado para envio das credenciais do usuário caso
a instituição não utilize *cpf* ou *cnpj* para autenticação.

- `consentOwner`: Conjunto de informações definidas pela instituição para
identificar o dono do consentimento como, por exemplo, agência, conta, CPF e/ou
CNPJ. É formado por um array de dicionários *chave/valor* com dois campos obrigatórios,
`key` e `value`. Este campo é utilizado para a consulta do consentimento
via [API de Backoffice](../portal-backoffice/apis-backoffice/readme.md).

**Importante**: Caso a claim `consentOwner` não seja enviada, a solução OOB
irá utilizar o `cpf` e `cnpj` do usuário logado para definir o dono do consentimento.

Um exemplo do conteúdo do JSON a ser utilizado no token JWT:

```JSON
{
    "iat": 1618664738,
    "jti": "e8f172c9-6f83-4d36-9dbb-e3ce7ca8a39b",
    "cpf": "32180490089",
    "cnpj": "77202036000182",
    "name": "João Maria José",
    "authExtraData": [
        {
            "key": "agencia",
            "value": "1234"
        },
        {
            "key": "conta",
            "value": "1234-5"
        }
    ],
    "consentOwner": [
        {
            "key": "conta",
            "value": "542345234"
        },
        {
            "key": "cnpj",
            "value": "77202036000182"
        }
    ]
}
```

## Comando *consent*

Requisita a exibição da intenção do consentimento solicitado pelo TPP à instituição.
As informações do consentimento são retornadas juntamente com o comando,
além das informações do próprio TPP, da marca da instituição (para instalações
com suporte a multimarca) e, para consentimentos de compartilhamento de dados,
informações descritivas das permissões e tipos de recursos solicitados.

O papel do aplicativo nesse ponto é exibir a solicitação do TPP ao usuário e
coletar o consentimento do mesmo além da escolha dos recursos selecionáveis.

Consentimentos de compartilhamento de dados podem tratar diversos tipos de
recursos simultaneamente, e vários desses tipos podem ser recursos
selecionáveis. Os recursos selecionáveis devem ser exibidos para o usuário
escolher o compartilhamento ou não de cada produto.

Consentimentos de iniciação de pagamento tratam exclusivamente do recurso
"payment", esse tipo de recurso foi criado internamente no OOB para permitir
diversos produtos como origem financeira nos pagamentos, desvinculado a
exclusividade do uso de contas correntes/poupança. Os recursos de "payment"
possuem duas propriedades extras para trafegar o saldo e a moeda do saldo
permitindo o aplicativo exibir o mesmo para facilitar o usuário na escolha da
origem financeira para o pagamento em questão.

É importante seguir o [Guia de Experiência](https://openbanking-brasil.github.io/areadesenvolvedor/#guia-de-experiencia-de-compartilhamento-de-dados-e-iniciacao-de-pagamento)
do Usuário do Open Banking Brasil nessa etapa.

Os recursos selecionados e por consequência o aceite do consentimento devem ser
enviados ao AS através da API `PUT /app/command/{id}/consent`.

### Produtos não selecionáveis

Diferentemente dos demais produtos, os produtos não selecionáveis são
compartilhados com base nas permissões fornecidas no consentimento
de compartilhamento de dados. Portanto durante a aprovação do consentimento
não é feita a seleção deles.

## Comando *error*

Indica a ocorrência de algum erro durante o fluxo de autenticação OIDC.
O erro é descrito no comando, podendo ser erros conhecidos do processo do Open
Banking ou erros inesperados conforme vemos na tabela a seguir.

| Código do Erro                               | Descrição                                                                                                   |
| -------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| CPF_MISMATCH                                 | CPF do usuário autenticado diverge do enviado pelo TPP na intenção do consentimento                         |
| CNPJ_MISMATCH                                | CNPJ do usuário autenticado diverge do enviado pelo TPP na intenção do consentimento                        |
| EXPIRED_CONSENT                              | Consentimento expirado                                                                                      |
| INVALID_SESSION                              | Sessão não existe ou expirou devido ao tempo limite de 10 minutos                                           |
| RESOURCE_MUST_CONTAIN_ID                     | Lista de recursos na aprovação do consentimento deve conter pelo menos um ID                                |
| RESOURCE_MUST_CONTAIN_ID_SELECTABLE_PRODUCTS | Lista de recursos na aprovação do consentimento deve conter pelo menos um ID para cada produto selecionável |
| DISCOVERY_ERROR                              | Falha no processo de discovery                                                                              |
| DISCOVERY_TIMEOUT                            | Processo de discovery passou do tempo limite                                                                |
| INVALID_STATUS_CONFIRMATION                  | Status do consentimento não é valido para realizar a confirmação                                            |
| GENERIC_ERROR                                | Erro genérico do AS, o campo `message` possui a descrição do erro que deve ser exibida ao usuário           |

O comando `error` conclui a geração do consentimento. Nos casos
de handoff o aplicativo deve apenas exibir a mensagem de erro ao usuário e
encerrar o processo da geração do consentimento. A página no dispositivo que
iniciou o processo de consentimento irá retornar automaticamente para o TPP
informando o motivo do erro do consentimento.

Já o caso de hybrid flow tradicional, a aplicação, além de exibir a mensagem de
erro, também deve solicitar que o sistema operacional do dispositivo abra a URL
de retorno enviada no comando, garantindo que o TPP seja informado do motivo do
erro e retome fluxo conforme o esperado pelo Guia de Experiência do Open Banking.

A propriedade `isHandOff` indica se o fluxo é um hybrid flow com handoff e para
os casos de que o valor for `false`, a propriedade `redirectTo`, quando retornada,
contém a URL que deve ser aberta no sistema operacional do dispositivo para
retorno ao TPP.

O aplicativo deve orientar o usuário adequadamente para os cenários que a propriedade
`redirectTo` não esteja presente.

## Comando *completed*

Indica a conclusão com sucesso do fluxo de geração do consentimento.

O tratamento é o mesmo do comando `error` porém a mensagem a ser exibida ao
usuário é do sucesso do consentimento. O tratamento de retorno ao TPP deve
ser seguido como descrito no `error`.

## Changelog

### 2023-07-27 - v1.2.2

- Adição do novo command error INVALID_STATUS_CONFIRMATION.

### 2023-05-15 - v1.2.1

- Adição do novo command error DISCOVERY_TIMEOUT.

### 2023-02-15 - v1.2.0

- Adição do campo *type* (tipo do consentimento) no retorno do command authenticate.

### 2022-11-09 - v1.1.2

- Adição do novo códigos de erro RESOURCE_MUST_CONTAIN_ID_SELECTABLE_PRODUCTS.

### 2022-08-25 - v1.1.1

- Adição de novos códigos de erro.

### 2022-04-06 - v1.1.0

- Adição da nova claim `consentOwner` no JSON do token JWT para utilização no
command authenticate.

### 2022-01-24 - v1.0.1

- Adição da nova claim `authExtraData` no JSON do token JWT para utilização
no command authenticate.

### 2022-01-11 - v1.0.0

- Versão inicial do arquivo.
