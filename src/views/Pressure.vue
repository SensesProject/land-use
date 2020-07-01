<template>
  <div class="pressure text-col wide">
    <section class="chapter-title" v-html="getText('pressure')[0]"/>
    <!-- <section> -->
      <VisPressure/>
    <!-- </section> -->
  </div>
</template>
<script>
import { mapGetters } from 'vuex'
import VisPressure from '@/components/VisPressure.vue'
export default {
  components: { VisPressure },
  computed: {
    ...mapGetters(['getText'])
  }
}
</script>
<style lang="scss" scoped>
@import "library/src/style/global.scss";
.pressure {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  margin-bottom: $spacing * 2;
  // .chapter-title {

  // }
  h2 {
    margin-bottom: $spacing / 2;
    // align-self: flex-start;
  }
}
</style>
