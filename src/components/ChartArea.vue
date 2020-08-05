<template>
  <div class="chart-area">
    <div class="narrow" v-resize:debounce.initial="onResize">
      <svg v-if="scenarios.length > 0" width="100%" height="100%"
        @mousemove="setYear($event)" @mouseenter="setYear($event)" @mouseout="resetYear()">
        <text class="strong" y="16">{{ label }}</text>
        <g transform="translate(0 8)">
          <g class="lines">
            <path v-for="(l, i) in lines" :key="`lb${i}`" class="background" :class="[l.color, l.type]" :d="l.points.replace(/M/g, 'L').replace(/L/, 'M')"/>
          </g>
          <g class="axes">
            <g class="axis-y" :transform="`translate(${padding[3]}, 0)`">
              <g class="ticks ticks-y">
                <g class="tick tick-y" v-for="(t, i) in yTicks" :key="`y${i}`" :transform="`translate(0, ${t.y})`">
                  <line :x2="width" :class="{ zero: t.value === 0 }"/>
                </g>
              </g>
              <g class="ruler" v-if="ruler" :transform="`translate(${ruler.x}, ${padding[0]})`">
                <!-- <line class="ruler" :y2="height - padding[0] - padding[2]" :y1="Math.min(0, ...points.map(p => p.y - padding[0]))" /> -->
              </g>
            </g>
          </g>
          <polyline class="diff" :points="diff"/>
          <g class="points">
            <g v-if="ruler.year !== 2005">
              <g v-for="(p, i) in basePoints" :key="`p${i}`"  :transform="`translate(${0}, 0)`">
                <!-- <line v-if="p.y2 < p.y1 && (value || year) !== 2005 && (value || year) !== 2100" class="ruler" :y1="p.y1" :y2="p.y2"/> -->
                <circle class="dark" :class="[p.color]" r="1.5" :cx="0.5" :transform="`translate(0, ${p.y})`" v-if="p.color !== 'orange'"/>
                <g :transform="`translate(0, ${p.y})`" v-if="p.color !== 'orange'">
                  <!-- <text y="4" :x="7" :style="{ 'text-anchor': 'start'}" :class="[p.color]" class="shadow">{{ p.label }}<tspan> {{p.scenario}}</tspan></text> -->
                  <text y="4" :x="4" :style="{ 'text-anchor': 'start', 'opacity': 0.8}" :class="[p.color]" class="dark">{{ p.label }}<tspan> {{p.scenario}}</tspan></text>
                </g>
              </g>
            </g>
            <g v-for="(p, i) in points" :key="`p${i}`"  :transform="`translate(${ruler.x}, 0)`">
              <!-- <polyline class="shadow" :points="ruler.x < width / 2 ? `0 ${p.y} 4 ${p.y} 8 ${p.y2} 12 ${p.y2}` : `0 ${p.y} -4 ${p.y} -8 ${p.y2} -12 ${p.y2}`"/> -->
              <!-- <polyline :class="[p.color]" :points="ruler.x < width / 2 ? `0 ${p.y} 4 ${p.y} 8 ${p.y2} 12 ${p.y2}` : `0 ${p.y} -4 ${p.y} -8 ${p.y2} -12 ${p.y2}`"/> -->
              <line v-if="p.y2 < p.y1 && (value || year) !== 2005 && (value || year) !== 2100" class="ruler" :y1="p.y1" :y2="p.y2"/>
              <circle :class="[p.color]" r="2" :transform="`translate(0, ${p.y})`"/>
              <g :transform="`translate(0, ${p.y})`">
                <text y="4" :x="ruler.x < width / 2 ? 7 : -7" :style="{ 'text-anchor': ruler.x < width / 2 ? 'start' : 'end'}" :class="[p.color]" class="shadow">{{ p.label }}<tspan> {{p.scenario}}</tspan></text>
                <text y="4" :x="ruler.x < width / 2 ? 7 : -7" :style="{ 'text-anchor': ruler.x < width / 2 ? 'start' : 'end'}" :class="[p.color]">{{ p.label }}<tspan> {{p.scenario}}</tspan></text>
              </g>
            </g>
          </g>
          <g class="axes">
            <g class="axis-x" :transform="`translate(0, ${height - padding[2]})`">
              <g class="ticks ticks-x">
                <g class="tick tick-x" v-for="(t, i) in xTicks" :key="`x${i}`" :transform="`translate(${t.x}, 0)`">
                  <text :y="tickSize" :class="{transparent: ruler !== null && Math.abs(ruler.x - t.x) < 60}">
                    {{ t.value }}
                  </text>
                </g>
              </g>
              <g class="ruler" v-if="ruler" :transform="`translate(${ruler.x}, 0)`">
                <text :y="tickSize" :style="{ 'text-anchor': ruler.x === 0 ? 'start' : ruler.x === width ? 'end' : 'middle'}">{{ value || year }}</text>
              </g>
            </g>
            <!-- <g class="axis-y" :transform="`translate(${padding[3]}, 0)`">
              <g class="ticks ticks-y">
                <g class="tick tick-y" v-for="(t, i) in yTicks" :key="`y${i}`"
                  :transform="`translate(0, ${t.y})`" :class="{transparent: ruler !== null && ruler.x < 60 && i !== 0}">
                  <text y="-4" class="shadow">{{ t.label }}<tspan v-if="i === 0"> {{ unit }}</tspan></text>
                  <text y="-4">{{ t.label }}<tspan v-if="i === 0"> {{ unit }}</tspan></text>
                </g>
              </g>
            </g> -->
          </g>
        </g>
      </svg>
      <div v-else :style="{width: `${width}px`, height: `${height}px`}" class="tiny warn">
        <span>no data available</span>
      </div>
    </div>
  </div>
