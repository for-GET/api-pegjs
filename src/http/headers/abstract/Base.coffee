_ = require 'lodash'
SuperObject = require './SuperObject'

module.exports = class AbstractBase extends SuperObject
  _type: undefined
  _parser: undefined
  ast: undefined


  constructor: (source) ->
    if _.isString source
      @ast = @_parse source
    else if source?
      @ast = source
    else
      @ast = @_defaultAst()


  _defaultAst: () ->


  _parse: (string) ->
    @_parser string


  toString: () ->
