misc = require './misc'
PEG = require('core-pegjs')['RFC/httpbis_p1']


allowedStartRules =
  # 'Connection'
  HTTP_message: 'message'
  HTTP_version: 'version'
  header_field: 'header'
  method: null
  reason_phrase: null
  request_line: null
  request_target: null
  status_code: null
  status_line: 'response_line'


rules =
  HTTP_version: () ->
    {
      __type: 'version'
      major: __result[2]
      minor: __result[4]
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


module.exports = misc.buildParser PEG, rules, allowedStartRules
