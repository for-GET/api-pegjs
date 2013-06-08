{
  _
} = require '../../util'
{
  httpbis_p1
  httpbis_p2
} = require '../../parsers'

module.exports = class AcceptItem
  _value: undefined


  constructor: (string) ->
    @_value = @_parse string  if string


  _parse: (string) ->
    parsed = httpbis_p2.Accept_item_ string
    return  unless parsed
    {
      entity
      version
      syntax
    } = @_parseSubtype parsed.media_range.subtype
    _.assign parsed.media_range, {
      entity
      version
      syntax
    }
    parsed


  _parseSubtype: (string) ->
    string = @_subtypeObjToString string  unless _.isString string
    parsed = httpbis_p2.media_subtype string
    return string  unless parsed
    parsed.subtype = string
    parsed


  _subtypeObjToString: (obj) ->
    obj = _.merge {}, @_value.media_range, obj
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
      @_value.media_range.type
    set: (type) ->
      @_value.media_range.type = type


  Object.defineProperty @::, 'subtype',
    get: () ->
      @_value.media_range.subtype
    set: (subtype) ->
      {
        subtype
        entity
        version
        syntax
      } = @_parseSubtype subtype
      _.assign @_value.media_range, {
        subtype
        entity
        version
        syntax
      }


  Object.defineProperty @::, 'entity',
    get: () ->
      @_value.media_range.entity
    set: (entity) ->
      if @_value.media_range.entity is @_value.media_range.syntax
        syntax = entity
      @subtype = {entity, syntax}


  Object.defineProperty @::, 'version',
    get: () ->
      @_value.media_range.version
    set: (version) ->
      @subtype = {version}


  Object.defineProperty @::, 'syntax',
    get: () ->
      @_value.media_range.syntax
    set: (syntax) ->
      if @_value.media_range.entity is @_value.media_range.syntax
        entity = syntax
      @subtype = {entity, syntax}


  mediaParam: (attribute, value) ->
    for parameter, index in @_value.media_range.parameters
      continue  unless parameter.attribute is attribute
      if value?
        return parameter.value = value
      else if value is null
        @_value.media_range.parameters.splice index, 1
        return value
      else
        return parameter.value
    if value?
      @_value.media_range.parameters.push {
        attribute
        value
      }
    undefined


  acceptParam: (attribute, value) ->
    for parameter, index in @_value.accept_params
      continue  unless parameter.attribute is attribute
      if value?
        return parameter.value = value
      else if value is null
        @_value.accept_params.splice index, 1
        return value
      else
        return parameter.value
    if value?
      @_value.accept_params.push {
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
    } = @_value.media_range
    result = [
      "#{type}/#{subtype}"
    ]
    parameters = parameters.concat @_value.accept_params
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
    result = result.join ';'
    result
