{
  _
  createModule
  funToString
} = require '../_misc'
grammar = require('core-pegjs') 'for-get/literate-http-curl-trace'

litHTTP_curl = require('../../../')('core/for-get/literate-http-curl') {
  startRule: 'litHTTP'
  options:
    output: 'source'
  }

parse_data_lines = funToString () ->
  options.parse_data_lines = (lines) ->
    hexList = []
    for line in lines
      hexList = hexList.concat line
    charList = []
    for hex in hexList
      charCode = parseInt "0x#{hex}"
      continue  if isNaN charCode
      charList.push String.fromCharCode charCode
    charList.join('').split "\r\n"


initializer = """
  options.litHTTP_curl = #{litHTTP_curl};
  #{parse_data_lines}
  """

rules =
  litHTTP_fenced_block: () ->
    __result[0]

  litHTTP_transaction: () ->
    __result[0]

  CURL_TRACE: () ->
    request = __result[3]
    request_body = request.pop()
    response = __result[5]
    response_body = response.pop()
    request_body = "\r\n" + request_body  if request_body.length
    response_body = "\r\n" + response_body  if response_body.length
    request = request.join "\r\n> "
    response = response.join "\r\n< "
    options.litHTTP_curl("> #{request}#{request_body}\r\n< #{response}#{response_body}")[0]

  CURLINFO_TEXTs: () ->

  CURLINFO_TEXT: () ->

  CURLINFO_OUT: () ->

  CURLINFO_IN: () ->

  CURLDUMP_OUTs: () ->
    options.parse_data_lines __result[0]

  CURLDUMP_INs: () ->
    options.parse_data_lines __result[0]

  CURL_DUMP: () ->
    __result[1]

  CURL_DUMP_HEX: () ->
    __result[0]


mixins = [
  require('./literate-http')._.rules
]

module.exports = createModule {grammar, initializer, rules, mixins}
