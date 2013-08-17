httpbis_p2 = require '../../ietf/draft_ietf_httpbis_p2_semantics'
AcceptLanguageItem = require './AcceptLanguageItem'
MixinAccept = require './mixin/Accept'
AbstractBase = require '../../abstract/Base'

module.exports = class Accept extends AbstractBase
  @mixin MixinAccept

  _AcceptItemClass: AcceptLanguageItem
  _parser: httpbis_p2.AcceptLanguage
  _type: 'Accept_Language'


  _defaultAst: () ->
    {
      __type: @_type
      value: []
    }
