_ = require 'lodash'

module.exports = class SuperObject
  @_superObjectProps: [
    '_superObjectProps'
    'constructor'
    'mixin'
  ]


  @mixin: (klass, props) ->
    props ?= Object.getOwnPropertyNames klass::
    props = _.difference props, @_superObjectProps
    for prop in props
      descriptor = Object.getOwnPropertyDescriptor klass::, prop
      Object.defineProperty @::, prop, descriptor
    @
