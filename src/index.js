// pull in desired CSS/SASS files
require('ace-css/css/ace.css')
require('font-awesome/css/font-awesome.css' )

const html = require('./public/index.html')
// console.log("html", html)
// inject bundled Elm app into div#main
var Elm = require( './Main' )
Elm.Main.embed( document.getElementById( 'main' ) )
