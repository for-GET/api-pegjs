{
  should
  loadTestcases
  runTestcase
  thisModule
} = require '../../_utils'
httpbis_p4 = thisModule 'core/ietf/draft-ietf-httpbis-p4-conditional'
testcases = loadTestcases {dir: 'api-pegjs-test/draft_ietf_httpbis_p4_conditional'}

describe 'draft-ietf-httpbis-p4-conditional', runTestcase httpbis_p4, testcases
