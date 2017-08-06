<template lang="pug">
.ui.stackable.two.column.grid(v-if="selected")
    .column(v-if="imageUrl")
      .ui.rounded.fluid.image
        img(:src="imageUrl")
        .ui.bottom.attached.label {{ info ? info.imageCaption : 'No caption found.'}}
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
      return wikiApi.page(this.selected).then(x => x.mainImage())
    },
    info () {
      return wikiApi.page(this.selected).then(x => x.info())
    },
    text () {
      return wikiApi.page(this.selected).then(x => x.summary())
    }
  }
}
</script>