<template lang="pug">
.ui.basic.segment(v-bind:class="{ loading: loading }" v-if="selected")
  .ui.stackable.two.column.grid
    .column()
      .ui.rounded.fluid.image
        img(:src="imageUrl")
        .ui.bottom.attached.label(v-if="info") {{ info ? info.imageCaption : 'No caption found.'}}
    .column
      p {{ text }}
</template>

<script>
import wiki from 'wikijs'
var wikiApi = wiki({apiUrl: 'https://en.wikipedia.org/w/api.php'})
export default {
  name: 'wiki-summary',
  props: ['selected'],
  data () {
    return {
      loading: true
    }
  },
  asyncComputed: {
    imageUrl () {
      this.imageUrl = ''
      var vm = this
      return wikiApi.page(this.selected).then(x => {
        vm.loading = false
        return x.mainImage()
      })
    },
    info () {
      this.info = {}
      return wikiApi.page(this.selected).then(x => x.info())
    },
    text () {
      var vm = this
      this.text = 'Waiting for Wikipedia...'
      return wikiApi.page(this.selected).then(x => {
        vm.loading = false
        return x.summary()
      })
    }
  }
}
</script>