{
  createModule
  zeroOrMoreHTTP
  oneOrMoreHTTP
} = require './_misc'
grammar = require('core-pegjs') 'ietf/draft-ietf-httpbis-p2-semantics'


rules =
  media_type: () ->
    parameters = __result[3] or []
    parameters = parameters.map (parameter) -> parameter[3]
    {
      __type: __ruleName
      type: __result[0]
      subtype: __result[2]
      parameters
    }


  parameter: () ->
    {
      __type: __ruleName
      attribute: __result[0]
      value: __result[2] or true
    }


  Content_Type: () ->
    {
      __type: __ruleName
      value: __result[0]
    }


  Content_Encoding: oneOrMoreHTTP


  Content_Language: oneOrMoreHTTP


  Content_Location: () ->
    {
      __type: __ruleName
      value: __result
    }


  Expect: oneOrMoreHTTP


  expectation: () ->
    {
      __type: __ruleName
      expect_name: __result[0]
      expect_value: __result[1]?[3]
      expect_params: (__result[2] or []).map (param) -> param[2]?[1]
    }


  expect_param: () ->
    {
      __type: __ruleName
      expect_name: __result[0]
      expect_value: __result[1]?[3]
    }


  Max_Forwards: () ->
    {
      __type: __ruleName
      value: __result
    }


  weight: () ->
    {
      __type: __ruleName
      attribute: 'q'
      value:  __result[4]
    }


  Accept: zeroOrMoreHTTP


  Accept_item_: () ->
    {
      __type: __ruleName
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
      __type: __ruleName
      attribute: __result[3]
      value: __result[4]?[1]
    }


  media_range: () ->
    [type, _separator, subtype] = __result[0]
    parameters = __result[1] or []
    parameters = parameters.map (parameter) -> parameter[4]
    {
      __type: __ruleName
      type
      subtype
      parameters
    }


  Accept_Charset: oneOrMoreHTTP


  Accept_Charset_item_: () ->
    {
      __type: __ruleName
      charset: __result[0]
      weight: __result[1]
    }


  Accept_Encoding: zeroOrMoreHTTP


  Accept_Encoding_item_: () ->
    {
      __type: __ruleName
      encoding: __result[0]
      weight: __result[1]
    }


  Accept_Language: oneOrMoreHTTP


  Accept_Language_item_: () ->
    {
      __type: __ruleName
      language_range: __result[0]
      weight: __result[1]
    }


  # FIXME From


  Referer: () ->
    {
      __type: __ruleName
      value: __result
    }


  User_Agent: () ->
    value = __result[1] or []
    value = value.map (item) -> item[1]
    head = __result[0]
    value.unshift head
    {
      __type: __ruleName
      value
    }


  product: () ->
    {
      __type: __ruleName
      name: __result[0]
      version: __result[1]?[1]
    }


  HTTP_date: () ->
    {
      __type: __ruleName
      value: __result
    }


  Date: () ->
    {
      __type: __ruleName
      date: __result
    }


  IMF_fixdate: () ->
    {
      __type: __ruleName
      day_name: __result[0]
      date: __result[3]
      time_of_day: __result[5]
    }


  date1: () ->
    {
      __type: __ruleName
      day: __result[0]
      month: __result[2]
      year: __result[4]
    }


  time_of_day: () ->
    {
      __type: __ruleName
      hour: __result[0]
      minute: __result[2]
      second: __result[4]
    }


  Location: () ->
    {
      __type: __ruleName
      value: __result
    }


  Retry_After: [
    () ->
      {
        __type: __ruleName
        HTTP_date: __result
      }
    () ->
      {
        __type: __ruleName
        delta_seconds: __result
      }
  ]


  Vary: [
    () ->
      {
        __type: __ruleName
        field_name: "*"
      }
    oneOrMoreHTTP
  ]


  Allow: oneOrMoreHTTP


  Server: () ->
    value = __result[1] or []
    value = value.map (item) -> item[1]
    head = __result[0]
    value.unshift head
    {
      __type: __ruleName
      value
    }


mixins = [
  require('./draft-ietf-httpbis-p1-messaging')._.rules
]
module.exports = createModule {grammar, rules, mixins}
