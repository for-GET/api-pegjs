{
  _
  createModule
} = require '../_misc'
{grammar, rules} = require('../ietf/draft-ietf-httpbis-p1-messaging')._

rules = _.assign {}, rules, {
  HTTP_version: null
}

module.exports = createModule {grammar, rules}
