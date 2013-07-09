_ = require 'lodash'
{
  _3986_uri
} = require './parsers'
AbstractBase = require './abstract/Base'


module.exports = class URI extends AbstractBase
  _type: 'URI'
  _parser: _3986_uri.URI


  _defaultAst: () ->
    {
      __type: @type
      scheme: ''
      slashes: ''
      authority:
        __type: 'authority'
        userinfo: ''
        hostname: ''
        port: ''
      path: '/'
      query: ''
      fragment: ''
    }


  Object.defineProperty @::, 'scheme',
    get: () ->
      @ast.scheme
    set: (value) ->
      @ast.scheme = value


  Object.defineProperty @::, 'protocol',
    get: () ->
      return ''  unless @ast.scheme
      @ast.scheme + ':'
    set: (value) ->
      @ast.scheme = value.replace ':', ''


  Object.defineProperty @::, 'slashes',
    get: () ->
      @ast.slashes
    set: (value) ->
      @ast.slashes = value


  Object.defineProperty @::, 'userinfo',
    get: () ->
      @ast.authority.userinfo
    set: (value) ->
      @ast.authority.userinfo = value


  Object.defineProperty @::, 'hostname',
    get: () ->
      @ast.authority.hostname
    set: (value) ->
      @ast.authority.hostname = value


  Object.defineProperty @::, 'port',
    get: () ->
      @ast.authority.port
    set: (value) ->
      @ast.authority.port = value


  Object.defineProperty @::, 'path',
    get: () ->
      @ast.path
    set: (value) ->
      @ast.path = value


  Object.defineProperty @::, 'query',
    get: () ->
      @ast.query
    set: (value) ->
      @ast.query = value


  Object.defineProperty @::, 'fragment',
    get: () ->
      @ast.fragment
    set: (value) ->
      @ast.fragment = value


  toString: () ->
    authority = ''
    authority += @userinfo + '@'  if @userinfo?
    authority += @hostname
    authority += ':' + @port  if @port?
    query = ''
    query += '?' + @query  if @query?
    fragment = ''
    fragment += '#' + @fragment  if @fragment?
    @protocol + @slashes + authority + @path + query + fragment
