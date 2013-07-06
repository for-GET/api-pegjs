_ = require 'lodash'
AbstractBase = require '../abstract/Base'

module.exports = class MixinAcceptItem extends AbstractBase
  _ItemClass: undefined


  _parse: (string) ->
    parsed = super
    return  unless parsed
    media = parsed.media_range
    _.assign media, @_parseSubtype media.subtype
    parsed


  Object.defineProperty @::, 'q',
    get: () ->
      @acceptParam('q') || '1'
    set: (value) ->
      @acceptParam 'q', value


  Object.defineProperty @::, 'params',
    get: () ->
      @mediaParams.concat @acceptParams


  Object.defineProperty @::, 'acceptParams',
    get: () ->
      @ast.accept_params
    set: (value) ->
      @ast.accept_params = value


  acceptParam: (attribute, value) ->
    for param, index in @acceptParams
      continue  unless param.attribute is attribute
      if value?
        return param.value = value
      else if value is null
        @acceptParams.splice index, 1
        return value
      else
        return param.value
    if value?
      ast = {
        __type: 'accept_ext'
        attribute
        value
      }
      if attribute is 'q'
        return @acceptParams.shift ast
      else
        return @acceptParams.push ast
    undefined
