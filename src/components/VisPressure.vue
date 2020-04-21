<template>
  <div class="vis-pressure narrow">
    <div class="text">
      <div class="sticky">
        <h3 class="purple">Population and Income</h3>
        <p>
          Population growth and higher income are at the core of rising pressure on land. Rising living standards led to higher overall calorie intake per capita.
        </p>
      </div>
    </div>
    <div class="chart-group">
      <ChartLineFactor class="chart" :key="`clf-${i}`" v-for="(d, i) in masonry.filter(d => d.group === 0)"
        :data="d.series" :label="d.label" :width="width" tint="purple" :y-scale="yScale" :id="`${d.group}-${i}`" show-zero/>
    </div>
    <div class="text">
      <div class="sticky">
        <h3 class="yellow">Calorie supply</h3>
        <p>
          Calorie supply from fish – which doesn't directly impact land use – almost doubled, but the increase from livestock and secondary products is also remarkable.
        </p>
      </div>
    </div>
    <div class="chart-group">
      <ChartLineFactor class="chart" :key="`clf-${i}`" v-for="(d, i) in masonry.filter(d => d.group === 1)"
        :data="d.series" :label="d.label" :width="width" tint="yellow" :y-scale="yScale" :id="`${d.group}-${i}`" show-zero/>
    </div>
    <div class="text">
      <div class="sticky">
        <h3 class="purple">Demand</h3>
        <p>
          Higher Calory intake combination with an overall growth in poulation increases the global demand for these reseources.
        </p>
      </div>
    </div>
    <div class="chart-group">
      <ChartLineFactor class="chart" :key="`clf-${i}`" v-for="(d, i) in masonry.filter(d => d.group === 2)"
        :data="d.series" :label="d.label" tint="purple" :width="width" :y-scale="yScale" :id="`${d.group}-${i}`" show-zero/>
    </div>
    <div class="text">
      <div class="sticky">
        <h3 class="yellow">Prices</h3>
        <p>
          While prices for most agricultural products also increased, they did not keep up with increasing income. So actually household expenditure shares for food decreased.
        </p>
      </div>
    </div>
    <div class="chart-group">
      <ChartLineFactor class="chart" :key="`clf-${i}`" v-for="(d, i) in masonry.filter(d => d.group === 3)"
        :data="d.series" :label="d.label" tint="yellow" :width="width" :y-scale="yScale" :id="`${d.group}-${i}`" show-zero/>
    </div>
    <div class="text">
      <div class="sticky">
        <h3 class="purple">Household Expenditure</h3>
        <p>
          While prices for most agricultural products also increased, they did not keep up with increasing income. So actually household expenditure shares for food decreased.
        </p>
      </div>
    </div>
    <div class="chart-group">
      <ChartLineFactor class="chart" :key="`clf-${i}`" v-for="(d, i) in masonry.filter(d => d.group === 4)"
        :data="d.series" :label="d.label" tint="purple" :width="width" :y-scale="yScale" :id="`${d.group}-${i}`" show-zero/>
    </div>
    <div class="text">
      <div class="sticky">
        <h3 class="yellow">Land Cover</h3>
        <p>
          Since land is a limited resource, the rising demand could hardly be met by increasing cropland and pastures. And with the exception of managed forests and urban areas, which both remain quite low in absolute numbers, land use changed only slightly.
        </p>
      </div>
    </div>
    <div class="chart-group">
      <ChartLineFactor class="chart" :key="`clf-${i}`" v-for="(d, i) in masonry.filter(d => d.group === 5)"
        :data="d.series" :label="d.label" tint="yellow" :width="width" :y-scale="yScale" :id="`${d.group}-${i}`" show-zero/>
    </div>
    <div class="text">
      <div class="sticky">
        <h3 class="purple">Yields</h3>
        <p>
          Instead productivity could be increased leading to bigger and bigger yields…
        </p>
      </div>
    </div>
    <div class="chart-group">
      <ChartLineFactor class="chart" :key="`clf-${i}`" v-for="(d, i) in masonry.filter(d => d.group === 6)"
        :data="d.series" :label="d.label" tint="purple" :width="width" :y-scale="yScale" :id="`${d.group}-${i}`" show-zero/>
    </div>
    <div class="text">
      <div class="sticky">
        <h3 class="yellow">Productivity</h3>
        <p>
          Instead productivity could be increased leading to bigger and bigger yields…
        </p>
      </div>
    </div>
    <div class="chart-group">
      <ChartLineFactor class="chart" :key="`clf-${i}`" v-for="(d, i) in masonry.filter(d => d.group === 7)"
        :data="d.series" :label="d.label" tint="yellow" :width="width" :y-scale="yScale" :id="`${d.group}-${i}`" show-zero/>
    </div>
    <div class="text">
      <div class="sticky">
        <h3 class="purple">Emissions</h3>
        <p>
          Which also meant increasing emissions especially in regards to N₂O.
        </p>
      </div>
    </div>
    <div class="chart-group">
      <ChartLineFactor class="chart" :key="`clf-${i}`" v-for="(d, i) in masonry.filter(d => d.group === 8)"
        :data="d.series" :label="d.label" :width="width" tint="purple" :y-scale="yScale" :id="`${d.group}-${i}`" show-zero/>
    </div>
  </div>
</template>
<script>
import Pressure from 'dsv-loader!@/assets/data/landpressure.csv' // eslint-disable-line import/no-webpack-loader-syntax
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
    return {
      yScale: 64,
      width: 320,
      columnSpacing: 16,
      pressure: Pressure.map(d => {
        return {
          type: 'data',
          label: d.name,
          group: +d.group,
          series: '.'.repeat(2017 - 1960 + 1).split('').map((y, i) => {
            const year = i + 1960
            return {
              year,
              value: d[year] === '' ? null : +d[year]
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
      const { pressure } = this
      const masonry = [...pressure]
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
      const cols = iw < 480 ? 2 : iw < 960 ? 3 : iw < 1440 ? 4 : 5
      this.width = (iw - columnSpacing) / cols - columnSpacing
      this.$nextTick(() => this.$redrawVueMasonry('vis-pressure'))
    }
  }
}
</script>
<style lang="scss" scoped>
@import "library/src/style/global.scss";
.vis-pressure {
  width: 100%;
  // max-width: 1600px;
  align-self: center;
  // padding: 0 $spacing / 4;
  // display: flex;
  // align-items: center;
  // flex-direction: column;
  display: grid;
  grid-template-columns: 1fr 2fr;
  gap: $spacing $spacing / 2;
  @include max-width($narrow) {
    grid-template-columns: 1fr;
    gap: $spacing / 2;
  }
  // display: flex;
  // flex-wrap: wrap;
  // align-items: flex-start;
  // justify-content: center;

  .chart-group {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: $spacing / 2;
  //   display: flex;
  //   align-items: flex-end;
  //   justify-content: center;
  //   flex-wrap: wrap;
  }

  .text {
    // padding: $spacing / 4;
    // display: flex;
    // flex-direction: column;
    // justify-content: space-between;

    .sticky {
      position: sticky;
      align-self: start;
      top: $spacing * 2
    }

    h3 {
      @include tint(color);
      margin-bottom: $spacing / 4;
    }
  }

  .pressure-text {
    // @include tint(background);
    background: $color-neon;
    padding: $spacing / 4;
  }
}
</style>
