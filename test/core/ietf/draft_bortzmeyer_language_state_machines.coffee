{
  should
  loadTestcases
  runTestcase
  thisModule
} = require '../../_utils'
cosmogol = thisModule['core/ietf/draft-bortzmeyer-language-state-machines']
testcases = loadTestcases {dir: 'api-pegjs-test/draft-bortzmeyer-language-state-machines'}

describe 'draft-bortzmeyer-language-state-machines', runTestcase cosmogol, testcases