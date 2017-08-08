<template lang="pug">
div
  .ui.secondary.menu
    .ui.container
      .right.menu
        .item
          .ui.primary.button(v-on:click="tutorial") Tutorial
        .item
          .ui.basic.button About
  .ui.container(data-intro="Welcome to family birding")
    h1#masthead Family Birding
</template>

<script>
export default {
  name: 'my-menu',
  methods: {
    tutorial () {
      window.introJS().start()
    }
  }
}
</script>

<style scoped>
#masthead {
  text-align: center;
  font-weight: 200;
  letter-spacing: 3px;
  text-transform: lowercase;
}
.container {
  padding: 1em 0;
}
</style>