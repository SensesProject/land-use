<template>
  <div id="app">
    <SensesMenu/>
    <article>
      <Intro/>
    <img alt="Vue logo" src="./assets/logo.png">
    <HelloWorld msg="Welcome to Your Vue.js App"/>
    </article>
  </div>
</template>

<script>
import SensesMenu from 'library/src/components/SensesMenu.vue'
import Intro from './views/Intro.vue'
import HelloWorld from './components/HelloWorld.vue'

export default {
  name: 'app',
  components: {
    SensesMenu,
    Intro,
    HelloWorld
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
