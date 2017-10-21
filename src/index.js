const Elm = require('./Main.elm')
const mountNode = document.getElementById('root')

const app = Elm.Main.embed(mountNode)
