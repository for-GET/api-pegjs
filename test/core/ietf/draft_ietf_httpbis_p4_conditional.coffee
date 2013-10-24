{
  should
  loadTestcases
  runTestcase
} = require '../../_utils'
httpbis_p4 = require '../../../src/core/ietf/draft_ietf_httpbis_p4_conditional'
testcases = loadTestcases {dir: 'api-pegjs-test/draft_ietf_httpbis_p4_conditional'}

describe 'draft_ietf_httpbis_p4_conditional', runTestcase httpbis_p4, testcases
