<template lang="pug">
.ui.grid(v-if="selected")
  .two.column.row
    .wide.column(v-if="imageUrl")
      .ui.fluid.rounded.image
        img(:src="imageUrl")
        .ui.bottom.attached.label {{ caption ? caption : 'No caption found.'}}
    .wide.column
      p {{ text }}
</template>

<script>
import wiki from 'wikijs'
var wikiApi = wiki({apiUrl: 'https://en.wikipedia.org/w/api.php'})
export default {
  name: 'wiki-summary',
  props: ['selected'],
  computed: {
    caption () {
      return this.info.imageCaption ? this.info.imageCaption : ''
    }
  },
  asyncComputed: {
    imageUrl: async function () {
      return await wikiApi.page(this.selected).then(x => x.mainImage())
    },
    info () {
      return wikiApi.page(this.selected).then(x => x.info())
    },
    text: {
      get () {
        return wikiApi.page(this.selected).then(x => x.summary())
      },
      default () {
        return 'Loading summary for ' + this.selected
      }
    }
  }
}
</script>

<style>
#img {
  margin: 0 auto !important;
}
</style>