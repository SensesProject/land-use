<template>
  <div class="vis-emissions narrow">
    <svg :height="svgHeight" :width="svgWidth">
      <g :transform="`translate(${margin} ${0})`">
        <ChartLineComponent v-for="(r, i) in results" :key="`re-${i}`"
          v-bind="r" :width="innerWidth" :height="chartHeight" :margin="margin" :yAxisWidth="yAxisWidth" :show-zero="i >= 1" :signed-axis="i >= 1" :show-lines="i < 1 || step >= 1"
          :transform="`translate(0 ${(chartHeight + margin) * i})`"/>
        <g class="axis">
          <g class="x-axis" :transform="`translate(0 ${innerHeight - margin})`">
            <line :x1="yAxisWidth" :x2="innerWidth"/>
            <line :x1="yAxisWidth" :x2="yAxisWidth" y1="-0.5" y2="3"/>
            <line :x1="innerWidth" :x2="innerWidth" y1="-0.5" y2="3"/>
            <text :x="yAxisWidth" :y="margin">2005</text>
            <text :y="margin" :style="{'text-anchor': 'end'}" :x="innerWidth">2100</text>
          </g>
        </g>
      </g>
    </svg>
    <div class="key tiny">
      <template v-if="step < 2">
        <svg width="12" height="12">
          <rect width="12" height="12" class="green"/>
        </svg>
        <span>SSP1-1.9</span>
        <svg width="12" height="12">
          <rect width="12" height="12" class="blue"/>
        </svg>
        <span>SSP2-1.9</span>
        <svg width="12" height="12">
          <rect width="12" height="12" class="violet"/>
        </svg>
        <span>SSP5-1.9</span>
      </template>
    </div>
  </div>
</template>
<script>
import SSP from 'dsv-loader!@/assets/data/sspcomparison.csv' // eslint-disable-line import/no-webpack-loader-syntax
import ChartLineComponent from '@/components/ChartLineComponent.vue'
// import resize from 'vue-resize-directive'
export default {
  name: 'VisLandResults',
  props: {
    width: Number,
    height: Number,
    step: Number
  },
  components: {
    ChartLineComponent
  },
  data () {
    const years = [2005, 2010, 2020, 2030, 2040, 2050, 2060, 2070, 2080, 2090, 2100]
    // const variables = ['Bioenergy', 'Carbon Sequestration from Biomass CCS', 'Food Price']
    const variables = ['Population', 'Food Demand|Crops', 'Food Demand|Livestock']
    const tints = {
      'SSP1-19': 'green',
      'SSP2-19': 'blue',
      'SSP5-19': 'violet'
    }
    return {
      margin: 16,
      yAxisWidth: 64,
      results: variables.map(variable => {
        const rows = SSP.filter(e => e.variable === variable)
        return {
          variable: variable === variables[0] ? variable : `Change in ${variable}`,
          // variable,
          unit: rows[0].unit,
          data: rows.map(r => {
            return {
              scenario: r.scenario,
              source: r.source,
              tint: tints[r.scenario],
              series: years.map(year => {
                return {
                  year,
                  value: variable === variables[0] ? r[year] : r[year] - r[2005]
                  // value: r[year]
                }
              })
            }
          })
        }
      })
    }
  },
  computed: {
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
      // return (innerHeight - margin * 4) / 3
      return (innerHeight - margin * 4) / 3
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

      rect {
        @include tint(fill);
      }

      &.lines {
        stroke: $color-black;
        @include tint(stroke);

        &.dot {
          stroke-dasharray: 4 4;
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

     polyline, text {
      // transition: opacity $transition;

      &.hide {
        opacity: 0;

        &.dot {
          opacity: 0.4;
          stroke-dasharray: 4 4;
        }
      }
    }

    .bold {
      font-weight: $font-weight-bold;
    }

    .axis {
      line {
        stroke: $color-gray;
      }
      text {
        fill: $color-gray;
      }
      .y-axis {
        text {
          text-anchor: end;
        }
      }
    }
    polyline {
      fill: none;
      stroke-width: 2;
      @include tint(stroke);
    }
  }
}
</style>
