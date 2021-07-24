# Documentação para Criação de Plugin Externo

Esta documentação tem como objetivo guiar o desenvolvimento de plugins para serviços relacionados à(s) fase(s) do Open Banking Brasil (OBB).

&nbsp;

Índice:

- [Introdução](#introdução)
- [Exemplo de Plugins e Extensão da Imagem Docker](#exemplo-de-plugins-e-extensão-da-imagem-docker)
- [Consumindo o objeto de consentimento](#consumindo-o-objeto-de-consentimento)
- [Injetando Variáveis de Ambiente](#injetando-variáveis-de-ambiente)
- [Componentes Suportados](#componentes-suportados)
- [Data Formats Suportados](#data-formats-suportados)
- [Linguages Suportadas](#linguagens-suportadas)
- [Glossário](#glossario)

&nbsp;

## Introdução

&nbsp;

### O que é um Plugin

&nbsp;

Um plugin é um artefato responsável por estender uma ou mais funcionalidades de um software. 

No caso do Opus Open Banking (OOB) espeficamente, espera-se que o plugin receba um objeto de entrada conforme spec(s) previamente definida(s) por parte do OOB e, a partir dele, realize a(s) chamada(s) necessária(s) ao(s) sistema(s) legado(s) (ou quaisquer outros que sejam pertinentes) da instituição financeira, retornando para o OOB um objeto de resposta, de sucesso ou erro, em conformidade com spec(s) previamente definida(s).

&nbsp;

### Como a Aplicação Realiza o Carregamento do Plugin

&nbsp;

O carregamento do plugin é feito em tempo de execução através do redirecionamento das chamadas realizadas no OOB para as rotas a serem implementadas no plugin.

Por padrão, a aplicação do OOB busca os arquivos de rota no diretório `/work` da imagem. Porém, tal caminho pode ser modificado na imagem estendida criada pelo plugin, desde que a variável de ambiente `camel.main.routes-include-pattern` (vide [Variáveis de Configuração Suportadas](#variáveis-de-configuração-suportadas)) reflita essa mudança, assim como quaisquer outros arquivos que venham a ser copiados para a imagem e suas referências (vide [Adicionando o plugin à uma imagem existente](#adicionando-o-plugin-à-uma-imagem-existente)).

&nbsp;

### Responsabilidade de Processamento

&nbsp;

### OOB - Opus Open Banking

- Verificar se existe um consentimento válido por parte do cliente para a requisição `HTTP` sendo realizada e, caso não haja, recusar a requisição;
- Validar se o `request` recebido na requisição `HTTP` (tanto *headers* quanto *body*) está de acordo com os padrões definidos pelo OBB;
- Retorna o devido erro, de acordo com as especificações do OBB, caso o `request` recebido na requisição `HTTP` não seja válido;
- Realizar os mapeamentos necessários entre o `id` de um recurso no OBB e o equivalente no(s) sistema(s) legado(s) da instituição financeira, e vice-versa;
- Converter o `response` retornado pelo plugin e adicionar os metadados necessário para retornar um objeto de `response` em conformidade com a especificação do OBB;
- Validar se o objeto de `response` retornado pelo plugin está em acordo com a(s) spec(s) previamente definidas pelo OOB;
- Gerar retornos de erros nos formatos especificados pelo OBB no caso de haver erros de processamento interno, ou na chamada do plugin, ou no objeto de `response` retornado pelo plugin. 

### Plugin

- Possuir uma interface de entrada em conformidade com a(s) spec(s) previamente definidas pelo OOB;
- Realizar chamadas ao(s) sistema(s) legado(s) da instituição financeira (ou qualquer outro sistema que seja pertinente) para obtenção dos dados a serem retornados na requisição;
- Retornar um objeto de `response` (tanto em caso de sucesso, quanto de erro) em conformidade com a(s) spec(s) previamente definidas pelo OOB;
- Para as chamadas que utilizam *id de idempotência*, realizar o devido controle do mesmo;
-  Realizar as consultas necessárias (quando houver) ao objeto de consentimento enviado no header `consent` da requisição para decisão em relação aos dados a serem retornados.
 
&nbsp;

### Disponibilização de Imagens Docker

&nbsp;

A Opus entregará à instituição financeira duas imagens distintas:

1. Imagem nativa sem rotas definidas
2. Imagem com rotas de mocks

&nbsp;

## Exemplo de Plugins e Extensão da Imagem Docker

&nbsp;

Nesta seção são apresentados alguns exemplos de criação de plugin, assim como um passo a passo de como estender uma imagem para incluir um plugin.

Aqui nós estamos dando exemplos de plugin suscintos que realizam uma chamada direta à um serviço HTTP externo ou que retorna um JSON estático sempre. Porém, é possível realizar chamadas para diversos componentes do Camel que são suportados em modo nativo no Quarkus. Nesta [seção](#componentes-suportados) você encontra todos os componentes suportados para quarkus camel nativo que são suportados pelo OOB.

&nbsp;

### Utilizando Proxy Simples

&nbsp;

O intuito deste exemplo é demonstrar os passos necessário para criação de um plugin que realiza uma requisição HTTP para um serviço externo e retorna diretamente o response obtido a partir desta requisição.

Considere que iremos criar um plugin contendo duas rotas, as quais escutam chamadas realizadas em `direct:customersGetPersonalQualifications` e `direct:customersGetBusinessQualifications` e as processa através de uma requisição a um endpoint `HTTP GET`, retornando o resultado obtido diretamente.

&nbsp;

Para isso, iremos criar os seguintes arquivos de rota do Camel:

*personal_qualifications_route.xml*
```xml
<routes xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns="http://camel.apache.org/schema/spring"
        xsi:schemaLocation="
            http://camel.apache.org/schema/spring
            http://camel.apache.org/schema/spring/camel-spring.xsd">

    <route id="customersGetPersonalQualificationsRoute">
        <from uri="direct:customersGetPersonalQualifications"/>
        <to uri="http://mockbin.org/bin/77ef082f-b311-4123-a287-0ee99347bfe1?bridgeEndpoint=true"/>

    </route>
</routes>
```

&nbsp;

*business_qualifications_route.xml*
```xml
<routes xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns="http://camel.apache.org/schema/spring"
        xsi:schemaLocation="
            http://camel.apache.org/schema/spring
            http://camel.apache.org/schema/spring/camel-spring.xsd">

    <route id="customersGetBusinessQualificationsRoute">
        <from uri="direct:customersGetBusinessQualifications"/>
        <to uri="http://mockbin.org/bin/ad5a2df2-38db-47df-a418-cf260719a3b1?bridgeEndpoint=true"/>

    </route>
</routes>
```

O atributo `bridgeEndpoint` deve **obrigatoriamente** ser atribuído como `true`. Ele é necessário para que a URI da qual a rota é proveniente seja ignorada na chamada e somente a que foi definida na rota criada seja chamada.

&nbsp;

A partir das imagens acima, podemos verificar que quando este plugin for adicionado, a rota `direct:customersGetPersonalQualifications` passará a realizar uma requisição para a URI http://mockbin.org/bin/77ef082f-b311-4123-a287-0ee99347bfe1, enquanto que a rota `direct:customersGetBusinessQualifications` irá redirecionar para o endereço http://mockbin.org/bin/ad5a2df2-38db-47df-a418-cf260719a3b1.

&nbsp;

Com os arquivos de rotas criados, é necessário realizar a extensão da imagem para adição do plugin através dos passos apresentados nesta [Seção](#adicionando-o-plugin-à-uma-imagem-existente).

&nbsp;

### Utilizando Mock

&nbsp;

O intuito deste exemplo é demonstrar os passos necessário para criação de um plugin que retorna um mock contido em um arquivo interno ao plugin.

Considere que iremos criar um plugin contendo duas rotas, as quais escutam chamadas realizadas em `direct:customersGetPersonalQualifications` e `direct:customersGetBusinessQualifications` e as processa retornando sempre os mesmo dados para uma mesma chamada, os quais estão contidos em um arquivo de mock.

&nbsp;

Para isso, iremos criar dois tipos de arquivos distintos:

&nbsp;

1. Arquivos contendo os mocks a serem retornado

*personal_qualifications.json*
```json
{
    "correlationId": "1fe4ae88-db5f-4bc9-b49b-5290d3acefe4",
    "data": {
        "updateDateTime": "2021-05-21T08:30:00Z",
        "companyCnpj": "50685362000135",
        "occupationCode": "RECEITA_FEDERAL",
        "occupationDescription": "01",
        "informedIncome": {
            "frequency": "DIARIA",
            "amount": "100000.0412",
            "currency": "BRL",
            "date": "2021-05-21"
        },
        "informedPatrimony": {
            "amount": "100000.0498",
            "currency": "BRL",
            "year": 2010
        }
    }
}
```

&nbsp;

*business_qualifications.json*
```json
{
    "correlationId": "64d0ba85-ea54-4bc7-9c33-f949ce166f63",
    "data": {
        "updateDateTime": "2021-05-21T08:30:00Z",
        "economicActivities": [
            {
                "code": 8599604,
                "isMain": true
            }
        ],
        "informedRevenue": {
            "frequency": "DIARIA",
            "frequencyAdditionalInfo": "Informações adicionais",
            "amount": "100000.0415",
            "currency": "BRL",
            "year": 2010
        },
        "informedPatrimony": {
            "amount": "100000.0415",
            "currency": "BRL",
            "date": "2021-05-21"
        }
    }
}
```

&nbsp;

2. Arquivos de rotas do Camel

*personal_qualifications_route.xml*
```xml
<routes xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns="http://camel.apache.org/schema/spring"
        xsi:schemaLocation="
            http://camel.apache.org/schema/spring
            http://camel.apache.org/schema/spring/camel-spring.xsd">

    <route id="customersGetPersonalQualificationsRoute">
        <from uri="direct:customersGetBusinessQualifications"/>
        <to uri="velocity:file:/plugin/mocks/personal_qualifications.json?allowContextMapAll=true&amp;encoding=UTF-8"/>

    </route>
</routes>
```

&nbsp;

*business_qualifications_route.xml*
```xml
<routes xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns="http://camel.apache.org/schema/spring"
        xsi:schemaLocation="
            http://camel.apache.org/schema/spring
            http://camel.apache.org/schema/spring/camel-spring.xsd">

    <route id="customersGetBusinessQualificationsRoute">
        <from uri="direct:customersGetBusinessQualifications"/>
        <to uri="velocity:file:/plugin/mocks/business_qualifications.json?allowContextMapAll=true&amp;encoding=UTF-8"/>

    </route>
</routes>
```
 
&nbsp;

Com esses arquivos criados, é necessário realizar a extensão da imagem para adição do plugin. Os passos necessários para realizar essa extensão podem ser vistos nesta [Seção](#adicionando-o-plugin-à-uma-imagem-existente).

&nbsp;

### Adicionando o Plugin à Uma Imagem Existente

&nbsp;

O intuito desta seção é demonstrar como uma imagem existente pode ser estentida para adicionar um plugin que tenha sido criado para uma u mais de suas rotas. Para isso, iremos estender uma imagem docker contendo dois endpoints: http://localhost:8080/open-banking/customers/v1/personal/qualifications e http://localhost:8080/open-banking/customers/v1/business/qualifications; os quais direcionam para `direct:customersGetPersonalQualifications` e `direct:customersGetBusinessQualifications`, respectivamente.

&nbsp;

- Considere a imagem docker `oob-without-route-example-native` abaixo apresentada como sendo aquela contendo os endpoints acima mencionados:

![Estender Imagem - Imagens Docker](./images/estender_imagem__docker_images.png)

&nbsp;

- Considere que atualmente não existe nenhuma rota nessa imagem escutando as chamadas direcionadas para `direct:customersGetPersonalQualifications` e `direct:customersGetBusinessQualifications`, o que ocasiona no erro abaixo apresentado quando quaisquer desses endpoints são chamados:

&nbsp;

```sh
curl --location --request GET 'http://localhost:8080/open-banking/customers/v1/personal/qualifications'
```

![Estender Imagem - Erro Chamada Sem Rota](./images/estender_imagem__personal_sem_rota_erro.png)

&nbsp;

```sh
curl --location --request GET 'http://localhost:8080/open-banking/customers/v1/business/qualifications'
```

![Estender Imagem - Erro Chamada Sem Rota](./images/estender_imagem__business_sem_rota_erro.png)

&nbsp;

Assumindo que os plugins tenham sido já criados de acordo com as seções anteriores, precisamos criar um `Dockerfile` para realizar a extensão da imagem de forma a criar uma nova imagem docker que contém a imagem docker inicial juntamente com o plugin criado. Iremos estender a imagem para adição do plugin com as rotas, de forma que as chamadas direcionadas a `direct:customersGetPersonalQualifications` e `direct:customersGetBusinessQualifications` sejam processadas por essas novas rotas.

As subseções seguintes apresentam os passos a serem seguidos para criação desse `Dockerfile`, considerando cada um dos exemplos de plugins apresentados nas seções anteriores.

&nbsp;

Uma vez criado o `Dockerfile`, o seguinte comando deve ser executado para que a imagem existente seja estendida com a adição do plugin recém criado:

```sh
docker build -t oob-with-plugin-example-native .
```

![Estender Imagem - Docker build](./images/estender_imagem__docker_build.png)

&nbsp;

Após criação da imagem, o seguinte comando deve ser rodado para que ela seja executada:

```sh
docker run -d -p 8080:8080 oob-with-plugin-example-native
```
![Estender Imagem - Docker run](./images/estender_imagem__docker_run.png)

&nbsp;

Neste ponto, ao realizar uma nova requisição aos endpoints deve-se obter como resposta os resultados definidos nas rotas do plugin adicionado à imagem.

```sh
curl --location --request GET 'http://localhost:8080/open-banking/customers/v1/personal/qualifications'
```
![Estender Imagem - Chamada Com Plugin](./images/estender_imagem__personal_com_plugin.png)

&nbsp;

```sh
curl --location --request GET 'http://localhost:8080/open-banking/customers/v1/business/qualifications'
```
![Estender Imagem - Chamada Com Plugin](./images/estender_imagem__business_com_plugin.png)

&nbsp;

#### Dockerfile Para o Plugin de Proxy Simples

&nbsp;

Considere que o plugin de proxy simples criado possui a seguinte estrutura de diretórios:

![Proxy Simples - Estrutura Diretório](./images/proxy_simples__estrutura_diretorios.png)

&nbsp;

O `Dockerfile` deve ser criado como segue:
```dockerfile
FROM oob-without-route-example-native:latest
COPY --chown=1001:root routes/ /plugin/routes/

ARG routes=file:/plugin/routes/*_route.xml
ENV camel.main.routes-include-pattern=$routes
```

Onde:

- A linha 1 indica a imagem original a ser estendida (no caso `oob-without-route-example-native`);
- A linha 2 copia todos os arquivos contidos no diretório `/routes` do plugin para o diretório `/plugin/routes` da imagem;
- A linha 4 cria uma variárel chamada `routes` e atribui à ela o padrão de caminho onde estão os arquivos de rota na imagem. Nesse caso espeífico, o padrão está sendo determinado como todos os arquivos cuja a nomenclatura terminal com `_route.xml` dentro do diretório `/plugin/routes`;
- A linha 5 atribui a variável criada na linha 4 à variável de ambiente `camel.main.routes-include-pattern`. Essa variável de ambiente é responsável por informar ao Camel onde os arquivos de rotas devem ser procurados.


&nbsp;

#### Dockerfile Para o Plugin de Mock

&nbsp;

Considere que o plugin de mock criado possui a seguinte estrutura de diretórios:

![PLugin Mock - Estrutura Diretório](./images/plugin_mock__estrutura_diretorios.png)

&nbsp;

O `Dockerfile` deve ser criado como segue:

```dockerfile
FROM oob-without-route-example-native:latest
COPY --chown=1001:root routes/ /plugin/routes/
COPY --chown=1001:root mocks/ /plugin/mocks/

ARG routes=file:/plugin/routes/personal_qualifications_route.xml,file:/plugin/routes/business_qualifications_route.xml
ENV camel.main.routes-include-pattern=$routes
```

Onde:

- A linha 1 indica a imagem original a ser estendida (no caso `oob-without-route-example-native`);
- A linha 2 copia todos os arquivos contidos no diretório `/routes` do plugin para o diretório `/plugin/routes` da imagem;
- A linha 2 copia todos os arquivos contidos no diretório `/mocks` do plugin para o diretório `/plugin/mocks` da imagem;
- A linha 4 cria uma variárel chamada `routes` e atribui uma lista de arquivos de rota separados por vírgulas (aqui foram colocados os arquivos um a um no intuito de desmonstrar a opções. Porém, poderíamos ter utilizado um padrão da mesma forma do exemplo de proxy simples);
- A linha 5 atribui a variável criada na linha 4 à variável de ambiente `camel.main.routes-include-pattern`. Essa variável de ambiente é responsável por informar ao Camel onde os arquivos de rotas devem ser procurados.

&nbsp;

## Consumindo o objeto de consentimento

Suponha que temos a imagem oob-phase3-native-with-mocks, que já realiza a chamada do serviço para obter o consentimento por meio do id informado no header com a chave “X-Consent-ID”:

![Consentimento - Lista de imagens](./images/consent_docker_images.png)

&nbsp;

### Exemplo de proxy simples

Para um exemplo de proxy simples, temos a seguinte rota da fase 3, que redireciona a chamada para uma outra API:

![Consentimento - Arquivo de rotas proxy](./images/consent_proxy_route.png)

&nbsp;

Neste exemplo, trata-se de uma API criada no Mockoon, para fins de demonstração:

![Consentimento - Mockoon proxy](./images/consent_mockoon_proxy.png)

&nbsp;

Iremos estender a imagem oob-phase3-native-with-mocks, para que a rota que criamos seja utilizada pela nova imagem:

![Consentimento - Imagem estendida](./images/consent_image_extended.png)

&nbsp;

Faremos a chamada para a rota que foi criado o proxy, e na API do Mockoon será possível verificar que o objeto do consentimento foi enviado e recebido corretamente pelo header de chave “consent”:

![Consentimento - Mockoon proxy header](./images/consent_proxy_header_mockoon.png)

&nbsp;

### Obtendo através do Camel XML

É possível obter o objeto do consentimento que está no header através do Camel XML; para tal, o mesmo deve ser acessado com a sintaxe “${header.consent}”:

![Consentimento - Arquivo de rotas para obter o consentimento](./images/consent_camel_xml_get_header_consent.png)

&nbsp;

Neste exemplo de rota, estamos logando o conteúdo do header “consent", e criando um novo header com a chave “consentNewHeader”, e utilizando como valor o conteúdo do header “consent”.

Após realizar o procedimento de estender a imagem original e executar a mesma na porta 8080 (vide passos anteriores), teremos como retorno no console e na API do Mockoon respectivamente:

![Consentimento - Log consent](./images/consent_camel_xml_header_consent_logged.png)

Conteúdo do header “consent” logado no console

&nbsp;

![Consentimento - novo header consentimento](./images/consent_camel_xml_header_consent_new_key.png)

Novo header de chave “consentNewHeader”, com o mesmo conteúdo do header de chave “consent”.

&nbsp;

## Injetando Variáveis de Ambiente

&nbsp;

### Injetando Via Dockerfile

Necessário adicionar as seguintes linhas no Dockerfile
```
ARG <nome_variavel>=<valor_variavel>
ENV env_var_name=$<nome_variavel>
```
&nbsp;

### Exemplos

Os exemplos abaixo assumem que os arquivos de rota estão contidos no diretório `/work` da imagem docker.

&nbsp;

Adicionando um novo arquivo de rota via variável de ambiente
```
ARG route=file:/work/routes.xml
ENV camel.main.routes-include-pattern=$route
```

&nbsp;

Adicionando múltiplos arquivos de rota via variável de ambiente
```
ARG route=file:/work/routes1.xml,file:/work/routes2.xml
ENV camel.main.routes-include-pattern=$route
```

&nbsp;

Adicionando múltiplos arquivos de um diretório
```
ARG route=file:/work/*.xml
ENV camel.main.routes-include-pattern=$route
```

&nbsp;

### Injetando Variáveis no Build
```
docker build -t <nome_imagem> --build-arg <nome_variavel>=<valor_variavel> .
```

&nbsp;

### Injetando Variáveis na Execução do Container

```
docker run --env <nome_variavel>=<valor_variavel> -p 8080:8080 <nome_imagem>
```

&nbsp;

### Consumindo Variáveis de Ambiente via Camel

&nbsp;

#### Exemplo com Proxy Simples

&nbsp;

Tomando como exemplo o [plugin com proxy simples](#utilizando-proxy-simples), considere o arquivo de rotas `business_qualifications_route.xml` apresentado:
```xml
<routes xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns="http://camel.apache.org/schema/spring"
        xsi:schemaLocation="
            http://camel.apache.org/schema/spring
            http://camel.apache.org/schema/spring/camel-spring.xsd">

    <route id="getCustomersBusinessQualificationsRoute">
        <from uri="direct:getCustomersBusinessQualifications"/>
        <to uri="http://mockbin.org/bin/ad5a2df2-38db-47df-a418-cf260719a3b1?bridgeEndpoint=true"/>
    </route>

</routes>
```

&nbsp;

Iremos modificá-lo para utilizar uma variável de ambiente chamada `routes.customers.uri-legado` no lugar do valor estático para a URI do sistema legado `http://mockbin.org/bin/ad5a2df2-38db-47df-a418-cf260719a3b1`. 

Para isso, precisamos inicialmente modicar o arquivo `business_qualifications_route.xml`, de forma que ele consuma a variável de ambiente mencionada, o que é feito através do comando `{{env:<nome_variavel>}}`:
```xml
<routes xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns="http://camel.apache.org/schema/spring"
        xsi:schemaLocation="
            http://camel.apache.org/schema/spring
            http://camel.apache.org/schema/spring/camel-spring.xsd">

    <route id="getCustomersBusinessQualificationsRoute">
        <from uri="direct:getCustomersBusinessQualifications"/>
        <to uri="{{env:routes.customers.uri-legado}}?bridgeEndpoint=true"/>

    </route>
</routes>
```

&nbsp;

Após isso, basta realizar a injeção do variável de ambiente `routes.customers.uri-legado` utilizando umas das abordagens apresentadas mas acima nesta mesma [seção](#injetando-variáveis-de-ambiente).

Por exemplo, poderíamos injetar o valor no momento de execução da imagem, via comando `run`:
```
docker run --env routes.customers.uri-legado=http://mockbin.org/bin/ad5a2df2-38db-47df-a418-cf260719a3b1 -p 8080:8080 <nome_imagem>
```

&nbsp;

#### Exemplo com Mock

&nbsp;

Tomando como exemplo o [plugin com arquivo de mock](#utilizando-mock), considere o arquivo de rotas `personal_qualifications_route.xml` apresentado:
```xml
<routes xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns="http://camel.apache.org/schema/spring"
        xsi:schemaLocation="
            http://camel.apache.org/schema/spring
            http://camel.apache.org/schema/spring/camel-spring.xsd">

    <route id="getCustomersPersonalQualificationsRoute">
        <from uri="direct:getCustomersPersonalQualifications"/>
        <to uri="velocity:file://plugin/mocks/personal_qualifications.json?allowContextMapAll=true"/>

    </route>
</routes>
```

&nbsp;

Iremos modificá-lo para utilizar uma variável de ambiente chamada `routes.customers.personal-identifications` no lugar do valor estático `velocity:file://plugin/sucesso.json?allowContextMapAll=true`. 

Para isso, precisamos inicialmente modicar o arquivo `personal_qualifications_route.xml`, de forma que ele consuma a variável de ambiente mencionada, o que é feito através do comando `{{env:<nome_variavel>}}`:
```xml
<routes xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns="http://camel.apache.org/schema/spring"
        xsi:schemaLocation="
            http://camel.apache.org/schema/spring
            http://camel.apache.org/schema/spring/camel-spring.xsd">

    <route id="getCustomersPersonalQualificationsRoute">
        <from uri="direct:getCustomersPersonalQualifications"/>
        <to uri="velocity:{{env:routes.customers.personal-identifications}}"/>

    </route>
</routes>
```

&nbsp;

Após isso, basta realizar a injeção do variável de ambiente `routes.customers.personal-identifications` utilizando umas das abordagens apresentadas mas acima nesta mesma [seção](#injetando-variáveis-de-ambiente).

Por exemplo, poderíamos injetar o valor via `Dockerfile`, através da edição das linhas abaixo:
```dockerfile
ARG route=file://plugin/sucesso.json?allowContextMapAll=true
ENV routes.customers.personal-identifications=$route
```

&nbsp;

## Componentes Suportados

### ACTIVEMQ
```
Envie mensagens para(ou consome do) Apache ActiveMQ. Esse componente é uma extensão do Camel JMS Component.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/activemq.html
```

&nbsp;

### AMQP
```
Mensagens com o AMQP protocol usando o Apache QPid Client

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/amqp.html

Para a utilização do AMQP de forma apropriada talvez seja necessário adicionar configurações ao application.properties, o guia a seguir ou a documentação podem ser úteis para a utilização.
- https://quarkus.io/guides/jms
- https://github.com/amqphub/quarkus-qpid-jms#configuration
```

&nbsp;

### ATLASMAP
```
Transforma mensagens usando o AtrasMap transformation.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/atlasmap.html
```

&nbsp;

### DATA FORMAT
```
Usa o Camel Data Format como um Camel Component comum.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/dataformat.html
```

&nbsp;

### DIRECT
```
Chamada de outro endpoint pelo mesmo Camel Context de forma síncrona.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/dataformat.html
```

&nbsp;

### ELASTICSEARCH REST
```
Envia requisições para com ElasticSearch via RESP API.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/elasticsearch-rest.html
```

&nbsp;

### EXEC
```
Executa comandos no sistema operacional em uso.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/exec.html
```

&nbsp;

### FILE
```
Lê e escreve arquivos.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/file.html
```

&nbsp;

### HTTP
```
Envia requisições para servidores HTTP externos usando o Apache HTTP Client 4.x.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/http.html
```

&nbsp;

### JING
```
Valida XML em comparação ao RelaxNG schema (XML Syntax ou Compact Syntax) usando Jing library.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/jing.html
```

&nbsp;

### LOG
```
Cria log de mensagens no mecanismo de log em uso.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/log.html
```

&nbsp;

### MOCK
```
Teste rotas e regras usando mocks.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/mock.html
```

&nbsp;

### MSV
```
Valida XML payloads usando Multi-Shema Validator (MSV).

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/msv.html
```

&nbsp;

### PLATFORM HTTP
```
Essa extensão permite a criação de endpoints HTTP para consumir requisições HTTP.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/platform-http.html
```

&nbsp;

### REF
```
Roteia mensagens para um endpoint de forma dinâmica pelo nome no Camel Registry.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/ref.html
```

&nbsp;

### REST
```
Expõe serviçõs REST e suas especificações OpenApi ou chama serviçoes REST externos.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/rest.html
```

&nbsp;

### SEDA
```
Chama outros endpoints assícronamente em qualquer Camel Context no mesmo JVM.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/seda.html
```

&nbsp;

### TIMER
```
Gera mensagens em intervalos específicos usando java.util.Timer.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/timer.html
```

&nbsp;

### VALIDATOR
```
Valida o payload usando XML Schema e JAXP Validation.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/validator.html
```

&nbsp;

### VELOCITY
```
Transforma mensagens usando o Velocity template.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/velocity.html
```

&nbsp;

### VM
```
Chama outro endpoint no mesmo CamelContext de forma assíncrona.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/vm.html
```

&nbsp;

## Data Formats Suportados

### Jackson
```
Combinação de POJOs para JSON e vice-versa usando Jackson.

Conversão e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/jackson.html
```

&nbsp;

### Gson
```
Conversão de POJOs para JSON e vice-versa usando Gson. Gson é um Data Format que utiliza a biblioteca Gson.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/gson.html
```

&nbsp;

### CSV
```
Manipulação de CSV (Comma Separated Values).

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/csv.html
```

&nbsp;

### Flatpack
```
Manipulação de arquivo posicional utilizando a biblioteca FlatPack.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/flatpack.html
```

&nbsp;

### Bindy
```
Conversão entre POJOs e CSV (Comma separated values), POJOs e arquivo posicional and entre POJOs e pares chave-valor (KVP) utilizando Camel Bindy.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/bindy.html
```

&nbsp;

### TidyMarkup
```
TidyMarkup é um Data Format que utiliza TagSoup para organizar HTML. Pode ser utilizado para converter HTML desorganizados, retornando um  HTML devidamente estruturado.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/tagsoup.html
```

&nbsp;

### BASE64
```
Utilizado para codificação e decodificação de base64.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/base64.html
```

&nbsp;

### SNAKEYAML
```
Conversão de objetos Java em YAML e vice-versa.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/snakeyaml.html
```

&nbsp;

### JACKSONXML
```
Jackson XML é um Data Format que utiliza a biblioteca Jackson com a extensão XMLMapper para converter payloads XML em objetos Java e vice-versa.

Usabilidade e documentação: https://camel.apache.org/camel-quarkus/latest/reference/extensions/jacksonxml.html
```

&nbsp;

## Linguagens suportadas

### Bean Method
````
Chama o método do Java bean especificado passando o Exchange, o Corpo ou cabeçalhos específicos para ele.

https://camel.apache.org/camel-quarkus/latest/reference/extensions/bean.html
````

&nbsp;

### CORE
````
Funcionalidade central e linguagens básicas do Camel: Constant, ExchangeProperty, Header, Ref, Ref, Simple e Tokeinze.

https://camel.apache.org/camel-quarkus/latest/reference/extensions/core.html
````

&nbsp;

### HL7 Terser
````
Combinação/conversão de objetos HL7 (Health Care) utilizando o decodificador HL7 MLLP.

https://camel.apache.org/camel-quarkus/latest/reference/extensions/hl7.html
````

&nbsp;

### JSON PATH
````
Valida uma expressão JsonPath em relação a um corpo de mensagem JSON.

https://camel.apache.org/camel-quarkus/latest/reference/extensions/jsonpath.html

````

&nbsp;

### XML JAXP
````
Tokeniza cargas úteis XML usando a expressão de caminho especificada.

https://camel.apache.org/camel-quarkus/latest/reference/extensions/xml-jaxp.html

````

&nbsp;

### XPATH
````
Valida uma expressão XPath em relação a uma carga XML.

https://camel.apache.org/camel-quarkus/latest/reference/extensions/xpath.html
````

&nbsp;

### XQUERY
````
Consulta e/ou transforma payloads XML usando XQuery e Saxon.

https://camel.apache.org/camel-quarkus/latest/reference/extensions/saxon.html
````
