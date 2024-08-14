<script>
  import { useLocation } from 'svelte-navigator';
  const location = useLocation();

  const action = new URLSearchParams(window.location.search).get('action');

  const fetchData = (async () => {
    const response = await fetch(`/api/consent/redirect/${action}`);
    const redirectData = await response.json();
    redirectAfterTimeout(redirectData.redirectUrl);
    return redirectData;
  })();

  const redirectAfterTimeout = (url) => {
    setTimeout(() => {
      window.location.href = url;
    }, 3000);
  };
</script>

<div />
{#await fetchData}
  <div class="container">Redirecionando</div>
{:then data}
  <div class="container">
    <h1>Redirecionando</h1>
    <img src={data.tpp.logoUrl} alt={data.tpp.name} width="70" height="70" />
    <span>{data.tpp.name}</span>
    <br />
    <span>⇩</span>
    <br />
    <img src={data.brand.logoUrl} alt={data.brand.name} width="50" height="50" />
    <span>{data.brand.name}</span>
  </div>
{:catch error}
  <p>An error occurred!</p>
{/await}

<style>
  .container {
    display: flex;
    flex-direction: column;
    flex: 1;
    justify-content: center;
    align-content: center;
    align-items: center;
  }
</style>
