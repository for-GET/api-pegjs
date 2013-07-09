{
  httpbis_p2
} = require '../../parsers'
AcceptItem = require './AcceptItem'
MixinAccept = require './mixin/Accept'
AbstractBase = require '../../abstract/Base'

module.exports = class Accept extends AbstractBase
  @mixin MixinAccept

  _AcceptItemClass: AcceptItem
  _parser: httpbis_p2.Accept
  _type: 'Accept'


  _defaultAst: () ->
    {
      __type: @_type
      value: []
    }
