{
  buildParser
} = require './_misc'
PEG = require('core-pegjs')['ietf/rfc3986_uri']


allowedStartRules = [
  'URI'
  'URI_reference'
  'authority'
  'relative_ref'
  'absolute_URI'
]


rules =
  URI: () ->
    hier_part = __result[2]
    {
      __type: 'URI'
      scheme: __result[0]
      slashes: hier_part.slashes
      authority: hier_part.authority
      path: hier_part.path
      query: __result[3]?[1]
      fragment: __result[4]?[1]
    }


  hier_part: [
    () ->
      {
        __type: 'hier_part'
        slashes: __result[0]
        authority: __result[1]
        path: __result[2]
      }
    () ->
      {
        __type: 'hier_part'
        path: __result[0]
      }
    () ->
      {
        __type: 'hier_part'
        path: __result[0]
      }
    () ->
      {
        __type: 'hier_part'
        path: __result[0]
      }
  ]


  authority: () ->
    {
      __type: 'authority'
      userinfo: __result[0]?[0]
      hostname: __result[1]
      port: __result[2]?[1]
    }


  relative_ref: () ->
    relative_part = __result[0]
    {
      __type: 'relative_ref'
      slashes: relative_part.slashes
      authority: relative_part.authority
      path: relative_part.path
      query: __result[1]?[1]
      fragment: __result[1]?[1]
    }


  relative_part: [
    () ->
      {
        __type: 'relative_part'
        slashes: __result[0]
        authority: __result[1]
        path: __result[2]
      }
    () ->
      {
        __type: 'relative_part'
        path: __result[0]
      }
    () ->
      {
        __type: 'relative_part'
        path: __result[0]
      }
    () ->
      {
        __type: 'relative_part'
        path: __result[0]
      }
  ]


  absolute_URI: () ->
    {
      __type: 'absolute_uri'
      scheme: __result[0]
      hier_part: __result[2]
      query: __result[3]?[1]
    }


module.exports = buildParser PEG, rules, allowedStartRules
module.exports.allowedStartRules = allowedStartRules
module.exports.rules = rules
