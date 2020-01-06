<template>
  <div id="app">
    <SensesMenu/>
    <article>
      <Intro/>
      <Pressure/>
    </article>
  </div>
</template>

<script>
import SensesMenu from 'library/src/components/SensesMenu.vue'
import Intro from './views/Intro.vue'
import Pressure from './views/Pressure.vue'
export default {
  name: 'app',
  components: {
    SensesMenu,
    Intro,
    Pressure
  }
}
</script>

<style lang="scss">
@import "library/src/style/base.scss";
#app {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  article {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;

    .text {
      width: 100vw;
      max-width: calc(768px + #{$spacing});
      padding: $spacing $spacing / 2 0;
    }
  }
}
</style>
