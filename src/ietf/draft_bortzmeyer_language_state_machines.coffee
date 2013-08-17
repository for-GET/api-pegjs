{
  _
  buildParser
} = require './misc'
PEG = require('core-pegjs')['ietf/draft_bortzmeyer_language_state_machines']


allowedStartRules = [
  'state_machine'
]


rules =
  state_machine: () ->
    {
      __type: 'state_machine'
      statements: __result[0]
    }

  statement: [
    () ->
      "" # ignore comments
    () ->
      __result[0]
  ]

  declaration: () ->
    {
      __type: 'declaration'
      names: __result[0]
      value: __result[2]
    }

  assignment: () ->
    {
      __type: 'assignment'
      name: __result[0]
      value: __result[2]
    }

  names: () ->
    names = [__result[0]]
    names.push item[1]  for item in __result[1]
    names

  name: [
    () -> __result[1]
    () -> __result[0]
  ]

  transition: () ->
    {
      __type: 'transition'
      states: __result[0]
      messages: __result[2]
      next_state: __result[4]
      action: __result[5]?[1]
    }


module.exports = buildParser PEG, rules, allowedStartRules
module.exports.allowedStartRules = allowedStartRules
module.exports.rules = rules
