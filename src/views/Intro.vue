<template>
  <div class="intro">
    <VisLandCover class="background" :cover="cover"/>
    <div class="overlay">
      <section class="text-col wide">
        <div v-html="getText('intro')[0]"/>
        <div class="key narrow">
          <span class="tiny key-title">
            <strong>Global ice-free land cover:</strong>
          </span>
          <span v-for="(c, i) in groups" :key="`ck-${i}`" class="tiny highlight" :class="[c.color]"
            @mouseover="group = c.label" @mouseleave="group = null" @mouseout="group = null">
            {{c.label}}
          </span>
        </div>
      </section>
    </div>
    <div class="tooltips">
      <VisLandCover :cover="cover" :group="group"/>
    </div>
    <div class="overlay bottom">
      <section class="text-col wide" v-html="getText('intro')[1]"/>
    </div>
  </div>
</template>
<script>
import VisLandCover from '@/components/VisLandCover.vue'
import cover from '@/assets/data/land-cover'
import { mapGetters } from 'vuex'
export default {
  name: 'intro',
  components: { VisLandCover },
  data () {
    return {
      cover,
      group: null,
      groups: [{
        label: 'Infrastructure',
        color: 'red'
      }, {
        label: 'Cropland',
        color: 'yellow'
      }, {
        label: 'Grazing land',
        color: 'green'
      }, {
        label: 'Used forests',
        color: 'blue'
      }, {
        label: 'Unused land',
        color: 'purple'
      }]
    }
  },
  computed: {
    ...mapGetters(['getText'])
  }
}
</script>
<style lang="scss" scoped>
@import "library/src/style/global.scss";
.intro {
  position: relative;

  .key {
    margin-top: $spacing * 0.75;
    width: 100vw;
    max-width: 1200px;
    align-self: center;
    padding: 0 $spacing / 2;
    text-align: center;

    > span {
      margin: 0 $spacing / 8;
      display: inline-block;

      &.key-title {
        @include max-width($narrow) {
          display: block;
        }
      }

      .glyph-dot {
        font-weight: $font-weight-bold;
        &:before {
          content: '●';
          font-family: $font-sans;
          margin: 0;
        }
        @include tint(color);
      }
    }
  }

  .background {
    z-index: -1;
  }
  .overlay {
    width: 100vw;
    display: flex;
    flex-direction: column;
    align-items: center;
    padding-bottom: $spacing / 2;
    background: linear-gradient(to top, transparentize($color-white, 0.3), $color-white);
    @supports ((-webkit-backdrop-filter: saturate(180%) blur(20px)) or(backdrop-filter: saturate(180%) blur(20px))) {
      background: linear-gradient(to top, transparentize($color-white, 0.3), $color-white);
      -webkit-backdrop-filter: saturate(180%) blur(10px);
      backdrop-filter:saturate(180%) blur(10px)
    }

    &.bottom {
      background: linear-gradient(transparentize($color-white, 0.3), $color-white);
    }
  }

  .tooltips {
    height: 40vh;
    position: relative;
  }

  .text-col {
    display: flex;
    flex-direction: column;

    h1 {
      margin-bottom: $spacing / 2;
    }
  }
}
</style>
