# Customizable Handoff Page Configurations

> The configuration is done through a JSON file. The environment variable **OOB_CUSTOM_HANDOFF_URL_CONFIG** must be set to point to a valid URL that returns a JSON in the format of the following example.

Default configuration:
[config.json](#example-configuration)

| Key        | Description                                                   |
| ---------- | ------------------------------------------------------------- |
| logo       | Logo displayed at the top of the entire application           |
| favicon    | Icon shown in the browser tab                                 |
| title      | Page title shown in the browser tab                           |
| colors     | Colors to be used in the application                          |
| texts      | Texts to be used in the application                           |
| customHtml | Field to receive a string with HTML to be injected            |

## Colors

| Key         | Description                                |
| ----------- | ------------------------------------------ |
| primary     | Highlight primary color                    |
| background  | Background color of the entire app         |
| fontTitle   | Highlight text color on each page          |
| fontText    | Default font color throughout the app      |
| error       | Color used to represent errors             |

## Texts

| Key       |             | Description                                                                            |
| --------- | ----------- | -------------------------------------------------------------------------------------- |
| ready     |             | Initial Screen with the QR Code                                                        |
|           | title       | Highlight text on the page                                                             |
|           | codeText    | Text showing the validation code                                                       |
|           | timer       | Message that appears before the timer                                                  |
|           | keepOpened  | Warning that the browser window should remain open until the process is completed      |
| <br />    | <br />      | <br />                                                                                 |
| read      |             | Screen after the QR Code is read                                                       |
|           | title       | Highlight text on the screen                                                           |
|           | description | Text providing more details about the current status                                   |
| <br />    | <br />      | <br />                                                                                 |
| completed |             | Screen after everything is verified. This screen will automatically redirect to the TPP.|
|           | title       | Highlight text on the screen                                                           |
|           | description | Text providing more details about the current status                                   |
| <br />    | <br />      | <br />                                                                                 |
| timeout   |             | Screen when authentication time expires                                                |
|           | title       | Highlight text on the screen                                                           |
|           | description | Text providing more details about the current status                                   |
| <br />    | <br />      | <br />                                                                                 |
| error     |             | Screen for the error event triggered by the library                                    |
|           | title       | Highlight text on the screen                                                           |
|           | description | Text providing more details about the current status                                   |
| abort     |             | Messages for the cancellation screen and button                                        |
|           | title       | Highlight text on the screen                                                           |
|           | description | Text providing more details about the cancellation                                     |
|           | abortButton | Text that will appear on the cancel button                                             |

## Example Configuration

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
    },
    "abort": {
      "abortButton": "Cancelar operação",
      "title": "Operação cancelada!",
      "description": "Você será redirecionado de volta!"
    }
  }
}
```

## Custom HTML

> By setting the `customHtml` field in the configuration, the value will be injected into the footer of the page.

Example of HTML string:

```<div style='padding: 2rem;background: pink'><a href='https://ev.institution.com.br' style='padding: 1rem'>Click here!</a></div>```
