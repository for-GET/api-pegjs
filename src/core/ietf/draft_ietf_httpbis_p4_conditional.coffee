{
  createModule
} = require './_misc'
PEG = require('core-pegjs')['ietf/draft_ietf_httpbis_p4_conditional']


rules = {}

mixins = [
  require('./draft_ietf_httpbis_p2_semantics')._.rules
]
module.exports = createModule {PEG, rules, mixins}
