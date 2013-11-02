_ = require 'lodash'
pegjs = require 'pegjs'
overrideAction = require 'pegjs-override-action'


module.exports = {
  _


  buildParser: ({PEG, initializer, rules, startRules}) ->
    startRules ?= []
    alias = {}
    startRules = startRules.map (rule) ->
      alias[rule] = rule
      return rule  unless Array.isArray rule
      [rule, aliasName] = rule
      alias[rule] = aliasName
      rule
    options = {
      allowedStartRules: startRules
      plugins: [overrideAction]
      overrideActionPlugin: {
        rules
        initializer
      }
    }

    {parse} = pegjs.buildParser PEG, options

    parser = {
      _: {
        PEG
        initializer
        rules
        startRules
      }
    }

    for rule, aliasName of alias
      parser[aliasName] = do () ->
        startRule = rule
        (input) ->
          parse input, {startRule}

    parser


  funToString: (fun) ->
    fun = fun.toString()
    bodyStarts = fun.indexOf('{') + 1
    bodyEnds = fun.lastIndexOf '}'
    fun.substring bodyStarts, bodyEnds
}