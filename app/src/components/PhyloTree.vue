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
    :person="selectedPerson"
    v-on:clicked="clicked"
    :zoomable="false"
    ramp="interpolateYlGnBu")

  .ui.raised.container
    .ui.clearing.segment(v-bind:class="{ loading: loading }")
      my-header(v-bind:main="selectedLeaf", v-bind:sub="common")
      .ui.divider
      .ui.one.column.wide.grid
        .column
          table.ui.center.aligned.table
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
      wiki-summary(:selected="selectedLeaf")
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

      this.selectedLeaf = x.data.name
    },
    recolor: function (person) {
      this.selectedPerson = person
    }
  },
  watch: {
    summaryName: function (newsummary) {
      this.summary.text = 'Waiting for Wikipedia.'
      this.loading = true
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
  height: 900px;
  max-height: 1000px;
  width: 100%;
  margin: 0 auto;
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
