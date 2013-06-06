{
  _
  buildParser
  zeroOrMore
  oneOrMore
} = require './misc'
PEG = require('core-pegjs')['RFC/httpbis_p1']


allowedStartRules = [
  # Host
  # Host
  # TE
  # Transfer_Encoding
  # Via
  'Connection'
  'Upgrade'
  'method'
  'reason_phrase'
  'request_line'
  'request_target'
  'status_code'
  ['HTTP_message', 'message']
  ['HTTP_version', 'version']
  ['header_field', 'header']
  ['status_line', 'response_line']
]


rules =
  HTTP_version: () ->
    {
      __type: 'version'
      major: __result[2]
      minor: __result[4]
    }


  partial_uri: () ->
    {
      __type: 'partial_uri'
      relative_part: __result[0]
      query: __result[1]?[1]
    }


  HTTP_message: () ->
    line = __result[0]
    subtype = 'request'
    subtype = 'response'  if line.__type is 'response_line'

    message = {
      __type: 'message'
      subtype
      line
      headers: __result[2]
      body: __result[4]
    }


  request_line: () ->
    {
      __type: 'request_line'
      method: __result[0]
      target: __result[2]
      version: __result[4]
    }


  # method


  # Trailer


  # TE


  # request_target


  status_line: () ->
    {
      __type: 'response_line'
      version: __result[0]
      status_code: __result[2]
      reason_phrase: __result[4]
    }


  # status_code


  # reason_phrase


  header_field: () ->
    {
      __type: 'header'
      name: __result[0]
      value: __result[3]
    }


  comment: () ->
    {
      __type: 'comment'
      value: __result[1]
    }


  # Transfer_Encoding


  # Trailer


  # TE


  # Host


  # Via


  Connection: oneOrMore 'Conection'


  Upgrade: oneOrMore 'Upgrade'


  protocol: () ->
    {
      __type: 'protocol'
      name: __result[0]
      version: __result[1]?[1]
    }


rules = _.assign(
  {},
  require('./3986_uri').rules,
  rules
)
module.exports = buildParser PEG, rules, allowedStartRules
