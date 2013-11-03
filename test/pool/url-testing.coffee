# Do not run this suite unless specifically runnings test pools
return  unless process.env.TEST_POOLS

{
  should
  loadTestcases
  pctEncode
  parserShouldNotThrow
} = require '../_utils'
uri = require '../../src/core/ietf/rfc3986_uri'
cb = ({file, name, content}) ->
  groups = content.tests.group
  content = []
  for group in groups
    for test in group.test
      input = test.expect_url
      continue  unless input?
      # FIXME tampering with the samples
      # Ignore some groups
      if group.name in [
        'ipv6'
        'idna2003'
        'idna2008'
        'whitespace'
        'anchor'
        'port'
        'miscellaneous'
        'percent-encoding'
        'standard-url'
        'mailto'
      ]
        continue
      # URI having non point-encoded
      # Point encoded - invalid, slash
      input = input.replace /%2$/g, '/'
      input = input.replace /%2[^0-9A-Fa-f]/g, (item) -> '/%' + item[2]
      input = input.replace /%.[a-f]/g, (item) -> item.toUpperCase()
      input = input.replace /%[a-f]./g, (item) -> item.toUpperCase()
      input = input.replace /%[^0-9A-Fa-f]/g, (item) -> '%25' + item[1]
      input = input.replace /%$/g, '%25'
      # Trailing slash
      input = input.replace /\/$/g, ''
      # Misc
      continue  if /\uFFFD/.test input
      continue  if group.name is 'host' and test.id in ['25', '31', '45']
      content.push ["#{group.name}.#{test.id}", input]
  content
testcases = loadTestcases {dir: 'url-testing', pattern: 'urls*.json', cb}

describe.only 'pool.url-testing', () ->
  for {file, name, content} in testcases
    for [description, input] in content
      parser = uri {startRule: 'URI'}
      inputDesc = input.toString()#.replace("\r", "").replace("\n", "").substr 0, 50
      it "#{name}.#{description} (#{inputDesc})", parserShouldNotThrow {parser, input}
