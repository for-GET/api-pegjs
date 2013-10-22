{
  should
  loadTestcases
  runTestcase
} = require '../../_utils'
uri = require '../../../src/core/ietf/rfc3986_uri'
testcases = loadTestcases {dir: 'api-pegjs-test/rfc3986_uri'}

describe 'rfc3986_uri', runTestcase uri, testcases
