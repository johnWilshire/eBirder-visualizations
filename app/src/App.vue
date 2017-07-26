<template lang="pug">
#app
  .ui.container
    h1.ui.center.aligned.header Title
    tree
</template>

<script>
import Tree from './components/Tree'
require('../node_modules/semantic-ui-css/semantic.min.css')
export default {
  name: 'app',
  components: {
    Tree
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