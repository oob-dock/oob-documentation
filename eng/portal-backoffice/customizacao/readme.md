# OOB Portal Backoffice

The Backoffice Portal allows some style configurations, such as title,
icons, logo, and colors of your visual identity.

## Portal Configuration

Below are the editable properties:

| Property           | Description                |
| ------------------ | -------------------------- |
| app > title        | Page title                 |
| app > faviconPath  | Page icon path             |
| app > copyright    | Copyright                  |
| brand > name       | Brand name                 |
| brand > path       | Brand logo path            |

## UI Customization

It is possible to make some customizations in the portal UI.
Various themes can be created, and through the selectedTheme property, it should be
indicated which theme will be active.
Following this example:

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

> It is important to specify the selected theme, otherwise
> the theme application will have no effect.

Below is the list of theme variables that the portal currently supports:

| Property             | Description                                                    |
| -------------------- | -------------------------------------------------------------- |
| primary-color        | Primary color (Applied to most elements of the portal)         |
| primary-color-light  | Lighter primary color                                          |
| secondary-color      | Secondary color                                                |
| tertiary-color       | Tertiary color                                                 |
| bg-color             | Page background color                                          |
| alert-color          | Alert color, mainly used in the delete icon                    |
| attention-color      | Warning color                                                  |
| success-color        | Success color                                                  |
| link-color           | Link color                                                     |

## Example of configuration to be passed to the portal

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