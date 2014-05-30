{
  createModule
} = require './_misc'
grammar = require('core-pegjs') 'ietf/rfc5646-language'


rules =
  language: [
    () ->
      {
        __type: __ruleName
        tag: __result[0]
        subtag: __result[1]
      }
    () ->
      {
        __type: __ruleName
        tag: __result[0]
        reserved: true
      }
    () ->
      {
        __type: __ruleName
        tag: __result[0]
        registered: true
      }
  ]


  extlang: () ->
    __result


module.exports = createModule {grammar, rules}
