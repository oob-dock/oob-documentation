<script>
  import { Router, Route } from 'svelte-navigator';

  import RouteTransition from './components/RouteTransition.svelte';

  import Home from './pages/Home.svelte';
  import Login from './pages/Login.svelte';
  import Consent from './pages/Consent.svelte';
  import Redirect from './pages/Redirect.svelte';
</script>

<Router primary={false}>
  <div class="page">
    <header class="heading">
      <h1>Auth Example</h1>
    </header>
    <main class="content">
      <Route path="/">
        <RouteTransition>
          <Home />
        </RouteTransition>
      </Route>
      <Route path="/login">
        <RouteTransition>
          <Login />
        </RouteTransition>
      </Route>
      <Route path="/consent">
        <RouteTransition>
          <Consent />
        </RouteTransition>
      </Route>
      <Route path="/redirect">
        <RouteTransition>
          <Redirect />
        </RouteTransition>
      </Route>
    </main>
    <footer>Opus Software</footer>
  </div>
</Router>

<style>
  .page {
    width: 100%;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
  }

  .page .heading {
    display: flex;
    align-items: center;
    height: 100px;
    flex-shrink: 0;
  }

  .page .heading h1 {
    flex: 1;
  }

  .page .content {
    width: 100%;
    max-width: 1024px;
    margin: 0 auto;
    position: relative;
    flex: 1;
  }

  footer {
    margin: 10px auto;
    font-size: 0.8rem;
  }
</style>
