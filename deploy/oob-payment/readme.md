# Instalação do OOB Payment

## Instalação

A instalação do módulo é feita via Helm Chart

## Configuração

### internalApis/consentServer

Endereço base do serviço de consentimento

**Ex:** `http://oob-consent` #Apontamento interno no K8s
  
### tokenValidationService

Configuração de validação do token de autenticação

* host: Endereço base do authorization server

**Ex:** `http://oob-authorization-server` #Apontamento interno no K8s

* path: Caminho do endpoint de introspection

**Ex:** /auth/token/introspection

* clientId: Client criado na configuração do oob-authorization-server

* clientSecret: Secret do client criado na configuração do oob-authorization-server

### signature

Lista de chaves privadas utilizadas para encriptar ou assinar mensagens. A lista
deve conter pelo menos uma chave com use = sig (assinatura).

* certSecretName: Nome do secret que contém a chave privada. Default: "oob-as-keys"
* certSecretKey: Nome da propriedade do secret que contém a chave privada. Default:
"sig.key"
* kid: Identificador da chave (Obtido do diretório de participantes)

Exemplo:

```yaml
  privateKeys:
    certSecretName: "oob-as-keys"
    certSecretKey: "sig.key"
    kid: "uGe7YNnhE83esu86xeqGJMIQi8IamA8FTSaLd1pkXy8"
```

### organisation/id

Deve ser preenchido com o organisationId da instituição cadastrada no diretório
de participantes.
Utilizar o id de sandbox para ambientes não produtivos, e o valor de produção
para ambientes produtivos.

#### cnpjInitiatorValidation

* directoryRolesUrl: Endereço do diretório de participantes. Ambientes
não-produtivos devem utilizar o endereço de sandbox do diretório de participantes.

| Ambiente | Endereço                                                        |
| -------- | --------------------------------------------------------------- |
| Sandbox  | <https://data.sandbox.directory.openbankingbrasil.org.br/roles> |
| Produção | <https://data.directory.openbankingbrasil.org.br/roles>         |

* cacheTimeout: Tempo de vida definido para armazenamento do cache do diretório
de participantes.

**Ex:**: 5M (cinco minutos)
