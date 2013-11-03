_ = require 'lodash'
httpbis_p2 = require '../../core/ietf/draft_ietf_httpbis_p2_semantics'
MixinAcceptItem = require './mixin/AcceptItem'
ContentType = require './ContentType'

module.exports = class AcceptItem extends ContentType
  @mixin MixinAcceptItem

  _ItemClass: ContentType
  _parser: httpbis_p2 {startRule: 'Accept_item_'}
  _type: 'Accept_item_'


  _defaultAst: () ->
    {
      __type: @_type
      media_range:
        __type: 'media_range'
        type: '*'
        subtype: '*'
        parameters: []
      accept_params: []
    }


  _parse: (string) ->
    parsed = ContentType.__super__._parse.call @, string
    return  unless parsed
    _.assign parsed.media_range, @_parseSubtype parsed.media_range.subtype
    parsed


  Object.defineProperty @::, 'media',
    get: () ->
      @ast.media_range
    set: (value) ->
      @ast.media_range = value


  matches: (Item) ->
    Item = @matchItem Item

    # Count weight
    score = @q * 100000

    # Count type
    return false  unless @type in ['*', Item.type]
    score += 1000

    # Count subtype
    return false  unless @subtype in ['*', Item.subtype]
    score += 100

    # Accept more specific media-types than the range
    subset = @mediaParams.length < Item.mediaParams.length
    return false  unless subset or @mediaParams.length is Item.mediaParams.length

    # Count specificity
    score += Item.mediaParams.length - @mediaParams.length
    for param in @mediaParams
      itemParam = _.first _.filter Item.params, param
      return false  unless itemParam?
      score += 1

    score


  matchItem: (Item) ->
    Item = new @_ItemClass Item  unless Item instanceof @_ItemClass
    Item
