_ = require 'lodash'
SuperObject = require './SuperObject'

module.exports = class AbstractBase extends SuperObject
  _type: undefined
  _parser: undefined
  ast: undefined


  constructor: (source) ->
    if _.isString source
      @ast = @_parse source
    else if _.isPlainObject(source) and source.__type is @_type
      @ast = source
    else
      @ast = @_defaultAst()


  _defaultAst: () ->
    {}

  _parse: (string) ->
    @_parser string


  toString: () ->
    @ast.toString()


  toJSON: () ->
    return @ast.toJSON()  if _.isFunction @ast.toJSON
    return @ast  unless _.isPlainObject @ast or _.isArray @ast
    for key, value of @ast
      @ast[key] = value.toJSON()  if _.isFunction value.toJSON
    @ast