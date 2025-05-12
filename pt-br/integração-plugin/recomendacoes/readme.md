# Boas práticas na construção de conectores

## Requisições http

Atualmente, o produto OOB suporta os seguintes componentes Camel para a realização de requisições HTTP:

- [HTTP](https://camel.apache.org/components/3.21.x/http-component.html): Baseado no Apache HttpClient,
recomendado para necessidades simples de comunicação HTTP.
- [Netty HTTP](https://camel.apache.org/components/3.21.x/netty-http-component.html): Baseado no framework
Netty, o componente cria comunicações HTTP não bloqueantes, resultando em uma maior eficiência em cenários
com múltiplas requisições simultâneas.
- [Vertx HTTP](https://camel.apache.org/components/3.21.x/vertx-http-component.html): Baseado no Vert.x,
um toolkit geralmente utilizado para construção de aplicações reativas. O componente do Camel utiliza o
Vert.x Web Client para criar comunicação HTTP assíncrona, evitando bloqueios de I/O nas requisições.

**Importante**: Recomendamos o uso do componente Netty HTTP no nosso produto por proporcionar maior eficiência
por oferecer configurações que permitem maior controle sobre seu funcionamento, otimizando o uso de recursos.

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
    <toD uri="netty-http:{{host}}/api/v1/loans?bridgeEndpoint=true&amp;throwExceptionOnFailure=false&amp;encoding=UTF-8"/>
</route>
```

Caso trate-se de uma chamada de verbo GET, deve-se remover o payload setando um body vazio:

<route id="discoveryAccountsRoute">
    <from uri="direct:discoverAccounts"/>
    <setHeader name="Content-Type">
        <constant>application/json</constant>
    </setHeader>
    <setHeader name="Accept">
        <constant>application/json</constant>
    </setHeader>
    <setHeader name="CamelHttpMethod">
        <constant>GET</constant>
    </setHeader>
    <setBody>
        <constant></constant>
    </setBody>
    <toD uri="netty-http:{{host}}/api/v1/accounts?bridgeEndpoint=true&amp;throwExceptionOnFailure=false&amp;encoding=UTF-8"/>
</route>
```

Além das mudanças no tratamento do método HTTP, a migração para o componente `netty-http` traz diversos benefícios significativos para os conectores:

- **Melhor desempenho e menor latência:** O Netty é um framework assíncrono e orientado a eventos, o que permite que conexões sejam gerenciadas de forma não bloqueante, resultando em maior throughput e resposta mais ágil em cenários de alto volume de requisições.

- **Maior escalabilidade:** Por usar uma arquitetura baseada em reatores e um modelo de thread pool eficiente, o `netty-http` suporta melhor cargas crescentes e picos de acesso sem a necessidade de aumentar linearmente os recursos computacionais, ao contrário de soluções síncronas tradicionais.

- **Configuração fina e flexível:** O componente oferece opções avançadas para configuração de timeouts, controle de conexões, SSL/TLS customizado e manipulação detalhada de headers TCP/IP, permitindo que os conectores sejam adaptados com mais precisão às demandas específicas do ambiente e do serviço consumido.

- **Menor consumo de recursos:** O modelo não bloqueante reduz o uso de threads e memória, o que melhora o custo-benefício quando executado em ambientes restritos em recursos ou em containers, alinhando-se às práticas modernas de cloud native.

- **Melhor integração com o ecossistema Quarkus:** Como Quarkus já utiliza internamente o Netty para vários serviços reativos, o uso do `netty-http` no Camel facilita a integração e potencializa os ganhos de performance e footprint que a plataforma oferece nativamente.

Dessa forma, a adoção do componente `netty-http` não só adequa o conector às especificações esperadas, mas também propicia ganhos concretos em eficiência operacional e manutenção a longo prazo.

#### Vertx HTTP

Para migrar para o Vertx HTTP, será necessário apenas remover o parâmetro `bridgeEndpoint`, o que pode
resultar na não transmissão de alguns headers dependendo da configuração da rota:

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

Independentemente do componente utilizado, é crucial configurar o timeout de conexão e requisição
para evitar bloqueio de recursos por longos períodos em cenários de sobrecarga ou mal funcionamento do Camel.
A configuração de timeout pode ser adicionada em cada uma das requisições da seguinte forma:

#### Netty HTTP

- **requestTimeout**: Tempo máximo para obter a resposta de uma requisição, em milissegundos.
- **connectTimeout**: Tempo máximo para estabelecer a conexão com o servidor, em milissegundos.

Exemplo:

```xml
<toD uri="netty-http:{{host}}/api/v1/loans?bridgeEndpoint=true&amp;throwExceptionOnFailure=false&amp;encoding=UTF-8&amp;connectTimeout=1500&amp;requestTimeout=15000"/>
```

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
    <toD uri="netty-http:{{host}}/api/v1/loans?bridgeEndpoint=true&amp;throwExceptionOnFailure=false&amp;encoding=UTF-8&amp;connectTimeout=1500&amp;requestTimeout=15000"/>
</route>
```

Caso trate-se de uma chamada de verbo GET, deve-se remover o payload setando um body vazio:

<route id="discoveryAccountsRoute">
    <from uri="direct:discoverAccounts"/>
    <setHeader name="Content-Type">
        <constant>application/json</constant>
    </setHeader>
    <setHeader name="Accept">
        <constant>application/json</constant>
    </setHeader>
    <setHeader name="CamelHttpMethod">
        <constant>GET</constant>
    </setHeader>
    <setBody>
        <constant></constant>
    </setBody>
    <toD uri="netty-http:{{host}}/api/v1/accounts?bridgeEndpoint=true&amp;throwExceptionOnFailure=false&amp;encoding=UTF-8&amp;connectTimeout=1500&amp;requestTimeout=15000"/>
</route>
```

**Obs:** O Netty HTTP permite a configuração de um timeout geral para todas as rotas. Nosso produto
estabelece um tempo padrão de 15 segundos, que será utilizado caso a rota não especifique os parâmetros
mencionados acima.

### Vertx HTTP

- **timeout**: Tempo máximo para obter a resposta de uma requisição, em milissegundos.
- **connectTimeout**: Tempo máximo para estabelecer a conexão com o servidor, em milissegundos.

Exemplo:

```xml
<toD uri="vertx-http:{{host}}/api/v1/loans?throwExceptionOnFailure=false&amp;httpMethod=POST&amp;timeout=15000&amp;connectTimeout=1500"/>
```

### HTTP

O componente HTTP não suporta configuração de timeout por rota.