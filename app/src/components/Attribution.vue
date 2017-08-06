<template lang="pug">
.ui.one.column.wide.center.aligned.page.padded.grid
  .column
      .ui.divider
      p Text and Images: 
        a(href="https://en.wikipedia.org/wiki/Main_Page") Wikipedia 
      p Tree Data: 
        a(href="http://birdtree.org/") BirdTree
      p Inspired by: 
        a(href="https://bl.ocks.org/mbostock/c034d66572fd6bd6815a") Tree of Life
      .ui.divider
</template>
<script>
export default {
  name: 'attribution'
}
</script>

<style>
.sources {
  text-align: center;
}
</style>