# Using the Camel XML Cache Component

This document aims to explain and exemplify the use of the cache component available in the Opus Open Banking payment API to optimize resource usage, especially for authentication, which has a specific lifespan and allows for reuse.

The solution uses the [caffeine cache](https://camel.apache.org/components/3.12.x/caffeine-cache-component.html), which allows configuring the cache invalidation method, either by size or by time (in seconds, which better meets the need). It is also possible to set the cache expiration time, whether it should occur after the access time or write time has elapsed.

**:warning: Attention**: The cache of the component is stored in memory, so it will be lost if the container is restarted (a new call will be made to retrieve the data). Additionally, caution is needed regarding its lifespan, as it should not be too short (there would be little advantage in storing it) nor too long (as the data may become outdated).

Below are two examples of Camel XML route files with cache configurations, respectively for the consent and payment APIs.

- [Consent](./attachments/OOB_Cache_Consent.xml)
- [Payment](./attachments/OOB_Cache_Payment.xml)

The `tokenService` route is responsible for calling the token retrieval service; within it, the credentials and the content-type header are provided, and upon return of the call, the `Authorization` header is filled with the `access_token` (in this example, OAuth2 authentication is assumed). The `getToken` route is responsible for managing the cache control, where a check is first made to see if there is valid cache (snippet below):

```xml
<!-- GET TOKEN IN CACHE -->
<setHeader name="CamelCaffeineAction">
    <constant>GET</constant>
</setHeader>
<to uri="caffeine-cache://token?evictionType=TIME_BASED&amp;expireAfterWriteTime=290&amp;key=1"/>
```

For this example, the time-based invalidation type is used (`evictionType=TIME_BASED`), establishing that the cache expiration time is 290 seconds after the cache is written (`expireAfterWriteTime=290`), with `1` being the cache key (`key=1`). If the cache does not exist or has expired, a call is made to obtain the token (`<to uri="direct:tokenService"/>`), and the result is persisted in the cache using the following snippet:

```xml
<setHeader name="CamelCaffeineAction">
    <constant>PUT</constant>
</setHeader>
<setBody>
    <simple>${in.headers.Authorization}</simple>
</setBody>
<to uri="caffeine-cache://token?evictionType=TIME_BASED&amp;expireAfterWriteTime=290&amp;key=1"/>
```
It is recommended that the cache expiration time be shorter than the value returned when obtaining the token (in this example, the returned expiration time was 300 seconds, and the cache lifespan was set to 290 seconds).

After making the necessary configurations, the token cache retrieval route can be consumed. However, due to the synchronous and sequential nature of the calls made, it is necessary to store the original payload content, as shown in the following snippet:

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