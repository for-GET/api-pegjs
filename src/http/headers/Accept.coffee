{
  _
} = require '../../util'
{
  httpbis_p1
  httpbis_p2
} = require '../../parsers'
AcceptItem = require './AcceptItem'

module.exports = class Accept
  _AcceptItem: AcceptItem
  _itemSep: ','
  ast: undefined


  constructor: (source) ->
    if _.isString source
      @ast = @_parse source
    else if source?
      @ast = source
    else
      @ast = @_defaultAst()


  _defaultAst: () ->
    {
      __type: 'Accept'
      value: []
    }


  _parse: (string) ->
    parsed = httpbis_p2.Accept string
    parsed.value = parsed.value.map (item) => new @_AcceptItem item
    parsed


  Object.defineProperty @::, 'items',
    get: () ->
      @ast.value
    set: (value) ->
      value = value.map (item) =>
        return item  if item instanceof @_AcceptItem
        new @_AcceptItem item
      @ast.value = value


  add: (item) ->
    item = new @_AcceptItem item  unless item instanceof @_AcceptItem
    @items.push item


  remove: (item) ->
    item = new @_AcceptItem item  unless item instanceof @_AcceptItem
    # FIXME


  matches: (ContentType) ->
    for item in @items
      score = item.matches ContentType
      return score  if score
    false


  prefers: (ContentTypes, returnBest = false) ->
    result = []
    for ContentType in ContentTypes
      best = {
        score: 0
      }
      for item in @items
        score = item.matches ContentType
        if score > best.score
          best = {
            item
            ContentType
            score
          }
      result.push best  if best.score
    return result  unless returnBest
    _.last _.sortBy result, 'score'


  prefersOne: (ContentTypes) ->
    @prefers ContentTypes, true


  toString: () ->
    result = @items.map (item) -> item.toString()
    result = result.join @_itemSep
    result
