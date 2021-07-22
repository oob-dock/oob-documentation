# Domínios e certificados para Opus Open Banking

Este documento compila a documentação do Open Banking Brasil (OBB) descrevendo
os domínios, endpoints e requisitos de segurança para uma implantação do produto
Opus Open Banking (OOB).

Uma solução de Open Banking típica possui os seguintes componentes expostos para
o ecossistema do OBB:

- Authorization Server
- Resource Server (APIs regulatórias)

Além disso, a solução OOB adiciona componentes opcionais de uso:

- APIs extras para utilização por aplicações do banco
- APIs extras para suporte aos portais de gestão consentimento cliente e backoffice
- Portal de gestão consentimento cliente
- Portal backoffice

As exigências para eles são:

| Tipo        | Obrigatório      | Componente                                  | Tipo certificado | Domínio                                                                      | Exigências                    | Exemplo                                        |
| ----------- | ---------------- | ------------------------------------------- | ---------------- | ---------------------------------------------------------------------------- | ----------------------------- | ---------------------------------------------- |
| Regulatório | Sim              | Authorization Server                        | Transporte       | `https://<dominio-AS-OBB-1>`                                                 | HTTPS EV ou HTTPS [^1]        | <https://as-obb.banco.com.br>                  |
| Regulatório | Sim              | Authorization Server (mTLS)                 | Transporte       | `https://<dominio-AS-OBB-2>`<br>Sugestão: `https://matls-<dominio-AS-OBB-1>` | Certificado ICP-Brasil e mTLS | <https://matls-as-obb.banco.com.br>            |
| Regulatório | Depende do banco | Authorization Server do Banco [^2]          | Transporte       | `https://<dominio-AS-banco>`                                                 | HTTPS EV ou HTTPS [^1]        | <https://as-cliente.banco.com.br>              |
| Regulatório | Depende do banco | Resource Server - open-data (HTTPS)         | Transporte       | `https://<dominio-RS-1>`                                                     | HTTPS                         | <https://api.banco.com.br>                     |
| Regulatório | Sim              | Resource Server - Não open-data (mTLS)      | Transporte       | `https://<dominio-RS-2>`                                                     | Certificado ICP-Brasil e mTLS | <https://matls-api.banco.com.br>               |
| OOB         | Sim              | Resource Server - OOB (HTTPS)               | Transporte       | `https://<dominio-RS-1>`                                                     | HTTPS                         | <https://api.banco.com.br>                     |
| Regulatório | Opcional         | Portal Gestão Consentimento Cliente (HTTPS) | Transporte       | Critério do banco                                                            | HTTPS EV                      | <https://www.banco.com.br/gestaoconsentimento> |
| OOB         | Opcional         | Portal Backoffice (HTTPS)                   | Transporte       | Critério do banco                                                            | HTTPS                         | <https://interno.banco.com.br/backoffice-oob>  |

[^1]: Instalações com autenticação APP2APP não precisam de certificado EV por não conter front-end web para autenticação pelo cliente do banco
[^2]: Apenas para instalações com autenticação WEB2WEB utilizando federation entre o AS OOB e o AS do Banco

Basicamente, os requisitos de segurança se dividem em dois tipos: HTTPS e HTTPS
com mTLS.

## HTTPS EV

Os endpoints que hospedam algum front-end para clientes da instituição precisam
ter HTTPS com certificado EV conforme diz a seção
[5.2.4](https://openbanking-brasil.github.io/specs-seguranca/open-banking-brasil-certificate-standards-1_ID1.html#section-5.2.4)
da documentação do Open Banking Brasil.

## Certificado ICP-Brasil de transporte e mTLS

Os endpoints com certificado ICP-Brasil devem ser configurados com HTTPS e o
certificado para servidores WEB da ICP-Brasil, conforme a sessão [5.2.1](https://openbanking-brasil.github.io/specs-seguranca/open-banking-brasil-certificate-standards-1_ID1.html#name-server-certificate)
da especificação de segurança do OBB, além do mais o ponto de conexão (WAF,
firewall, proxy reverso) no banco pode exigir o certificado cliente,
aumentando a segurança através de mTLS.

## HTTPS

A segurança mínima para os endpoints que não tem um mecanismo de segurança
específico é o HTTPS padrão.

## Considerações TLS para componentes regulatórios

É necessário observar os critérios para TLS na sessão [6.1.2](https://openbanking-brasil.github.io/specs-seguranca/open-banking-brasil-financial-api-1_ID1.html#section-6.1.2)
da especificação de segurança do OBB que descreve o uso de TLS1.2 e suporte para
`TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256` e `TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384`
nos endpoints do Authorization Server e Resource Server regulatórios
