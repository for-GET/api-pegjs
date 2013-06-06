_ = require 'lodash'
pegjs = require 'pegjs'
overrideAction = require 'pegjs-override-action'
corePEGjs = require 'core-pegjs'


exports._ = _


exports.buildParser = (PEG, rules, startRules = []) ->
  allowedStartRules = startRules
  allowedStartRules = Object.keys startRules  unless Array.isArray startRules
  options = {
    allowedStartRules
    plugins: [overrideAction]
    overrideActionPlugin: {
      rules
    }
  }

  {parse} = pegjs.buildParser PEG, options

  parser = {}

  for rule, alias of startRules
    rule = alias  if Array.isArray startRules
    alias ?= rule
    parser[alias] = do () ->
      startRule = rule
      (input) ->
        parse input, {startRule}

  parser


exports.funToString = (fun) ->
  fun = fun.toString()
  bodyStarts = fun.indexOf('{') + 1
  bodyEnds = fun.lastIndexOf '}'
  fun.substring bodyStarts, bodyEnds
