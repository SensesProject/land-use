<template>
  <div class="solution text wide">
    <h2 class="serif text-col">Land Is Part of the Solution</h2>
    <LayoutScrollytelling>
      <template v-slot:vis="props">
        <VisEmissions slot="vis" v-bind="props"/>
      </template>
      <template v-slot:text="{ width, step }">
        <IntersectionObserver :align="width >= 900 ? 'right' : 'center'" :step="0" :class="{active: step === 0}">
          <p>Today about 13% of annual CO₂ emissions come from forestry, agriculture and other land uses (AFOLU). Most of the AFOLU CO₂ emissions are caused by deforestation. In contrast to the general trend of rising CO₂ emissions from burning fossil fuels in the SSP2 Baseline scenario, the AFOLU CO₂ emissions are projected to decrease, reaching net-zero by the end of the century. In contrast, AFOLU today is responsible for about 44% of all methane (CH₄) emissions for about 82% of all nitrous oxide (N₂O) emissions. The majority of AFOLU non-CO₂ emissions is caused by rice and livestock production (CH₄), and synthetic fertilizer application (N₂O). Since AFOLU non-CO₂ emissions are strongly linked to food production, they remain at relatively high levels throughout the century.</p>
        </IntersectionObserver>
        <IntersectionObserver :align="width >= 900 ? 'right' : 'center'" :step="1" :class="{active: step === 1}">
          <p>This has to be tackled. To be in line with RCP 1.9, CO₂ emissions from land use already need to reach net-zero in the early 2030s. While CH₄ and N₂0 emissions are inherent to agriculture and therefore can't be eliminated completely, they still need to be cut down by half.</p>
        </IntersectionObserver>
        <IntersectionObserver :align="width >= 900 ? 'right' : 'center'" :step="2" :class="{active: step === 2}">
          <p>While CH₄ and N₂O emssions almost seem negligible compared to CO₂ emissions, their contribution to climate change per Mt is far greater. Looking at CO₂ equivalent instead gives us a better sense of their effect.</p>
        </IntersectionObserver>
      </template>
    </LayoutScrollytelling>
    <section class="text-col wide">
      <p>
        Strategies to reduce emissions from AFOLU entail measures on the demand and the supply side. For instance, CH₄ and N₂O AFOLU emissions can be reduced by behavioral change towards diets with less animal products or by technical mitigation options, or by a combination of both. Reduction of AFOLU CO₂ emissions can be achieved by less deforestation. In addition, land can be used to remove carbon dioxide from the atmosphere (CDR or negative emission technologies), e.g. via afforestation or BECCS (Bioenergy with Carbon Capture and Strorage). Land-based CDR options have substantially different characteristics in terms of CDR potential, land, water and energy requirements as well as costs.
      </p>
      <VisNet/>
    </section>
    <section class="text-col wide">
      <p>
        Looking at the SSP2-1.9 scenario in more depth we can explore how the land-based CDR options afforestation and BECCS are used to offset CO₂ emissions from other sectors.
      </p>
    </section>
    <LayoutScrollytelling class="land-use-change">
      <template v-slot:vis="props">
        <VisLandChange slot="vis" v-bind="props" v-if="props.step !== 2 && props.step !== 4"/>
        <VisEffects slot="vis" v-bind="props" v-if="props.step === 2"/>
        <VisPrices slot="vis" v-bind="props" v-if="props.step === 4"/>
        <!-- <VisLandChange slot="vis" v-bind="props" v-else/> -->
      </template>
      <template v-slot:text="{ width, step }">
        <IntersectionObserver :align="width >= 900 ? 'right' : 'center'" :step="0" :class="{active: step === 0}">
          <p>The baseline scenario where neither BECCS nor Afforestation & Reforastation are deployed shows only slight changes in land cover. The global Forest decreases and while there is a rise in land cover for bio energy crops, Carbon Capture and Storage (CCS) is not used here.</p>
        </IntersectionObserver>
        <IntersectionObserver :align="width >= 900 ? 'right' : 'center'" :step="1" :class="{active: step === 1}">
          <p>In SSP2–1.9 land use change plays a far more important role as land cover for both forest and bio-energy crops rise.</p>
        </IntersectionObserver>
        <IntersectionObserver :align="width >= 900 ? 'right' : 'center'" :step="2" :class="{active: step === 2}">
          <p>This pays off – biomass energy becomes far more relevant and carbon sequestration unfolds its potential in the second half of the century.</p>
        </IntersectionObserver>
        <IntersectionObserver :align="width >= 900 ? 'right' : 'center'" :step="3" :class="{active: step === 3}">
          <p>But it also means overall land pressure is rising further and land cover of non-bioenergy crops decreases and even more drastically so does land cover of pastures.</p>
        </IntersectionObserver>
        <IntersectionObserver :align="width >= 900 ? 'right' : 'center'" :step="4" :class="{active: step === 4}">
          <p>This in turn drastically increases food prices in SSP2–1.9 compared to the baseline scenario.
            <span class="highlight no-hover orange">incorrect data, needs updating</span>
          </p>
        </IntersectionObserver>
      </template>
    </LayoutScrollytelling>
  </div>
</template>
<script>
import LayoutScrollytelling from 'library/src/components/LayoutScrollytelling.vue'
import IntersectionObserver from 'library/src/components/IntersectionObserver.vue'
import VisEmissions from '@/components/VisEmissions.vue'
import VisLandChange from '@/components/VisLandChange.vue'
import VisEffects from '@/components/VisEffects.vue'
import VisNet from '@/components/VisNet.vue'
import VisPrices from '@/components/VisPrices.vue'
export default {
  components: {
    LayoutScrollytelling,
    IntersectionObserver,
    VisEmissions,
    VisLandChange,
    VisEffects,
    VisNet,
    VisPrices
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
        padding-bottom: $spacing * 15;
      }
    }
  }
  h2 {
    margin-bottom: $spacing / 2;
    // align-self: flex-start;
  }
}
</style>
