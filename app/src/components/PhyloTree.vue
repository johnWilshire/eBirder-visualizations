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
    :person="selected"
    v-on:clicked="clicked")

  .ui.raised.very.padded.container
    .ui.clearing.segment(v-bind:class="{ loading: loading }")
      a(v-bind:href="summary.link" target="blank")
        h2.ui.center.aligned.header
          .content {{summaryName}}
          .sub.header {{summary.common}}
      .ui.divider
      .ui.one.column.wide.grid
        .column
          table.ui.center.aligned.table
            thead
              tr
                th Total in Family
                th(v-on:click="recolor('corey')"
                  v-bind:class="[selected == 'corey' ? 'positive' : '']") Corey
                th(v-on:click="recolor('jim')"
                  v-bind:class="[selected == 'jim' ? 'positive' : '']") Jim
                th(v-on:click="recolor('will')"
                  v-bind:class="[selected == 'will' ? 'positive' : '']") Will
            tbody
              tr
                td {{ people.sp_count }}
                td {{ people.corey }}
                td {{ people.jim }}
                td {{ people.will }}
      .ui.divider
      h3.ui.center.aligned.header Summary
      .ui.two.column.wide.stackable.padded.grid
        .column
          .ui.large.left.rounded.floated.image(v-if="summaryImage")
            img(:src="summaryImage")
            .ui.bottom.attached.label {{summary.info.imageCaption}}
        .column
          p {{ summary.text }}

  attribution
</template>

<script>
import newick from 'tree/jetz_family_tree'
import {tree} from './vue-d3-tree'
import wiki from 'wikijs'
import attribution from './Attribution'
// think of a better name
var treeData = require('./parseNewick')
export default {
  name: 'phylo-tree',
  data () {
    return {
      treeData: treeData.parseNewick(newick.newick),
      summaryName: 'Click a family!',
      summary: {info: ''},
      summaryImage: '',

      selected: 'will',

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

      this.summaryName = x.data.name
      this.summaryImage = ''
      this.summary.link = 'https://en.wikipedia.org/wiki/' + x.data.name
      this.summary.common = x.data.common

      this.people.corey = x.data.corey
      this.people.will = x.data.will
      this.people.jim = x.data.jim
    },
    getSummary: function () {
      var vm = this
      var page = wiki({apiUrl: 'https://en.wikipedia.org/w/api.php'}).page(this.summaryName)
      page.then(page => page.mainImage())
        .then(function (img) {
          vm.summaryImage = img
        })
      page.then(page => page.summary())
        .then(function (summary) {
          vm.summary.text = summary
          vm.loading = false
        })
      page.then(page => page.info())
        .then(function (x) {
          vm.summary.info = x
        })
    },
    recolor: function (person) {
      this.selected = person
    }
  },
  watch: {
    summaryName: function (newsummary) {
      this.summary.text = 'Waiting for Wikipedia.'
      this.loading = true
      this.getSummary()
    }
  },
  components: {
    tree,
    attribution
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
