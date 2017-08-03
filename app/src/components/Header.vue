
<template lang="pug">
#my-header
  a(v-bind:href="link" target="blank")
    h2.ui.center.aligned.header {{main}}
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