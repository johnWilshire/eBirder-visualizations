<template lang="pug">
#app
  .ui.container
    h1.ui.center.aligned.header Some toy visualisations
    over-time
    family-table
</template>

<script>
import FamilyTable from './components/FamilyTable'
import OverTime from './components/OverTime'
export default {
  name: 'app',
  components: {
    FamilyTable,
    OverTime
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