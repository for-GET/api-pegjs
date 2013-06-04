pegjs = require 'pegjs'
overrideAction = require 'pegjs-override-action'
corePEGjs = require 'core-pegjs'

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
    if typeof alias is 'number'
      alias = rule
    else
      alias ?= rule
    parser[alias] = do () ->
      startRule = rule
      (input) ->
        parse input, {startRule}

  parser
