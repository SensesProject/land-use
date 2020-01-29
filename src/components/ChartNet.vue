<template>
  <div class="chart-net narrow" :style="{width: `${width}px`}">
    <svg :width="size" :height="size">
      <rect v-for="(d, i) in dims" :key="`r-${i}`" :class="[d.color]" :transform="`translate(${i * dimWidth + 1} ${size / 2 - 1})`"
        :width="dimWidth - 2" height="2"/>
      <polyline v-for="(d, i) in dims" :key="`d-${i}`" :class="[d.color]" :transform="`translate(${i * dimWidth} ${size / 2 + d.yOffset})`"
        :points="`1 0 ${dimWidth / 2} ${d.y} ${dimWidth - 1} 0`"/>
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
          color: 'red',
          key: 'land'
        }, {
          color: 'yellow',
          key: 'energy'
        }, {
          color: 'blue',
          key: 'water'
        }, {
          color: 'violet',
          key: 'cost'
        }]
      }
    }
  },
  computed: {
    size () {
      const { width } = this
      return Math.min(160, width)
    },
    dimWidth () {
      const { size, dims } = this
      return size / dims.length
    },
    dims () {
      const { data, size, dimensions } = this
      return dimensions.map(d => {
        const offset = 3
        const y = data[d.key] * (size / 2 - offset) * (d.key === 'removal' ? -1 : 1)
        return {
          ...d,
          y,
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
      @include tint(fill)
    }
  }
  span {
    // font-weight: $font-weight-bold;
    max-width: 200px;
    padding: $spacing / 4 0 0 0;
    text-align: center;
  }
}
</style>
