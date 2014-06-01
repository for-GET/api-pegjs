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
      __result[1]
  ]

  litHTTP_fenced_blocks: () ->
    transactions = []
    transactions = transactions.concat(item)  for item in __result[0]
    transactions

  litHTTP_fenced_block: [
    () ->
      __result[0]
    () ->
      transactions = [].concat(__result[0].transactions ? [])
      transactions.push
        __type: 'litHTTP_transaction'
        request: __result[0].request
        response: __result[2].response
      transactions = transactions.concat(__result[2].transactions ? [])
  ]

  litHTTP_fenced_transactions: () ->
    __result[2]

  litHTTP_fenced_transactions_request: () ->
    {
      transactions: __result[2]?[0]
      request: __result[3]
    }

  litHTTP_fenced_response_transactions: () ->
    {
      response: __result[2]
      transactions: __result[3]?[0]
    }

  litHTTP_transactions: () ->
    transactions = [__result[0]]
    for [_separator, transaction] in __result[1]
      transactions.push transaction
    transactions

  litHTTP_transaction: () ->
    {
      __type: __ruleName
      request: __result[0]
      response: __result[1]
    }

  litHTTP_request: () ->
    {
      __type: __ruleName
      method: __result[0].method
      target: __result[0].target
      HTTP_version: __result[0].HTTP_version
      headers: __result[1]
      body: __result[3]
    }

  litHTTP_request_line: () ->
    {
      method: __result[1]
      target: __result[3]
      HTTP_version: __result[4]?[1]
    }

  litHTTP_request_target: [
    () ->
      {
        __type: 'request_target'
        value: __result[1]
      }
    () ->
      {
        __type: 'request_target_extended'
        value: __result[0]
      }
  ]

  litHTTP_request_headers: () ->
    headers = []
    for [header] in __result[0]
      continue  unless header?
      headers.push header
    headers

  litHTTP_request_header: () ->
    __result[1]

  litHTTP_request_body: () ->
    __result[0]

  litHTTP_response: () ->
    {
      __type: __ruleName
      HTTP_version: __result[0].HTTP_version
      status_code: __result[0].status_code
      reason_phrase: __result[0].reason_phrase
      headers: __result[1]
      body: __result[3]
    }

  litHTTP_status_line: () ->
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
    __result[0]

  HTTP_version: () ->
    text()

  status_code: () ->
    parseInt __result[0], 10

  header_field: () ->
    {
      name: __result[0]
      value: __result[3]
    }



module.exports = createModule {grammar, rules}
