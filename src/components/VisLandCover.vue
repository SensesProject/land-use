<template>
  <div class="areas">
    <div
      v-for="(c, i) in cover" :key="`c-${i}`"
      :style="{width: `${c.value}vw`, opacity: c.opacity}"
      :class="['area', c.color]"
      @mouseover="highlight = c.group" @mouseleave="highlight = null" @mouseout="highlight = null">
      <v-popover offset="0" :popoverClass="['senses-tooltip', 'senses-tooltip-custom']" class="trigger" placement="right"
        :open="group === c.group || highlight === c.group ? true : null"
        :style="{transform: `translateY(${-20 + c.offset}px)`}">
        <div slot="popover" class="tiny">
          <span :class="['glyph-dot', c.color]" :style="{opacity: c.opacity}"></span>
          <span>{{ c.value }}%</span> <strong>{{ c.name }}</strong>
        </div>
      </v-popover>
    </div>
  </div>
</template>
<script>
import { VPopover } from 'v-tooltip'
export default {
  name: 'vis-land-cover',
  components: { VPopover },
  props: {
    cover: {
      type: Array,
      default () { return [] }
    },
    group: {
      type: String,
      default: null
    }
  },
  data () {
    return {
      highlight: null
    }
  }
}
</script>
<style lang="scss" scoped>
@import "library/src/style/global.scss";
.areas {
  width: 100%;
  height: 100%;

  position: absolute;
  display: flex;
  background: $color-white;

  .area {
    height: 100%;
    position: relative;
    @include tint(background, 50);
    display: flex;
    align-items: center;
    justify-content: center;
  }
}
</style>
<style lang="scss">
@import "library/src/style/global.scss";
.senses-tooltip.senses-tooltip-custom {

  pointer-events: none;

  .glyph-dot {
    font-weight: $font-weight-bold;
    &:before {
      transform: scale(2) translate(-2px, -0.5px);
      content: '●';
      font-family: $font-sans;
      margin: 0 0 0 0;
    }
    @include tint(color);
  }

  .tooltip-inner {
    background: $color-white;
    color: $color-black;
    padding: $spacing / 8 $spacing / 4;
    min-width: auto;
    min-height: auto;
    display: flex;
    justify-content: center;
    align-items: center;
    max-width: 600px;
  }

  .tooltip-arrow {
    border-color: $color-white;
  }
}
</style>
