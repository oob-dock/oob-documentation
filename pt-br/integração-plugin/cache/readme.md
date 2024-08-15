# Utilização do componente de cache do Camel XML

Este documento tem como objetivo explicar e exemplificar o uso do componente de
cache disponível na API payment do Opus Open Banking a fim de otimizar o uso dos
recursos, principalmente de autenticação, que possuem um tempo de vida específico
e que permitem reuso.

O componente utilizado pela solução é o [caffeine cache](https://camel.apache.org/components/3.12.x/caffeine-cache-component.html),
que permite configurar a forma de invalidação do cache, sendo as opções por tamanho
ou por tempo (em segundos, que atende melhor a necessidade). É possível também
estabelecer o tempo para o cache expirar, e se deve ocorrer após o tempo de acesso
ou escrita ser ultrapassado.

**:warning: Atenção**: o cache do componente é armazenado em memória, sendo assim
o mesmo será perdido caso o container seja reiniciado (será feita uma nova chamada
para obter os dados). Além disto é preciso ter cautela quanto ao tempo de vida do
mesmo, não deve ser muito curto (pois não haverá muita vantagem em armazená-lo) e
nem muito longo (pois é possível que os dados estejam desatualizados).

Abaixo seguem dois exemplos de arquivos de rotas Camel XML com as configurações
de cache, sendo respectivamente para as APIs consent e payment.

- [Consent](./attachments/OOB_Cache_Consent.xml)
- [Payment](./attachments/OOB_Cache_Payment.xml)

A rota tokenService é a responsável por chamar o serviço de obtenção do token;
dentro da mesma as credenciais e o cabeçalho de content-type são informados, e
no retorno da chamada é feito o preenchimento do cabeçalho Authorization com o
access_token (neste exemplo considera-se que a autenticação é OAuth2).
A rota getToken é a responsável por gerenciar o controle de cache, na qual
primeiramente faz-se uma consulta para verificar se existe cache válido (trecho abaixo):

```xml
<!-- GET TOKEN IN CACHE -->
<setHeader name="CamelCaffeineAction">
    <constant>GET</constant>
</setHeader>
<to uri="caffeine-cache://token?evictionType=TIME_BASED&amp;expireAfterWriteTime=290&amp;key=1"/>
```

Para este exemplo está sendo utilizado o tipo de invalidação por tempo
(evictionType=TIME_BASED), estabelecendo que o tempo de expiração é de 290 segundos
após a escrita do cache (expireAfterWriteTime=290), sendo 1 a chave do cache (key=1).
Caso ainda não exista cache ou tenha expirado, é feita a chamada para obtenção do
token (<to uri="direct:tokenService"/>), e o resultado é persistindo em cache
através do seguinte trecho:

```xml
<setHeader name="CamelCaffeineAction">
    <constant>PUT</constant>
</setHeader>
<setBody>
    <simple>${in.headers.Authorization}</simple>
</setBody>
<to uri="caffeine-cache://token?evictionType=TIME_BASED&amp;expireAfterWriteTime=290&amp;key=1"/>
```

Recomenda-se que o tempo de expiração do cache seja menor do que o valor devolvido
na obtenção do mesmo (neste exemplo considera-se que o tempo de expiração retornado
foi de 300 segundos, e o tempo de vida do cache foi estabelecido em290 segundos).

Após realizadas as devidas configurações, pode-se consumir a rota de obtenção do
cache de token. No entanto, devido a natureza síncrona e sequencial das chamadas
realizadas é necessário guardar o conteúdo original do payload, conforme o trecho:

```xml
<!-- SAVE INITIAL BODY -->
<unmarshal>
    <json library="Gson"/>
</unmarshal>
<setProperty name="payload">
    <simple>${in.body}</simple>
</setProperty>

<!-- OBTAINS TOKEN FROM CACHE -->
<to uri="direct:getToken"/>

<!--RESTORE INITIAL BODY -->
<setBody>
    <simple>${exchangeProperty[payload]}</simple>
</setBody>
```
