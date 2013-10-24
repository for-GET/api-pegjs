{
  _
  buildParser
} = require './_misc'
PEG = require('core-pegjs')['ietf/draft_ietf_httpbis_p4_conditional']


startRules = [
  'Last_Modified'
  'ETag'
  'If_Match'
  'If_None_Match'
  'If_Modified_Since'
  'If_Unmodified_Since'
]


rules = {}

rules = _.defaults(
  rules,
  require('./draft_ietf_httpbis_p2_semantics')._.rules
)

module.exports = buildParser {PEG, rules, startRules}
