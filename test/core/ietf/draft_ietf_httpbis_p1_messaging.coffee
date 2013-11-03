{
  should
  loadTestcases
  runTestcase
  thisModule
} = require '../../_utils'
httpbis_p1 = thisModule['core/ietf/draft_ietf_httpbis_p1_messaging']
testcases = loadTestcases {dir: 'api-pegjs-test/draft_ietf_httpbis_p1_messaging'}

describe 'draft_ietf_httpbis_p1_messaging', runTestcase httpbis_p1, testcases