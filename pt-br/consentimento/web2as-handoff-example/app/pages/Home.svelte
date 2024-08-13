<script>
  import { useLocation } from 'svelte-navigator';
  import { onMount } from 'svelte';
  const location = useLocation();
  let commandId;

  $: {
    commandId = $location.hash.substring(1);
  }

  onMount(async () => {
    document.getElementById('form').submit();
  });
</script>

<form action="/api/load" method="post" id="form" class="form">
  <input type="text" name="commandid" bind:value={commandId} />
</form>

<style>
  .form {
    display: none;
  }
</style>
