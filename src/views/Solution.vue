<template>
  <div class="solution text wide">
    <h2 class="serif text-col">Land Is Part of the Solution</h2>
    <LayoutScrollytelling>
      <template v-slot:vis="props">
        <VisEmissions slot="vis" v-bind="props"/>
      </template>
      <template v-slot:text="{ width, step }">
        <IntersectionObserver :align="width >= 900 ? 'right' : 'center'" :step="0" :class="{active: step === 0}">

          <p>Today X.X% of yearly C0₂ emissions comes from land use. In contrast to the general trend of rising CO₂ emissions in the SSP2 Baseline scenario, the ones from land use are expected to decrease reaching net-zero by the end of the century. Looking at other emissions from land-use the outlook is less good. While land-uses share on CH₄ and N₂0 emissions will roughly stay the same, they'll increase overall.</p>
        </IntersectionObserver>
        <IntersectionObserver :align="width >= 900 ? 'right' : 'center'" :step="1" :class="{active: step === 1}">
          <p>This has to be tackled. To be in line with RCP 1.9, CO₂ emissions from land use already need to reach net-zero in the early 2030s. While CH₄ and N₂0 emissions are inherent to agriculture and therefore can't be eliminated completely, they still need to be cut down by half.</p>
        </IntersectionObserver>
      </template>
    </LayoutScrollytelling>
    <section class="text-col wide">
      <p>
        Strategies to reduce emissions from land use entail making dietary changes to reduce the land cover of pastures and the demand for feed, reducing food waste, but also changing land use to allow for negative emission technologies. Some of these, i.e.; BECCS (Bioenergy with Carbon Capture and Strorage) and Afforestation & Reforastation demand high quantities of land to be deployed on a large scale.
      </p>
      <VisNet/>
    </section>
    <section class="text-col wide">
      <p>
        Looking at the SSP2-1.9 scenario in more depth we can make out how afforestation, reforastation and BECCS are applied to enable the reduction of emissions compared to the SSP2-Baseline.
      </p>
    </section>
    <LayoutScrollytelling class="land-use-change">
      <template v-slot:vis="props">
        <VisLandChange slot="vis" v-bind="props" v-if="props.step !== 2"/>
        <VisEffects slot="vis" v-bind="props" v-else/>
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
export default {
  components: {
    LayoutScrollytelling,
    IntersectionObserver,
    VisEmissions,
    VisLandChange,
    VisEffects,
    VisNet
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
