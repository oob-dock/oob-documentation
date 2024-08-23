<script>
  import { fly, fade } from 'svelte/transition';

  export let x = 50;
  export let duration = 250;
  export let delay = 500;
  /** @type {"forward"|"backward"} */
  export let direction = 'forward';

  $: directionFactor = direction === 'forward' ? 1 : -1;
</script>

<div
  class="route-wrapper"
  in:fly={{ x: x * directionFactor, duration, delay }}
  out:fly={{ x: -x * directionFactor, duration }}
>
  <slot />
</div>

<style>
  .route-wrapper {
    width: 100%;
    height: 100%;
  }
</style>
