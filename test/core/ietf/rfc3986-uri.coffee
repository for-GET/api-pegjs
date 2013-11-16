{
  should
  loadTestcases
  runTestcase
  thisModule
} = require '../../_utils'
uri = thisModule['core/ietf/rfc3986-uri']
testcases = loadTestcases {dir: 'api-pegjs-test/rfc3986-uri'}

describe 'rfc3986-uri', runTestcase uri, testcases
