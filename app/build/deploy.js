var ghpages = require('gh-pages')


console.log("deploying")
ghpages.publish('dist', {
    repo: 'git@github.com:johnwilshire/personalised-tol.git'
}, () => { // todo error handling
    console.log('deployed')
})

