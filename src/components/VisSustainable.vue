<template>
  <div class="vis-pressure narrow">
    <div class="key tiny">
      <span class="highlight no-hover neon">Default Policy</span>
      <span class="highlight no-hover green">Sustainable Policy Set</span>
    </div>
    <template v-for="(g, i) in groups">
      <div class="text" :key="`g-${i}`">
        <div class="sticky">
          <h3>{{ g.title }}</h3>
          <p>{{ g.text }}</p>
        </div>
      </div>
      <div class="chart-group" :key="`gc-${i}`">
        <ChartLine class="chart" v-for="(c, i2) in g.charts" :key="`gc-${i}-${i2}`"
          v-bind="c"/>
      </div>
    </template>
    <!-- <p class="tiny sources">
      <strong>Sources: </strong>
      <span v-for="(source, i) in sources" :key="`source-${i}`">
        <strong>{{i + 1}}</strong><span v-html="`&nbsp;${source || '?'}`"/><span v-if="i !== sources.length - 1" v-html="`; `"/>
      </span>
    </p> -->
  </div>
</template>
<script>
import Sustainable from 'dsv-loader!@/assets/data/sustainable.csv' // eslint-disable-line import/no-webpack-loader-syntax
import ChartLine from '@/components/ChartLine.vue'
import resize from 'vue-resize-directive'
export default {
  name: 'vis-sustainable',
  components: {
    ChartLine
  },
  directives: {
    resize
  },
  data () {
    const years = [2005, 2010, 2015, 2020, 2025, 2030, 2035, 2040, 2045, 2050, 2055, 2060, 2070, 2080, 2090, 2100]
    // const vars = [...new Set(Sustainable.map(s => s.variable))]
    const text = [{
      title: 'Land based mitigation / Supply side mitigation CO2',
      text: ''
    }, {
      title: 'Demand side mitigation non-CO2',
      text: ''
    }, {
      title: 'Emissions',
      text: ''
    }, {
      title: 'Indices',
      text: ''
    }]
    return {
      yScale: 64,
      groups: text.map((t, g) => {
        const group = Sustainable.filter(d => +d.group === g)
        const vars = [...new Set(group.map(s => s.name))]
        return {
          ...t,
          charts: vars.map(v => {
            const scenarios = group.filter(d => d.name === v)
            const s0 = scenarios[0]
            const domain = s0.min !== '' && s0.max !== '' ? [+s0.max, +s0.min] : null
            return {
              label: s0.name,
              unit: s0.unit,
              domain,
              nice: v === 'Water Consumption for Irrigation' ? false : 3,
              ticks: v === 'Water Consumption for Irrigation' ? [5000, 2500, 0] : null,
              years,
              scenarios: scenarios.map(s => {
                return {
                  color: s.scenario === 'default' ? 'neon' : 'green',
                  scenario: s.scenario,
                  series: years.map(year => ({ year, value: s[year] }))
                }
              })
            }
          })
        }
      })
    }
  },
  computed: {
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
  margin-top: -$spacing;
  display: grid;
  grid-template-columns: 1fr 2fr;
  gap: $spacing $spacing / 2;
  @include max-width($narrow) {
    grid-template-columns: 1fr;
    gap: $spacing / 2;
    margin-top: -$spacing / 2;
  }

  @include min-width($narrow) {
    >:nth-child(2), >:nth-child(3) {
      margin-top: -$spacing * 2;
    }
  }
  @include max-width($narrow) {
    >:nth-child(3) {
      margin-top: -$spacing * 2;
    }
  }

  .key {
    position: sticky;
    // margin-top: - $spacing / 2;
    top: calc(100vh - #{$spacing});
    display: flex;
    justify-content: flex-end;
    align-items: flex-start;
    grid-column: 2 / 3;
    z-index: 10;
    // margin-bottom: -$spacing * 2;
    margin-top: $spacing * 1;
    // padding: $spacing / 4 0;
    height: $spacing;
    :first-child {
      margin-right: $spacing / 4;
    }
    @include max-width($narrow) {
      grid-column: 1 / 2;
      grid-row: 2 / 2;
      margin-top: $spacing * 0.5;
    }
    // background: $color-white;
    // @supports ((-webkit-backdrop-filter: saturate(180%) blur(20px)) or(backdrop-filter: saturate(180%) blur(20px))) {
    //   background: transparentize($color-white, 0.25);
    //   -webkit-backdrop-filter: saturate(180%) blur(10px);
    //   backdrop-filter:saturate(180%) blur(10px);
    //   width: calc(100% + 2rem);
    //   margin-left: -1rem;
    //   padding-right: 1rem;
    // }
  }
  // display: flex;
  // flex-wrap: wrap;
  // align-items: flex-start;
  // justify-content: center;

  .chart-group {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: $spacing / 2;
      align-items: end;

      &:last-child {
        margin-bottom: $spacing;
      }
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
      // color: $color-neon;
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