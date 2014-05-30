{
  should
  loadTestcases
  runTestcase
  thisModule
} = require '../../_utils'
httpbis_p2 = thisModule 'core/ietf/draft-ietf-httpbis-p2-semantics'
testcases = loadTestcases {dir: 'api-pegjs-test/draft_ietf_httpbis_p2_semantics'}

describe 'draft-ietf-httpbis-p2-semantics', runTestcase httpbis_p2, testcases
