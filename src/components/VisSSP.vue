<template>
  <div class="vis-pressure" v-resize:debounce.initial="onResize">
    <div class="chart-group narrow table-head">
      <div class="tiny bold green" :style="{width: `${width}px`}">SSP1-1.9</div>
      <div class="tiny bold blue" :style="{width: `${width}px`}">SSP2-1.9</div>
      <div class="tiny bold violet" :style="{width: `${width}px`}">SSP5-1.9</div>
    </div>
    <div class="chart-group">
      <ChartLineFactor class="chart" :key="`clf-${i}`" v-for="(d, i) in masonry.filter(d => d.group === 'Population')"
        :data="d.series" :label="d.label" :width="width" :y-scale="yScale" :id="`ssp-a-${i}`" :tint="tints[i]"/>
    </div>
    <div class="chart-group">
      <ChartLineFactor class="chart" :key="`clf-${i}`" v-for="(d, i) in masonry.filter(d => d.group === 'Food Demand|Crops')"
        :data="d.series" :label="d.label" :width="width" :y-scale="yScale" :id="`ssp-b-${i}`" :tint="tints[i]"/>
    </div>
    <div class="chart-group">
      <ChartLineFactor class="chart" :key="`clf-${i}`" v-for="(d, i) in masonry.filter(d => d.group === 'Food Demand|Livestock')"
        :data="d.series" :label="d.label" :width="width" :y-scale="yScale" :id="`ssp-c-${i}`" :tint="tints[i]"/>
    </div>
  </div>
</template>
<script>
import SSP from 'dsv-loader!@/assets/data/sspcomparison.csv' // eslint-disable-line import/no-webpack-loader-syntax
import ChartLineFactor from '@/components/ChartLineFactor.vue'
import resize from 'vue-resize-directive'
export default {
  name: 'VisPressure',
  components: {
    ChartLineFactor
  },
  directives: {
    resize
  },
  data () {
    const tints = ['green', 'blue', 'violet']
    return {
      tints,
      yScale: 64,
      width: 320,
      columnSpacing: 16,
      ssp: SSP.map(d => {
        return {
          type: 'data',
          label: `${d.variable}`,
          group: d.variable,
          series: '.'.repeat(2100 - 2005 + 1).split('').map((y, i) => {
            const year = i + 2005
            return {
              year,
              value: d[year] === '' || d[year] == null ? null : +d[year]
            }
          }).filter(
            d => d.value != null
          ).map(({ year, value }, i, data) => {
            return {
              year,
              value: value / data[0].value
            }
          })
        }
      })
    }
  },
  computed: {
    masonry () {
      const { ssp } = this
      const masonry = [...ssp]
      // masonry.splice(6, 0, {
      //   type: 'text',
      //   tint: 'neon',
      //   text: 'Population growth and rising living standards connected with higher calorie intake drastically increased the global demand for food – especially for Fish and Livestock products – and non-food products'
      // })
      // masonry.splice(25, 0, {
      //   type: 'text',
      //   tint: 'neon',
      //   text: 'The demand is met with higher production, while keeping prices low in relation to rising incomes'
      // })
      // masonry.splice(39, 0, {
      //   type: 'text',
      //   text: 'Land however is a limited resource and changing land use to cropland and pastures happens on the expense of forests and other land with low human impact'
      // })
      // masonry.splice(52, 0, {
      //   type: 'text',
      //   text: 'Higher productivity allows to keep land use changes low but is only made possible with more irrigated agriculture and a drastic increase in the use of fertilizer'
      // })
      // masonry.splice(60, 0, {
      //   type: 'text',
      //   text: 'This becomes apparent as the nitrogen budget in cropland rises as well as N₂0 emissions'
      // })
      return masonry
    }
  },
  methods: {
    onResize (a, b, c) {
      const { columnSpacing } = this
      const iw = Math.min(innerWidth, 1600)
      const cols = iw < 480 ? 3 : iw < 960 ? 3 : iw < 1440 ? 4 : 5
      this.width = (iw - columnSpacing) / cols - columnSpacing
      // this.$nextTick(() => this.$redrawVueMasonry('vis-pressure'))
    }
  }
}
</script>
<style lang="scss" scoped>
@import "library/src/style/global.scss";
.vis-pressure {
  width: 100vw;
  max-width: 1600px;
  align-self: center;
  padding: 0 $spacing / 4;
  display: flex;
  align-items: center;
  flex-direction: column;
  // display: flex;
  // flex-wrap: wrap;
  // align-items: flex-start;
  // justify-content: center;

  .chart-group {
    display: flex;
    align-items: flex-end;
    justify-content: center;
    flex-wrap: wrap;

    &.table-head {
      margin: $spacing / 2 0 0 0;
      .bold {
        margin: $spacing / 4;
        font-weight: $font-weight-bold;
        text-align: center;
        @include tint(color);
      }
    }
  }

  .text-col {
    padding-top: $spacing / 2;
    padding-bottom: $spacing / 2;
  }

  .pressure-text {
    // @include tint(background);
    background: $color-neon;
    padding: $spacing / 4;
  }
}
</style>
