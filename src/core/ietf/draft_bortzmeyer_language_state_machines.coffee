{
  _
  buildParser
} = require './_misc'
PEG = require('core-pegjs')['ietf/draft_bortzmeyer_language_state_machines']


startRules = [
  'state_machine'
]


rules =
  state_machine: () ->
    statements = [__result[1]]
    __result[2].forEach (statement) ->
      return  unless statement?.__type in ['transition', 'declaration', 'assignment']
      statements.push statement
    {
      __type: __ruleName
      statements
    }


  statement: () ->
    __result[0]


  declaration: () ->
    {
      __type: __ruleName
      names: __result[0]
      value: __result[2]
    }


  assignment: () ->
    {
      __type: __ruleName
      name: __result[0]
      value: __result[2]
    }


  names: () ->
    names = [__result[0]]
    names.push item[1]  for item in __result[1]
    names


  name: () ->
    __result[0]


  quoted_name: () ->
    __result[1]


  transition: () ->
    {
      __type: __ruleName
      states: __result[0]
      messages: __result[2]
      next_state: __result[4]
      action: __result[5]?[1]
    }


module.exports = buildParser {PEG, rules, startRules}
