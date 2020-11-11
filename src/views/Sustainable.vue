<template>
  <div class="solution text-col wide">
    <section class="text sustainable" v-html="getText('sustainable')[0]"/>
    <VisSustainable/>
    <section class="text conclusion" v-html="getText('conclusion')[0]"/>
  </div>
</template>
<script>
import VisSustainable from '@/components/VisSustainable.vue'
import { mapGetters } from 'vuex'

export default {
  components: {
    VisSustainable
  },
  computed: {
    ...mapGetters(['getText'])
  }
}
</script>
<style lang="scss" scoped>
@import "library/src/style/global.scss";
.solution {
  display: flex;
  flex-direction: column;
  align-items: center;

  .text {
    &.conclusion {
      margin-top: $spacing * 2;
      margin-bottom: $spacing;
    }

    &.sustainable {
      margin-bottom: $spacing;
    }

    h2 {
      margin-bottom: $spacing / 2;
    }
  }
}
</style>
