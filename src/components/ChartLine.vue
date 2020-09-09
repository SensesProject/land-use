<template>
  <div class="chart-line">
    <div class="narrow" v-resize:debounce.initial="onResize">
      <div class="tiny title">{{ label }}</div>
      <svg v-if="scenarios.length > 0" width="100%" :height="height"
        @mousemove="setYear($event)" @mouseenter="setYear($event)" @mouseout="resetYear()">
        <g class="axes">
          <g class="axis-y" :transform="`translate(${padding[3]}, 0)`">
            <g class="ticks ticks-y">
              <g class="tick tick-y" v-for="(t, i) in yTicks" :key="`y${i}`" :transform="`translate(0, ${t.y})`">
                <line :x2="width" :class="{ zero: t.value === 0 }"/>
              </g>
            </g>
            <g class="ruler" v-if="ruler" :transform="`translate(${ruler.x}, ${padding[0]})`">
              <line class="ruler" :y2="height - padding[0] - padding[2]" :y1="Math.min(0, ...points.map(p => p.y - padding[0]))" />
            </g>
          </g>
        </g>
        <g class="lines">
          <polyline v-for="(l, i) in lines" :key="`l${i}`" :class="[l.color, l.type]" :points="l.points"/>
        </g>
        <polyline class="diff" :class="difftint" :points="diff"/>
        <g class="points">
          <g v-for="(p, i) in points" :key="`p${i}`"  :transform="`translate(${ruler.x}, 0)`">
            <polyline class="shadow" :points="ruler.x < width / 2 ? `0 ${p.y} 4 ${p.y} 8 ${p.y2} 12 ${p.y2}` : `0 ${p.y} -4 ${p.y} -8 ${p.y2} -12 ${p.y2}`"/>
            <polyline :class="[p.color]" :points="ruler.x < width / 2 ? `0 ${p.y} 4 ${p.y} 8 ${p.y2} 12 ${p.y2}` : `0 ${p.y} -4 ${p.y} -8 ${p.y2} -12 ${p.y2}`"/>
            <circle :class="[p.color]" r="2" :transform="`translate(0, ${p.y})`"/>
            <g :transform="`translate(0, ${p.y2})`">
              <text y="4" :x="ruler.x < width / 2 ? 14 : -14" :style="{ 'text-anchor': ruler.x < width / 2 ? 'start' : 'end'}" class="shadow">{{ p.label }}<tspan> {{p.scenario}}</tspan></text>
              <text y="4" :x="ruler.x < width / 2 ? 14 : -14" :style="{ 'text-anchor': ruler.x < width / 2 ? 'start' : 'end'}" :class="[p.color]">{{ p.label }}<tspan> {{p.scenario}}</tspan></text>
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
              <text :y="tickSize" :style="{ 'text-anchor': ruler.x === 0 ? 'start' : ruler.x === width ? 'end' : 'middle'}">{{ year }}</text>
            </g>
          </g>
          <g class="axis-y" :transform="`translate(${padding[3]}, 0)`">
            <g class="ticks ticks-y">
              <g class="tick tick-y" v-for="(t, i) in yTicks" :key="`y${i}`"
                :transform="`translate(0, ${t.y})`" :class="{transparent: ruler !== null && ruler.x < 60 && i !== 0}">
                <text y="-4" class="shadow">{{ t.label }}<tspan v-if="i === 0"> {{ unit }}</tspan></text>
                <text y="-4">{{ t.label }}<tspan v-if="i === 0"> {{ unit }}</tspan></text>
              </g>
            </g>
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
  name: 'ChartLine',
  directives: {
    resize
  },
  props: {
    label: {
      type: String,
      default: null
    },
    difftint: {
      type: String,
      default: 'green'
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
  },
  data () {
    return {
      width: null,
      height: 200,
      padding: [18, 0, 16, 0],
      tickSize: 16,
      year: null
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
          points: s.series.map(d => `${xScale(d.year)}, ${yScale(d.value)}`).join(' ')
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
      const { year, xScale } = this
      if (year === null) return null

      return {
        x: xScale(year)
      }
    },
    points () {
      const { year, scenarios, yScale, numberFormat, height, padding } = this
      if (year === null) return null
      const points = scenarios.map((c, i) => {
        const d = c.series.find(v => v.year === year)
        if (d == null) return null
        const y = yScale(d.value)
        return {
          label: format(numberFormat)(d.value).replace(/,/, ' '),
          color: c.color,
          y,
          y2: y,
          validPosition: false
        }
      }).filter(d => d != null)
        .sort((a, b) => a.y - b.y)

      const positions = points.map(p => p.y2)
      const minDist = 14
      let diffs = positions.filter((y, i) => i > 0).map((y, i) => y - positions[i])
      while (diffs.find(d => d < minDist) != null) {
        diffs.forEach((d, i) => {
          if (d < minDist) {
            positions[i] = positions[i] - Math.max((minDist - d) / 2, 2)
            positions[i + 1] = positions[i + 1] + Math.max((minDist - d) / 2, 2)
            if (positions[i + 1] >= height - padding[2]) {
              positions[i + 1] = height - padding[2]
            }
          }
        })
        diffs = positions.filter((y, i) => i > 0).map((y, i) => y - positions[i])
      }
      points.forEach((p, i) => {
        p.y2 = positions[i]
      })

      return points
    }
  },
  mounted () {
  },
  methods: {
    onResize (el) {
      this.date = new Date().getTime()
      this.width = el.getBoundingClientRect().width
    },
    setYear (e) {
      const { xScale, years } = this
      const year = xScale.invert(e.offsetX)
      const closestYear = years.reduce((a, b) => (Math.abs(b - year) < Math.abs(a - year) ? b : a))
      this.year = closestYear
    },
    resetYear (e) {
      this.year = null
    }
  }
}
</script>
<style lang="scss" scoped>
@import "library/src/style/global.scss";
.chart-line {
  .title {
    font-weight: bold;
  }

  .warn {
    color: getColor(red, 50);
    display: flex;
    justify-content: center;
    align-items: center;
    span {
      border: 1px solid getColor(red, 50);
      padding: $spacing / 2 $spacing;
    }
  }

  svg {
    overflow: visible;

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
      polyline {
        fill: none;
        stroke: $color-black;
        stroke-width: 1.5;
        transition: opacity $transition;

        @include tint(stroke);
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
      }
    }
    .diff {
      @include tint(fill);
      opacity: 0.05;
    }
    .points {
      circle {
        fill: $color-white;
        stroke: $color-black;
        stroke-width: 1.5;

        @include tint(stroke);

      }
      text {
        fill: $color-deep-gray;

        &.shadow {
          fill: $color-white;
          stroke: transparentize($color: $color-white, $amount: .2);
          stroke-width: 3px;
        }
      }
    }
    .axes {
      line {
        stroke: $color-pale-gray;

        &.zero {
          stroke: $color-dark-gray;
        }
      }
      .ticks, .ruler {
        transition: opacity $transition;
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
