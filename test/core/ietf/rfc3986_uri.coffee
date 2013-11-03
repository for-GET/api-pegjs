{
  should
  loadTestcases
  runTestcase
  thisModule
} = require '../../_utils'
uri = thisModule['core/ietf/rfc3986_uri']
testcases = loadTestcases {dir: 'api-pegjs-test/rfc3986_uri'}

describe 'rfc3986_uri', runTestcase uri, testcases
