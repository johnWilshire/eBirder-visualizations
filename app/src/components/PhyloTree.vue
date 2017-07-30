<template lang="pug">
div
  tree(class="tree" 
    :data="treeData" 
    layoutType="radial"
    type="cluster"
    :duration="50"
    nodeText="name"
    :margin-x="0"
    :margin-y="0"
    v-on:clicked="clicked")
  .ui.raised.very.padded.container
    .ui.clearing.segment(v-bind:class="{ loading: loading }")
      a(v-bind:href="summaryLink" target="blank")
        h2.ui.center.aligned.header
          .content {{summaryName}}
          .sub.header {{summaryCommon}}
      .ui.divider
      .ui.large.left.rounded.floated.image(v-if="summaryUrl")
        img(:src="summaryUrl")
        .ui.bottom.attached.label {{summaryInfo.imageCaption}}
      // p {{ summaryInfo }}
      p {{ summaryText }}
  .ui.raised.segment
    .ui.header todo
    ul
      li color branches
      li layout
      li populate tree data with birding data
      li vis that data round the outside
      li mouse over events

</template>

<script>
import newick from 'tree/jetz_family_tree'
import {tree} from './vue-d3-tree'
import wiki from 'wikijs'
// <!-- Copyright 2011 Jason Davies https://github.com/jasondavies/newick.js -->
var parseNewick = (s) => {
  var ancestors = []
  var tree = {}
  var tokens = s.split(/\s*(;|\(|\)|,|:)\s*/)
  for (var i = 0; i < tokens.length; i++) {
    var token = tokens[i]
    switch (token) {
      case '(': // new children
        var subtree = {}
        tree.children = [subtree]
        ancestors.push(tree)
        tree = subtree
        break
      case ',': // another branch
        subtree = {}
        ancestors[ancestors.length - 1].children.push(subtree)
        tree = subtree
        break
      case ')': // optional name next
        tree = ancestors.pop()
        break
      case ':': // optional length next
        break
      default:
        var x = tokens[i - 1]
        if (x === ')' || x === '(' || x === ',') {
          token = token.replace(/_/g, ' ')
          tree.name = token.replace(/-.*/, '')
          tree.common = token.replace(/.*-/, '')
        } else if (x === ':') {
          tree.length = parseFloat(token)
        }
    }
  }
  return tree
}

export default {
  name: 'phylo-tree',
  data () {
    return {
      treeData: parseNewick(newick.newick),
      summaryName: 'Click a family!',
      summaryCommon: '',
      summaryText: '',
      summaryUrl: '',
      summaryLink: '',
      summaryInfo: '',
      loading: false
    }
  },
  methods: {
    clicked: function (x) {
      this.summaryName = x.data.name
      this.summaryLink = 'https://en.wikipedia.org/wiki/' + x.data.name
      this.summaryCommon = x.data.common
    },
    getSummary: function () {
      var vm = this
      var page = wiki({apiUrl: 'https://en.wikipedia.org/w/api.php'}).page(this.summaryName)
      page.then(page => page.mainImage())
        .then(function (img) {
          vm.summaryUrl = img
        })
      page.then(page => page.summary())
        .then(function (summary) {
          vm.summaryText = summary
          vm.loading = false
        })
      page.then(page => page.info())
        .then(function (x) {
          vm.summaryInfo = x
        })
    }
  },
  watch: {
    summaryName: function (newsummary) {
      this.summaryText = 'Waiting for Wikipedia.'
      this.loading = true
      this.summaryUrl = ''
      this.getSummary()
    }
  },
  components: {
    tree
  }
}
</script>

<style>
.tree {
  height: 1000px;
  max-height: 1000px;
  width: 100%;
  margin: 0 auto;
}
.treeclass .nodetree  circle {
  fill: #999;
  r: 2;
}

.treeclass .node--internal circle {
  cursor: pointer;
  fill:  #555;
  r: 2;
}

.treeclass .nodetree text {
  font: 10px sans-serif;
  cursor: pointer;
}
.treeclass .nodetree text:hover {
  font-weight: bold;
}

.treeclass .nodetree.selected text {
  font-weight: bold;
}

.treeclass .node--internal text {
  text-shadow: 0 1px 0 #fff, 0 -1px 0 #fff, 1px 0 0 #fff, -1px 0 0 #fff;
}

.treeclass .linktree {
  fill: none;
  stroke: #555;
  stroke-opacity: 0.4;
  stroke-width: 1.5px;
}

.hidden {
  display: none;
}
</style>
