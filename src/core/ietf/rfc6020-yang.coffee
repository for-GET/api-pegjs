{
  createModule
} = require './_misc'
grammar = require('core-pegjs') 'ietf/rfc6020-yang'


rules = {}

module.exports = createModule {grammar, rules}
