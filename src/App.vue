<template>
  <div id="app">
    <SensesMenu id="land-transitions"/>
    <article>
      <Intro/>
      <Pressure/>
      <Solution/>
      <Sustainable/>
      <SensesMeta class="senses-meta" id="land-transitions"/>
    </article>
  </div>
</template>

<script>
import SensesMeta from 'library/src/components/SensesMeta.vue'
import SensesMenu from 'library/src/components/SensesMenu.vue'
import Intro from './views/Intro.vue'
import Pressure from './views/Pressure.vue'
import Solution from './views/Solution.vue'
import Sustainable from './views/Sustainable.vue'
export default {
  name: 'app',
  components: {
    SensesMenu,
    Intro,
    Pressure,
    Solution,
    Sustainable,
    SensesMeta
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
}

h1, h2 {
  font-family: $font-serif;

  + p {
    margin: $spacing / 2 0 $spacing;
  }
}

article {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  padding-bottom: $spacing * 2;

  .text-col {
    width: 100vw;
    max-width: calc(768px + #{$spacing});
    padding: $spacing $spacing / 2 0;
  }
}
</style>
<style lang="scss" scoped>
@import "library/src/style/global.scss";
#app {
  .senses-meta {
    margin: $spacing $spacing / 2 0;
  }
}
</style>
