{
  _
  createModule
} = require '../_misc'
grammar = require('core-pegjs') 'for-get/literate-http'

rules =
  litHTTP: [
    () ->
      __result[1]
    () ->
      messages = []
      for [block] in __result[1]
        for message in block
          messages.push message
      messages
  ]

  litHTTP_fenced_block: () ->
    __result[2]

  litHTTP_messages: () ->
    messages = []
    for [message] in __result[0]
      messages.push message
    messages

  litHTTP_message: () ->
    {
      __type: __ruleName
      request: __result[0]
      response: __result[1]
    }

  litHTTP_request: () ->
    {
      __type: __ruleName
      method: __result[0].method
      target: __result[0].request_target
      HTTP_version: __result[0].HTTP_version
      headers: __result[1]
      body: __result[2]
    }

  litHTTP_request_line: () ->
    {
      method: __result[1]
      request_target: __result[3]
      HTTP_version: __result[4]?[1]
    }

  litHTTP_request_headers: () ->
    headers = []
    for [header] in __result[0]
      continue  unless header?
      headers.push header
    headers

  litHTTP_request_header: () ->
    __result[1]

  litHTTP_request_body: () ->
    __result[1]

  litHTTP_response: () ->
    {
      __type: __ruleName
      HTTP_version: __result[0].HTTP_version
      status_code: __result[0].status_code
      reason_phrase: __result[0].reason_phrase
      headers: __result[1]
      body: __result[2]
    }

  litHTTP_response_line: () ->
    {
      HTTP_version: __result[1]?[0]
      status_code: __result[2]
      reason_phrase: __result[3]?[1]
    }

  litHTTP_response_headers: () ->
    headers = []
    for [header] in __result[0]
      continue  unless header?
      headers.push header
    headers

  litHTTP_response_header: () ->
    __result[1]

  litHTTP_response_body: () ->
    __result[1]


mixins = [
  require('../ietf/draft-ietf-httpbis-p1-messaging')._.rules
]

module.exports = createModule {grammar, rules, mixins}
