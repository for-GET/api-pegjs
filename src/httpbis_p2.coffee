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
  # 'Allow'
  # 'Connection'
  # 'Content_Encoding'
  # 'Content_Language'
  # 'Content_Location'
  'Content_Type'
  # 'Date'
  # 'Expect'
  # 'From'
  # 'Host'
  # 'Location'
  # 'Max_Forwards'
  'media_type'
  # 'Referer'
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
  Accept: zeroOrMore 'Accept'


  Accept_item_: () ->
    accept_params = __result[1][1] or []
    weight = __result[1][0]
    accept_params.unshift weight  if weight
    {
      media_range: __result[0]
      accept_params
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


  weight: () ->
    value = __result[4]
    return undefined  unless value
    {
      __type: 'weight'
      value
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


  Content_Type: () ->
    {
      __type: 'Content_Type'
      value: __result[0]
    }


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


module.exports = misc.buildParser PEG, rules, allowedStartRules
