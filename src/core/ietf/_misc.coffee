_ = require 'lodash'
pegjs = require 'pegjs'
overrideAction = require 'pegjs-override-action'
corePEGjs = require 'core-pegjs'


exports._ = _


exports.buildParser = (PEG, rules, startRules = [], initializer) ->
  allowedStartRules = startRules
  alias = {}
  allowedStartRules = allowedStartRules.map (rule) ->
    alias[rule] = rule
    return rule  unless Array.isArray rule
    [rule, aliasName] = rule
    alias[rule] = aliasName
    rule
  options = {
    allowedStartRules
    plugins: [overrideAction]
    overrideActionPlugin: {
      rules
      initializer
    }
  }

  {parse} = pegjs.buildParser PEG, options

  parser = {}

  for rule, aliasName of alias
    parser[aliasName] = do () ->
      startRule = rule
      (input) ->
        parse input, {startRule}

  parser.allowedStartRules = allowedStartRules
  parser.rules = rules
  parser


exports.funToString = (fun) ->
  fun = fun.toString()
  bodyStarts = fun.indexOf('{') + 1
  bodyEnds = fun.lastIndexOf '}'
  fun.substring bodyStarts, bodyEnds


exports.zeroOrMore = (__type) ->
  fun = () ->
    value = __result[0]?[1] or []
    value = value.map (item) -> item[2]?[1]
    head = __result[0]?[0]
    value.unshift head  if head
    {
      __type: "{{__type}}"
      value
    }
  exports.funToString(fun).replace '{{__type}}', __type


exports.oneOrMore = (__type) ->
  fun = () ->
    value = __result[2] or []
    value = value.map (item) -> item[2]?[1]
    head = __result[1]
    value.unshift head  if head
    {
      __type: "{{__type}}"
      value
    }
  exports.funToString(fun).replace '{{__type}}', __type
