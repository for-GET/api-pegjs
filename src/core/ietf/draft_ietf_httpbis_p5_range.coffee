{
  _
  buildParser
} = require './_misc'
PEG = require('core-pegjs')['ietf/draft_ietf_httpbis_p5_range']


startRules = [
  'If_Range'
]


rules = {}

rules = _.defaults(
  rules,
  require('./draft_ietf_httpbis_p4_conditional')._.rules
)

module.exports = buildParser {PEG, rules, startRules}
