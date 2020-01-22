<template>
  <g class="chart-line-component">
    <text :y="margin" :x="yAxisWidth"><tspan class="bold">{{ variable }}</tspan> {{ unit }}</text>
    <g>
      <g v-for="(area, i) in areas" class="areas" :key="`a-${i}`">
        <!-- <polyline class="area positive" :class="[area.scenario, area.source]" :points="area.area"/> -->
        <!-- <polyline class="line" :class="[area.scenario, area.source]" :points="area.line"/> -->
      </g>
      <g v-for="(area, i) in areas" class="lines" :key="`l-${i}`">
        <!-- <polyline class="area positive" :class="[area.scenario, area.source]" :points="area.area" :clip-path="`url(#mask-a-${id})`"/>
        <polyline class="area negative" :class="[area.scenario, area.source]" :points="area.area" :clip-path="`url(#mask-b-${id})`"/> -->
        <polyline class="line" :class="[area.scenario, area.source]" :points="area.line"/>
      </g>
    </g>
    <g class="axis">
      <line :y2="height" :x1="yAxisWidth - margin" :x2="yAxisWidth - margin"/>
      <g v-for="(t, i) in yTicks" class="ticks" :key="`t-${i}`" :transform="`translate(0 ${t.y})`">
        <line :x1="yAxisWidth - margin - 3" :x2="yAxisWidth - margin + 0.5"/>
        <text :x="yAxisWidth - margin - 7" :y="margin / 2 - 3">{{ t.value }}</text>
      </g>
    </g>
  </g>
</template>
<script>
import { scaleLinear } from 'd3-scale'
import { format } from 'd3-format'
export default {
  name: 'ChartLineComponent',
  props: {
    data: {
      type: Array,
      default () { return [] }
    },
    variable: {
      type: String,
      default: 'Label'
    },
    unit: {
      type: String,
      default: null
    },
    width: {
      type: Number,
      default: 320
    },
    height: {
      type: Number,
      default: 240
    },
    margin: {
      type: Number,
      default: 16
    },
    xDomain: {
      type: Array,
      default () { return [2005, 2100] }
    },
    yAxisWidth: {
      type: Number,
      default: 64
    }
  },
  computed: {
    xScale () {
      const { width, xDomain, yAxisWidth } = this
      return scaleLinear()
        .domain(xDomain)
        .range([yAxisWidth, width])
    },
    yDomain () {
      const { data } = this
      return [
        Math.min(...data.map(d => Math.min(...d.series.map(s => s.value), 0))),
        Math.max(...data.map(d => Math.max(...d.series.map(s => s.value), 0)))
      ]
    },
    yScale () {
      const { height, yDomain } = this
      return scaleLinear()
        .domain(yDomain)
        .range([height, 0])
        .nice()
    },
    areas () {
      const { data, xScale, yScale } = this
      return data.map(d => {
        const line = d.series.map(s => `${xScale(s.year)} ${yScale(s.value)}`).join(' ')
        return {
          ...d,
          line,
          area: `${xScale(2005)} ${yScale(0)} ${line} ${xScale(2100)} ${yScale(0)}`
        }
      })
    },
    yTicks () {
      const { yScale } = this
      return yScale.ticks(5).map(t => {
        return {
          value: format(',.0f')(t).replace(/,/, ' '),
          y: yScale(t)
        }
      })
    }
    // mask () {
    //   const { width, base } = this
    //   // const mask = `<svg xmlns='http://www.w3.org/2000/svg' width='${width}' height='${height}'><clipPath id='positive'><rect x='-4' y='-4' width='${width + 8}' height='${base + 4}' fill='white'/></clipPath></svg>`
    //   const mask = `<rect x='-4' y='-4' width='${width + 8}' height='${base + 4}' fill='white'/>`
    //   return `url("data:image/svg+xml;utf8,${mask}")`
    // }
  }
}
</script>
<style lang="scss" scoped>
@import "library/src/style/global.scss";
.chart-line-component {
  line {
    stroke: $color-black;
  }
  text {
    tspan.bold {
      font-weight: $font-weight-bold;
    }
  }
  .areas, .lines {
    .line {
      fill: none;
      stroke: $color-blue;
      stroke-width: 2;

      opacity: 1;
      &.total {
        opacity: 0.2;
      }
      &.SSP2-Baseline {
        stroke-dasharray: 4 4;
        stroke: $color-violet;

        &.total {
          stroke-dasharray: none;
          stroke: $color-white;
          opacity: 1;
        }
      }
    }
  }
  .axis {
    line {
      stroke: $color-gray;
    }
    .ticks {
      text {
        text-anchor: end;
        fill: $color-gray;
      }
    }
  }
}
</style>
