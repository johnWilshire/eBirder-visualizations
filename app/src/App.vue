<template lang="pug">
#app
  h1 Family Birding
  phylo-tree
    // over-time
    // family-table
</template>

<script>
// import FamilyTable from './components/FamilyTable'
// import OverTime from './components/OverTime'
import PhyloTree from './components/PhyloTree'
export default {
  name: 'app',
  components: {
    // FamilyTable,
    // OverTime,
    PhyloTree
  }
}
</script>

<style>
h1 {
  text-align: center;
  padding-top: 1em;
}
</style>