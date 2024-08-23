# Domains and Certificates for Opus Open Finance

***

**:warning: ATTENTION**: Never share your private keys on internet services.

***

This document compiles the Open Finance Brazil (OFB) documentation describing the domains, endpoints, and security requirements for an Opus Open Finance (OOF) product deployment.

A typical Open Finance solution has the following components exposed to the OFB ecosystem:

- Authorization Server (AS)
- Resource Server (regulatory APIs)

In addition, the OOB solution adds optional use components:

- Extra APIs for bank applications
- Extra APIs to support client consent management and back-office portals
- Client consent management portal
- Back-office portal

The requirements for them are:

| Type        | Mandatory        | Component                                  | Certificate Type | Domain                                                                       | Requirements                  | Example                                        |
| ----------- | ---------------- | ------------------------------------------ | ---------------- | ---------------------------------------------------------------------------- | ----------------------------- | ---------------------------------------------- |
| Regulatory  | Yes              | Authorization Server                       | Transport        | `https://<domain-AS-OBB-1>`                                                  | HTTPS EV or HTTPS             | <https://as-obb.bank.com>                      |
| Regulatory  | Yes              | Authorization Server (mTLS)                | Transport        | `https://<domain-AS-OBB-2>`<br>Suggestion: `https://matls-<domain-AS-OBB-1>` | ICP-Brasil Certificate and mTLS | <https://matls-as-obb.bank.com>                |
| Regulatory  | Yes              | Authorization Server                       | Signature        |                                                                              | BRSEAL Certificate            | See [^3]                                       |
| Regulatory  | Bank-dependent   | Bank's Authorization Server [^2]           | Transport        | `https://<domain-AS-bank>`                                                  | HTTPS EV or HTTPS             | <https://as-client.bank.com>                   |
| Regulatory  | Bank-dependent   | Resource Server - open-data (HTTPS)        | Transport        | `https://<domain-RS-1>`                                                      | HTTPS                         | <https://api.bank.com>                         |
| Regulatory  | Yes              | Resource Server - Non open-data (mTLS)     | Transport        | `https://<domain-RS-2>`                                                      | ICP-Brasil Certificate and mTLS | <https://matls-api.bank.com>                   |
| OOB         | Yes              | Resource Server - OOB (HTTPS)              | Transport        | `https://<domain-RS-1>`                                                      | HTTPS                         | <https://api.bank.com>                         |
| Regulatory  | Optional         | Client Consent Management Portal (HTTPS)   | Transport        | Bank's criteria                                                             | HTTPS EV                      | <https://www.bank.com/consentmanagement>       |
| OOB         | Optional         | Back-office Portal (HTTPS)                 | Transport        | Bank's criteria                                                             | HTTPS                         | <https://internal.bank.com/backoffice-oob>     |

[^2]: Only for installations with WEB2WEB authentication using federation between the OOB AS and the Bank AS
[^3]: [Documentation](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/246054913/EN+Padr+o+de+Certificados+Open+Finance+Brasil+2.1#5.2.3.-Signature-Certificate) and [Example](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/246054913/EN+Padr+o+de+Certificados+Open+Finance+Brasil+2.1#8.3.-Configuration-Template-for-Signature-Certificate---OpenSSL)

Basically, the security requirements are divided into two types: HTTPS and HTTPS with mTLS.

## Unification of FQDNs

One possibility in the Opus Open Banking installation at the institution is the unification of all external endpoints for security requirements, which reduces the necessary amount of EV and ICP-Brasil certificates.

The unification of the endpoints can be done basically into two endpoints, a traditional HTTPS with EV certificate and another HTTPS MTLS endpoint with ICP-Brasil certificate.

This unification requires a reverse proxy setup that must be properly configured to route requests to the correct services, as the FQDN no longer provides the context of the service itself.

Knowing this loss of context, it is advisable that the FQDNs used do not induce any service, having as the only common point the context of "open banking" itself. Therefore, the suggested FQDNs for an Open Finance Brazil installation are:

- `openbanking.<institution>.com.br` for HTTPS and HTTPS EV endpoints
- `mtls-openbanking.<institution>.com.br` for HTTPS MTLS ICP-Brasil endpoints

The WAF (or reverse proxy) should receive requests for the two URLs and route them to Kong or the authorization server based on the accessed path:

**Authorization server:**

- /auth
- /.well-known
- /apple-app-site-association

**Kong:**

- /open-banking
- Any other route

## HTTPS EV

Endpoints hosting any front-end for the institution's clients must have HTTPS with EV certificate as stated in section [5.2.4](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/246054913/EN+Padr+o+de+Certificados+Open+Finance+Brasil+2.1#5.2.4.-Front-End-Certificates) of the Open Banking Brazil documentation.

## ICP-Brasil Transport and mTLS Certificate

Endpoints with ICP-Brasil certificates must be configured with HTTPS and the ICP-Brasil server certificate, as per section [5.2.1](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/246054913/EN+Padr+o+de+Certificados+Open+Finance+Brasil+2.1#5.2.1.-Server-Certificate) of the OBB security specification. Additionally, the connection point (WAF, firewall, reverse proxy) at the bank may require the client certificate, increasing security through mTLS.

## Signature Certificate

Participants in Open Banking Brazil need to sign various requests to prove the authenticity of the request. These signatures are made with BRSEAL certificates described in the [Central Directory Operation Guide](https://openbanking-brasil.github.io/areadesenvolvedor/documents/OpenBanking-Guia_Operacao_Diretorio_Central.pdf).

Signature certificates in the production environment are issued by ICP-Brasil and Open Banking Brazil accredited certifiers. Certificates for non-production environments are issued by the Open Banking Brazil Participant Directory itself.

The institution can use the same signature certificate whether acting as a payment initiator/receiver or account holder/transmitter.

## HTTPS

The minimum security for endpoints without a specific security mechanism is standard HTTPS.

## TLS Considerations for Regulatory Components

It is necessary to observe the TLS criteria in section [8.4](https://openfinancebrasil.atlassian.net/wiki/spaces/OF/pages/246054913/EN+Padr+o+de+Certificados+Open+Finance+Brasil+2.1#8.4.-Endpoints-vs-Certificate-type-and-mTLS-requirements) of the OBB security specification, which describes the use of TLS1.2 and support for `TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256` and `TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384` on Authorization Server and regulatory Resource Server endpoints.

## Non-production vs. Production Environments

Non-production environments have relaxed certificate requirements. The participant directory sandbox acts as a CA for non-production environment certificates, allowing the institution to self-service these certificates.

It is necessary for the institution to have HTTPS certificates (EV and non-EV) preferably issued by a CA valid in browsers. The free service [Let's Encrypt](https://letsencrypt.org/) can be used as the issuer of these certificates.

The signature certificate must be generated in the sandbox environment of the participant directory. The [certificate generation guide](./tpp.md) for TPP contains useful information for generating and converting certificate formats.

## mTLS Termination Configuration

For mTLS routes, the WAF must pass the `X-SSL-Client-Cert` header to internal services with the client's certificate used.

**For non-mTLS routes, the WAF must not pass the `X-SSL-Client-Cert` header if it is received from the client. Receiving this header from outside a controlled environment can generate security breaches.**
