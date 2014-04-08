{
  createModule
} = require './_misc'
PEG = require('core-pegjs')['ietf/rfc6020-yang']


rules = {}

module.exports = createModule {PEG, rules}
