_ = require 'lodash'
AbstractBase = require '../../../abstract/Base'

module.exports = class MixinAccept extends AbstractBase
  _AcceptItemClass: undefined
  _itemSep: ','


  _parse: (string) ->
    parsed = super
    parsed.items = parsed.items.map (AcceptItem) => new @_AcceptItemClass AcceptItem
    parsed


  Object.defineProperty @::, 'items',
    get: () ->
      @ast.items
    set: (items) ->
      items = items.map (AcceptItem) =>
        return AcceptItem  if AcceptItem instanceof @_AcceptItemClass
        new @_AcceptItemClass AcceptItem
      @ast.items = items


  add: (Item) ->
    Item = new @_AcceptItemClass item  unless Item instanceof @_AcceptItemClass
    @items.push Item


  remove: (Item) ->
    Item = new @_AcceptItemClass Item  unless Item instanceof @_AcceptItemClass
    @items = _.reject @items, (AcceptItem) ->
      AcceptItem.matches Item


  matches: (Item) ->
    for AcceptItem in @items
      score = AcceptItem.matches Item
      return score  if score
    false


  prefers: (Items, returnBest = false) ->
    result = []
    for Item in Items
      best = {
        score: 0
      }
      for AcceptItem in @items
        Item = AcceptItem.matchItem Item
        score = AcceptItem.matches Item
        if score > best.score
          best = {
            AcceptItem
            Item
            score
          }
      result.push best  if best.score
    return result  unless returnBest
    _.last _.sortBy result, 'score'


  prefersOne: (Item) ->
    @prefers Item, true


  toString: () ->
    result = @items.map (AcceptItem) -> AcceptItem.toString()
    result = result.join @_itemSep
    result
