
import fam from 'taxonomy/eBird_clements_checklist_family'

var seen = fam.reduce((res, x) => {
  res[x.fam] = x
  return res
}, {})

import will from 'data/eBird_json/will'
import jim from 'data/eBird_json/jim'
import corey from 'data/eBird_json/corey'
function assign (li, name) {
  li.forEach(x => {
    seen[x.Family][name] = x.seen_count
  })
}
assign(will, 'will')
assign(jim, 'jim')
assign(corey, 'corey')

// <!-- A modified version of  https://github.com/jasondavies/newick.js -->
function parseNewick (s) {
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
          var name = token.replace(/ -.*/, '')
          if (name.match(/ ott[0-9]+$/)) {
            tree.ott = name.match(/ ott([0-9]+)$/)[2]
            name = name.replace(/ ott[0-9]+$/, '')
          }
          tree.name = name
          if (seen[name]) {
            tree.sp_count = seen[name].sp_count
            tree.will = seen[name].will ? seen[name].will : 0
            tree.jim = seen[name].jim ? seen[name].jim : 0
            tree.corey = seen[name].corey ? seen[name].corey : 0
          }

          tree.common = token.replace(/.*?-/, '')
        } else if (x === ':') {
          tree.length = parseFloat(token)
        }
    }
  }
  return tree
}
export {
  parseNewick,
  seen
}
