{
  _
  createModule
} = require '../_misc'
{PEG, rules} = require('../ietf/draft_ietf_httpbis_p1_messaging')._

rules = _.assign {}, rules, {
  HTTP_version: null
  target: null
}

module.exports = createModule {PEG, rules}
