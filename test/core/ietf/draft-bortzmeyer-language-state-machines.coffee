{
  should
  loadTestcases
  runTestcase
  thisModule
} = require '../../_utils'
cosmogol = thisModule 'core/ietf/draft-bortzmeyer-language-state-machines'
testcases = loadTestcases {dir: 'api-pegjs-test/draft_bortzmeyer_language_state_machines'}

describe 'draft-bortzmeyer-language-state-machines', runTestcase cosmogol, testcases