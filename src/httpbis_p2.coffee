misc = require './misc'
PEG = require('core-pegjs')['RFC/httpbis_p2']

zeroOrMore = (__type) ->
  fun = () ->
    value = __result[0][1] or []
    head = __result[0][0]
    value.unshift head  if head
    {
      __type: "{{__type}}"
      value
    }
  misc.funToString(fun).replace '{{__type}}', __type


oneOrMore = (__type) ->
  fun = () ->
    value = __result[2] or []
    value = value.map (item) -> item[1]
    head = __result[1]
    value.unshift head  if head
    {
      __type: "{{__type}}"
      value
    }
  misc.funToString(fun).replace '{{__type}}', __type


allowedStartRules = [
  'Accept'
  'Accept_Charset'
  'Accept_Encoding'
  'Accept_Language'
  'Allow'
  'Content_Encoding'
  'Content_Language'
  'Content_Location'
  'Content_Type'
  # 'Date'
  # 'Expect'
  # 'From'
  # 'Host'
  # 'Location'
  # 'Max_Forwards'
  'media_type'
  'Referer'
  # 'Retry_After'
  # 'Server'
  # 'TE'
  # 'Tranfer_Encoding'
  # 'Upgrade'
  # 'User_Agent'
  # 'Vary'
  # 'Via'
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
    value = __result[4]
    return undefined  unless value
    {
      __type: 'weight'
      value
    }


  Accept: zeroOrMore 'Accept'


  Accept_item_: () ->
    {
      media_range: __result[0]
      accept_params: __result[1]
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


  # FIXME Referer


  # FIXME User_Agent


  # FIXME HTTP_date


  # FIXME Date


  # FIXME Location


  # FIXME Retry_After


  # FIXME Vary


  # FIXME Allow


  # FIXME Server


module.exports = misc.buildParser PEG, rules, allowedStartRules
