<template lang="pug">
.ui.basic.segment(v-bind:class="{ loading: loading }" v-if="selected")
  .ui.stackable.two.column.grid
    .column
      .ui.rounded.fluid.image(if="imgU")
        img(:src="imageUrl")
        .ui.bottom.attached.label {{ info ? (info.imageCaption ? info.imageCaption : 'No caption found.') : 'No caption found.' }}
    .column
      p(v-if="text") {{ text }}
      p(v-if="!text") No Wikipedia article found for 
        b {{selected}} &#x1F622
</template>

<script>
import wiki from 'wikijs'
var wikiApi = wiki({apiUrl: 'https://en.wikipedia.org/w/api.php'})
export default {
  name: 'wiki-summary',
  props: ['selected'],
  watch: {
    selected () {
      this.loading = true
    }
  },
  asyncComputed: {
    imageUrl () {
      var vm = this
      return wikiApi.page(this.selected).then(x => {
        return x.mainImage(x => {
          return x
        })
      })
      .catch(reason => {
        return wikiApi.page(this.selected)
          .then(page => page.images(x => {
            if (x.length === 1) {
              return x
            } else if (vm.info) {
              return x.filter(img => img.match(/vm.info.image/i))
            }
            return 'https://via.placeholder.com/400?text=No+Image+Found'
          }))
      })
    },
    info () {
      this.info = {}
      return wikiApi.page(this.selected).then(x => x.info())
    },
    text () {
      var vm = this
      return wikiApi.page(this.selected).then(x => {
        vm.loading = false
        return x.summary()
      }).catch(() => {
        vm.loading = false
        return ''
      })
    }
  }
}
</script>