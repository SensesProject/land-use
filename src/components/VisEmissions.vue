<template>
  <div class="vis-emissions narrow" v-resize:debounce.initial="onResize">
    <svg :height="svgHeight" :width="svgWidth">
      <g :transform="`translate(${offsetX} ${0})`">
        <g>
          <text :y="lineHeight">Emissions from AFOLU and other sources</text>
          <transition name="fade">
            <text v-if="step < 3" :y="lineHeight">
              <tspan class="strong" :dy="lineHeight * 2" x="0">SSP Baseline 2020</tspan>
              <tspan :dy="lineHeight" x="0">relative</tspan>
              <tspan :x="columnWidth">absolute</tspan>
              <tspan :x="columnWidth * 2">CO₂-equivalent</tspan>
            </text>
          </transition>
          <transition name="fade">
            <text v-if="step >= 3" :y="lineHeight">
              <tspan :dy="lineHeight * 2" x="0">CO₂-equivalent</tspan>
              <tspan class="strong" :dy="lineHeight" x="0">SSP2-Baseline 2020</tspan>
              <tspan class="strong" :x="columnWidth">SSP2-Baseline 2100</tspan>
              <tspan class="strong" :x="columnWidth * 2">SSP2-1.9 2100</tspan>
            </text>
          </transition>
        </g>
        <g :transform="`translate(${0} ${lineHeight * 4})`">
          <line :x1="0.5" :x2="0.5" :y1="margin / 2" :y2="innerHeight" class="pale"/>
          <line :x1="0.5 + svgWidth / 3" :x2="0.5 + svgWidth / 3" :y1="margin / 2" :y2="innerHeight" class="pale"/>
          <line :x1="0.5 + svgWidth / 3 * 2" :x2="0.5 + svgWidth / 3 * 2" :y1="margin / 2" :y2="innerHeight" class="pale"/>
          <g v-for="(v, i) in variables" :key="`row-${i}`" :transform="`translate(${0}, ${rowHeight * (i + 1)})`">
            <line :x2="svgWidth" class="pale"/>
            <g class="slide-container" :style="{transform: `translate(${step < 3 ? 0.5 : -columnWidth * 2 + 0.5}px, 0px)`}">
              <g v-for="(u, i2) in units[i]" :key="`row-${i}-${i2}`" :transform="`translate(${columnWidth * i2} 0)`">
                <transition name="fade">
                  <g v-if="u.min <= step && (u.max == null || u.max >= step)">
                    <rect transform="rotate(-90)" :width="u.total" :height="u.total" class="white"/>
                    <rect transform="rotate(-90)" :width="u.afolu" :height="u.afolu" class="white"/>
                    <rect transform="rotate(-90)" :width="u.total" :height="u.total" class="yellow"/>
                    <rect transform="rotate(-90)" :width="u.afolu" :height="u.afolu" class="purple"/>
                    <rect class="white-text" :height="lineHeight + 6" x="-1" :width="2" y="1"/>
                    <text class="purple" :y="lineHeight">{{ u.label }}</text>
                  </g>
                </transition>
              </g>
              <g v-for="(u, i2) in scenarios[i]" :key="`row2-${i}-${i2}`" :transform="`translate(${columnWidth * (i2 + 2)} 0)`">
                <transition name="fade">
                  <g v-if="u.min <= step && (u.max == null || u.max >= step)">
                    <rect :transform="u.total > 0 ? 'rotate(-90)' : ''" :width="Math.abs(u.total)" :height="Math.abs(u.total)" class="white"/>
                    <rect :transform="u.afolu > 0 ? 'rotate(-90)' : ''" :width="Math.abs(u.afolu)" :height="Math.abs(u.afolu)" class="white"/>
                    <rect :transform="u.total > 0 ? 'rotate(-90)' : ''" :width="Math.abs(u.total)" :height="Math.abs(u.total)" class="yellow"/>
                    <rect :transform="u.afolu > 0 ? 'rotate(-90)' : ''" :width="Math.abs(u.afolu)" :height="Math.abs(u.afolu)" class="purple"/>
                    <rect v-if="u.total < 0" class="white-text" :height="lineHeight + 4" x="-1" :width="2" :y="-lineHeight - 4"/>
                    <rect v-if="u.afolu > 0" class="white-text" :height="lineHeight + 6" x="-1" :width="2" y="1"/>
                    <text class="purple" :y="u.afolu > 0 ? lineHeight : -6">{{ u.label }}</text>
                  </g>
                </transition>
              </g>
            </g>

            <g :transform="`translate(${0} ${lineHeight * 2})`">
              <rect class="white-text" :height="lineHeight + 6" :y="-lineHeight" x="-1" :width="3"/>
              <text class="strong">{{ v.variable }}</text>
            </g>
          </g>
        </g>
        <g class="key" :transform="`translate(0 ${svgHeight - lineHeight -3})`">
          <g>
            <rect class="key-icon purple" :width="lineHeight * 0.75" :height="lineHeight * 0.75" :y="-lineHeight * 0.75 + 1" x="0.5"/>
            <text :x="lineHeight + 2">AFOLU</text>
          </g>
          <g :transform="`translate(75 0)`">
            <polygon class="key-icon yellow" :transform="`translate(0 1)`"
              :points="`
                0 ${-lineHeight * 0.75}
                ${lineHeight * 0.75} ${-lineHeight * 0.75}
                ${lineHeight * 0.75} 0
                ${lineHeight * 0.35} 0
                ${lineHeight * 0.35} ${-lineHeight * 0.35}
                0 ${-lineHeight * 0.35}
              `"/>
            <text :x="lineHeight + 2">Other sources</text>
          </g>
        </g>
      </g>
    </svg>
  </div>
</template>
<script>
import Emissions from 'dsv-loader!@/assets/data/land-emissions.csv' // eslint-disable-line import/no-webpack-loader-syntax
import resize from 'vue-resize-directive'
import { scalePow } from 'd3-scale'
export default {
  name: 'VisEmissions',
  directives: {
    resize
  },
  props: {
    step: Number
  },
  components: {
  },
  data () {
    const years = [2020, 2100]
    const variables = [{
      variable: 'CO₂',
      factor: 1
    }, {
      variable: 'CH₄',
      factor: 28
    }, {
      variable: 'N₂0',
      factor: 265
    }]
    return {
      width: null,
      height: null,
      margin: 16,
      lineHeight: 16,
      variables,
      yAxisWidth: 64,
      emissions: variables.map(v => {
        const rows = Emissions.filter(e => e.variable === v.variable).reverse()
        return {
          ...v,
          // unit: rows[0].unit,
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
      const { width, margin } = this
      return width >= 600 ? width / 3 * 2 - margin : width
    },
    offsetX () {
      const { width } = this
      return width >= 600 ? 0 : 0
    },
    svgHeight () {
      const { height } = this
      return height
    },
    columnWidth () {
      const { svgWidth } = this
      return svgWidth / 3
    },
    innerHeight () {
      const { svgHeight, margin, lineHeight } = this
      return svgHeight - margin - lineHeight * 8
    },
    rowHeight () {
      const { innerHeight } = this
      return innerHeight / 3
    },
    maxSquare () {
      const { rowHeight, columnWidth, margin, lineHeight } = this
      return Math.min(rowHeight - lineHeight, columnWidth) - margin
    },
    scaleAbs () {
      const { maxSquare } = this
      const max = Emissions.filter(e => e.variable === 'CO₂' && e.scenario === 'SSP2-Baseline' && e.source === 'total')[0][2100]
      return scalePow([0, max], [0, maxSquare]).exponent(0.5)
    },
    scaleRel () {
      const { scaleAbs } = this
      const base = Emissions.filter(e => e.variable === 'CO₂' && e.scenario === 'SSP2-Baseline' && e.source === 'total')[0][2020]
      return scalePow([0, 1], [0, scaleAbs(base)]).exponent(0.5)
    },
    units () {
      const { scaleAbs, scaleRel } = this
      return this.variables.map(v => {
        const total = Emissions.filter(e => e.variable === v.variable && e.scenario === 'SSP2-Baseline' && e.source === 'total')[0][2020]
        const afolu = Emissions.filter(e => e.variable === v.variable && e.scenario === 'SSP2-Baseline' && e.source === 'afolu')[0][2020]
        return [{
          total: scaleRel(1),
          afolu: scaleRel(afolu / total),
          label: `${Math.round((afolu / total) * 100)}%`,
          min: 0,
          max: 2
        }, {
          total: scaleAbs(total),
          afolu: scaleAbs(afolu),
          label: `${Math.round(afolu)} Mt`,
          min: 1,
          max: 2
        }]
      })
    },
    scenarios () {
      const { scaleAbs } = this
      return this.variables.map(v => {
        const total1 = Emissions.filter(e => e.variable === v.variable && e.scenario === 'SSP2-Baseline' && e.source === 'total')[0][2020]
        const afolu1 = Emissions.filter(e => e.variable === v.variable && e.scenario === 'SSP2-Baseline' && e.source === 'afolu')[0][2020]
        const total2 = Emissions.filter(e => e.variable === v.variable && e.scenario === 'SSP2-Baseline' && e.source === 'total')[0][2100]
        const afolu2 = Emissions.filter(e => e.variable === v.variable && e.scenario === 'SSP2-Baseline' && e.source === 'afolu')[0][2100]
        const total3 = Emissions.filter(e => e.variable === v.variable && e.scenario === 'SSP2-19' && e.source === 'total')[0][2100]
        const afolu3 = Emissions.filter(e => e.variable === v.variable && e.scenario === 'SSP2-19' && e.source === 'afolu')[0][2100]
        return [{
          total: scaleAbs(total1 * v.factor),
          afolu: scaleAbs(afolu1 * v.factor),
          label: `${Math.round(afolu1 * v.factor)} Mt`,
          min: 2
        }, {
          total: scaleAbs(total2 * v.factor),
          afolu: scaleAbs(afolu2 * v.factor),
          label: `${Math.round(afolu2 * v.factor)} Mt`,
          min: 4
        }, {
          total: scaleAbs(total3 * v.factor),
          afolu: scaleAbs(afolu3 * v.factor),
          label: `${Math.round(afolu3 * v.factor)} Mt`,
          min: 5
        }]
      })
    }
  },
  methods: {
    onResize (el) {
      this.width = el.getBoundingClientRect().width
      this.height = el.getBoundingClientRect().height
    }
  }
}
</script>
<style lang="scss" scoped>
@import "library/src/style/global.scss";
.vis-emissions {
  height: 100%;
  svg {
    display: block;
    overflow: visible;

    text, tspan {
      &.strong {
        font-weight: $font-weight-bold;
      }
    }
    .purple {
      fill: $color-purple;
      stroke: $color-purple;
    }

    .white {
      fill: $color-white;
      stroke: $color-white;
      stroke-width: 12;
    }

    .white-text {
      fill: $color-white;
    }

    .pale {
      stroke: $color-pale-gray;
    }
    text.purple {
      stroke: none;
    }

    .yellow {
      fill: none;
      stroke: $color-yellow;
    }

    .slide-container {
      transition: transform $transition;
    }
    .fade-enter-active, .fade-leave-active {
      transition: opacity $transition;
    }
    .fade-enter, .fade-leave-to {
      opacity: 0;
    }
  }
}
</style>
