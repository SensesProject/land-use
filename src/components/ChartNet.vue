<template>
  <div class="chart-net narrow" :style="{width: `${width}px`}">
    <svg :width="width" :height="height">
      <g v-if="label" :transform="`translate(12 ${height / 2}) rotate(-90)`">
        <text :x="height/ 4" text-anchor="middle">Gains</text>
        <text :x="-height/ 4" text-anchor="middle">Needs</text>
      </g>
      <line class="ref" :x2="width"/>
      <line class="ref" :x2="width" :y1="height/ 2" :y2="height/ 2"/>
      <line class="ref" :x2="width" :y1="height" :y2="height"/>
      <g :transform="`translate(${(width - size) / 2} 0)`">
        <rect v-for="(d, i) in dims" :key="`r-${i}`" :class="[d.color]" :transform="`translate(${i * dimWidth + 1} ${height / 2 - 1})`"
          :width="dimWidth - 2" height="2"/>
        <g v-for="(d, i) in dims" :key="`d-${i}`" :transform="`translate(${i * dimWidth} ${height / 2 + d.yOffset})`">
          <polyline v-if="d.y2 != null" class="max" :class="[d.color]" :points="`1 0 ${dimWidth / 2} ${d.y2} ${dimWidth - 1} 0`"/>
          <polyline :class="[d.color]" :points="`1 0 ${dimWidth / 2} ${d.y} ${dimWidth - 1} 0`"/>
        </g>
        <g v-if="explain" :transform="`translate(${dimWidth / 2} ${height / 2})`">
          <line class="explain" y1="-53" y2="-53" :x2="dimWidth / 2 + 3"/>
          <line class="explain" y1="-18" y2="-18" :x2="dimWidth / 2 + 3"/>
          <text y="-50" :x="dimWidth / 2 + 6">maximal</text>
          <text y="-15" :x="dimWidth / 2 + 6">realistic</text>
        </g>
      </g>
      <!-- <polyline :points="`${size - size/6} ${size/2} ${size - size/6 * 2} ${size/2 + (size / 2 * data.cost)} ${size - size/6 * 3} ${size/2}`" class="violet"/> -->
    </svg>
    <span class="tiny">{{ data.name }}</span>
  </div>
</template>
<script>
export default {
  name: 'chartNet',
  props: {
    data: {
      type: Object,
      default () { return {} }
    },
    width: {
      type: Number,
      default: 320
    },
    dimensions: {
      type: Array,
      default () {
        return [{
          color: 'green',
          key: 'removal'
        }, {
          color: 'yellow',
          key: 'energy'
        }, {
          color: 'violet',
          key: 'cost'
        }, {
          color: 'blue',
          key: 'water'
        }, {
          color: 'red',
          key: 'land'
        }]
      }
    },
    label: {
      type: Boolean,
      default: false
    },
    explain: {
      type: Boolean,
      default: false
    }
  },
  data () {
    return {
      height: 160
    }
  },
  computed: {
    size () {
      const { width } = this
      return Math.min(160, width - 32)
    },
    dimWidth () {
      const { size, dims } = this
      return size / dims.length
    },
    dims () {
      const { data, height, dimensions } = this
      return dimensions.map(d => {
        const offset = 3
        const y = data.realistic[d.key] * (height / 2 - offset) * (d.key === 'removal' ? -1 : 1)
        const y2 = data.maximum != null ? data.maximum[d.key] * (height / 2 - offset) * (d.key === 'removal' ? -1 : 1) : null
        return {
          ...d,
          y,
          y2,
          yOffset: y < 0 ? -offset : offset
        }
      })
    }
  }
}
</script>
<style lang="scss" scoped>
@import "library/src/style/global.scss";
.chart-net {
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
  padding-top: $spacing / 2;
  svg {
    overflow: visible;
    polyline, rect {
      stroke: none;
      @include tint(fill);
      &.max {
        opacity: 0.2;
      }
    }
    .ref {
      stroke: $color-gray;
      stroke-dasharray: 2 2;
    }
    .explain {
      stroke: $color-green;
      stroke-dasharray: 2 2;
    }
    g text {
      fill: $color-dark-gray;
    }
  }
  span {
    // font-weight: $font-weight-bold;
    max-width: 200px;
    padding: $spacing / 2 0;
    text-align: center;
  }
}
</style>
