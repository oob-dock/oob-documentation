# Instalação do OOB Handoff Web

## Instalação

A instalação do módulo é feita via Helm Chart

> **Atenção**: O módulo OOB Handoff Web não faz parte do pacote padrão do Opus
> Open Banking, sendo comercializado separadamente.

## Configuração

### oobCustomHandoffUrlConfig

- Configuração da URL da API que fornece o JSON que definirá
o estilo da página (cores, ícones, etc...).

O retorno dessa API deve ser um objeto JSON com as propriedades definidas em
[Configuração do conteúdo da página de handoff](#referências).

Essa configuração pode ser feita pelo header `Access-Control-Allow-Origin`,
configurando o domínio da URL da página de handoff.

### oobCustomHandoffJsonConfig

- JSON que definirá o estilo da página (cores, ícones, etc...).

Essa variável deve receber um JSON em formato de String com as propriedades definidas
em [Configuração do conteúdo da página de handoff](#referências).

**Observação**: O objeto JSON deve ter aspas simples ao invés de aspas duplas,
caso contrário haverá problema no momento da injeção do valor da variável
durante a inicialização do módulo front-end.

**Importante**: Essa variável tem prioridade em relação a `oobCustomHandoffUrlConfig`,
ou seja, caso `oobCustomHandoffJsonConfig` seja definida, `oobCustomHandoffUrlConfig`
não será utilizada.

Ex: `"{'logo':'https://ev.instituicao.com.br/logo.png','favicon':'https://ev.instituicao.com.br/icone.png',
'title':'Open Banking','colors':{'primary':'#BA1D36','background':'#EEEEEE',
'fontTitle':'#BA1D36','fontText':'#333333','error':'#B33A3A'},'texts':{'ready':
{'title':'Escaneie o código QR','codeText':'Código para validação','timer':
'Tempo restante -','keepOpened':'Atenção: mantenha esta página aberta até que
você confirme sua solicitação.'},'read':{'title':'Código escaneado','description':
'O seu código foi escaneado com sucesso. Aguarde a validação.'},'completed':
{'title':'Sucesso!','description':'Sua autenticação foi realizada com sucesso.
Agora você será redirecionado de volta.'},'timeout':{'title':'Código expirado',
'description':'O tempo de validação do código QR expirou. Tente novamente.'},
'error':{'title':'Oops! Algo deu errado','description':'Você será redirecionado
de volta.'}}}"`

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
