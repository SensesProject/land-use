<template>
  <div class="vis-pressure" v-resize:debounce.initial="onResize">
    <div v-masonry="'vis-pressure'" item-selector=".chart"
      transition-duration="0s">
      <!-- <masonry :cols="{default: 6, 1400: 4, 1280: 3, 960: 2, 640: 2}" :gutter="16">

      </masonry> -->
      <template v-for="(d, i) in masonry">
        <ChartLineFactor v-if="d.type === 'data'" v-masonry-tile class="chart"
           :key="`clf-${i}`"
          :data="d.series" :label="d.label" :width="width" :y-scale="yScale" :id="i"/>
        <div v-else v-masonry-tile class="chart narrow invert pressure-text"
          :key="`clf-${i}`"
          :style="{width: `${width * 1 + columnSpacing * 0}px`, margin: `${columnSpacing / 2}px`}">
          <h3>{{ d.title }}</h3>
          <p>{{ d.text }}</p>
        </div>
      </template>
        <!-- alt attributes: show-zero :x-domain="[1960, 2017]" -->
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
          label: d.variable,
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
      masonry.splice(9, 0, {
        type: 'text',
        title: 'Rising Living Standards',
        text: 'Nihil voluptas ipsum rerum ea voluptate. Eos sed occaecati amet. Odit qui ratione possimus minus necessitatibus magnam odio. Perferendis qui molestias saepe nemo natus. Sunt animi eveniet eligendi omnis reprehenderit aliquam fuga.'
      })
      masonry.splice(27, 0, {
        type: 'text',
        title: 'Rising Demand',
        text: 'Eos possimus doloremque qui. Et et tempore ad dolores neque. Odit pariatur qui voluptatem aut magnam. Culpa blanditiis eum sit sequi iusto. Occaecati ut enim et occaecati odio.'
      })
      masonry.splice(52, 0, {
        type: 'text',
        title: 'Limited Resources',
        text: 'Et atque eius et facilis. Aut repellendus inventore delectus repudiandae laboriosam. Et esse quam laborum officia. Facere quaerat praesentium id est commodi voluptas ea. Quia quasi architecto ut.'
      })
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
  width: 100vw;
  max-width: 1600px;
  align-self: center;
  padding: 0 $spacing / 4;
  // display: flex;
  // flex-wrap: wrap;
  // align-items: flex-start;
  // justify-content: center;

  .pressure-text {
    background: $color-neon;
    padding: $spacing / 4;
  }
}
</style>
