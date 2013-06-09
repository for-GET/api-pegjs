{
  _
} = require '../../util'
{
  httpbis_p1
  httpbis_p2
} = require '../../parsers'

module.exports = class AcceptItem
  _ast: undefined
  _paramSep: ';'


  constructor: (source) ->
    if _.isString source
      @_ast = @_parse source
    else if source?
      @_ast = source
    else
      @_ast =
        __type: 'Accept_item_'
        media_range:
          __type: 'media_range'
          type: '*'
          subtype: '*'
          parameters: []
        accept_params: []
    _.assign @_ast.media_range, @_parseSubtype @_ast.media_range.subtype


  _parse: (string) ->
    parsed = httpbis_p2.Accept_item_ string
    return  unless parsed
    _.assign parsed.media_range, @_parseSubtype parsed.media_range.subtype
    parsed


  _parseSubtype: (string) ->
    string = @_subtypeObjToString string  unless _.isString string
    parsed = httpbis_p2.media_subtype string
    return string  unless parsed
    parsed.subtype = string
    parsed


  _subtypeObjToString: (obj) ->
    obj = _.merge {}, @_ast.media_range, obj
    string = ''
    string += obj.entity  if obj.entity
    string += "-v#{obj.version}"  if obj.version?
    if obj.syntax?
      if obj.entity? and obj.entity isnt obj.syntax
        string += "+#{obj.syntax}"
      else
        string += "#{obj.syntax}"
    string


  Object.defineProperty @::, 'type',
    get: () ->
      @_ast.media_range.type
    set: (type) ->
      @_ast.media_range.type = type


  Object.defineProperty @::, 'subtype',
    get: () ->
      @_ast.media_range.subtype
    set: (subtype) ->
      {
        subtype
        entity
        version
        syntax
      } = @_parseSubtype subtype
      _.assign @_ast.media_range, {
        subtype
        entity
        version
        syntax
      }


  Object.defineProperty @::, 'entity',
    get: () ->
      @_ast.media_range.entity
    set: (entity) ->
      if @_ast.media_range.entity is @_ast.media_range.syntax
        syntax = entity
      @subtype = {entity, syntax}


  Object.defineProperty @::, 'version',
    get: () ->
      @_ast.media_range.version
    set: (version) ->
      @subtype = {version}


  Object.defineProperty @::, 'syntax',
    get: () ->
      @_ast.media_range.syntax
    set: (syntax) ->
      if @_ast.media_range.entity is @_ast.media_range.syntax
        entity = syntax
      @subtype = {entity, syntax}


  mediaParam: (attribute, value) ->
    for parameter, index in @_ast.media_range.parameters
      continue  unless parameter.attribute is attribute
      if value?
        return parameter.value = value
      else if value is null
        @_ast.media_range.parameters.splice index, 1
        return value
      else
        return parameter.value
    if value?
      @_ast.media_range.parameters.push {
        __type: 'parameter'
        attribute
        value
      }
    undefined


  acceptParam: (attribute, value) ->
    for parameter, index in @_ast.accept_params
      continue  unless parameter.attribute is attribute
      if value?
        return parameter.value = value
      else if value is null
        @_ast.accept_params.splice index, 1
        return value
      else
        return parameter.value
    if value?
      @_ast.accept_params.push {
        __type: 'accept_ext'
        attribute
        value
      }
    undefined


  prefers: (AcceptItem) ->


  matches: (AcceptItem) ->


  toString: () ->
    {
      type
      subtype
      parameters
    } = @_ast.media_range
    result = [
      "#{type}/#{subtype}"
    ]
    parameters = parameters.concat @_ast.accept_params
    for parameter in parameters
      {
        attribute
        value
      } = parameter
      try
        httpbis_p1.token value
      catch e
        value = "\"value\""
      result.push "#{attribute}=#{value}"
    result = result.join @_paramSep
    result
