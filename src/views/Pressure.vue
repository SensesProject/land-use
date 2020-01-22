<template>
  <div class="pressure text-col wide">
    <section class="chapter-title">
      <h2 class="serif">Land Is Under Pressure</h2>
    </section>
    <!-- <section> -->
      <VisPressure/>
    <!-- </section> -->
  </div>
</template>
<script>
import VisPressure from '@/components/VisPressure.vue'
export default {
  components: { VisPressure }
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
