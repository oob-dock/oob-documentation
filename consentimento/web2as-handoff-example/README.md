# Web2AS Handoff Example

Aplicativo web de exemplo de implementação do fluxo de autenticação web e de
telas customizadas de geração de consentimento, bem como exemplo de implementação
de tela para o fluxo de handoff.

A documentação sobre o fluxo web pode ser conferida [aqui](../web2as/readme.md).

A documentação sobre o fluxo handoff pode ser conferida [aqui](../app2as-handoff/readme.md).

## Instalando

```bash
npm install
```

## Executando em desenvolvimento

```bash
npm run dev
```

## Variáveis de ambiente configuradas (arquivo .env)

`API_REQUEST_TIMEOUT`: Tempo máximo de espera de retorno das chamadas de API
feitas ao Authorization Server (AS).

**Exemplo**: `5000`.

`AS_OOB_URL`: Endereço base do AS. Geralmente essa URL termina com `/auth`.

**Exemplo**: `"https://oob.authorization-server/auth"`.

`JWT_PRIVATE_KEY`: Chave privada a ser utilizada para assinar o token JWT.

**Exemplo**: `"-----BEGIN PRIVATE KEY-----\nprivatekey\n-----END PRIVATE KEY-----"`.

`JWT_KID`: Identificador da chave a ser utilizada na criação e assinatura dos tokens
JWT. Em cenários de existência de múltiplas chaves esse identificador é necessário
para que na hora de decodificar o token seja possível saber qual chave o assinou,
para então validar essa assinatura.

**Exemplo**: `"EUsMHFwXz5zMhkJoi1lcnIM2pCpLc3kc_2WV8YKZCK9"`.
