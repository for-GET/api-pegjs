misc = require './misc'

PEG = require('core-pegjs')['RFC/httpbis_p1']

allowedStartRules =
  HTTP_version: 'version'
  method: null

rules =
  HTTP_version: () ->
    console.log $result
    {
      major: $result[2]
      minor: $result[4]
    }

module.exports = misc.buildParser PEG, rules, allowedStartRules
