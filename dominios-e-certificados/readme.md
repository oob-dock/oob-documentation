# Domínios e certificados para Opus Open Banking

***

**ATENÇÃO**: Jamais disponibilize suas chaves privadas em serviços da internet.

***

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
| Regulatório | Sim              | Authorization Server                        | Assinatura       |                                                                              | Certificado BRSEAL            | Ver [^3]                                       |
| Regulatório | Depende do banco | Authorization Server do Banco [^2]          | Transporte       | `https://<dominio-AS-banco>`                                                 | HTTPS EV ou HTTPS [^1]        | <https://as-cliente.banco.com.br>              |
| Regulatório | Depende do banco | Resource Server - open-data (HTTPS)         | Transporte       | `https://<dominio-RS-1>`                                                     | HTTPS                         | <https://api.banco.com.br>                     |
| Regulatório | Sim              | Resource Server - Não open-data (mTLS)      | Transporte       | `https://<dominio-RS-2>`                                                     | Certificado ICP-Brasil e mTLS | <https://matls-api.banco.com.br>               |
| OOB         | Sim              | Resource Server - OOB (HTTPS)               | Transporte       | `https://<dominio-RS-1>`                                                     | HTTPS                         | <https://api.banco.com.br>                     |
| Regulatório | Opcional         | Portal Gestão Consentimento Cliente (HTTPS) | Transporte       | Critério do banco                                                            | HTTPS EV                      | <https://www.banco.com.br/gestaoconsentimento> |
| OOB         | Opcional         | Portal Backoffice (HTTPS)                   | Transporte       | Critério do banco                                                            | HTTPS                         | <https://interno.banco.com.br/backoffice-oob>  |

[^1]: Instalações com autenticação APP2APP não precisam de certificado EV por não conter front-end web para autenticação pelo cliente do banco
[^2]: Apenas para instalações com autenticação WEB2WEB utilizando federation entre o AS OOB e o AS do Banco
[^3]: [Documentação](https://openbanking-brasil.github.io/specs-seguranca/open-banking-brasil-certificate-standards-1_ID1.html#name-signature-certificate)
      e [Exemplo](https://openbanking-brasil.github.io/specs-seguranca/open-banking-brasil-certificate-standards-1_ID1.html#name-configuration-template-for-s)

Basicamente, os requisitos de segurança se dividem em dois tipos: HTTPS e HTTPS
com mTLS.

## Unificação de FQDNs

Uma possibilidade na instalação do Opus Open Banking na instituição é da
unificação de todos os endpoints externos pelos requisitos de segurança, isso
diminui a quantidade necessária de certificados EV e ICP-Brasil.

A unificação dos endpoints pode ser feita basicamente em dois endpoints, um
HTTPS tradicional com certificado EV e outro endpoint HTTPS MTLS com certificado
ICP-Brasil.

Essa unificação passa a necessitar de um tratamento de proxy reverso que deve
ser configurado adequadamente para rotear as requisições para os serviços
corretos, uma vez que o FQDN deixou de ter o contexto do serviço propriamente dito.

Sabendo então dessa perda de contexto, é interessante que os FQDNs usados não
induzam nenhum serviço, ficando com o único ponto em comum o cotexto do "open
banking" em si. Dessa forma os FQDNs sugeridos para uma instalação Open Banking
Brasil são:

- `openbanking.<instituição>.com.br` para os endpoints HTTPS e HTTPS EV
- `mtls-openbanking.<instituição>.com.br` para os endpoints HTTPS MTLS ICP-Brasil

O WAF (ou proxy reverso) deve receber requisições para as duas URLs e rotear
para o Kong ou authorization server em função do path acessado:

**Authorization server:**

- /auth
- /.well-known
- /apple-app-site-association

**Kong:**

- /open-banking
- Qualquer outra rota

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

## Certificado de assinatura

Os participantes do Open Banking Brasil precisam assinar diversas requisições
para provar a autenticidade da solicitação, essas assinaturas são efetuadas com
certificados do tipo BRSEAL descrito no  [Guia de Operação do Diretório Central](https://openbanking-brasil.github.io/areadesenvolvedor/documents/OpenBanking-Guia_Operacao_Diretorio_Central.pdf).

Os certificados de assinatura no ambiente de produção são emitidos por
certificadoras homologadas ICP-Brasil e Open Banking Brasil, os certificados
para ambientes não-produtivos são emitidos pelo próprio Diretório de
Participantes do Open Banking Brasil.

A instituição pode usar o mesmo certificado de assinatura esteja ela agindo como
iniciadora de pagamento/receptora ou detentora de conta/transmissora.

## HTTPS

A segurança mínima para os endpoints que não tem um mecanismo de segurança
específico é o HTTPS padrão.

## Considerações TLS para componentes regulatórios

É necessário observar os critérios para TLS na sessão [6.1.2](https://openbanking-brasil.github.io/specs-seguranca/open-banking-brasil-financial-api-1_ID1.html#section-6.1.2)
da especificação de segurança do OBB que descreve o uso de TLS1.2 e suporte para
`TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256` e `TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384`
nos endpoints do Authorization Server e Resource Server regulatórios

## Ambientes não-produtivos vs produtivos

Os ambientes não-produtivos possuem um relaxamento nas exigências dos
certificados. O sandbox do diretório de participantes age como CA para os
certificados de ambientes não-produtivo, permitindo um autosserviço por parte
da instituição na geração desses certificados.

É necessário que a instituição tenha os certificados HTTPS (EV e não EV)
preferencialmente gerados por algum CA válido nos navegadores. O serviço
gratuito [Let's Encrypt](https://letsencrypt.org/) pode ser usado como emissor
desses certificados.

O certificado de assinatura deve ser gerado no ambiente de sandbox do diretório
de participantes, o [guia de geração dos certificados](./tpp.md) para TPP contém
informações úteis para a geração e transformação de formatos dos certificados.

## Configuração da terminação de mTLS

Para rotas com mTLS, o WAF deve passar para os serviços internos o header
`X-SSL-Client-Cert` com o certificado utilizado pelo cliente.

**Para rotas sem mTLS, o WAF não deve repassar o header X-SSL-Client-Cert se ele
for recebido do cliente. O recebimento deste header de fora de um ambiente controlado
pode gerar falhas de segurança.**
