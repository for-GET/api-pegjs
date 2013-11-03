{
  _
  createModule
} = require '../_misc'
PEG = require('core-pegjs')['for-get/media_subtype']


rules =
  media_subtype: [
    () ->
      {
        __type: __ruleName
        entity: __result[0]
        version: __result[2]
        syntax: __result[4]
      }
    () ->
      {
        __type: __ruleName
        entity: __result[0]
        version: __result[2]
      }
    () ->
      {
        __type: __ruleName
        entity: __result[0]
        syntax: __result[2]
      }
    () ->
      {
        __type: __ruleName
        entity: __result
        syntax: __result
      }
    () ->
        __type: __ruleName
        entity: __result
  ]


mixins = [
  require('../ietf/draft_ietf_httpbis_p2_semantics')._.rules
]
module.exports = createModule {PEG, rules, mixins}
