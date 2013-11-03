_ = require 'lodash'
pegjs = require 'pegjs'
overrideAction = require 'pegjs-override-action'


module.exports = {
  _


  createModule: ({PEG, initializer, rules, mixins}) ->
    mixins ?= []
    _.defaults rules, mixin.rules  for mixin in mixins
    mod = ({startRule, options}) ->
      options ?= {}
      _.assign options, {
        allowedStartRules: [startRule]
        plugins: [overrideAction]
        overrideActionPlugin: {
          initializer
          rules
        }
      }

      {parse} = pegjs.buildParser PEG, options

      (input) ->
        parse input, {startRule}

    mod._ = {
      PEG
      initializer
      rules
    }

    mod


  buildParser: ({PEG, initializer, rules, startRules}) ->
    defaultStartRules = startRules
    (args = {}) ->
      {startRules} = args
      startRules ?= defaultStartRules or []
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
          initializer
          rules
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