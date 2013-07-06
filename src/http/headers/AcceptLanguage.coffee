{
  httpbis_p2
} = require '../../parsers'
AcceptLanguageItem = require './AcceptLanguageItem'
MixinAccept = require './mixin/Accept'
AbstractBase = require './abstract/Base.coffee'

module.exports = class Accept extends AbstractBase
  @mixin MixinAccept

  _AcceptItemClass: AcceptLanguageItem
  _parser: httpbis_p2.Language


  _defaultAst: () ->
    {
      __type: 'Language'
      value: []
    }
