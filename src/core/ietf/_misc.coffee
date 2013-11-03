{_} = misc = require '../_misc'

module.exports = _.assign {}, misc, {
  zeroOrMoreHTTP: () ->
    items = __result[0]?[1] or []
    items = items.map (item) -> item[2]?[1]
    head = __result[0]?[0]
    items.unshift head  if head
    {
      __type: __ruleName
      items
    }


  oneOrMoreHTTP: () ->
    items = __result[2] or []
    items = items.map (item) -> item[2]?[1]
    head = __result[1]
    items.unshift head  if head
    {
      __type: __ruleName
      items
    }


  oneOrMoreTCN: () ->
    items = __result[1] or []
    items = items.map (item) -> item[1]
    head = __result[0]
    items.unshift head  if head
    {
      __type: __ruleName
      items
    }
}