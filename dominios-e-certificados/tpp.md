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
