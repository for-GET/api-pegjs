httpbis_p2 = require '../../core/ietf/draft_ietf_httpbis_p2_semantics'
AcceptItem = require './AcceptItem'
MixinAccept = require './mixin/Accept'
AbstractBase = require '../../abstract/Base'

module.exports = class Accept extends AbstractBase
  @mixin MixinAccept

  _AcceptItemClass: AcceptItem
  _parser: httpbis_p2 {startRule: 'Accept'}
  _type: 'Accept'


  _defaultAst: () ->
    {
      __type: @_type
      value: []
    }
