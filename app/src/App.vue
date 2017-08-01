<template lang="pug">
#app
  .ui.container
    h1.ui.center.aligned.header eBirder Tree Vis
    phylo-tree
    // over-time
    // family-table
</template>

<script>
import FamilyTable from './components/FamilyTable'
// import OverTime from './components/OverTime'
import PhyloTree from './components/PhyloTree'
export default {
  name: 'app',
  components: {
    FamilyTable,
    // OverTime,
    PhyloTree
  }
}
</script>

<style>
h1 {
  text-align: center;  
}

#app{
  margin: 2em;
}
</style>