<template>
  <div class="solution text-col wide">
    <section class="text">
      <h2 class="serif">Land Solutions Need to Be Sustainable</h2>
      <p>
        With a decline in available land for food production food prices rise and food security declines. How this plays out in detail greatly depends on socioeconomic factors – mainly population developement and diets.
      </p>
    </section>
    <VisSustainable/>
    <section class="text">
      <p>
        While all land based negative emissions technologies increase pressure on land use, high level implementations of those pose a risk to food security. BECCS is the only one also posing risks of desertification, land degradation, and countering adaptation measures.
      </p>
      <br>
      <p>
        Land management is key!
      </p>
    </section>
  </div>
</template>
<script>
import VisSustainable from '@/components/VisSustainable.vue'
export default {
  components: {
    VisSustainable
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
    margin: $spacing 0;

    h2 {
      margin-bottom: $spacing / 2;
    }
  }
}
</style>
