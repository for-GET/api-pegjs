{
  _
  buildParser
  zeroOrMore
  oneOrMore
} = require './misc'
PEG = require('core-pegjs')['RFC/httpbis_p2']
PEG = """
#{PEG}

media_subtype
  = media_subtype_entity "-v" media_subtype_version "+" media_subtype_syntax
  / media_subtype_entity "-v" media_subtype_version
  / media_subtype_entity "+" media_subtype_syntax
  / media_subtype_syntax
  / subtype

media_subtype_entity
  = $((!("-v" / "+") tchar)+)

media_subtype_version
  = $(DIGIT+)

media_subtype_syntax
  = $(ALPHA+)
"""


allowedStartRules = [
  # 'From'
  'Accept'
  'Accept_Charset'
  'Accept_Encoding'
  'Accept_Language'
  'Accept_item_'
  'Allow'
  'Content_Encoding'
  'Content_Language'
  'Content_Location'
  'Content_Type'
  'Date'
  'Expect'
  'HTTP_date'
  'Location'
  'Max_Forwards'
  'media_type'
  'Referer'
  'Retry_After'
  'Server'
  'User_Agent'
  'Vary'
  'media_subtype'
  'media_type'
]


rules =
  media_type: () ->
    parameters = __result[3] or []
    parameters = parameters.map (parameter) -> parameter[3]
    {
      __type: 'media_type'
      type: __result[0]
      subtype: __result[2]
      parameters
    }


  parameter: () ->
    {
      __type: 'parameter'
      attribute: __result[0]
      value: __result[2]
    }


  Content_Type: () ->
    {
      __type: 'Content_Type'
      value: __result[0]
    }


  Content_Encoding: oneOrMore 'Content_Encoding'


  Content_Language: oneOrMore 'Content_Language'


  Content_Location: () ->
    {
      __type: 'Content_Location'
      value: __result
    }


  Expect: oneOrMore 'Expect'


  expectation: () ->
    {
      __type: 'expectation'
      expect_name: __result[0]
      expect_value: __result[1]?[3]
      expect_params: (__result[2] or []).map (param) -> param[2]?[1]
    }


  expect_param: () ->
    {
      __type: 'expect_param'
      expect_name: __result[0]
      expect_value: __result[1]?[3]
    }


  Max_Forwards: () ->
    {
      __type: 'Max_Forwards'
      value: __result
    }


  weight: () ->
    {
      __type: 'weight'
      attribute: 'q'
      value:  __result[4]
    }


  Accept: zeroOrMore 'Accept'


  Accept_item_: () ->
    {
      __type: 'Accept_item_'
      media_range: __result[0]
      accept_params: __result[1] or []
    }


  accept_params: () ->
    value = __result[1] or []
    weight = __result[0]
    value.unshift weight  if weight
    value


  accept_ext: () ->
    {
      __type: 'accept_ext'
      attribute: __result[3]
      value: __result[4]?[1]
    }


  media_range: () ->
    [type, _separator, subtype] = __result[0]
    parameters = __result[1] or []
    parameters = parameters.map (parameter) -> parameter[4]
    {
      __type: 'media_range'
      type
      subtype
      parameters
    }


  Accept_Charset: oneOrMore 'Accept_Charset'


  Accept_Charset_item_: () ->
    {
      charset: __result[0]
      weight: __result[1]
    }


  Accept_Encoding: zeroOrMore 'Accept_Encoding'


  Accept_Encoding_item_: () ->
    {
      encoding: __result[0]
      weight: __result[1]
    }


  Accept_Language: oneOrMore 'Accept_Language'


  Accept_Language_item_: () ->
    {
      language_range: __result[0]
      weight: __result[1]
    }


  # FIXME From


  Referer: () ->
    {
      __type: 'Referer'
      value: __result
    }


  User_Agent: () ->
    value = __result[1] or []
    value = value.map (item) -> item[1]
    head = __result[0]
    value.unshift head
    {
      __type: 'User_Agent'
      value
    }


  product: () ->
    {
      __type: 'product'
      name: __result[0]
      version: __result[1]?[1]
    }


  HTTP_date: [
    () ->
      {
        __type: 'HTTP_date'
        value: __result
      }
    () ->
  ]


  Date: () ->
    {
      __type: 'Date'
      date: __result
    }


  IMF_fixdate: () ->
    {
      __type: 'IMF_fixdate'
      day_name: __result[0]
      date: __result[3]
      time_of_day: __result[5]
    }


  date1: () ->
    {
      __type: 'date1'
      day: __result[0]
      month: __result[2]
      year: __result[4]
    }


  time_of_day: () ->
    {
      __type: 'time_of_day'
      hour: __result[0]
      minute: __result[2]
      second: __result[4]
    }


  Location: () ->
    {
      __type: 'Location'
      value: __result
    }


  Retry_After: [
    () ->
      {
        __type: 'Retry_After'
        HTTP_date: __result
      }
    () ->
      {
        __type: 'Retry_After'
        delta_seconds: __result
      }
  ]


  Vary: [
    () ->
      {
        __type: 'Vary'
        field_name: "*"
      }
    oneOrMore 'Vary'
  ]


  Allow: oneOrMore 'Allow'


  Server: () ->
    value = __result[1] or []
    value = value.map (item) -> item[1]
    head = __result[0]
    value.unshift head
    {
      __type: 'Server'
      value
    }

  media_subtype: [
    () ->
      {
        __type: 'media_subtype'
        entity: __result[0]
        version: __result[2]
        syntax: __result[4]
      }
    () ->
      {
        __type: 'media_subtype'
        entity: __result[0]
        version: __result[2]
      }
    () ->
      {
        __type: 'media_subtype'
        entity: __result[0]
        syntax: __result[2]
      }
    () ->
      {
        __type: 'media_subtype'
        entity: __result
        syntax: __result
      }
    () ->
        __type: 'media_subtype'
        entity: __result
  ]


rules = _.assign(
  {},
  require('./httpbis_p1').rules,
  rules
)

module.exports = buildParser PEG, rules, allowedStartRules
