<template lang="pug">
div
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
    ramp="interpolateYlGnBu"
    data-step="2"
    data-intro="This is a phylogeny of all veges.\n You can click on the names to learn more about them! Try it!"
    )

  .ui.raised.container.segment
    my-header(v-if="selectedLeaf"
              v-bind:main="selectedLeaf ? selectedLeaf : ''", 
              v-bind:sub="common")
    .ui.horizontal.divider Which Tree:
    .ui.center.aligned.basic.segment(data-step="3" data-intro="You can also change the tree!")
      .ui.radio.checkbox
        input(type='radio' v-model="selectedTree" value="bird")
        label Birds
      .ui.radio.checkbox
        input(type='radio' v-model="selectedTree"  value="vege" checked='checked')
        label Vegetables
      .ui.radio.checkbox
        input(type='radio' v-model="selectedTree"  value="life")
        label Life
      .ui.radio.checkbox
        input(type='radio' v-model="selectedTree"  value="carnivora")
        label Carnivora
    .ui.divider(v-if="selectedTree === 'bird'")
    table.ui.center.aligned.single.line.table(v-if="selectedTree === 'bird'")
      thead
        tr
          th Total in Family
          th(v-on:click="recolor('corey')"
            v-bind:class="[selectedPerson == 'corey' ? 'positive' : '']"
            data-step="4") Corey 
            //data-intro="You can color the tips by the proportion of bird species seen in that family!"
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
    .ui.horizontal.divider(v-if="selectedLeaf")#summary Summary
    wiki-summary(:selected="selectedLeaf")
  attribution
</template>

<script>
// Components
import {tree} from './vue-d3-tree'
import WikiSummary from './WikiSummary'
import attribution from './Attribution'
import myHeader from './Header'
// Tree data
import rawTrees from 'tree/trees'
// think of a better name
var parseNewick = require('./parseNewick')

var trees = {}
Object.keys(rawTrees).forEach(x => {
  trees[x] = parseNewick.parseNewick(rawTrees[x])
})

export default {
  name: 'phylo-tree',
  data () {
    return {
      treeData: trees.vege,
      selectedPerson: 'will',
      selectedLeaf: '',
      people: {
        sp_count: 0,
        corey: 0,
        jim: 0,
        will: 0
      },
      selectedTree: 'vege',
      seen: parseNewick.seen
    }
  },
  methods: {
    clicked: function (x) {
      var d = this.seen[x.data.name]
      if (d) {
        this.people.sp_count = this.seen[x.data.name].sp_count
        this.people.corey = x.data.corey
        this.people.will = x.data.will
        this.people.jim = x.data.jim
      }

      this.$scrollTo('#summary')

      this.selectedLeaf = x.data.name
    },
    recolor: function (person) {
      this.selectedPerson = person
    },
    notNullColor (d) {
      return x => '#F00'
      // d3.scaleOrdinal()
         //  .domain(['Bacteria', 'Eukaryota', 'Archaea'])
         //  .range(d3.schemeCategory10)
    }
  },
  watch: {
    selectedTree (newValue) {
      this.selectedLeaf = ''
      this.treeData = trees[newValue]
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
label {
  padding-right: 1em;
}
.tree {
  margin: 0 auto;
  height: 950px;
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

.link-active {
  opacity: 1;
  stroke: #000;
  stroke-width: 3px !important;
}
.treeclass .nodetree text {
  font: 10px sans-serif;
  cursor: pointer;
}
.treeclass .nodetree text:hover {
  font-weight: bold;
  background-color: #FFF;
  display: block;
}

.treeclass .nodetree.selected text {
  font-weight: bold;
  font-size: 1em;
}

.treeclass .linktree {
  fill: none;
  stroke-opacity: 0.6;
  stroke-width: 1.5px;
}

th {
  cursor: pointer !important;
}

.positive {
  color: #acdfb7 !important;
}
</style>
