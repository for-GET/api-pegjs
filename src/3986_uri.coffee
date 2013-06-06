misc = require './misc'
PEG = require('core-pegjs')['RFC/3986_uri']


allowedStartRules = [
  'URI'
  'URI_reference'
  'authority'
  'relative_ref'
  'absolute_uri'
]


rules =
  URI: () ->
    {
      __type: 'URI'
      scheme: __result[0]
      hier_part: __result[2]
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
    {
      __type: 'relative_ref'
      relative_part: __result[0]
      query: __result[1]?[1]
      fragment: __result[1]?[1]
    }


  absolute_URI: () ->
    {
      __type: 'absolute_uri'
      scheme: __result[0]
      hier_part: __result[2]
      query: __result[3]?[1]
    }


module.exports = misc.buildParser PEG, rules, allowedStartRules
module.exports.allowedStartRules = allowedStartRules
module.exports.rules = rules
