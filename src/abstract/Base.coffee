_ = require 'lodash'
SuperObject = require './SuperObject'

module.exports = class AbstractBase extends SuperObject
  _type: '__abstract__'
  ast: undefined


  constructor: (source) ->
    @set source


  _defaultAst: () ->
    {
      __type: '__abstract__'
      value: ''
    }


  _parse: (string) ->
    @_parser string


  _parser: (string) ->
    {
      __type: @_type
      value: string
    }


  set: (source) ->
    if _.isString source
      @ast = @_parse source
    else if _.isPlainObject(source) and source.__type is @_type
      @ast = source
    else
      @ast = @_defaultAst()



  toString: () ->
    @ast.value


  toJSON: () ->
    return @ast.toJSON()  if _.isFunction @ast.toJSON
    return @ast  unless _.isPlainObject @ast or _.isArray @ast
    for key, value of @ast
      @ast[key] = value.toJSON()  if _.isFunction value.toJSON
    @ast