</template>

<script>
import resize from 'vue-resize-directive'
import { scaleLinear } from 'd3-scale'
import { format } from 'd3-format'
export default {
  name: 'ChartArea',
  directives: {
    resize
  },
  props: {
    value: {
      type: Number,
      default: null
    },
    label: {
      type: String,
      default: null
    },
    unit: {
      type: String,
      default: null
    },
    scenarios: {
      type: Array,
      default () { return [] }
    },
    years: {
      type: Array,
      default () { return [] }
    },
    numberFormat: {
      default: ',.4~r',
      type: String
    },
    domain: {
      default: null,
      type: Array
    },
    nice: {
      type: [Number, Boolean],
      default: 3
    },
    ticks: {
      type: Array,
      default: null
    }
    // height: {
    //   type: Number,
    //   default: 200
    // }
  },
  data () {
    return {
      width: null,
      height: null,
      padding: [18, 0, 32, 0],
      tickSize: 16,
      year: 2100
    }
  },
  computed: {
    xDomain () {
      const { years } = this
      return [Math.min(...years), Math.max(...years)]
    },
    yDomain () {
      const { scenarios, domain } = this
      if (domain != null) return domain
      const values = scenarios.map(c => c.series.map(s => s.value)).flat()
      return [Math.max(...values), Math.min(...values)]
    },
    xScale () {
      const { padding, width, xDomain } = this
      return scaleLinear()
        .domain(xDomain)
        .range([padding[3], width - padding[1]])
        // .nice()
    },
    yScale () {
      const { padding, height, yDomain, nice } = this
      return scaleLinear()
        .domain(yDomain)
        .range([padding[0], height - padding[2]])
        .nice(nice)
    },
    xTicks () {
      const { xScale, xDomain } = this
      return xDomain.map(t => ({
        value: t,
        x: xScale(t)
      }))
    },
    yTicks () {
      const { yScale, numberFormat, nice, ticks } = this
      return (ticks != null ? ticks : yScale.ticks(nice)).map(t => ({
        value: t,
        label: format(numberFormat)(t).replace(/,/, ' '),
        y: yScale(t)
      }))
    },
    lines () {
      const { scenarios, xScale, yScale } = this
      return scenarios.map((s, i) => {
        return {
          ...s,
          points: [...s.series.map((d, di) => {
            const sum = scenarios.filter((s2, i2) => i2 <= i).map(s2 => s2.series.find(s2s => s2s.year === d.year).value).reduce((a, b) => +a + +b, 0)
            return `${di === 0 ? 'M' : 'L'} ${xScale(d.year)},${yScale(sum)}`
          }),
          ...s.series.reverse().map((d, di) => {
            const sum = scenarios.filter((s2, i2) => i2 < i).map(s2 => s2.series.find(s2s => s2s.year === d.year).value).reduce((a, b) => +a + +b, 0)
            return `${di === 0 ? 'M' : 'L'} ${xScale(d.year)},${yScale(sum)}`
          })].join(' ')
        }
      })
    },
    diff () {
      const { scenarios, xScale, yScale } = this
      const s1 = scenarios[0].series.map(d => `${xScale(d.year)}, ${yScale(d.value)}`).join(' ')
      const s2 = scenarios[1].series.map(d => `${xScale(d.year)}, ${yScale(d.value)}`).reverse().join(' ')

      return `${s1} ${s2}`
    },
    ruler () {
      const { xScale } = this
      const year = this.value || this.year
      if (year === null) return null

      return {
        year,
        x: xScale(year)
      }
    },
    points () {
      const { scenarios, yScale } = this
      const year = this.value || this.year
      if (year === null) return null
      const points = scenarios.map((c, i) => {
        const d = c.series.find(v => v.year === year)
        if (d == null) return null
        const sum = scenarios.filter((s2, i2) => i2 < i).map(s2 => s2.series.find(s2s => s2s.year === d.year).value).reduce((a, b) => +a + +b, 0)
        const y = yScale(sum + d.value / 2)
        const diff = Math.round(d.value - c.series.find(v => v.year === 2005).value)
        const labelValue = year === 2005 ? Math.round(d.value) : diff >= 0 ? `+${diff}` : diff
        return {
          label: `${labelValue} Mha`,
          color: c.color,
          y,
          y1: yScale(sum) - 4,
          y2: yScale(sum + +d.value) + 4,
          validPosition: false
        }
      }).filter(d => d != null)
      return points
    },
    basePoints () {
      const { scenarios, yScale } = this
      const year = 2005
      const points = scenarios.map((c, i) => {
        const d = c.series.find(v => v.year === year)
        if (d == null) return null
        const sum = scenarios.filter((s2, i2) => i2 < i).map(s2 => s2.series.find(s2s => s2s.year === d.year).value).reduce((a, b) => +a + +b, 0)
        const y = yScale(sum + d.value / 2)
        const diff = Math.round(d.value - c.series.find(v => v.year === 2005).value)
        const labelValue = year === 2005 ? Math.round(d.value) : diff >= 0 ? `+${diff}` : diff
        return {
          label: `${labelValue} Mha`,
          color: c.color,
          y,
          y1: yScale(sum) - 4,
          y2: yScale(sum + +d.value) + 4,
          validPosition: false
        }
      }).filter(d => d != null)
      return points
    }
  },
  mounted () {
  },
  methods: {
    onResize (el) {
      this.width = el.getBoundingClientRect().width
      this.height = el.getBoundingClientRect().height
    },
    setYear (e) {
      const { xScale, years } = this
      const year = xScale.invert(e.offsetX)
      const closestYear = years.reduce((a, b) => (Math.abs(b - year) < Math.abs(a - year) ? b : a))
      this.year = closestYear
      this.$emit('input', closestYear)
    },
    resetYear (e) {
      this.year = 2100
      this.$emit('input', null)
    }
  }
}
</script>
<style lang="scss" scoped>
@import "library/src/style/global.scss";
.chart-area {
  // background: $color-neon;
  // margin-bottom: $spacing;
  // display: flex;
  // flex-direction: column;
  // justify-content: flex-end;

  .title {
    font-weight: bold;
  }

  .narrow {
    height: 100%;
  }

  svg {
    overflow: visible;
    display: block;
    .strong {
      fill: $color-black;
      font-weight: $font-weight-bold;
    }
    * {
      pointer-events: none;
    }
    .background {
      fill: getColor(gray, 90);
    }
    .title {
      font-weight: $font-weight-bold;
    }
    .lines, .points {
      polyline, path {
        fill: none;
        stroke: $color-black;
        stroke-width: 1.5;
        transition: opacity $transition;
        // mix-blend-mode: multiply;
        stroke: $color-white;
        // @include tint(stroke);
        &.shadow {
          stroke-width: 3.5;
          stroke: $color-white;
        }
        &.transparent {
          opacity: 0.1;
        }
        &.reference {
          stroke: $color-black;
          stroke-dasharray: 4 4;
        }

        &.background {
          @include tint(fill);
          stroke: none;
          // opacity: 0.1;
        }
      }
    }
    .diff {
      fill: $color-green;
      opacity: 0.05;
    }
    .points {
      .ruler {
        stroke: $color-white;
      }
      circle {
        fill: $color-white;
        stroke: $color-white;
        stroke-width: 1.5;
        // mix-blend-mode: multiply;

        @include tint(stroke);

        &.dark {
          @include tint(fill, 20);
          stroke: none;
          opacity: 0.8;
        }

        // &.light {
        //   @include tint(stroke, 60);
        // }
        // &.dark {
        //   @include tint(stroke, 40);
        // }
      }
      text {
        fill: $color-white;
        // @include tint(fill);
        // &.light {
        //   @include tint(fill, 60);
        // }
        // &.dark {
        //   @include tint(fill, 40);
        // }
        // font-size: 0.7em;

        &.shadow {
          // fill: $color-white;
          // stroke: transparentize($color: $color-white, $amount: .2);
          @include tint(stroke);
          @include tint(fill);
          stroke-width: 3px;
        }
        &.dark {
          @include tint(fill, 20);
          opacity: 0.8;
          // fill: $color-white;
          // stroke: transparentize($color: $color-white, $amount: .2);
          // @include tint(stroke);
          // @include tint(fill);
          // stroke-width: 3px;
        }
      }
    }
    .axes {
      line {
        stroke: $color-white;

        &.zero {
          stroke: $color-dark-gray;
        }
      }
      .ticks, .ruler {
        transition: opacity $transition;
        stroke-width: 1.5;
        text {
          fill: $color-deep-gray;
          transition: opacity $transition;

          &.shadow {
            fill: $color-white;
            stroke: transparentize($color: $color-white, $amount: .2);
            stroke-width: 3px;
          }
          &.transparent {
            opacity: 0.2;
          }
        }
        .tick {
          transition: opacity $transition;
        }
        &.transparent, .transparent {
          opacity: 0.2;
        }
      }
      .ticks-x {
        .tick-x {
          text {
            text-anchor: middle;
          }
          &:first-of-type {
            text {
              text-anchor: start;
            }
          }
          &:last-of-type {
            text {
              text-anchor: end;
            }
          }
        }
      }
    }
  }
}
</style>
