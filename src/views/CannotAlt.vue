<template>
  <div class="cannot wide">
    <section class="text-col">
      <h2 class="serif">Land Cannot Do All</h2>
      <p>
        With a decline in available land for food production food prices rise and food security declines. How this plays out in detail greatly depends on socioeconomic factors – mainly population developement and diets.
      </p>
    </section>
      <VisSSP/>
    <section class="text-col">
      <p>
        [Chart showing food prices across SSPs]
      </p>
      <p>
        While BECCS demands less land and water resources to achieve the same amount of emission removal than afforestation and reforrastation it has other negative consequences. Risks of desertification, land degradation and decreasing biodiversity become intensify while it also counters adaptation measures.
      </p>
    </section>
  </div>
</template>
<script>
import VisSSP from '@/components/VisSSP.vue'
export default {
  components: {
    VisSSP
  }
}
</script>
<style lang="scss" scoped>
@import "library/src/style/global.scss";
.cannot {
  display: flex;
  flex-direction: column;
  align-items: center;

  h2 {
    // width: 100%;
    margin-bottom: $spacing / 2;
  }

  p + p {
    padding-top: $spacing / 2;
  }
}
</style>
