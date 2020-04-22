<template>
  <div class="solution text wide">
    <section class="text-col">
      <h2 class="serif">Land Solutions Need to Be Sustainable</h2>
      <p>
        With a decline in available land for food production food prices rise and food security declines. How this plays out in detail greatly depends on socioeconomic factors – mainly population developement and diets.
      </p>
    </section>
    <LayoutScrollytelling class="land-use-change">
      <template v-slot:vis="props">
        <VisSSPPressure slot="vis" v-bind="props" v-if="props.step <= 1"/>
        <VisSSPLandChange slot="vis" v-bind="props" v-if="props.step === 2"/>
        <VisSSPEffects slot="vis" v-bind="props" v-if="props.step === 3"/>
      </template>
      <template v-slot:text="{ width, step }">
        <IntersectionObserver :align="width >= 900 ? 'right' : 'center'" :step="0" :class="{active: step === 0}">
          <p>For now we only looked at SSP2–Baseline and SSP2–1.9 Scenarios. To see how land use changes in different socioeconomic contexts that are still compatible with the 1.5°C warming limit, we now compare <span class="highlight blue no-hover">SSP2–1.9</span> to <span class="highlight green no-hover">SSP1–1.9</span> and <span class="highlight violet no-hover">SSP5–1.9.</span> Both of which project less population growth than SPP2.</p>
        </IntersectionObserver>
        <IntersectionObserver :align="width >= 900 ? 'right' : 'center'" :step="1" :class="{active: step === 1}">
          <p>There is however a big difference in peoples dietary choices. Which shows an immediate decline in demand for livestock in <span class="highlight no-hover green">SSP1–1.9</span> whereas <span class="highlight no-hover violet">SSP5–1.9</span> shows a steady increase in demand for both crops and livestock. <span class="highlight no-hover blue">SSP2–1.9</span> is the only scenario which shows overall calory intake declining below todays levels by mid-century. This may not only be linked to a higher overall population, but also to limited resources, rising food prices and lower living standards.</p>
        </IntersectionObserver>
        <IntersectionObserver :align="width >= 900 ? 'right' : 'center'" :step="2" :class="{active: step === 2}">
          <p>In terms of land-cover SSP1–1.9 requires the least changes and even puts <span class="highlight no-hover green">afforestation</span> and <span class="highlight no-hover green">reforrastation</span> in front of <span class="highlight no-hover yellow">BECCS.</span> Even though SSP5–1.9 shows the highest demand for livestock products there is a decline in <span class="highlight no-hover red">pastures</span> comparable to SSP2–1.9, which in the end has to be compensated with increased productivity. But since the demand for <span class="highlight no-hover violet">food crops</span> also keeps rising there is less overall capacity for mitigation measures. So <span class="highlight no-hover yellow">BECCS</span> which can remove more emissions on the same amount of land is deployed much more rapidely and intensively.</p>
        </IntersectionObserver>
        <IntersectionObserver :align="width >= 900 ? 'right' : 'center'" :step="3" :class="{active: step === 3}">
          <p>Therefore biomass energy is deployed at a larger scale in <span class="highlight violet no-hover">SSP5–1.9,</span> resulting also in greater potential for carbon sequestration with BECCS. But the decrease in land-cover for food production in <span class="highlight blue no-hover">SSP2–1.9</span> and <span class="highlight violet no-hover">SSP5–1.9.</span> leads to higher production costs and food prices, while they can be kept low in <span class="highlight green no-hover">SSP1–1.9.</span> In <span class="highlight violet no-hover">SSP5–1.9</span> those prices can be offset with higher incomes, the demand decreases in <span class="highlight blue no-hover">SSP2–1.9.</span></p>
        </IntersectionObserver>
      </template>
    </LayoutScrollytelling>
    <section class="text-col wide">
      <p>
        BECCS demands less land and water resources to achieve the same amount of emission removal than afforestation and reforrastation, which makes it a quite attractive negative emissions technology. But it can have negative side-effects that become apparent if implemented on a large scale.
      </p>
      <!-- <VisRisks/> -->
    </section>
    <section class="text-col wide">
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
import LayoutScrollytelling from 'library/src/components/LayoutScrollytelling.vue'
import IntersectionObserver from 'library/src/components/IntersectionObserver.vue'
import VisSSPPressure from '@/components/VisSSPPressure.vue'
import VisSSPLandChange from '@/components/VisSSPLandChange.vue'
import VisSSPEffects from '@/components/VisSSPEffects.vue'
// import VisRisks from '@/components/VisRisks.vue'
export default {
  components: {
    LayoutScrollytelling,
    IntersectionObserver,
    VisSSPPressure,
    VisSSPLandChange,
    VisSSPEffects
    // VisRisks
  }
}
</script>
<style lang="scss" scoped>
@import "library/src/style/global.scss";
.solution {
  display: flex;
  flex-direction: column;
  align-items: center;

  h2.text-col {
    padding-bottom: $spacing / 2;
  }

  .layout-scrollytelling {
    width: 100vw;
    max-width: 1600px;

    &.land-use-change {
      margin-top: $spacing * 2;
    }

    .intersection-observer {
      padding-top: $spacing * 6;
      padding-bottom: $spacing * 3;
      opacity: 0.4;
      transition: opacity $transition;

      &.active {
        opacity: 1;
      }

      &:last-of-type {
        padding-bottom: $spacing * 10;
      }
    }
  }
  h2 {
    margin-bottom: $spacing / 2;
    // align-self: flex-start;
  }
}
</style>
