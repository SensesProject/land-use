<template>
  <div class="vis-emissions narrow">
    <svg :height="svgHeight" :width="svgWidth">
      <!-- <mask id="mask-baseline">
        <rect x="0" y="0" :width="maskWidthBaseline" :height="innerHeight" fill="white"/>
      </mask>
      <clipPath id="mask-rcp">
        <rect x="0" y="0" :width="maskWidthRCP" :height="innerHeight" fill="white"/>
      </clipPath> -->
      <g :transform="`translate(${margin} ${0})`">
        <ChartAreaComponent v-for="(e, i) in emissions" :key="`em-${i}`" :id="`em-${i}`"
          v-bind="e" :width="innerWidth" :height="chartHeight" :margin="margin" :showRCP="showRCP" :yAxisWidth="yAxisWidth"
          :transform="`translate(0 ${(chartHeight + margin) * i})`"/>
        <g class="x-axis axis" :transform="`translate(0 ${innerHeight - margin})`">
          <line :x1="yAxisWidth" :x2="innerWidth"/>
          <line :x1="yAxisWidth" :x2="yAxisWidth" y1="-0.5" y2="3"/>
          <line :x1="innerWidth" :x2="innerWidth" y1="-0.5" y2="3"/>
          <text :x="yAxisWidth" :y="margin">2005</text>
          <text :y="margin" :style="{'text-anchor': 'end'}" :x="innerWidth">2100</text>
        </g>
      </g>
    </svg>
    <div class="key tiny">
      <svg width="12" height="12">
        <rect width="12" height="12" class="red"/>
        <polyline v-if="showRCP" points="12 0 12 12 0 12" class="violet"/>
      </svg>
      <span>AFOLU</span>
      <svg width="12" height="12" class="light">
        <rect width="12" height="12" class="red"/>
        <polyline v-if="showRCP" points="12 0 12 12 0 12" class="violet"/>
      </svg>
      <span>Total Emissions</span>
      <span v-if="!showRCP">SSP2 Baseline</span>
      <span v-else class="before-line-key">SSP2 RCP 1.9</span>
      <div class="line-key">
        <svg width="12" height="12" v-if="showRCP" class="lines">
          <polyline points="0 4 12 4" class="light"/>
          <polyline points="0 8 12 8"/>
        </svg>
        <span v-if="showRCP">SSP2 Baseline</span>
      </div>
    </div>
  </div>
</template>
<script>
import Emissions from 'dsv-loader!@/assets/data/landemissions.csv' // eslint-disable-line import/no-webpack-loader-syntax
import ChartAreaComponent from '@/components/ChartAreaComponent.vue'
// import resize from 'vue-resize-directive'
export default {
  name: 'VisEmissions',
  props: {
    width: Number,
    height: Number,
    step: Number
  },
  components: {
    ChartAreaComponent
  },
  data () {
    const years = [2005, 2010, 2020, 2030, 2040, 2050, 2060, 2070, 2080, 2090, 2100]
    const variables = ['CO₂', 'CH₄', 'N₂0']
    return {
      margin: 16,
      yAxisWidth: 64,
      emissions: variables.map(variable => {
        const rows = Emissions.filter(e => e.variable === variable).reverse()
        return {
          variable,
          unit: rows[0].unit,
          data: rows.map(r => {
            return {
              scenario: r.scenario,
              source: r.source,
              series: years.map(year => {
                return {
                  year,
                  value: r[year]
                }
              })
            }
          })
        }
      })
    }
  },
  computed: {
    showRCP () {
      const { step } = this
      return step >= 1
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
      return (innerHeight - margin * 4) / 3
    },
    maskWidthBaseline () {
      const { step, innerWidth } = this
      const start = 0
      return Math.min(Math.max(0, step - start), 1) * innerWidth
    },
    maskWidthRCP () {
      const { step, innerWidth } = this
      const start = 3
      return Math.min(Math.max(0, step - start), 1) * innerWidth
    }
  },
  methods: {
  }
}
</script>
<style lang="scss" scoped>
@import "library/src/style/global.scss";
.vis-emissions {
  .key {
    padding-left: $spacing * 2.5;
    @include max-width($narrow) {
      padding-left: $spacing / 2;
    }
    height: 16px;
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    span {
      margin-right: $spacing / 4;

      &.before-line-key {
        margin-right: $spacing / 2;
      }
    }
    svg {
      margin-right: $spacing / 8;

      .red {
        fill: $color-red;
      }
      .violet {
        fill: $color-violet;
      }
      &.light {
        opacity: 0.2
      }

      &.lines {
        stroke: $color-red;
        stroke-dasharray: 4 4;
        .light {
          opacity: 0.2;
        }
      }
    }
    .line-key {
      white-space: nowrap;
      display: flex;
      align-items: center;
    }
  }
  svg {
    display: block;

    .x-axis {
      line {
        stroke: $color-gray;
      }
      text {
        fill: $color-gray;
      }
    }
  }
}
</style>
