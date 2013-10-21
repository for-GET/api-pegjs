{
  _
  buildParser
} = require './_misc'
PEG = require('core-pegjs')['ietf/rfc5646_language']


startRules = [
  'language'
]


rules =
  language: [
    () ->
      {
        __type: 'language'
        tag: __result[0]
        subtag: __result[1]
      }
    () ->
      {
        __type: 'language'
        tag: __result[0]
        reserved: true
      }
    () ->
      {
        __type: 'language'
        tag: __result[0]
        registered: true
      }
  ]


  extlang: () -> __result

module.exports = buildParser {PEG, rules, startRules}
