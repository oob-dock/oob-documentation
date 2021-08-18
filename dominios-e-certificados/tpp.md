# Certificados do diretório central (SANDBOX)

***

**ATENÇÃO**: Jamais disponibilize suas chaves privadas em serviços da internet.

***

Esse guia é uma compilação dos documentos para geração dos certificados para Open Banking.

## TPP

Utilize o [Guia de Operação do Diretório Central](https://openbanking-brasil.github.io/areadesenvolvedor/documents/OpenBanking-Guia_Operacao_Diretorio_Central.pdf) para cadastrar um novo TPP (Software Statement)

Informações importantes:

- Não é possível alterar as informações do Software Statement após visualizar o Software Statement Assertion
- Verifique todos os campos **múltiplas vezes** antes de concluir o cadastro
- Atenção especial aos endereços **`REDIRECT URI`**

### redirect_uri para testes e certificação

As seguintes URL são sugeridas como redirect_uri na criação de Software
Statement no diretório de participantes:

Para ferramentas de testes do Opus Open Banking:

- `https://tpp-client1.127.0.0.1.nip.io/cb`
- `https://tpp-client1.127.0.0.1.nip.io:3100/auth`
- `https://tpp-client1.127.0.0.1.nip.io:3100/cb`
- `https://tpp-client2.127.0.0.1.nip.io:3100/auth`
- `https://tpp-client2.127.0.0.1.nip.io:3100/cb`
- `https://tpp-client3.127.0.0.1.nip.io:3100/auth`
- `https://tpp-client3.127.0.0.1.nip.io:3100/cb`
- `https://tpp.127.0.0.1.nip.io:3100/auth`
- `https://tpp.127.0.0.1.nip.io:3100/cb`
- `https://tpp.localhost:3100/auth`
- `https://tpp.localhost:3100/cb`

Para a ferramenta de certificação OpenID (<https://gitlab.com/openid/conformance-suite>)
ou a certificação funcional (<https://gitlab.com/obb1/certification>)
executando localmente:

- `https://www.certification.127.0.0.1.nip.io:8443/test/a/<alias>/callback` 
- `https://www.certification.127.0.0.1.nip.io:8443/test/a/<alias>/callback?dummy1=lorem&dummy2=ipsum`

Para a ferramenta de certificação OpenID (<https://www.certification.openid.net/>):

- `https://www.certification.openid.net/test/a/<alias>/callback`
- `https://www.certification.openid.net/test/a/<alias>/callback?dummy1=lorem&dummy2=ipsum`

Para a ferramenta de certificação funcional (<http://web.conformance.directory.openbankingbrasil.org.br/>)

- `https://web.conformance.directory.openbankingbrasil.org.br/test/a/<alias>/callback`

**Importante**: As URLs de certificação devem ter o `<alias>` trocado por uma
string que identifique de forma única a instalação a ser certificada, conforme
o [guia de certificação](https://openid.net/certification/connect_op_testing/#:~:text=You%20must%20select%20an%20%E2%80%9CALIAS%E2%80%9D%20to%20use)
da OpenID, isso impede que execuções das instituições interfiram umas com
as outras.

### Certificados TPP

As aplicações clientes (TPPs) necessitam 2 certificados distintos:

- BRCAC (JWK: `"use": "enc"`)
- BRSEAL (JWK: `"use": "sig"`)

O certificado BRCAC é utilizado nas conexões MTLS para identificação da aplicação cliente e criptografias entre o aplicativo e o banco.

O BRSEAL é utilizado nas assinaturas entre a aplicação TPP e o servidor de autenticação e também nas  assinatura dos tokens JWS.

### Convertendo os certificados para JWKS

Após a geração dos certificados BRCAC e BRSEAL pode ser necessário convertê-los em um JWKS para utilizar no programa de certificação da OpenID.

## Informações importantes para clientes de certificação

O [programa de certificação](https://gitlab.com/openid/conformance-suite) da OpenID exige as seguintes configurações (em execução local):

### REDIRECT URI

<https://localhost:8443/test/a/obbsb/callback>

## Converter o certificado em JWK

**IMPORTANTE**: Jamais utilize serviços on-line para conversão de certificados, você não quer colocar teu bem mais precioso num site desconhecido

### Pré-requisitos

- Node
- `npm install -g pem-jwk`
  
### Passos

1. `openssl rsa -in <certificado>.key -out <certificado-em-rsa>.key`
2. `pem-jwk <certificado-em-rsa.key> > <jwk.json>`
3. Adicionar os atributos faltantes:
   - `"use": "<enc|sig>"` (depende to tipo do certificado: BRCAC=enc, BRSEAL=sig)
   - `"alg": "PS256"` 
   - `"kid": "<kid>"`

    O valor do atributo kid pode ser obtido no JWKS publicado no diretório central que é o mesmo que o arquivo PEM gerado pelo diretório central.

### Encapsulando em um JWKS

A estrutura de um arquivo JWKS é a seguinte, basta adicionar cada JWK no atributo jwks do JSON.

```JSON
{ 
    "jwks": [ {
        <JWK-1>
    }, {
        <JWK-2>
    }]
}
```

## Links úteis

### Verificando conteúdo do certificado cliente

Basta fazer uma chamada utilizando o certificado desejado como certificado cliente
para a URL <https://prod.idrix.eu/secure/> e ver as propriedades do seu certificado.

### Gerando chaves JWKS para teste

O serviço <https://mkjwk.org/> realiza a geração de JWK de vários formatos
possíveis, útil para ambientes **não-produtos**.
