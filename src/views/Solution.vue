<template>
  <div class="solution text text-col wide">
    <div v-html="getText('solution')[0]"/>
    <LayoutScrollytelling>
      <template v-slot:vis="props">
        <VisEmissions slot="vis" v-bind="props"/>
      </template>
      <template v-slot:text="{ width, step }">
        <IntersectionObserver class="narrow" :no-styling="width >= 600" :align="width >= 600 ? 'right' : 'center'" :step="0" :class="{active: step === 0}">
          <div v-html="getText('solution')[1]"/>
        </IntersectionObserver>
        <IntersectionObserver class="narrow" :no-styling="width >= 600" :align="width >= 600 ? 'right' : 'center'" :step="1" :class="{active: step === 1}">
          <div v-html="getText('solution')[2]"/>
        </IntersectionObserver>
        <IntersectionObserver class="narrow" :no-styling="width >= 600" :align="width >= 600 ? 'right' : 'center'" :step="2" :class="{active: step === 2}">
          <div v-html="getText('solution')[3]"/>
        </IntersectionObserver>
        <IntersectionObserver class="narrow" :no-styling="width >= 600" :align="width >= 600 ? 'right' : 'center'" :step="3" :class="{active: step === 3}">
          <div v-html="getText('solution')[4]"/>
        </IntersectionObserver>
        <IntersectionObserver class="narrow" :no-styling="width >= 600" :align="width >= 600 ? 'right' : 'center'" :step="4" :class="{active: step === 4}">
          <div v-html="getText('solution')[5]"/>
        </IntersectionObserver>
        <IntersectionObserver class="narrow" :no-styling="width >= 600" :align="width >= 600 ? 'right' : 'center'" :step="5" :class="{active: step === 5}">
          <div v-html="getText('solution')[6]"/>
          <div class="align-to-gem">
            <a class="to-gem" href="https://senses-gems.netlify.app/#/land-transition/emissions" target="_blank">↗ Access Data</a>
          </div>
        </IntersectionObserver>
      </template>
    </LayoutScrollytelling>
    <section class="text-col wide">
      <div v-html="getText('cdr')[0]"/>
      <VisNet/>
    </section>
    <section class="text-col wide" v-html="getText('cdr')[1]"/>
    <LayoutScrollytelling class="land-use-change">
      <template v-slot:vis="props">
        <VisLandChange slot="vis" v-bind="props"/>
      </template>
      <template v-slot:text="{ width, step }">
        <IntersectionObserver class="narrow" :no-styling="width >= 600" :align="width >= 600 ? 'right' : 'center'" :step="0" :class="{active: step === 0}">
          <div v-html="getText('change')[0]"/>
        </IntersectionObserver>
        <IntersectionObserver class="narrow" :no-styling="width >= 600" :align="width >= 600 ? 'right' : 'center'" :step="1" :class="{active: step === 1}">
          <div v-html="getText('change')[1]"/>
        </IntersectionObserver>
        <IntersectionObserver class="narrow" :no-styling="width >= 600" :align="width >= 600 ? 'right' : 'center'" :step="2" :class="{active: step === 2}">
          <p>
            <ChartLine label="Bioenergy" unit="EJ/yr" difftint="red" :years="years" :scenarios="biomass" />
            <span class="key tiny">
              <span v-for="(c, i) in Object.keys(colors)" :key="`ca-${i}`" class="highlight no-hover" :class="[colors[c]]">
                {{c}}
              </span>
            </span>
          </p>
          <div v-html="getText('change')[2]"/>
          <p>
            <ChartLine label="Carbon Sequestration from Biomass" unit="Mt CO2/yr" difftint="red" :years="years" :scenarios="seq" />
            <span class="key tiny">
              <span v-for="(c, i) in Object.keys(colors)" :key="`ca-${i}`" class="highlight no-hover" :class="[colors[c]]">
                {{c}}
              </span>
            </span>
          </p>
        </IntersectionObserver>
        <IntersectionObserver class="narrow" :no-styling="width >= 600" :align="width >= 600 ? 'right' : 'center'" :step="3" :class="{active: step === 3}">
          <div v-html="getText('change')[3]"/>
          <p>
            <ChartLine label="Food Price" unit="Index (2010 = 1)" difftint="red" :years="years" :scenarios="price"/>
            <span class="key tiny">
              <span v-for="(c, i) in Object.keys(colors)" :key="`cb-${i}`" class="highlight no-hover" :class="[colors[c]]">
                {{c}}
              </span>
            </span>
          </p>
          <div v-html="getText('change')[4]"/>
          <div class="align-to-gem">
            <a class="to-gem" href="https://senses-gems.netlify.app/#/land-transition/land-cover" target="_blank">↗ Access Data</a>
          </div>
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
import VisNet from '@/components/VisNet.vue'
import Scenarios from 'dsv-loader!@/assets/data/land-change-impact.csv' // eslint-disable-line import/no-webpack-loader-syntax
import ChartLine from '@/components/ChartLine.vue'
import { mapGetters } from 'vuex'

