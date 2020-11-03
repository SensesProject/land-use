<template>
  <div class="vis-emissions narrow">
    <div class="title tiny">
      Land cover change
    </div>
    <div class="safari-fix">
      <div class="grid">
        <ChartArea v-model="year" :years="years" :height="height - 34" :domain="[12476, 0]" :nice="false" unit="million ha" :scenarios="baseline" label="No Climate Policy"/>
        <transition name="fade">
          <ChartArea v-if="step >= 1" v-model="year" :years="years" :height="height - 34" :domain="[12476, 0]" :nice="false" unit="million ha" :scenarios="rcp19" label="1.5°C Pathway"/>
        </transition>
      </div>
    </div>
    <div class="key tiny">
      <span v-for="(c, i) in Object.keys(colors).reverse()" :key="`c-${i}`" class="highlight no-hover" :class="[colors[c]]">
        {{c}}
      </span>
    </div>
  </div>
</template>
<script>
import Change from 'dsv-loader!@/assets/data/land-change.csv' // eslint-disable-line import/no-webpack-loader-syntax
import ChartArea from '@/components/ChartArea.vue'
import { scaleLinear } from 'd3-scale'
import { format } from 'd3-format'
export default {
  name: 'VisLandChange',
  props: {
    width: Number,
    height: Number,
    step: Number
  },
  components: {
    ChartArea
  },
  data () {
    const years = [2005, 2010, 2020, 2030, 2040, 2050, 2060, 2070, 2080, 2090, 2100]
    const colors = {
      'Other Natural Land': 'purple',
      'Forest': 'blue',
      'Pasture': 'green',
      'Food and Feed Crops': 'yellow',
      'Bioenergy Crops': 'orange'
    }
    return {
      year: null,
      years,
      colors,
      margin: 16,
      yAxisWidth: 64,
      change: Change.reverse().map(d => {
        return {
          variable: d.variable,
          scenario: d.scenario,
          class: [colors[d.variable]],
          series: years.map(year => {
            return {
              year,
              value: d[year] - d[2005]
            }
          })
        }
      })
    }
  },
  computed: {
    baseline () {
      return this.getScenario('SSP2-Baseline')
    },
    rcp19 () {
      return this.getScenario('SSP2-19')
    },
    svgWidth () {
      const { width } = this
      return width >= 900 ? width - 460 : width
    },
    svgHeight () {
      const { height, margin } = this
      return height - margin * 2
    },
    innerWidth () {
      const { svgWidth, margin } = this
      return svgWidth - margin * 2
    },
    innerHeight () {
      const { svgHeight, margin } = this
      return svgHeight - margin * 1
    },
    chartHeight () {
      const { innerHeight, margin } = this
      return (innerHeight - margin * 2)
    },
    xScale () {
      const { innerWidth, yAxisWidth } = this
      return scaleLinear()
        .domain([2005, 2100])
        .range([yAxisWidth, innerWidth])
    },
    yDomain () {
      const { change } = this
      const min = Math.min(...change.map(d => Math.min(...d.series.map(s => s.value))))
      const max = Math.max(...change.map(d => Math.max(...d.series.map(s => s.value))))
      const abs = Math.max(Math.abs(min), Math.abs(max))
      return [
        -abs,
        abs
      ]
    },
    yScale () {
      const { chartHeight, yDomain } = this
      return scaleLinear()
        .domain(yDomain)
        .range([chartHeight, 0])
    },
    yTicks () {
      const { yScale } = this
      return yScale.ticks(7).map(t => {
        return {
          value: format('+,.0f')(t).replace(/,/, ' ').replace(/\+0$/, '±0'),
          y: yScale(t)
        }
      })
    },
    lines () {
      const { change, xScale, yScale } = this
      return change.map(d => {
        const line = d.series.map(s => `${xScale(s.year)} ${yScale(s.value)}`).join(' ')
        return {
          ...d,
          line
        }
      })
    }
  },
  methods: {
    getScenario (scenario) {
      const { colors, years } = this
      return Object.keys(colors).map(s => {
        const data = Change.find(d => d.scenario === scenario && d.variable === s)
        return {
          color: colors[s],
          scenario: s,
          series: years.map(year => ({ year, value: data[year] }))
        }
      })
    }
  }
}
</script>
<style lang="scss" scoped>
@import "library/src/style/global.scss";
.vis-emissions {
  height: 100%;
  display: flex;
  flex-direction: column;
  .safari-fix {
    display: flex;
    height: 100%;
  }
  .grid {
    height: 100%;
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: $spacing $spacing / 2;

    .fade-enter-active, .fade-leave-active {
      transition: opacity $transition;
    }
    .fade-enter, .fade-leave-to {
      opacity: 0;
    }
  }
  @include min-width($narrow) {
    width: calc(100% / 3 * 2 - #{$spacing / 2});
  }
  .key {
    padding-bottom: $spacing / 2;

    span {
      margin-right: $spacing / 8;
      margin-bottom: $spacing / 8;
    }
  }
  .title {
    padding-bottom: $spacing / 4;
    display: flex;
    justify-content: space-between;
  }
}
</style>
