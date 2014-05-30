{
  should
  loadTestcases
  runTestcase
  thisModule
} = require '../../_utils'
httpbis_p5 = thisModule 'core/ietf/draft-ietf-httpbis-p5-range'
testcases = loadTestcases {dir: 'api-pegjs-test/draft_ietf_httpbis_p5_range'}

describe 'draft-ietf-httpbis-p5-range', runTestcase httpbis_p5, testcases
