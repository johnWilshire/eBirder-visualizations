<template lang="pug">
#app
  my-menu
  phylo-tree
    // over-time
    // family-table
</template>

<script>
// import FamilyTable from './components/FamilyTable'
// import OverTime from './components/OverTime'
import PhyloTree from './components/PhyloTree'
import MyMenu from './components/MyMenu'
export default {
  name: 'app',
  components: {
    // FamilyTable,
    // OverTime,
    PhyloTree,
    MyMenu
  }
}
</script>

<style>
@import './assets/introjs.css'
</style>
