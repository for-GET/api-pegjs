{
  should
  loadTestcases
} = require '../../_utils'
cosmogol = require '../../../src/core/ietf/draft_bortzmeyer_language_state_machines'
testcases = loadTestcases {dir: 'api-pegjs-test/draft_bortzmeyer_language_state_machines'}

describe.only 'draft_bortzmeyer_language_state_machines', () ->
  for testcase in testcases
    {file, name, content} = testcase
    describe name, () ->
      for test in content
        [description, input, expected] = test
        it description, () ->
          actual = cosmogol[name] input
          actual.should.eql expected