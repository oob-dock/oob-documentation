<div class="form-container">
  <form action="/api/login" method="post" class="form">
    <label>
      Login
      <input name="login" type="text" />
    </label>
    <label>
      Password
      <input name="password" type="password" />
    </label>
    <label>
      Name
      <input name="name" type="text" />
    </label>
    <label>
      CPF
      <input name="cpf" type="text" />
    </label>
    <label>
      CNPJ
      <input name="cnpj" type="text" />
    </label>
    <label>
      Consent Owner
      <textarea rows="20" name="consentOwner" />
    </label>
    <label>
      Extra Data
      <textarea rows="20" name="authExtraData" />
    </label>
    <div class="button-container">
      <button class="login-button">Entrar</button>
      <button formAction="/api/login/cancel" class="login-button">
        Cancelar
      </button>
    </div>
  </form>
</div>

<style>
  .form-container {
    width: 100%;
    display: flex;
    justify-content: center;
  }

  .form {
    display: flex;
    flex-direction: column;
    align-items: center;
    width: 90%;
    max-width: 400px;
  }

  .button-container {
    display: flex;
    gap: 1rem;
    width: 100%;
  }

  .login-button {
    flex: 1;
  }
</style>
