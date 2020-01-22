<template>
  <div class="vis-net narrow" v-resize:debounce.initial="onResize" ref="visNet">
    <div class="key tiny">
      <svg width="12" height="12">
        <polyline points="0 12 6 0 12 12" class="violet"/>
      </svg>
      <span>Gains</span>
      <svg width="12" height="12">
        <polyline points="0 0 6 12 12 0" class="violet"/>
      </svg>
      <span>Requierements</span>
    </div>
    <div class="key tiny last">
      <div>
        <svg width="12" height="12">
          <rect width="12" height="12" class="green"/>
        </svg>
        <span>Emission Removal</span>
      </div>
      <div>
        <svg width="12" height="12">
          <rect width="12" height="12" class="red"/>
        </svg>
        <span>Land</span>
      </div>
      <div>
        <svg width="12" height="12">
          <rect width="12" height="12" class="yellow"/>
        </svg>
        <span>Energy</span>
      </div>
      <div>
        <svg width="12" height="12">
          <rect width="12" height="12" class="blue"/>
        </svg>
        <span>Water</span>
      </div>
      <div>
        <svg width="12" height="12">
          <rect width="12" height="12" class="violet"/>
        </svg>
        <span>Costs</span>
      </div>
    </div>
    <div class="charts">
      <ChartNet v-for="(n, i) in nets" :key="`n-${i}`" :data="n" :width="width"/>
    </div>
  </div>
</template>
<script>
import Nets from 'dsv-loader!@/assets/data/NegativeEmissionTechnoligies.csv' // eslint-disable-line import/no-webpack-loader-syntax
import ChartNet from '@/components/ChartNet.vue'
import resize from 'vue-resize-directive'
export default {
  name: 'VisPressure',
  components: {
    ChartNet
  },
  directives: {
    resize
  },
  data () {
    const cols = ['removal', 'land', 'water', 'energy', 'cost']
    const max = {}
    cols.forEach(c => {
      max[c] = Math.max(...Nets.map(d => Math.abs(d[c])))
    })
    const nets = Nets.map(n => {
      const obj = {
        name: n.name
      }
      cols.forEach(c => {
        obj[c] = n[c] / max[c]
      })
      return obj
    })
    return {
      width: 320,
      columnSpacing: 16,
      nets
    }
  },
  computed: {
  },
  methods: {
    onResize (a, b, c) {
      const { columnSpacing } = this
      const iw = this.$refs.visNet.getBoundingClientRect().width
      const cols = iw < 480 ? 2 : 4
      this.width = (iw - columnSpacing) / cols - columnSpacing // * 3
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
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    justify-content: center;

    &.last {
      padding-top: $spacing / 8;
    }

    div {
      display: flex;
      align-items: center;
      justify-content: center;
    }
    span {
      margin-right: $spacing / 4;

      &.before-line-key {
        margin-right: $spacing / 2;
      }
    }
    svg {
      margin-right: $spacing / 8;
      rect {
        @include tint(fill);
      }
    }
    .line-key {
      white-space: nowrap;
      display: flex;
      align-items: center;
    }
  }
}
</style>
