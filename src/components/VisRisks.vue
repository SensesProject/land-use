<template>
  <div class="vis-net narrow" v-resize:debounce.initial="onResize" ref="visNet">
    <div class="key tiny">
      <svg width="12" height="12">
        <polyline points="0 12 6 0 12 12" class="violet"/>
      </svg>
      <span>Positive Effects</span>
      <svg width="12" height="12">
        <polyline points="0 0 6 12 12 0" class="violet"/>
      </svg>
      <span>Negative Effects</span>
    </div>
    <div class="key tiny last">
      <div>
        <svg width="12" height="12">
          <rect width="12" height="12" class="green"/>
        </svg>
        <span>Mitigation</span>
      </div>
      <div>
        <svg width="12" height="12">
          <rect width="12" height="12" class="red"/>
        </svg>
        <span>Adaptation</span>
      </div>
      <div>
        <svg width="12" height="12">
          <rect width="12" height="12" class="yellow"/>
        </svg>
        <span>Desertification</span>
      </div>
      <div>
        <svg width="12" height="12">
          <rect width="12" height="12" class="blue"/>
        </svg>
        <span>Land Degradation</span>
      </div>
      <div>
        <svg width="12" height="12">
          <rect width="12" height="12" class="violet"/>
        </svg>
        <span>Food Security</span>
      </div>
    </div>
    <div class="charts">
      <ChartNet v-for="(n, i) in risks" :key="`n-${i}`" :data="n" :width="width" :dimensions="dimensions"/>
    </div>
  </div>
</template>
<script>
import Risks from 'dsv-loader!@/assets/data/Risks.csv' // eslint-disable-line import/no-webpack-loader-syntax
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
    const cols = ['mitigation', 'adaptation', 'desertification', 'land degradation', 'food security']
    const max = {}
    cols.forEach(c => {
      max[c] = Math.max(...Risks.map(d => Math.abs(d[c])))
    })
    const risks = Risks.map(n => {
      const obj = {
        name: n.name
      }
      cols.forEach(c => {
        obj[c] = -n[c] / max[c]
      })
      return obj
    })
    return {
      width: 320,
      columnSpacing: 16,
      risks,
      dimensions: [{
        color: 'green',
        key: 'mitigation'
      }, {
        color: 'blue',
        key: 'adaptation'
      }, {
        color: 'yellow',
        key: 'desertification'
      }, {
        color: 'red',
        key: 'land degradation'
      }, {
        color: 'violet',
        key: 'food security'
      }]
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