export default {
  components: {
    LayoutScrollytelling,
    IntersectionObserver,
    VisEmissions,
    VisLandChange,
    ChartLine,
    VisNet
  },
  data () {
    return {
      years: [2005, 2010, 2020, 2030, 2040, 2050, 2060, 2070, 2080, 2090, 2100],
      colors: {
        'SSP2-Baseline': 'red',
        'SSP2-19': 'neon'
      }
    }
  },
  computed: {
    ...mapGetters(['getText']),
    seq () {
      return this.getScenario('Carbon Sequestration from Biomass CCS')
    },
    price () { return this.getScenario('Food Price') },
    biomass () { return this.getScenario('Bioenergy') }
  },
  methods: {
    getScenario (variable) {
      const { colors, years } = this
      return Object.keys(colors).map(s => {
        const data = Scenarios.find(d => d.scenario === s && d.variable === variable)
        return {
          color: colors[s],
          scenario: s,
          series: years.map(year => ({ year, value: +data[year] }))
        }
      })
    }
  }
}
</script>
<style lang="scss" scoped>
@import "library/src/style/global.scss";
.solution {
  display: flex;
  flex-direction: column;
  align-items: center;

  ::v-deep h2.text-col {
    padding-bottom: $spacing / 2;
  }

  ::v-deep .layout-scrollytelling {
    width: 100%;
    max-width: 1600px;

    &.land-use-change {
      margin-top: $spacing * 2;

      .intersection-observer {
        &:first-of-type {
          padding-top: $spacing * 3.5;
        }

        .chart-line {
          margin-top: $spacing / 4;
        }

        .key {
          span {
            margin-right: $spacing / 8;
          }
        }

        @include max-width($narrow) {
          margin: 0 -$spacing / 2;

          &:first-of-type {
            padding-top: 100vh;
          }
        }
      }
    }

    .intersection-observer {
      padding-top: $spacing * 6;
      padding-bottom: $spacing * 3;
      opacity: 0.5;
      transition: opacity $transition;
      &.active {
        opacity: 1;
      }
      p {
        pointer-events: all;
      }
      p + p, p + div, div + p {
        margin-top: $spacing / 2;
      }

      &:first-of-type {
        padding-top: $spacing * 2;
      }

      &:last-of-type {
        padding-bottom: $spacing * 15;
      }

      @include min-width($narrow) {
        p, .align-to-gem {
          width: 33%;
          margin-left: auto;
        }
        .align-to-gem {
          margin-top: $spacing / 2;
        }
      }
      @include max-width($narrow) {
        margin: 0 -$spacing / 2;

        &:first-of-type {
          padding-top: 60vh;
        }
      }
    }
  }
  ::v-deep .section-intro {
    margin-bottom: $spacing / 2;
  }
}
</style>
