{
  _
  core
} = require '../../_misc'
_parser = core {
  pegModule: 'ietf/draft-ietf-httpbis-p1-messaging'
  startRule: 'Content_Type'
}
_parserToken = core {
  pegModule: 'ietf/draft-ietf-httpbis-p2-semantics'
  startRule: 'token'
}
_parserMediaSubtype = core {
  pegModule: 'for-get/media-subtype'
  startRule: 'media_subtype'
}
AbstractBase = require '../../abstract/Base'


module.exports = class ContentType extends AbstractBase
  _type: 'Content_Type'
  _parser: _parser
  _parserToken: _parserToken
  _parserMediaSubtype: _parserMediaSubtype
  _paramSep: ';'


  constructor: (source) ->
    super
    _.assign @media, @_parseSubtype @media.subtype


  _defaultAst: () ->
    {
      __type: @_type
      value:
        __type: 'media_type'
        type: '*'
        subtype: '*'
        parameters: []
    }


  _parse: (string) ->
    parsed = super
    return  unless parsed
    _.assign parsed.value, @_parseSubtype parsed.value.subtype
    parsed


  _parseSubtype: (string) ->
    string = @_subtypeObjToString string  unless _.isString string
    parsed = @_parserMediaSubtype string
    return string  unless parsed
    parsed.subtype = string
    parsed


  _subtypeObjToString: (obj) ->
    obj = _.merge {}, @media, obj
    string = ''
    string += obj.entity  if obj.entity
    string += "-v#{obj.version}"  if obj.version?
    if obj.syntax?
      if obj.entity? and obj.entity isnt obj.syntax
        string += "+#{obj.syntax}"
      else
        string += "#{obj.syntax}"
    string


  Object.defineProperty @::, 'media',
    get: () ->
      @ast.value
    set: (value) ->
      @ast.value = value


  Object.defineProperty @::, 'type',
    get: () ->
      @media.type
    set: (value) ->
      @media.type = value


  Object.defineProperty @::, 'subtype',
    get: () ->
      @media.subtype
    set: (value) ->
      {
        subtype
        entity
        version
        syntax
      } = @_parseSubtype value
      _.assign @media, {
        subtype
        entity
        version
        syntax
      }


  Object.defineProperty @::, 'entity',
    get: () ->
      @media.entity
    set: (value) ->
      @subtype =
        entity: value
        syntax: (value  if @syntax is @entity)


  Object.defineProperty @::, 'version',
    get: () ->
      @media.version
    set: (value) ->
      @subtype =
        version: value


  Object.defineProperty @::, 'syntax',
    get: () ->
      @media.syntax
    set: (value) ->
      @subtype =
        syntax: value
        entity: (value  if @syntax is @entity)


  Object.defineProperty @::, 'params',
    get: () ->
      @mediaParams


  Object.defineProperty @::, 'mediaParams',
    get: () ->
      @media.parameters
    set: (value) ->
      @media.parameters = value


  mediaParam: (attribute, value) ->
    for param, index in @mediaParams
      continue  unless param.attribute is attribute
      if value?
        return param.value = value
      else if value is null
        @mediaParams.splice index, 1
        return value
      else
        return param.value
    if value?
      ast = {
        __type: 'parameter'
        attribute
        value
      }
      return @mediaParams.push ast
    undefined


  equals: (item, superset = false) ->
    item = new @constructor item  unless item instanceof @constructor
    return false  unless @type is item.type
    return false  unless @subtype is item.subtype
    superset = superset and @mediaPparams.length > item.mediaParams.length
    return false  unless superset or @mediaParams.length is item.mediaParams.length
    for itemParam in item.mediaParams
      param = _.first _.filter @mediaParams, itemParam
      return false  unless param?
    true


  contains: (item) ->
    @equals item, true


  toString: () ->
    {
      type
      subtype
    } = @media
    result = [
      "#{type}/#{subtype}"
    ]
    for param in @params
      {
        attribute
        value
      } = param
      if value?
        try
          @_parserToken value
        catch e
          value = "\"#{value}\""
      value = "=#{value}"  if value?
      result.push "#{attribute}#{value}"
    result = result.join @_paramSep
    result
