<template>
  <div class="pressure text-col wide">
    <section class="chapter-title" v-html="getText('pressure')[0]"/>
    <VisPressure/>
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

  h2 {
    margin-bottom: $spacing / 2;
  }
}
</style>
