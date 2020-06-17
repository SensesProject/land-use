<template>
  <div class="intro">
    <!-- <section class="cover"> -->
      <VisLandCover class="background" :cover="cover"/>
      <div class="overlay">
        <section class="text-col wide">
          <h1 class="serif">Land Use</h1>
          <p>
            Today, most of the global ice-free land is used by humans in some way or another. Land use change and sustainable land management play an important role in climate change adaptation and mitigation. But they also have an impact on food security, desertification, land degradation.
          </p>
          <div class="key narrow">
            <span class="tiny key-title">
              <strong>Global ice-free land cover:</strong>
            </span>
            <span v-for="(c, i) in groups" :key="`ck-${i}`" class="tiny highlight" :class="[c.color]"
              @mouseover="group = c.label" @mouseleave="group = null" @mouseout="group = null">
              <!-- <span :style="{opacity: c.opacity}" :class="['glyph-dot', c.color]">{{c.value}}%</span> -->
              {{c.label}}
            </span>
          </div>
        </section>
      </div>
      <div class="tooltips">
        <VisLandCover :cover="cover" :group="group"/>
      </div>
      <div class="overlay bottom">
        <section class="text-col wide">
          <p>
            In this module we will show that the pressure on land has risen in recent decades. You will learn about the potentials of land use change to mitigate climate change as well as its limitations and potential trade-offs.
          </p>
        </section>
      </div>
  </div>
</template>
<script>
import VisLandCover from '@/components/VisLandCover.vue'
import cover from '@/assets/data/land-cover'
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
        // &.light {
        //   @include tint(color, 60);
        // }
        // &.dark {
        //   @include tint(color, 40);
        // }
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
      // @supports ((-webkit-backdrop-filter: saturate(180%) blur(20px)) or(backdrop-filter: saturate(180%) blur(20px))) {
      //   background: linear-gradient(to top, transparentize($color-white, 0.3), $color-white);
      //   -webkit-backdrop-filter: saturate(180%) blur(10px);
      //   backdrop-filter:saturate(180%) blur(10px)
      // }
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
