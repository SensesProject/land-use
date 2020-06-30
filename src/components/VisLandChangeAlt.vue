<template>
  <div class="vis-emissions narrow">
    <svg :height="svgHeight" :width="svgWidth">
      <g :transform="`translate(${margin} ${0})`">
        <text :y="chartHeight" :x="yAxisWidth">SSP2–Baseline</text>
        <text :y="margin" :x="yAxisWidth"><tspan class="bold">Land Cover Change </tspan>in million ha</text>
        <text :x="chartWidth + margin" :y="chartHeight" :class="{ hide: step < 1 }">SSP2–1.9</text>
        <!-- <text :x="chartWidth + margin" :y="margin * 2">Land Cover Change in million ha</text> -->
        <!-- <ChartAreaComponent v-for="(e, i) in emissions" :key="`em-${i}`" :id="`em-${i}`"
          v-bind="e" :width="innerWidth" :height="chartHeight" :margin="margin" :showRCP="showRCP" :yAxisWidth="yAxisWidth"
          :transform="`translate(0 ${(chartHeight + margin) * i})`"/> -->
        <g>
          <polyline v-for="(l, i) in lines.filter(l => l.scenario === 'SSP2-Baseline')" :key="`l-${i}`" :points="l.line" :class="l.class"/>
        </g>
        <g :transform="`translate(${chartWidth + margin - yAxisWidth} 0)`" :class="{ hide: step < 1 }">
          <polyline v-for="(l, i) in lines.filter(l => l.scenario === 'SSP2-19')" :key="`l-${i}`" :points="l.line" :class="l.class"/>
        </g>
        <g class="axis">
          <line :y2="chartHeight" :x1="yAxisWidth - margin" :x2="yAxisWidth - margin"/>
          <g v-for="(t, i) in yTicks" class="ticks y-axis" :key="`t-${i}`" :transform="`translate(0 ${t.y})`">
            <line :x1="yAxisWidth - margin - 3" :x2="yAxisWidth - margin + 0.5"/>
            <text :x="yAxisWidth - margin - 7" :y="margin / 2 - 3">{{ t.value }}</text>
          </g>
          <g v-for="i in [0, 1]" :key="`k1-${i}`" :transform="`translate(${(chartWidth + margin - yAxisWidth) * i} 0)`" :class="{ hide: step < 1 && i === 1 }">
            <g class="x-axis" :transform="`translate(0 ${innerHeight - margin})`">
              <line :x1="yAxisWidth" :x2="chartWidth"/>
              <line :x1="yAxisWidth" :x2="yAxisWidth" y1="-0.5" y2="3"/>
              <line :x1="chartWidth" :x2="chartWidth" y1="-0.5" y2="3"/>
              <text :x="yAxisWidth" :y="margin">2005</text>
              <text :y="margin" :style="{'text-anchor': 'end'}" :x="chartWidth">2100</text>
            </g>
          </g>
        </g>
      </g>
    </svg>
    <div class="key tiny">
      <svg width="12" height="12">
        <rect width="12" height="12" class="yellow"/>
      </svg>
      <span>Bioenergy Crops</span>
      <svg width="12" height="12">
        <rect width="12" height="12" class="green"/>
      </svg>
      <span>Forest</span>
      <svg width="12" height="12">
        <rect width="12" height="12" class="violet"/>
      </svg>
      <span>Food and Feed Crops</span>
      <svg width="12" height="12">
        <rect width="12" height="12" class="red"/>
      </svg>
      <span>Pasture</span>
    </div>
  </div>
</template>
<script>
import Change from 'dsv-loader!@/assets/data/landusechange.csv' // eslint-disable-line import/no-webpack-loader-syntax
import { scaleLinear } from 'd3-scale'
import { format } from 'd3-format'
// import resize from 'vue-resize-directive'
export default {
  name: 'VisLandChange',
  props: {
    width: Number,
    height: Number,
    step: Number
  },
  components: {
    // ChartAreaComponent
  },
  data () {
    const years = [2005, 2010, 2020, 2030, 2040, 2050, 2060, 2070, 2080, 2090, 2100]
    const colors = {
      'Bioenergy Crops': 'yellow',
      'Forest': 'green',
      'Food and Feed Crops': 'violet',
      'Pasture': 'red'
    }
    return {
      margin: 16,
      yAxisWidth: 64,
      change: Change.map(d => {
        // const rows = Change.filter(e => e.variable === variable).reverse()
        return {
          variable: d.variable,
          scenario: d.scenario,
          class: [{
            // dot: d.scenario === 'SSP2-Baseline'
          }, colors[d.variable]],
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
    chartWidth () {
      const { innerWidth, yAxisWidth, margin } = this
      return (innerWidth - margin + yAxisWidth) / 2
    },
    xScale () {
      const { chartWidth, yAxisWidth } = this
      return scaleLinear()
        .domain([2005, 2100])
        .range([yAxisWidth, chartWidth])
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
        // .nice(7)
    },
    yTicks () {
      const { yScale } = this
      return yScale.ticks(7).map(t => {
        return {
          value: format(',.0f')(t).replace(/,/, ' '),
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

    g, text {
      transition: opacity $transition;

      &.hide {
        opacity: 0;
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
      &.dot {
        stroke-dasharray: 4 4;
        opacity: 0.5;
      }
    }
  }
}
</style>
