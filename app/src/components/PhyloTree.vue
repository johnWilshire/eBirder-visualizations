<template lang="pug">
div
  // iframe
  tree.tree(
    :data="treeData" 
    layoutType="radial"
    type="cluster"
    :duration="50"
    nodeText="name"
    :margin-x="0"
    :margin-y="0"
    :person="selectedPerson"
    v-on:clicked="clicked"
    ramp="interpolateYlGnBu")

  .ui.raised.container.segment(v-bind:class="{ loading: loading }")
    my-header(v-bind:main="selectedLeaf ? selectedLeaf : 'Select a family to begin'", v-bind:sub="common")
    .ui.divider
    .ui.one.column.wide.grid
      .column
        table.ui.center.aligned.single.line.table
          thead
            tr
              th Total in Family
              th(v-on:click="recolor('corey')"
                v-bind:class="[selectedPerson == 'corey' ? 'positive' : '']") Corey
              th(v-on:click="recolor('jim')"
                v-bind:class="[selectedPerson == 'jim' ? 'positive' : '']") Jim
              th(v-on:click="recolor('will')"
                v-bind:class="[selectedPerson == 'will' ? 'positive' : '']") Will
          tbody
            tr
              td {{ people.sp_count }}
              td {{ people.corey }}
              td {{ people.jim }}
              td {{ people.will }}
    .ui.divider
    wiki-summary#summary(:selected="selectedLeaf")
  attribution
</template>

<script>
import newick from 'tree/jetz_family_tree'
import {tree} from './vue-d3-tree'
import WikiSummary from './WikiSummary'
import attribution from './Attribution'
import myHeader from './Header'
// think of a better name
var treeData = require('./parseNewick')
export default {
  name: 'phylo-tree',
  data () {
    return {
      treeData: treeData.parseNewick(newick.newick),
      selectedPerson: 'will',
      selectedLeaf: '',
      people: {
        sp_count: 0,
        corey: 0,
        jim: 0,
        will: 0
      },
      seen: treeData.seen,
      loading: false
    }
  },
  methods: {
    clicked: function (x) {
      this.people.sp_count = this.seen[x.data.name].sp_count

      this.people.corey = x.data.corey
      this.people.will = x.data.will
      this.people.jim = x.data.jim
      this.$scrollTo('#summary')

      this.selectedLeaf = x.data.name
    },
    recolor: function (person) {
      this.selectedPerson = person
    }
  },
  computed: {
    common () {
      var d = this.seen[this.selectedLeaf]
      if (d) {
        var c = d.Family.match(/\((.*)\)/)[1]
        return 'Order: ' + d.Order + ', Common: ' + c
      }
      return ''
    }
  },
  components: {
    tree,
    attribution,
    WikiSummary,
    myHeader
  }
}
</script>

<style>
.tree {
  margin: 0 auto;
  height: 900px;
  width: 1000px;
}

@media (max-width: 600px) {
  .tree {
    height: 400px;
    width: 400px;
  }
}
.treeclass .nodetree  circle {
  r: 3;
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

th {
  cursor: pointer !important;
}

.positive {
  color: #acdfb7 !important;
}
</style>
