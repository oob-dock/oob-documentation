# Instalação do OOF Fido Server

## Instalação

A instalação do módulo é feita via Helm Chart.

## Configuração

### db

Configuração de acesso ao banco.

* name: Nome da base
* username: Nome do usuário de acesso ao banco
* password: Senha do usuário de acesso ao banco
* host: Host do banco
* port: Porta do banco de dados

Exemplo:

```yaml
env:
  db:
    name: "oof_fido_server"
    username: "oof_fido_server"
    password: "oof_fido_server"
    host: "postgres.local"
    port: 5432
```

### liquibase/contexts

Vide a [definição](../shared-definitions.md#liquibase-contexts).

## FIDO

As definições padrão da RP pode ser configurada com os seguintes atributos.

Exemplo:

```yaml
env:
  fido:
    attestation: "none"
    authenticatorSelection:
      residentKey: "discouraged"
      userVerification: "preferred"
    algorithms: "-65535,-257,-258,-259,-7,-35,-36,-8"
```

***Importante***: Os valores definidos como padrão acima seguem o padrão definido na
especificação W3C para WebAuthn 2 - https://www.w3.org/TR/webauthn-2 - e devem ser
mantidos. Devem ser alterados apenas mediante solicitação da RP (ITP).

### Attestation

Define a forma como a RP gostaria de receber as informações do
authenticator/credenciais utilizados para validação no servidor,
conforme definição em https://www.w3.org/TR/webauthn-2/#attestation-conveyance.

Pode ser definido com os seguintes valores: "none", "indirect", "direct" ou "enterprise".

Valor padrão: "none".

### Authenticator Selection

Define requisitos que devem ser atendidos pelo authenticator selecionado pelo cliente
para criação e gerenciamento das chaves de criptografia utilizadas no FIDO2.

#### Resident Key

Define se o authenticator deve obrigatoriamente armazenar um identificador para
a credencial de acesso do usuário, conforme definido em
https://www.w3.org/TR/webauthn-2/#dom-authenticatorselectioncriteria-residentkey.

Pode ser definido com os seguintes valores: "discouraged", "preferred" ou "required".

Valor padrão: "discouraged".

#### User Verification

Define se o authenticator deve suportar algum método de validação do usuário,
como biometria, PIN, etc.

Pode ser definido com os seguintes valores: "required", "preferred" ou "discouraged".

Valor padrão: "preferred".

### Algorithms

Lista de algoritmos de criptografia suportados pelo servidor,
separados por vírgula. Os valores suportados são de acordo com a tabela
[`IANA COSE Algorithms registry`](https://www.iana.org/assignments/cose/cose.xhtml#algorithms).

Atualmente, os algoritmos suportados são:

* RS1 -> -65535;
* RS256 -> -257;
* RS384 -> -258;
* RS512 -> -259;
* ES256 -> -7;
* ES384 -> -35;
* ES512 -> -36;
* EdDSA -> -8;

Valor padrão: "-65535,-257,-258,-259,-7,-35,-36,-8"

## Variáveis adicionais

### Customização para um RP específica

Caso seja necessário alterar uma configuração FIDO para uma única RP, deve-se
adicionar seu identificador (CN do certificado BRCAC) ao nome da configuração e
incluí-la como *additional var*.
O exemplo a seguir considera uma RP (ITP) com BRCAC de CN igual a
"opussoftware.com.br":

```yaml
additionalVars:
    - name: fido_opussoftware_com_br_attestation
      value: direct
```

***Importante***: Todos os caracteres não alfanuméricos devem
ser substituídos por ***_***. 

Isso irá mudar apenas a configuração de *attestation* para essa RP. Todas
as demais configurações utilizarão o valor padrão.