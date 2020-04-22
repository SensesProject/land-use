<template>
  <div class="vis-pressure narrow">
    <template v-for="(s, i) in sections">
      <div class="text" :key="`st-${i}`">
        <div class="sticky">
          <h3 :class="s.color">{{ s.title }}</h3>
          <p>{{ s.text }}</p>
          <!-- <p class="tiny sources">
            <span v-for="(source, i2) in s.sources" :key="`source-${i}-${i2}`">
              <sup>{{source.ref}}</sup>{{source.label}}
            </span>
          </p> -->
        </div>
      </div>
      <div class="chart-group" :key="`sc-${i}`">
        <ChartLineFactor class="chart" v-for="(d, i2) in s.data" :key="`sc-${i}-${i2}`"
          :data="d.series" :source="d.source" :label="d.label" :tint="s.color" :y-scale="yScale" :id="`${i}-${i2}`" show-zero/>
      </div>
    </template>
    <p class="tiny sources">
      <strong>Sources: </strong>
      <span v-for="(source, i) in sources" :key="`source-${i}`">
        <strong>{{i + 1}}</strong><span v-html="`&nbsp;${source || '?'}`"/><span v-if="i !== sources.length - 1" v-html="`; `"/>
      </span>
    </p>
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
    const sources = [...new Set(Pressure.map(d => d.model))]
    return {
      yScale: 64,
      sources,
      pressure: Pressure.map(d => {
        return {
          type: 'data',
          label: d.name,
          group: +d.group,
          source: sources.indexOf(d.model),
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
    sections () {
      const { pressure, sources } = this
      return [{
        title: 'Population and Income',
        text: 'Population growth and higher income are at the core of rising pressure on land. Rising living standards led to higher overall calorie intake per capita.'
      }, {
        title: 'Calorie supply',
        text: 'Calorie supply from fish – which does not directly impact land use – almost doubled, but the increase from livestock and secondary products is also remarkable.'
      }, {
        title: 'Demand',
        text: 'Higher Calory intake combination with an overall growth in poulation increases the global demand for these reseources.'
      }, {
        title: 'Prices',
        text: 'While prices for most agricultural products also increased, they did not keep up with increasing income. So actually household expenditure shares for food decreased.'
      }, {
        title: 'Household Expenditure',
        text: 'While prices for most agricultural products also increased, they did not keep up with increasing income. So actually household expenditure shares for food decreased.'
      }, {
        title: 'Land Cover',
        text: 'Since land is a limited resource, the rising demand could hardly be met by increasing cropland and pastures. And with the exception of managed forests and urban areas, which both remain quite low in absolute numbers, land use changed only slightly.'
      }, {
        title: 'Yields',
        text: 'Instead productivity could be increased leading to bigger and bigger yields…'
      }, {
        title: 'Productivity',
        text: 'Instead productivity could be increased leading to bigger and bigger yields…'
      }, {
        title: 'Emissions',
        text: 'Which also meant increasing emissions especially in regards to N₂O.'
      }].map((s, i) => {
        const data = pressure.filter(d => d.group === i)
        return {
          ...s,
          data,
          color: i % 2 === 0 ? 'purple' : 'yellow',
          sources: [...new Set(data.map(d => d.source))].map(source => ({
            ref: source + 1,
            label: sources[source]
          }))
        }
      })
    }
  },
  methods: {
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

  .sources {
    color: $color-light-gray;
    grid-column: 2 / 3;
    @include max-width($narrow) {
      grid-column: 1 / 2;
    }
    span span {
      color: $color-deep-gray;
    }
  }
}
</style>
