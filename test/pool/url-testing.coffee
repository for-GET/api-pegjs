# Do not run this suite unless specifically allowing warnings
return  unless process.env.MOCHA_WARNINGS

{
  should
  loadTestcases
  pctEncode
} = require '../_utils'
uri = require '../../src/core/ietf/rfc3986_uri'
cb = ({file, name, content}) ->
  groups = content.tests.group
  content = []
  for group in groups
    for test in group.test
      content.push ["#{group.name}.#{test.id}", test.expect_url]
  content
testcases = loadTestcases {dir: 'url-testing', pattern: 'urls*.json', cb}

describe.only 'pool.url-testing', () ->
  for {file, name, content} in testcases
    for [description, input] in content
      inputDesc = input.toString()#.replace("\r", "").replace("\n", "").substr 0, 50
      it "#{name}.#{description} (#{inputDesc})", parserShouldNotThrow {parser, input}
