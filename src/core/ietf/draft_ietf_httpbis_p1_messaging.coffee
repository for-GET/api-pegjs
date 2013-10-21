{
  _
  buildParser
  oneOrMore
} = require './_misc'
PEG = require('core-pegjs')['ietf/draft_ietf_httpbis_p1_messaging']


startRules = [
  # TE
  'Connection'
  'Host'
  'Trailer'
  'Transfer_Encoding'
  'Upgrade'
  'Via'
  'method'
  'reason_phrase'
  'request_line'
  'request_target'
  'status_code'
  'token'
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
    headers = __result[1].map (headerCRLF) -> headerCRLF[0]
    body = __result[3]

    message = {
      __type: 'message'
      line
      headers
      body
    }


  request_line: () ->
    {
      __type: 'request_line'
      method: __result[0]
      target: __result[2]
      version: __result[4]
    }


  # method


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


  Transfer_Encoding: oneOrMore


  transfer_extension: () ->
    parameters = __result[2] or []
    parameters = parameters.map (parameter) -> parameter[3]
    {
      __type: 'transfer_extension'
      name: __result[0]
      parameters
    }


  transfer_parameter: () ->
    {
      __type: 'transfer_parameter'
      attribute: __result[0]
      value: __result[4]
    }


  Trailer: oneOrMore


  # TE


  # request_target


  Host: () ->
    {
      __type: 'Host'
      hostname: __result[0]
      port: __result[1]?[1]
    }


  Via: oneOrMore


  Via_item_: () ->
    {
      protocol: __result[0]
      received_by: __result[2]
      comment: __result[3]?[1]
    }


  received_protocol: () ->
    {
      __type: 'received_protocol'
      name: __result[0]?[0]
      version: __result[1]
    }


  received_by: [
    () ->
      {
        __type: 'received_by'
        hostname: __result[0]
        port: __result[1]?[1]
      }
    () -> __result
  ]


  pseudonym: () ->
    {
      __type: 'pseudonym'
      value: __result
    }


  Connection: oneOrMore


  Upgrade: oneOrMore


  protocol: () ->
    {
      __type: 'protocol'
      name: __result[0]
      version: __result[1]?[1]
    }


rules = _.defaults(
  rules,
  require('./rfc3986_uri')._.rules
)
module.exports = buildParser {PEG, rules, startRules}
