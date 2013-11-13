_ = require 'lodash'
AbstractBase = require '../abstract/Base'
URI = require '../uri/URI'


module.exports = class Response extends AbstractBase
  _type: 'HTTP_message'
  _parser: require('../core/for-get/request') {startRule: 'HTTP_message'}


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


  Object.defineProperty @::, 'reason_phrase',
    get: () ->
      @ast.line.reason_phrase
    set: (value) ->
      @ast.line.reason_phrase = value


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
    {hideBody} = args
    hideBody ?= false
    line = @version + ' ' + @status_code + ' ' + @reason_phrase
    headers = []
    for header in @headers
      {name, value} = header
      value = value.join ', '  if _.isArray value
      headers.push "#{name}: #{value}"
    headers = headers.join '\r\n'
    result = "#{line}\r\n#{headers}\r\n\r\n"
    result += "#{@body}\r\n"  unless hideBody
    result
