<template>
  <div class="vis-net narrow" v-resize:debounce.initial="onResize" ref="visNet">
    <div class="key tiny last">
      <span class="highlight no-hover green">Emission removal</span><span v-html="`&nbsp;`"/>
      <span class="highlight no-hover yellow">energy</span><span v-html="`&nbsp;`"/>
      <span class="highlight no-hover purple">capital</span><span v-html="`&nbsp;`"/>
      <span class="highlight no-hover blue">water</span>
      and<span v-html="`&nbsp;`"/>
      <span class="highlight no-hover red">land</span>
      gained and needed by different negative emission technologies relative to BECCS. Light colors show the potential of a maximal, saturated colors of a realistic implementation. Adapted from <a href="https://doi.org/10.1111/gcb.13178">Smith, 2016</a>
    </div>
    <div class="charts">
      <ChartNet v-for="(n, i) in nets" :key="`n-${i}`"
        :data="n" :dimensions="dimensions" :width="width"
        :label="i === 0 || cols === 2 && i === 2" :explain="i === 1"/>
    </div>
  </div>
</template>
<script>
import Nets from 'dsv-loader!@/assets/data/land-net.csv' // eslint-disable-line import/no-webpack-loader-syntax
import ChartNet from '@/components/ChartNet.vue'
import resize from 'vue-resize-directive'
export default {
  name: 'vis-net',
  components: {
    ChartNet
  },
  directives: {
    resize
  },
  data () {
    const dimensions = [{
      color: 'green',
      key: 'removal'
    }, {
      color: 'yellow',
      key: 'energy'
    }, {
      color: 'purple',
      key: 'cost'
    }, {
      color: 'blue',
      key: 'water'
    }, {
      color: 'red',
      key: 'land'
    }]
    const nets = ['BECCS',
      'Afforestation & Reforestation',
      'Soil Carbon Storage',
      'Biochar Addition to Soil'
    ]
    const max = {}
    dimensions.forEach(c => {
      max[c.key] = Math.abs(Nets[0][c.key])
    })
    return {
      width: 320,
      columnSpacing: 16,
      cols: 2,
      nets: nets.map(name => {
        const realistic = Nets.find(n => n.name === name && n.cat === 'realistic')
        const maximum = Nets.find(n => n.name === name && n.cat === 'maximum')
        const obj = {
          name,
          realistic: {},
          maximum: maximum ? {} : null
        }
        dimensions.forEach(c => {
          obj.realistic[c.key] = realistic[c.key] / max[c.key]
          if (maximum != null) {
            obj.maximum[c.key] = maximum[c.key] / max[c.key]
          }
        })
        return obj
      }),
      dimensions
    }
  },
  computed: {
  },
  methods: {
    onResize (a, b, c) {
      const iw = this.$refs.visNet.getBoundingClientRect().width
      this.cols = iw < 480 ? 2 : 4
      this.width = (iw) / this.cols
    }
  }
}
</script>
<style lang="scss" scoped>
@import "library/src/style/global.scss";
.vis-net {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: $spacing 0 0 0;
  .charts {
    width: 100%;
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    align-items: flex-start;
  }
  .key {
    text-align: center;
    max-width: 460px;
    width: 100%;
  }
}
</style>
