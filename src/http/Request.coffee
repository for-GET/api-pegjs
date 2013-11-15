_ = require 'lodash'
AbstractBase = require '../abstract/Base'
URI = require '../uri/URI'


module.exports = class Request extends AbstractBase
  _type: 'HTTP_message'
  _parser: require('../core/for-get/request') {startRule: 'HTTP_message'}


  _defaultAst: () ->
    {
      __type: @type
      line:
        __type: 'request_line'
        method: 'GET'
        target: '/'
        version: 'HTTP/1.1'
      headers: []
      body: ''
    }


  Object.defineProperty @::, 'method',
    get: () ->
      @ast.line.method
    set: (value) ->
      @ast.line.method = value


  Object.defineProperty @::, 'target',
    get: () ->
      @ast.line.target
    set: (value) ->
      @ast.line.target = value


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
    line = @method + ' ' + @target + ' ' + @version + '\r\n'
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
