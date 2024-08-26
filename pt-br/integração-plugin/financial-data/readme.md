# API Financial Data

Esse documento apresenta as **Rotas do Camel** e **Configurações Suportadas** para
o serviço de financial data, o qual equivale à junção das seguintes API do
Open Banking Brasil:

&nbsp;

- [Dados Cadastrais](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17370003/API+-+Dados+Cadastrais)
- [Cartão de Crédito](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17370864/API+-+Cart+o+de+Cr+dito)
- [Contas](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17371726/API+-+Contas)
- [Operações de Crédito - Empréstimos](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17372520/API+-+Opera+es+de+Cr+dito+-+Empr+stimos)
- [Operações de Crédito - Financiamentos](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17373362/API+-+Opera+es+de+Cr+dito+-+Financiamento)
- [Operações de Crédito - Adiantamento a Depositantes](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17374226/API+-+Opera+es+de+Cr+dito+-+Adiantamento+a+Depositantes)
- [Operações de Crédito - Direitos Creditórios Descontados](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/17375055/API+-+Opera+es+de+Cr+dito+-+Direitos+Credit+rios+Descontados)
- [Investimentos - Renda Fixa Bancária](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/75006394/API+-+Investimentos+-+Renda+Fixa+Banc+ria)
- [Investimentos - Renda Fixa Crédito](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/75005953/API+-+Investimentos+-+Renda+Fixa+Cr+dito)
- [Investimentos - Renda Variável](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/82378753/API+-+Investimentos+-+Renda+Vari+vel)
- [Investimentos - Títulos do Tesouro Direto](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/86605826/API+-+Investimentos+-+T+tulos+do+Tesouro+Direto)
- [Investimentos - Fundos de Investimento](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/89784321/API+-+Investimentos+-+Fundos+de+Investimento)
- [Câmbio](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/114032641/DC+API+-+C+mbio)

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

| Variável                              | Objetivo                                                              | Valor Padrão |
|---------------------------------------|---------------------------------------------------------------------------------------------------------------------------------|--------------|
| camel.main.routes-include-pattern     | Indica os locais onde o Camel deve procurar por rotas                                                                           |              |
| apis.validation.json-schema.enabled   | Habilita a validação dos objetos de request/response envidados/recebidos pelo plugin com as specs definidas (afeta performance) | false        |
| apis.validation.openapi.enabled-request       | Habilita a validação dos objetos de request recebidos pela API com a especificação do Open Banking Brasil   | true         |
| apis.validation.openapi.enabled-response       | Habilita a validação dos objetos de response devolvidos pela API com a especificação do Open Banking Brasil (afeta performance)   | false         |

&nbsp;

**Além das variáveis acima apresentada, dependendo do(s) componente(s) do quarkus
camel que o plugin venha a utilizar, poderão existir outras de acordo com o que
estiver específicado na própria documentação do componente sendo utilizado. Além
disso, o plugin pode criar suas próprias variáveis de ambiente a serem injetadas.

&nbsp;

## Rotas do Camel

As subseções seguintes contêm todos os `endpoints` que precisam ter rotas defnidas
no camel e para os quais é necessário a criação de um ou mais plugins.

Para o endpoint `/accounts/{accountId}/balances`, por exemplo, a rota deve estar

definida no plugin como:

```xml
<from uri="direct:accountsGetAccountsAccountIdBalances"/>
```

As rotas referentes aos endpoints da versão 1 podem ser consultadas [aqui](routes-v1.md).

As rotas referentes aos endpoints da versão 2 podem ser consultadas [aqui](routes-v2.md).