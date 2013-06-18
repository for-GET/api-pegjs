{
  _
} = require '../../util'
{
  httpbis_p1
  httpbis_p2
} = require '../../parsers'
ContentType = require './ContentType'

module.exports = class AcceptItem extends ContentType
  _ContentType: ContentType


  _defaultAst: () ->
    {
      __type: 'Accept_item_'
      media_range:
        __type: 'media_range'
        type: '*'
        subtype: '*'
        parameters: []
      accept_params: []
    }


  _parse: (string) ->
    parsed = httpbis_p2.Accept_item_ string
    return  unless parsed
    media = parsed.media_range
    _.assign media, @_parseSubtype media.subtype
    parsed


  Object.defineProperty @::, 'media',
    get: () ->
      @ast.media_range
    set: (value) ->
      @ast.media_range = value


  Object.defineProperty @::, 'params',
    get: () ->
      @mediaParams.concat @acceptParams


  Object.defineProperty @::, 'q',
    get: () ->
      @acceptParam('q') || '1'
    set: (value) ->
      @acceptParam 'q', value


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


  matches: (ContentType) ->
    ContentType = new @_ContentType ContentType  unless ContentType instanceof @_ContentType

    # Count weight
    score = @q * 100000

    # Count type
    return false  unless @type in ['*', ContentType.type]
    score += 1000

    # Count subtype
    return false  unless @subtype in ['*', ContentType.subtype]
    score += 100

    # Accept more specific media-types than the range
    subset = @mediaParams.length < ContentType.mediaParams.length
    return false  unless subset or @mediaParams.length is ContentType.mediaParams.length

    # Count specificity
    score += ContentType.mediaParams.length - @mediaParams.length
    for param in @mediaParams
      itemParam = _.first _.filter ContentType.params, param
      return false  unless itemParam?
      score += 1

    score
