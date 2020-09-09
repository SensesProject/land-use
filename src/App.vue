<template>
  <div id="app">
    <SensesMenu id="land-transitions"/>
    <article>
      <Intro/>
      <Pressure/>
      <Solution/>
      <Sustainable/>
    </article>
    <SensesMeta class="senses-meta" id="land-transitions"/>
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

  .text-col {
    width: 100vw;
    max-width: calc(768px + #{$spacing});
    padding: $spacing $spacing / 2 0;
  }

  a {
    color: inherit;
    background: none;
    text-decoration: underline;
    hyphens: initial;

    &:hover {
      background: none;
    }

    &.to-gem {
      text-decoration: none;
      text-align: center;
      padding: $spacing / 4 $spacing / 2;
      border: 1px solid $color-pale-gray;
      border-radius: $border-radius;
      pointer-events: all;
      &:hover {
        background-color: getColor(gray, 90)
      }
    }
  }
  .align-to-gem {
    margin-top: $spacing / 2;
  }
}
</style>
<style lang="scss" scoped>
@import "library/src/style/global.scss";
#app {
  .senses-meta {
    margin: 0 $spacing / 2 $spacing / 2;
  }
}
</style>
