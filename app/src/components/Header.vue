
<template lang="pug">
h2.ui.center.aligned.header
  a(v-bind:href="link" target="blank") {{main}}
  .sub.header {{sub}}
</template>

<script>
export default {
  name: 'my-header',
  props: ['main', 'sub'],
  computed: {
    link: function () {
      return 'https://en.wikipedia.org/wiki/' + this.main
    }
  }
}
</script>

<style scoped>
a {
  margin: 1em;
}
</style>