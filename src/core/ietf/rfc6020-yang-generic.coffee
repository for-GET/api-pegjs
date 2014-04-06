{
  createModule
} = require './_misc'
PEG = require('core-pegjs')['ietf/rfc6020-yang-generic']


rules =
  unknown_statement: () ->
    [prefix, _colon, identifier, args, _optsep, substatements] = __result
    args = args[1]  if args?
    substatements = undefined  if substatements isnt ';'
    if substatements?
      [_curly, maybe_comments, substatements] = substatements
      cleanSubstatements = []
      cleanSubstatements.push maybe_comments  if maybe_comments?
      substatements.forEach (substatement) ->
        [substatement, maybe_comments2] = substatement
        cleanSubstatements.push substatement
        cleanSubstatements.push maybe_comments2  if maybe_comments2?
      substatements = cleanSubstatements
    {
      __type: 'statement'
      prefix
      identifier
      args
      substatements
    }


  string_quoted_: [
    () ->
      value = __result[3] or []
      value = value.map (item) -> item[3]
      head = __result[1]
      value.unshift head
      value
    () ->
      value = __result[3] or []
      value = value.map (item) -> item[3]
      head = __result[1]
      value.unshift head
      value
  ]


  stmtsep: () ->
    __result[1]


  stmtsep_no_stmt_: () ->
    __result[1]


  comment_: () ->
    {
      __type: 'comment'
      value: __result[1]
    }


rules.unknown_statement2 = rules.unknown_statement

module.exports = createModule {PEG, rules}
