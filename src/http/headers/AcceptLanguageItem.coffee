_ = require 'lodash'
{
  httpbis_p2
} = require '../../parsers'
MixinAcceptItem = require './mixin/AcceptItem'
ContentLanguage = require './ContentLanguage'

module.exports = class AcceptLanguageItem extends Language
  @mixin MixinAcceptItem

  _ItemClass: ContentLanguage
  _parser: httpbis_p2.Accept_Language_item_
  _type: 'Accept_Language_item_'


  _defaultAst: () ->
    {
      __type: @_type
      tag: '*'
      accept_params: []
    }


  Object.defineProperty @::, 'media',
    get: () ->
      @ast.media_range
    set: (value) ->
      @ast.media_range = value


  matches: (Item) ->
    Item = new @_ItemClass Item  unless Item instanceof @_ItemClass

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
