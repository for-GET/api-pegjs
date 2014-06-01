{
  _
  createModule
} = require '../_misc'
grammar = require('core-pegjs') 'for-get/literate-http-apib'


rules = {}

mixins = [
  require('./literate-http')._.rules
]

module.exports = createModule {grammar, rules, mixins}
