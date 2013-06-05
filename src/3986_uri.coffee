misc = require './misc'
PEG = require('core-pegjs')['RFC/3986_uri']


allowedStartRules = [
  'URI'
  'URI_reference'
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


module.exports = misc.buildParser PEG, rules, allowedStartRules
