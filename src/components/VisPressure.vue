<template>
  <div class="vis-pressure narrow">
    <template v-for="(s, i) in sections">
      <div class="text" :key="`st-${i}`">
        <div class="sticky" v-html="s.html">
          <!-- <h3 :class="s.color">{{ s.title }}</h3>
          <p>{{ s.text }}</p> -->
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
      <span v-for="(source, i) in sourceUrls" :key="`source-${i}`">
        <strong>{{i + 1}}</strong>&nbsp;<component :is="source.url ? 'a':'span'" :href="source.url" target="_blank" v-html="`${source.model}`"/><span v-if="i !== sources.length - 1" v-html="`; `"/>
      </span>
    </p>
  </div>
</template>
<script>
import Pressure from 'dsv-loader!@/assets/data/landpressure.csv' // eslint-disable-line import/no-webpack-loader-syntax
import ChartLineFactor from '@/components/ChartLineFactor.vue'
import resize from 'vue-resize-directive'
import { mapGetters } from 'vuex'
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
    const sourceUrls = sources.map(s => Pressure.find(d => d.model === s))
    return {
      yScale: 64,
      sources,
      sourceUrls,
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
    ...mapGetters(['getText']),
    sections () {
      const { pressure, sources } = this
      return this.getText('pressure').filter((t, i) => i !== 0).map((s, i) => {
        const data = pressure.filter(d => d.group === i)
        return {
          html: s,
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
<style lang="scss">
@import "library/src/style/global.scss";
.vis-pressure {
  >:nth-child(4n+1) {
    h3 {
      color: $color-purple;
    }
  }
  >:nth-child(4n+3) {
    h3 {
      color: $color-yellow;
    }
  }
}
</style>
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
    a {
      color: $color-deep-gray;
      background: none;
      text-decoration: underline;
      &:hover {
        color: getColor(neon, 40);
      }
    }
  }
}
</style>
