<template>
  <div class="chart-line-factor narrow">
    <div class="label tiny" :style="{width: `${width}px`}">
      <strong>{{ label.replace(/\|/g,' | ') }}</strong>
      <span class="factor" :class="[tint]">{{factor}}×</span>
    </div>
    <svg class="graph" :width="width" :height="height + axisHeight">
      <clipPath :id="`mask-a-${id}`">
        <rect x="-4" y="-4" :width="width + 8" :height="base + 4" fill="white"/>
      </clipPath>
      <clipPath :id="`mask-b-${id}`">
        <rect x="-4" :y="base" :width="width + 8" :height="height - base + 4" fill="white"/>
      </clipPath>
      <polyline class="area up" :class="[tint]" :points="area" :clip-path="`url(#mask-a-${id})`"/>
      <polyline class="line up" :points="line" :clip-path="`url(#mask-a-${id})`"/>
      <polyline class="area down" :class="[tint]" :points="area" :clip-path="`url(#mask-b-${id})`"/>
      <polyline class="line down" :points="line" :clip-path="`url(#mask-b-${id})`"/>
      <!-- <polyline class="line up" :class="[tint]" :points="line"/> -->
      <g v-if="xDomain" :transform="`translate(0 ${height})`">
        <!-- <line :x2="width" y1="4" y2="4"/> -->
        <line :x1="xRange[0]" :x2="xRange[0]" y1="3" y2="6"/>
        <line :x1="xRange[1]" :x2="xRange[1]" y1="3" y2="6"/>
        <text :x="xRange[0]" :y="axisHeight - 1">{{data[0].year}}</text>
        <text :x="xRange[1]" :y="axisHeight - 1">{{data[data.length - 1].year}}</text>
      </g>
    </svg>
    <div v-if="!xDomain" class="years tiny" :style="{width: `${width}px`}">
      <span class="year">{{data[0].year}}</span>
      <span class="year">{{data[data.length - 1].year}}</span>
    </div>
  </div>
</template>
<script>
import { scaleLinear } from 'd3-scale'
import { format } from 'd3-format'
export default {
  name: 'chartLineFactor',
  props: {
    id: {
      type: String,
      default: '0'
    },
    data: {
      type: Array,
      default () { return [] }
    },
    label: {
      type: String,
      default: 'Label'
    },
    width: {
      type: Number,
      default: 320
    },
    yScale: {
      type: Number,
      default: 40
    },
    xDomain: {
      type: Array,
      default: null
    },
    showZero: {
      type: Boolean,
      default: false
    },
    tint: {
      type: String,
      default: 'neon'
    }
  },
  computed: {
    axisHeight () {
      const { xDomain } = this
      return xDomain == null ? 0 : 18
    },
    min () {
      const { data, showZero } = this
      return showZero ? 0 : Math.min(...data.map(({ value }) => value))
    },
    max () {
      const { data } = this
      return Math.max(...data.map(({ value }) => value))
    },
    height () {
      const { min, max, yScale } = this
      return (max - min) * yScale
    },
    factor () {
      const { data } = this
      return format('.1f')(data[data.length - 1].value)
    },
    xScale () {
      const { width, data, xDomain } = this
      return scaleLinear()
        .domain(xDomain || [data[0].year, data[data.length - 1].year])
        .range([0, width])
    },
    line () {
      const { data, xScale, yScale, min, height } = this
      return data.map(d => `${xScale(d.year)} ${-yScale * (d.value - min) + height}`).join(' ')
    },
    area () {
      const { line, showZero, base, height, xRange } = this
      const zero = showZero ? height : base
      return `${xRange[0]} ${zero} ${line} ${xRange[1]} ${zero}`
    },
    xRange () {
      const { xScale, data } = this
      return [xScale(data[0].year), xScale(data[data.length - 1].year)]
    },
    base () {
      const { yScale, data, min, height } = this
      return -yScale * (data[0].value - min) + height
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
.chart-line-factor {
  padding: $spacing / 4;
  display: flex;
  flex-direction: column;
  .label {
    display: flex;
    justify-content: space-between;
    align-items: flex-end;
    padding-bottom: $spacing / 8;
    hyphens: auto;
    .factor {
      color: $color-neon;
      // @include tint(color);
    }
  }
  svg {
    overflow: visible;
    .line {
      stroke: $color-neon;
      // @include tint(stroke);
      stroke-width: 2;
      fill: none;

      &.down {
        stroke: $color-blue;
      }
    }
    .area {
      fill: $color-neon;
      // @include tint(fill, 80);
      opacity: 0.2;

      &.down {
        fill: $color-blue;
        opacity: 0.1;
        // @include tint(fill, 40);
      }
    }
    text {
      fill: $color-light-gray;
      &:last-of-type {
        text-anchor: end;
      }
    }
    line {
      stroke: $color-light-gray;
    }
  }
  .years {
    display: flex;
    justify-content: space-between;
    color: $color-light-gray;
  }
}
</style>
