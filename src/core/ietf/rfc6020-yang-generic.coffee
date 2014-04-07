{
  createModule
} = require './_misc'
PEG = require('core-pegjs')['ietf/rfc6020-yang-generic']


rules =
  unknown_statement: () ->
    [prefix, identifier, args, _optsep, substatements] = __result
    prefix = prefix[0]  if prefix?
    args = args[1]  if args?
    result = {
      __prefix: prefix
      __identifier: identifier
      __args: args
    }
    substatements = undefined  if substatements is ';'
    if substatements?
      [_curly, _maybe_comments, substatements] = substatements
      do (prefix, identifier) ->
        substatements.forEach (substatement) ->
          [substatement, _maybe_comments] = substatement
          {__prefix, __identifier} = substatement
          __identifier = "#{__prefix}:#{__identifier}"  if prefix?
          result[__identifier] ?= []
          result[__identifier].push substatement
    result


  string_quoted_: [
    () ->
      value = __result[3] or []
      value = value.map (item) -> item[3]
      head = __result[1]
      value.unshift head
      value = undefine  unless value.length
      value.join ''
    () ->
      value = __result[3] or []
      value = value.map (item) -> item[3]
      head = __result[1]
      value.unshift head
      value = undefine  unless value.length
      value.join ''
  ]


  stmtsep: () ->
    __result[1]


  stmtsep_no_stmt_: () ->
    __result[1]


  comment_: () ->
    undefined


rules.unknown_statement2 = rules.unknown_statement

module.exports = createModule {PEG, rules}
