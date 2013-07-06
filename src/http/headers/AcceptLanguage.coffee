{
  httpbis_p2
} = require '../../parsers'
AcceptLanguageItem = require './AcceptLanguageItem'
MixinAccept = require './mixin/Accept'
AbstractBase = require './abstract/Base'

module.exports = class Accept extends AbstractBase
  @mixin MixinAccept
  _type: 'Accept_Language'

  _AcceptItemClass: AcceptLanguageItem
  _parser: httpbis_p2.AcceptLanguage


  _defaultAst: () ->
    {
      __type: @_type
      value: []
    }
