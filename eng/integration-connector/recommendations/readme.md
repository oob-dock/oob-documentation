# Best Practices for Building Connectors

## HTTP Requests

Currently, the OOB product supports the following Camel components for making HTTP requests:

- [HTTP](https://camel.apache.org/components/3.21.x/http-component.html): Based on Apache HttpClient, recommended for simple HTTP communication needs.
- [Netty HTTP](https://camel.apache.org/components/3.21.x/netty-http-component.html): Based on the Netty framework, this component creates non-blocking HTTP communications, resulting in higher efficiency in scenarios with multiple simultaneous requests.
- [Vertx HTTP](https://camel.apache.org/components/3.21.x/vertx-http-component.html): Based on Vert.x, a toolkit commonly used for building reactive applications. The Camel component uses the Vert.x Web Client to create asynchronous HTTP communication, avoiding I/O blocking during requests.

**Important**: We recommend using the Netty HTTP component in our product as it provides greater efficiency and offers configurations that allow more control over its operation.

### Migration Example

Below is an example of a route using the HTTP component:

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

To migrate to Netty HTTP, it will be necessary to remove the `httpMethod` parameter, which is not supported by the component. Instead, the HTTP method of the endpoint should be defined via the `CamelHttpMethod` header, as shown in the example below:

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

To migrate to Vertx HTTP, you will only need to remove the `bridgeEndpoint` parameter, which may result in some headers not being transmitted, depending on the route configuration:

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
### Configuring Timeout

Regardless of the component used, it is crucial to configure the connection and request timeouts to avoid resource blocking for extended periods in scenarios of overload or malfunction in Camel. The timeout configuration can be added to each of the requests as follows:

#### Netty HTTP

- **requestTimeout**: Maximum time to receive a response to a request, in milliseconds.
- **connectTimeout**: Maximum time to establish a connection with the server, in milliseconds.

Example:

```xml
<toD uri="netty-http:{{host}}/api/v1/loans?bridgeEndpoint=true&amp;throwExceptionOnFailure=false?connectTimeout=10000&amp;requestTimeout=10000"/>
```

**Note:** Netty HTTP allows for a general timeout configuration for all routes. Our product sets a default time of 15 seconds, which will be used if the route does not specify the parameters mentioned above.

### Vertx HTTP

- **timeout**: Maximum time to receive a response to a request, in milliseconds.
- **connectTimeout**: Maximum time to establish a connection with the server, in milliseconds.

Example:

```xml
<toD uri="vertx-http:{{host}}/api/v1/loans?throwExceptionOnFailure=false&amp;httpMethod=POST&amp;timeout=10000&amp;connectTimeout=10000"/>
```

### HTTP

The HTTP component does not support route timeout configuration