# OOB Portal Backoffice

## Configuração do portal

Abaixo as propriedades editáveis:

| Propriedade | Descrição
| ------ | ------ |
| app > title | Título da página
| app > faviconPath | Caminho do ícone da página
| app > copyright | Copyright
| brand > name | Nome da marca
| brand > path | Caminho do logotipo da marca

## Customização da UI

É possível fazer apenas algumas customizações na UI do portal.
Vários temas podem ser criado e passar o valor de qual tema deseja ser utilizado.
Seguindo esse exemplo:

```json
  {
    ...
    "selectedTheme": "default",
    "themes": [
      {
        "name": "default",
        "variables": {
          "primary-color": "grey"
          ...
        }
      }
    ]
  }
```

> É importante informar o tema selecionado, do contrário
> a aplicação do tema não terá efeito.

Abaixo a lista das variáveis de tema que o portal suporta atualmente:

| Propriedade | Descrição
| ------ | ------ |
| primary-color | Cor principal (Aplicada na maioria dos elementos do portal)
| primary-color-light | Cor principal mais clara
| secondary-color | Cor secundária
| tertiary-color | Cor terciária
| bg-color | Cor de fundo da página
| alert-color | Cor de alerta, usado principalmente no ícone de exclusão
| attention-color | Cor de aviso
| success-color | Cor de sucesso
| link-color | Cor dos links

## Exemplo de configuração que deve ser passada para o portal

```json
  {
    "app": {
      "title": "Opus Open Banking",
      "faviconPath": "https://bank.com.br/favicon.ico",
      "copyright": "2022 Copyright by Opus Open Banking"
    },
    "brand": {
      "name": "Opus Open Banking",
      "path": "https://bank.com.br/logo.svg"
    },
    "sidebarStatus": "closed",
    "selectedTheme": "default",
    "themes": [
      {
        "name": "default",
        "variables": {
          "primary-color": "#000000",
          "primary-color-light": "#000000",
          "secondary-color": "#000000",
          "tertiary-color": "#000000",
          "bg-color": "#ffffff",
          "alert-color": "#000000",
          "attention-color": "#000000",
          "success-color": "#000000",
          "link-color": "#000000"
        }
      }
    ]
  }
```
