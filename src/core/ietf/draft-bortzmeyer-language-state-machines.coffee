{
  createModule
} = require './_misc'
grammar = require('core-pegjs') 'ietf/draft-bortzmeyer-language-state-machines'


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


  transition: () ->
    {
      __type: __ruleName
      states: __result[0]
      messages: __result[2]
      next_state: __result[4]
      action: __result[5]?[1]
    }


  names: () ->
    names = [__result[0]]
    names.push item[1]  for item in __result[1]
    names


  name: () ->
    __result[0]


  quoted_name: () ->
    __result[1]


  coords: () ->
    coords = [__result[0]]
    coords.push item[1]  for item in __result[1]
    coords


  coordnames: () ->
    names = [__result[0]]
    names.push item[1]  for item in __result[1]
    names


  coordname: [
    () ->
      {
        name: __result[0]
        top_left:
          x: __result[2][0]
          y: __result[2][1]
        bottom_right:
          x: __result[4][0]
          y: __result[4][1]
      }
    () ->
      {
        name: __result[0]
        center:
          x: __result[2][0]
          y: __result[2][1]
      }
    () ->
      __result[0]
  ]


  arrow: () ->
    {
      coords: __result[2]
    }



module.exports = createModule {grammar, rules}
