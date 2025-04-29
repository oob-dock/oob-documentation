# Validações Obrigatórias para Pagamentos

As validações a seguir devem ser implementadas na rota específica para a validação de dados do pagamento.

Os campos mencionados aqui independem do tipo de integração adotado.

Para cada validação, o erro listado na resposta da integração deve apresentar no campo `code` o código correspondente, conforme indicado.

## Validação do Valor Máximo do Pagamento

**ℹ️ Observações:**

- Validação realizada para pagamentos do tipo `PAYMENT_CONSENT` (valor do campo `requestBody.paymentType`).
- Todos os demais campos abaixo estão localizados dentro de `requestBody.data.payment`.

### Regra

O valor da transação (campo `amount`) deve estar abaixo:

- Do limite estabelecido pela Instituição Detentora (caso exista).
- Do valor máximo absoluto, em reais, de `999999999.99` (isto é, até 9 dígitos antes do ponto decimal e 2 após).
    - O valor **não** pode ser igual ao limite máximo.

**Código de erro:** `VALOR_ACIMA_LIMITE`

## Validações de QR Code

**ℹ️ Observações:**

- Validações realizada para pagamentos do tipo `PAYMENT_CONSENT` (valor do campo `requestBody.paymentType`).
- Todos os demais campos abaixo estão localizados dentro de `requestBody.data.payment`.

### Regras Gerais

1. O tipo do QR Code deve ser coerente com a forma de iniciação do pagamento (campo `details.localInstrument`):
    - Se a forma de iniciação for **QRES**, o QR Code deve ser **Estático**.
    - Se a forma de iniciação for **QRDN**, o QR Code deve ser **Dinâmico**.
    - **Código de erro:** `QRCODE_INVALIDO`

### Caso o QR Code seja **Estático**

1. O valor presente no QR Code Estático deve ser o mesmo informado no payload do pagamento (campo `amount`).
    - **Código de erro:** `VALOR_INVALIDO`

2. A chave Pix presente no QR Code Estático deve ser idêntica à chave Pix informada no payload do pagamento (campo `details.proxy`).
    - **Código de erro:** `QRCODE_INVALIDO`

### Caso o QR Code seja **Dinâmico**

1. O status do QR Code Dinâmico deve ser válido para uso.
    - **Código de erro:** `QRCODE_INVALIDO`
