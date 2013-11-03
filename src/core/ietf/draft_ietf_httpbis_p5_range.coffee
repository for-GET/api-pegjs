{
  createModule
} = require './_misc'
PEG = require('core-pegjs')['ietf/draft_ietf_httpbis_p5_range']


rules = {}

mixins = [
  require('./draft_ietf_httpbis_p4_conditional')._.rules
]
module.exports = createModule {PEG, rules, mixins}
