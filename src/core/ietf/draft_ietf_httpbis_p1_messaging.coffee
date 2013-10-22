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
      __type: __ruleName
      major: __result[2]
      minor: __result[4]
    }


  partial_uri: () ->
    {
      __type: __ruleName
      relative_part: __result[0]
      query: __result[1]?[1]
    }


  HTTP_message: () ->
    line = __result[0]
    headers = __result[1].map (headerCRLF) -> headerCRLF[0]
    body = __result[3]

    message = {
      __type: __ruleName
      line
      headers
      body
    }


  request_line: () ->
    {
      __type: __ruleName
      method: __result[0]
      target: __result[2]
      version: __result[4]
    }


  # method


  status_line: () ->
    {
      __type: __ruleName
      version: __result[0]
      status_code: __result[2]
      reason_phrase: __result[4]
    }


  # status_code


  # reason_phrase


  header_field: () ->
    {
      __type: __ruleName
      name: __result[0]
      value: __result[3]
    }


  comment: () ->
    {
      __type: __ruleName
      value: __result[1]
    }


  Transfer_Encoding: oneOrMore


  transfer_extension: () ->
    parameters = __result[2] or []
    parameters = parameters.map (parameter) -> parameter[3]
    {
      __type: __ruleName
      name: __result[0]
      parameters
    }


  transfer_parameter: () ->
    {
      __type: __ruleName
      attribute: __result[0]
      value: __result[4]
    }


  Trailer: oneOrMore


  # TE


  # request_target


  Host: () ->
    {
      __type: __ruleName
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
      __type: __ruleName
      name: __result[0]?[0]
      version: __result[1]
    }


  received_by: [
    () ->
      {
        __type: __ruleName
        hostname: __result[0]
        port: __result[1]?[1]
      }
    () ->
      {
         __type: __ruleName
         pseudonym: __result[0]
      }
  ]


  Connection: oneOrMore


  Upgrade: oneOrMore


  protocol: () ->
    {
      __type: __ruleName
      name: __result[0]
      version: __result[1]?[1]
    }


rules = _.defaults(
  rules,
  require('./rfc3986_uri')._.rules
)
module.exports = buildParser {PEG, rules, startRules}
