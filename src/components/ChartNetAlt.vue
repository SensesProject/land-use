<template>
  <div class="chart-net narrow" :style="{width: `${width}px`}">
    <svg :width="size" :height="size">
      <polyline :points="`-2 ${size/2} ${size + 2} ${size/2}`"/>
      <rect :x="size / 2 - (size / 2 * data.land)" :y="size / 2 - (size / 2 * data.land)"
        :width="size * data.land" :height="size * data.land" class="red"/>
      <path :d="`M ${size / 2 - (size / 2 * data.removal)} ${size / 2}
        A ${data.removal / 2 * size} ${data.removal / 2 * size}
        0 0 1
        ${size / 2 + (size / 2 * data.removal)} ${size / 2}`" class="green"/>
      <path :d="`M ${size / 2 - (size / 2 * data.water)} ${size / 2}
        A ${data.water / 2 * size} ${data.water / 2 * size}
        0 0 0
        ${size / 2 + (size / 2 * data.water)} ${size / 2}`" class="blue"/>
      <polyline :points="`${size/6} ${size/2} ${size/6 * 2} ${size/2 + (size / 2 * data.energy)} ${size/6 * 3} ${size/2}`" class="yellow"/>
      <polyline :points="`${size - size/6} ${size/2} ${size - size/6 * 2} ${size/2 + (size / 2 * data.cost)} ${size - size/6 * 3} ${size/2}`" class="violet"/>
      <polyline v-if="data.name === 'Direct Air Capture'" :points="`${size / 2 - 2} ${size / 2} ${size / 2 + 2} ${size / 2}`" class="red"/>
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
    }
  },
  computed: {
    size () {
      const { width } = this
      return Math.min(160, width)
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
    polyline, path, rect {
      stroke: $color-pale-gray;
      stroke-width: 3;
      fill: none;

      @include tint(stroke)
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
