{
  should
  loadTestcases
  runTestcase
  thisModule
} = require '../../_utils'
httpbis_p1 = thisModule 'core/ietf/draft-ietf-httpbis-p1-messaging'
testcases = loadTestcases {dir: 'api-pegjs-test/draft_ietf_httpbis_p1_messaging'}

describe 'draft-ietf-httpbis-p1-messaging', runTestcase httpbis_p1, testcases