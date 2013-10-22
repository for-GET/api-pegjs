_ = require 'lodash'
pegjs = require 'pegjs'
overrideAction = require 'pegjs-override-action'
corePEGjs = require 'core-pegjs'


exports._ = _


exports.buildParser = ({PEG, initializer, rules, startRules}) ->
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


exports.funToString = (fun) ->
  fun = fun.toString()
  bodyStarts = fun.indexOf('{') + 1
  bodyEnds = fun.lastIndexOf '}'
  fun.substring bodyStarts, bodyEnds


exports.zeroOrMore = () ->
  items = __result[0]?[1] or []
  items = items.map (item) -> item[2]?[1]
  head = __result[0]?[0]
  items.unshift head  if head
  {
    __type: __ruleName
    items
  }


exports.oneOrMore = () ->
  items = __result[2] or []
  items = items.map (item) -> item[2]?[1]
  head = __result[1]
  items.unshift head  if head
  {
    __type: __ruleName
    items
  }
