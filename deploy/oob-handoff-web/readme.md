# Instalação do OOB Handoff Web

## Instalação

A instalação do módulo é feita via Helm Chart

> **Atenção**: O módulo OOB Handoff Web é oferecido como um complemento à solução
> padrão do Opus Open Banking, devendo ser contratato separadamente.

## Configuração

### oobCustomHandoffUrlConfig

- Configuração da url da api que fornece o json que definirá
o estilo da página (cores, ícones, etc...).

### oobCustomHandoffASPublicUrl

- Configuração da url do endereço público do OOB Authorization Server

### oobCustomHandoffLibPath

- Caminho da biblioteca javascript usada no handoff, que terá como endereço
base a configuração definida na propriedade **oobCustomHandoffASPublicUrl**.
É um caminho padrão, só deve ser alterado em caso de nova versão da
biblioteca.

**Exemplo:**

```yaml
  oobCustomHandoffUrlConfig: "http://ev.instituicao.com.br/config.json"
  oobCustomHandoffASPublicUrl: "https://as.instituicao.com.br"
  oobCustomHandoffLibPath: "/auth/handoff/v1/oob-handoff.js"
```

## Referências

**[Configuração do AS pro handoff](../oob-authorization-server/readme.md#HANDOFF\_RESOURCE\_URL)**

**[Fluxo do handoff](../../consentimento/app2as-handoff/readme.md)**

**[Configuração do conteúdo da página de handoff](../../consentimento/app2as-handoff/custom-handoff-config/readme.md)**
