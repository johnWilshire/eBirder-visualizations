<template lang="pug">
#tree
  table.ui.celled.center.aligned.padded.table
    thead
      th Order
      th Family
      th Species Name
      th Number of species in this Family

    tr(v-for="f in fam")
      td {{f.Order}}
      td {{f.Family}}
      td {{f.gs}}
      td {{f.sp_count}}
</template>

<script>
var fam = require('./../../../taxonomy/eBird_clements_checklist_family.json')
export default {
  name: 'tree',
  data: () => {
    return {
      fam: fam
    }
  }
}
</script>