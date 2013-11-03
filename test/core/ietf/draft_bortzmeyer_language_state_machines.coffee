{
  should
  loadTestcases
  runTestcase
  thisModule
} = require '../../_utils'
cosmogol = thisModule['core/ietf/draft_bortzmeyer_language_state_machines']
testcases = loadTestcases {dir: 'api-pegjs-test/draft_bortzmeyer_language_state_machines'}

describe 'draft_bortzmeyer_language_state_machines', runTestcase cosmogol, testcases