_ = require 'lodash'
core = require './core'

module.exports = {
  _
  core

  funToString: (fun) ->
    fun = fun.toString()
    bodyStarts = fun.indexOf('{') + 1
    bodyEnds = fun.lastIndexOf '}'
    fun = fun.substring bodyStarts, bodyEnds
    "(function() {#{fun}})();"
}