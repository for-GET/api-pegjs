{
  createModule
} = require './_misc'
PEG = require('core-pegjs')['ietf/rfc3986-uri']


rules =
  URI: () ->
    hier_part = __result[2]
    {
      __type: __ruleName
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
        __type: __ruleName
        slashes: __result[0]
        authority: __result[1]
        path: __result[2]
      }
    () ->
      {
        __type: __ruleName
        path: __result[0]
      }
    () ->
      {
        __type: __ruleName
        path: __result[0]
      }
    () ->
      {
        __type: __ruleName
        path: __result[0]
      }
  ]


  authority: () ->
    {
      __type: __ruleName
      userinfo: __result[0]?[0]
      hostname: __result[1]
      port: __result[2]?[1]
    }


  relative_ref: () ->
    relative_part = __result[0]
    {
      __type: __ruleName
      slashes: relative_part.slashes
      authority: relative_part.authority
      path: relative_part.path
      query: __result[1]?[1]
      fragment: __result[1]?[1]
    }


  relative_part: [
    () ->
      {
        __type: __ruleName
        slashes: __result[0]
        authority: __result[1]
        path: __result[2]
      }
    () ->
      {
        __type: __ruleName
        path: __result[0]
      }
    () ->
      {
        __type: __ruleName
        path: __result[0]
      }
    () ->
      {
        __type: __ruleName
        path: __result[0]
      }
  ]


  hostname: [
    () ->
      {
        __type: 'uri_host',
        ip: __result[0]
      }
    () ->
      {
        __type: 'uri_host',
        ip: __result[0]
      }
    () ->
      {
        __type: 'uri_host',
        reg_name: __result[0]
      }
  ]


  IP_literal: () ->
    __result[1]


  IPvFuture: () ->
    {
      __type: __ruleName
      version: __result[1]
      address: __result3
    }


  IPv6address: () ->
    {
      __type: __ruleName
      version: '6'
      address: __result[0]
    }


  IPv4address: () ->
    {
      __type: __ruleName
      version: '4'
      address: __result[0]
    }


  reg_name: () ->
    __result[0]


  absolute_URI: () ->
    {
      __type: __ruleName
      scheme: __result[0]
      hier_part: __result[2]
      query: __result[3]?[1]
    }


module.exports = createModule {PEG, rules}
