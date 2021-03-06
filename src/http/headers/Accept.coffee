{
  _
  core
} = require '../../_misc'
_parser = core {
  pegModule: 'ietf/draft-ietf-httpbis-p2-semantics'
  startRule: 'Accept'
}
AcceptItem = require './AcceptItem'
MixinAccept = require './mixin/Accept'
AbstractBase = require '../../abstract/Base'

module.exports = class Accept extends AbstractBase
  @mixin MixinAccept

  _AcceptItemClass: AcceptItem
  _parser: _parser
  _type: 'Accept'


  _defaultAst: () ->
    {
      __type: @_type
      value: []
    }
