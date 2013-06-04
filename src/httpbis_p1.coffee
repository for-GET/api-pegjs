misc = require './misc'

PEG = require('core-pegjs')['RFC/httpbis_p1']


allowedStartRules =
  HTTP_version: 'version'
  HTTP_message: 'message'
  request_line: null
  method: null
  request_target: null
  status_line: 'response_line'
  status_code: null
  reason_phrase: null
  header_field: 'header'


rules =
  HTTP_version: () ->
    {
      type: 'version'
      major: $result[2]
      minor: $result[4]
    }

  HTTP_message: () ->
    line = $result[0]
    subtype = 'request'
    subtype = 'response'  if line is 'response_line'

    message = {
      type: 'message'
      subtype
      line
      headers: $result[2]
      body: $result[4]
    }

  request_line: () ->
    {
      type: 'request_line'
      method: $result[0]
      target: $result[2]
      version: $result[4]
    }

  status_line: () ->
    {
      type: 'response_line'
      version: $result[0]
      status_code: $result[2]
      reason_phrase: $result[4]
    }

  header_field: () ->
    {
      type: 'header'
      name: $result[0]
      value: $result[3]
    }


module.exports = misc.buildParser PEG, rules, allowedStartRules
