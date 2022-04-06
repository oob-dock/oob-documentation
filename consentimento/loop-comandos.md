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

>**Importante**: Não existe uma sequência pré-determinada para execução dos `command`s.
Os comandos possuem o mesmo *schema* de resposta que contêm o comando seguinte a
ser executado.

A definição das APIs utilizadas para execução dos comandos está disponível em
[Open API Specification](./oas-webapp2as.yaml).

## Comando `authenticate`

O comando `authenticate` é enviado pelo AS ao aplicativo para solicitar a
autenticação do usuário. É importante garantir os requisitos de segurança do
Open Banking Brasil definidos no atributo ACR do comando.

O ACR pode ser `urn:brasil:openbanking:loa2` ou `urn:brasil:openbanking:loa3`,
de forma reduzida o LoA2 (Level Of Assurance 2) exige que o usuário utilize no
mínimo um fator de autenticação e o LoA3 exige no mínimo dois fatores distintos
conforme a [especificação de segurança](https://openbanking-brasil.github.io/specs-seguranca/open-banking-brasil-financial-api-1_ID3.html#name-requesting-the-urnbrasilope)
do Open Banking Brasil.

O aplicativo deve então garantir a autenticação do usuário segundo o ACR
solicitado e enviar o resultado do comando ao AS OOB.

Caso o usuário tenha se autenticado corretamente, a instituição deve emitir um
token JWT assinado e envia-lo ao AS através da API
`PUT /app/commands/{id}/authentication`, onde o `id` é o `commandId` do comando executado.

>**Importante**: O token JWT não deve ser assinado no aplicativo, evitando a exposição
da chave privada de assinatura. A chave pública utilizada deve ser exposta via
URL contendo o *JWKS* a ser configurada através da propriedade [`customer/federationJwksUrl`](../deploy/oob-authorization-server/readme.md#customerfederationjwksurl).

O JWT deve possuir as claims abaixo, sendo obrigatórias aquelas marcadas com asterisco:

- `cpf`**\***: CPF do usuário logado contendo apenas dígitos.

- `name`**\***: Nome do usuário logado.

- `cnpj`: CNPJ da instituição relacionada ao usuário logado contendo apenas dígitos.

- `iat`**\***: Data e hora de emissão do JWT no formato *EPOCH*.

- `jti`**\***: Identificador único do token em formato *UUID* utilizado para evitar
*replay-attacks*. Deve ser preenchido com o mesmo valor recebido do AS no início
do loop de comandos.

- `authExtraData`: Cojunto de informações extras relacionadas ao usuário logado
representadas em um formato de dicionário *chave/valor*. Deve ser utilizado usado
para envio das credenciais do usuário caso a instituição não utilize *cpf* ou
*cnpj* para autenticação.

- `consentOwner`: Conjunto de informações definidas pela instituição para
identificar o dono do consentimento como, por exemplo, agência, conta, CPF e/ou
CNPJ representadas como dicionário *chave/valor*. Essas informações serão utilizadas
para a consulta do consentimento via [API de Backoffice](../portal-backoffice/apis-backoffice/readme.md).

>**Importante**: Caso a claim `consentOwner` não seja enviada, a solução OOB
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

## Comando `consent`

O comando `consent` é o comando que solicita a exibição da intenção do
consentimento solicitado pelo TPP à instituição. As informações do consentimento
são retornadas juntamente com o comando, além das informações do próprio TPP, da
marca da instituição (para instalações com suporte a multimarca) e, para
consentimentos de compartilhamento de dados, informações descritivas das
permissões e tipos de recursos solicitados.

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

Os recursos selecionados e por consequencia o aceite do consentimento devem ser
enviados ao AS através da API `PUT /app/command/{id}/consent`.

## Comando `error`

O comando `error` é o comando que indica a ocorrência de algum erro durante o
fluxo de autenticação OIDC. O erro é descrito no comando, podendo ser erros
conhecidos do processo do Open Banking ou erros inesperados conforme vemos na
tabela a seguir.

| Código do Erro | Descrição                                                                                         |
| -------------- | ------------------------------------------------------------------------------------------------- |
| CPF_MISMATCH   | CPF do usuário autenticado diverge do enviado pelo TPP na intenção do consentimento               |
| CNPJ_MISMATCH  | CNPJ do usuário autenticado diverge do enviado pelo TPP na intenção do consentimento              |
| GENERIC_ERROR  | Erro genérico do AS, o campo `message` possui a descrição do erro que deve ser exibida ao usuário |

O comando `error` é um comando que conclui a geração do consentimento. Nos casos
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

## Comando `completed`

O comando `completed` é o comando que indica a conclusão com sucesso do fluxo de
geração do consentimento.

O tratamento é o mesmo do comando `error` porém a mensagem a ser exibida ao
usuário é do sucesso do consentimento. O tratamento de retorno ao TPP deve
ser seguido como descrito no `error`.

## Changelog

### 2022-04-06 - v1.1.0

- Adição da nova claim `consentOwner` no JSON do token JWT para utilização no
command authenticate.

### 2022-01-24 - v1.0.1

- Adição da nova claim `authExtraData` no JSON do token JWT para utilização
no command authenticate.

### 2022-01-11 - v1.0.0

- Versão inicial do arquivo.
