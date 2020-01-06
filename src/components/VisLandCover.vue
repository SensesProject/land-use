<template>
  <div class="areas">
    <div
      v-for="(c, i) in cover"
      :key="`c-${i}`"
      :style="{width: `${c.value}vw`, opacity: c.opacity}"
      :class="['area', c.color]"
    />
  </div>
</template>
<script>
export default {
  name: 'intro',
  props: {
    cover: {
      type: Array,
      default () { return [] }
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
  z-index: -1;

  .area {
    height: 100%;
    position: relative;
    @include tint(background, 50);
  }
}
</style>
