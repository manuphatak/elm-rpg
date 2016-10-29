require('ace-css/css/ace.css');
require('font-awesome/css/font-awesome.css')

require('./index.html')

const Elm = require('./Main.elm');

const node = document.getElementById('main')

const app = Elm.Main.embed(node)
