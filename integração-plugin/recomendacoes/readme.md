# Boas práticas na construção de conectores

## Requisições http

Atualmente, o produto OOB suporta os seguintes componentes Camel para a realização de requisições HTTP:

- [HTTP](https://camel.apache.org/components/3.21.x/http-component.html): Baseado no Apache HttpClient, recomendado para necessidades simples de comunicação HTTP.
- [Netty HTTP](https://camel.apache.org/components/3.21.x/netty-http-component.html): Baseado no framework Netty, o componente cria comunicações HTTP não bloqueantes,
resultando em uma maior eficiência em cenários com múltiplas requisições simultâneas.
- [Vertx HTTP](https://camel.apache.org/components/3.21.x/vertx-http-component.html): Baseado no Vert.x, um toolkit geralmente utilizado para construção de aplicações reativas.
O componente do Camel utiliza o Vert.x Web Client para criar comunicação HTTP assíncrona, evitando bloqueios de I/O nas requisições.

**Importante**: Recomendamos o uso do componente Netty HTTP no nosso produto por proporcionar maior eficiência por oferecer configurações que permitem maior controle sobre seu funcionamento.

### Exemplo de migração

Abaixo, um exemplo de rota utilizando o componente HTTP:

```xml
<route id="discoveryLoansRoute">
    <from uri="direct:discoverLoans"/>
    <setHeader name="Content-Type">
        <constant>application/json</constant>
    </setHeader>
    <setHeader name="Accept">
        <constant>application/json</constant>
    </setHeader>
    <toD uri="{{host}}/api/v1/loans?bridgeEndpoint=true&amp;throwExceptionOnFailure=false&amp;httpMethod=POST"/>
</route>
```

#### Netty HTTP

Para migrar para o Netty HTTP, será necessário remover o parâmetro `httpMethod`, não suportado pelo componente.
Assim, deve-se definir o método HTTP do endpoint através do header `CamelHttpMethod`, conforme o exemplo abaixo:

```xml
<route id="discoveryLoansRoute">
    <from uri="direct:discoverLoans"/>
    <setHeader name="Content-Type">
        <constant>application/json</constant>
    </setHeader>
    <setHeader name="Accept">
        <constant>application/json</constant>
    </setHeader>
    <setHeader name="CamelHttpMethod">
        <constant>POST</constant>
    </setHeader>
    <toD uri="netty-http:{{host}}/api/v1/loans?bridgeEndpoint=true&amp;throwExceptionOnFailure=false"/>
</route>
```

#### Vertx HTTP

Para migrar para o Vertx HTTP, será necessário apenas remover o parâmetro `bridgeEndpoint`, o que pode resultar na não transmissão de alguns headers dependendo da configuração da rota:

```xml
<route id="discoveryLoansRoute">
    <from uri="direct:discoverLoans"/>
    <setHeader name="Content-Type">
        <constant>application/json</constant>
    </setHeader>
    <setHeader name="Accept">
        <constant>application/json</constant>
    </setHeader>
    <toD uri="vertx-http:{{host}}/api/v1/loans?throwExceptionOnFailure=false&amp;httpMethod=POST"/>
</route>
```

### Configurando timeout

Independentemente do componente utilizado, é crucial configurar o timeout de conexão e requisição para evitar bloqueio de recursos por longos períodos em cenários de sobrecarga ou mal funcionamento do Camel.
A configuração de timeout pode ser adicionada em cada uma das requisições da seguinte forma:

#### Netty HTTP

- **requestTimeout**: Tempo máximo para obter a resposta de uma requisição, em milissegundos.
- **connectTimeout**: Tempo máximo para estabelecer a conexão com o servidor, em milissegundos.

Exemplo:

```xml
<toD uri="netty-http:{{host}}/api/v1/loans?bridgeEndpoint=true&amp;throwExceptionOnFailure=false?connectTimeout=10000&amp;requestTimeout=10000"/>
```

**Obs:** O Netty HTTP permite a configuração de um timeout geral para todas as rotas. Nosso produto estabelece um tempo padrão de 15 segundos, que será utilizado caso a rota não especifique os parâmetros mencionados acima.

### Vertx HTTP

- **timeout**: Tempo máximo para obter a resposta de uma requisição, em milissegundos.
- **connectTimeout**: Tempo máximo para estabelecer a conexão com o servidor, em milissegundos.

Exemplo:

```xml
<toD uri="vertx-http:{{host}}/api/v1/loans?throwExceptionOnFailure=false&amp;httpMethod=POST&amp;timeout=10000&amp;connectTimeout=10000"/>
```

### HTTP

O componente HTTP não suporta configuração de timeout por rota.