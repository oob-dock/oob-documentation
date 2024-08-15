<script>
  import Logs from '../components/Logs.svelte';
  import { onMount } from 'svelte';
	let consent;
	onMount(async () => {
		consent = await fetch('/api/consent').then(x => x.json())
	})
</script>

<div class="log-container">
  <Logs logs={consent} />
</div>
<br />
<form action="/api/consent" method="post" class="form-container">
  <p>
    Selecione os ids separados por vírgula. <br />
    Ex: "<b>e2029eb4-49be-462b-9ff6-da8a8ef0e918</b>,
    <b>e2029eb4-49be-462b-9ff6-da8a8ef0e919</b>"
  </p>
  <label>
    Ids
    <input name="selectedIds" type="text" />
  </label>
  <div class="buttons-container">
    <button type="submit" class="button">Confirmar Consentimento</button>
    <button formAction="/api/consent/cancel" class="button"
      >Recusar Consentimento</button
    >
  </div>
</form>

<style>
  .log-container {
    height: 55vh;
    overflow: auto;
  }

  .form-container {
    display: flex;
    flex-direction: column;
    padding: 1rem;
    background: #ffffff;
    border-radius: 0.5rem;
  }

  .buttons-container {
    display: flex;
    flex-direction: row;
  }

  .button {
    flex: 1;
    margin: 0 0.5rem;
  }
</style>
