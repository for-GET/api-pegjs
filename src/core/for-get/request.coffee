{
  _
  createModule
} = require '../_misc'
{PEG, rules} = require('../ietf/draft-ietf-httpbis-p1-messaging')._

rules = _.assign {}, rules, {
  HTTP_version: null
  target: null
}

module.exports = createModule {PEG, rules}
