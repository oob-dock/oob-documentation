# Configurações da página de handoff customizável

> A configuração é feita através de um arquivo json. A variável de
> ambiente **OOB_CUSTOM_HANDOFF_URL_CONFIG** deve ser configurada
> de modo que aponte para uma url válida que retorne
> um json com o formato do exemplo a seguir.

Configuração usada como default:
[config.json](#exemplo-de-configuração)

| Chave     | Descrição                                                        |
| --------- |  --------------------------------------------------------------- |
| logo      | Logo mostrado na parte superior de todo o aplicativo             |
| favicon   | Icone mostrado na aba do navegador                               |
| title     | Título da página mostrado na aba do navegador                    |
| colors    | Cores a serem utilizadas no aplicativo                           |
| texts     | Textos a serem utilizados no aplicativo                          |

## Cores

| Chave      | Descrição                               |
| ---------- | --------------------------------------- |
| primary    | Cor primária em destaque                |
| background | Cor de fundo de todo o app              |
| fontTitle  | Cor do texto em destaque em cada página |
| fontText   | Cor padrão da fonte em todo app         |
| error      | Cor usada para representar erro         |

## Textos

| Chave     |             | Descrição                                                                            |
| --------- | ----------- | ------------------------------------------------------------------------------------ |
| ready     |             | Tela Inicial com o QR Code                                                           |
|           | title       | Texto em destaque na página                                                          |
|           | codeText    | Texto mostrando o código de validação                                                |
|           | timer       | Mensagem que aparece antes do timer                                                  |
|           | keepOpened  | Aviso de que a janela do navegador deverá ficar aberta até ser completado o processo |
| <br />    | <br />      | <br />                                                                               |
| read      |             | Tela após o QR Code ser lido                                                         |
|           | title       | Texto em destaque na tela                                                            |
|           | description | Texto informando com mais detalhes o atual status                                    |
| <br />    | <br />      | <br />                                                                               |
| completed |             | Tela após tudo verificado. Esta tela fará o direcionamento automático para o TPP.    |
|           | title       | Texto em destaque na tela                                                            |
|           | description | Texto informando com mais detalhes o atual status                                    |
| <br />    | <br />      | <br />                                                                               |
| timeout   |             | Tela para quando é esgotado o tempo de autenticação                                  |
|           | title       | Texto em destaque na tela                                                            |
|           | description | Texto informando com mais detalhes o atual status                                    |
| <br />    | <br />      | <br />                                                                               |
| error     |             | Tela para o evento de erro disparado pela lib                                        |
|           | title       | Texto em destaque na tela                                                            |
|           | description | Texto informando com mais detalhes o atual status                                    |

## Exemplo de configuração

```json
{
  "logo": "https://ev.instituicao.com.br/logo.png",
  "favicon": "https://ev.instituicao.com.br/icone.png",
  "title": "Instituição Nome Exemplo",
  "colors": {
    "primary": "#BA1D36",
    "background": "#FFFFFF",
    "fontTitle": "#BA1D36",
    "fontText": "#333333",
    "error": "#B33A3A"
  },
  "texts": {
    "ready": {
      "title": "Escaneie o código QR",
      "codeText": "Código para validação",
      "timer": "Tempo restante - ",
      "keepOpened": "Atenção: mantenha esta página aberta até que você confirme sua solicitação."
    },
    "read": {
      "title": "Código escaneado",
      "description": "O seu código foi escaneado com sucesso. Aguarde a validação."
    },
    "completed": {
      "title": "Sucesso!",
      "description": "Sua autenticação foi realizada com sucesso. Agora você será redirecionado de volta."
    },
    "timeout": {
      "title": "Código expirado",
      "description": "O tempo de validação do código QR expirou. Tente novamente."
    },
    "error": {
      "title": "Oops! Algo deu errado",
      "description": "Você será redirecionado de volta."
    }
  }
}
```
