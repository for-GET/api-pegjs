{
  _
  core
} = require '../_misc'
_parser = core {
  pegModule: 'for-get/response'
  startRule: 'HTTP_message'
}
AbstractBase = require '../abstract/Base'
URI = require '../uri/URI'
httpWell = require 'know-your-http-well'
statusWell = httpWell.statusPhrasesToCodes
phraseWell = httpWell.statusCodesToPhrases


module.exports = class Response extends AbstractBase
  _type: 'HTTP_message'
  _parser: _parser

  _defaultAst: () ->
    {
      __type: @type
      line:
        __type: 'status_line'
        status_code: '200'
        reason_phrase: 'OK'
        version: 'HTTP/1.1'
      headers: []
      body: ''
    }


  Object.defineProperty @::, 'status_code',
    get: () ->
      @ast.line.status_code
    set: (value) ->
      @ast.line.status_code = value
      @ast.line.reason_phrase  = phraseWell[value]  if phraseWell[value]?


  Object.defineProperty @::, 'status',
    get: () ->
      @status_code
    set: (value) ->
      @status_code = value


  Object.defineProperty @::, 'reason_phrase',
    get: () ->
      @ast.line.reason_phrase
    set: (value) ->
      @ast.line.reason_phrase = value
      phraseToken = value.toUpperCase().replace /[^A-Z]/g, '_'
      @ast.line.status_code = statusWell[phraseToken]  if statusWell[phraseToken]?


  Object.defineProperty @::, 'version',
    get: () ->
      @ast.line.version
    set: (value) ->
      value = "HTTP/#{value}"  unless /^HTTP\//.test value
      @ast.line.version = value


  Object.defineProperty @::, 'headers',
    get: () ->
      @ast.headers
    set: (value) ->
      @ast.headers = value


  Object.defineProperty @::, 'body',
    get: () ->
      @ast.body
    set: (value) ->
      @ast.body = value


  toString: (args = {}) ->
    {split} = args
    split ?= false
    line = @version + ' ' + @status_code + ' ' + @reason_phrase + '\r\n'
    headers = []
    for header in @headers
      {name, value} = header
      value = [value]  unless _.isArray value
      headers.push "#{name}: #{v}"  for v in value
    headers.push ''  if headers.length
    headers = headers.join '\r\n'
    return {line, headers, @body}  if split
    result = line + headers + @body
    result
