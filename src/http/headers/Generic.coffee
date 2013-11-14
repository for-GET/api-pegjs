AbstractBase = require '../../abstract/Base'

module.exports = class Generic extends AbstractBase
  _type: 'Generic'


  Object.defineProperty @::, 'value',
    get: () ->
      @ast.value
    set: (value) ->
      @ast.value = value