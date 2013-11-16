# Do not run this suite unless specifically runnings test pools
return  unless process.env.TEST_POOLS

{
  should
  loadTestcases
  pctEncode
  parserShouldNotThrow
} = require '../_utils'
parsers =
  uri: require '../../src/core/ietf/rfc3986_uri'
  httpbis_p1: require '../../src/core/ietf/draft-ietf-httpbis-p1-messaging'
  httpbis_p2: require '../../src/core/ietf/draft-ietf-httpbis-p2-semantics'
  httpbis_p4: require '../../src/core/ietf/draft-ietf-httpbis-p4-conditional'
cb = ({file, name, content}) ->
  content = JSON.parse(content).log.entries
  content

pushUnique = (item, bucket) ->
  bucket.push item  if item? and item not in bucket

fixHAR = (type, input) ->
  # FIXME tampering with the samples
  if type is 'url'
    # URLs are apparently not using point encoding
    url = input
    url = pctEncode(/[%\[\]\{\}\|]/g) url
    url
  else
    input

uniqueTestcases = (testcases) ->
  content = {
    request:
      method: []
      url: []
      version: []
      headers: {}
    response:
      redirectURL: []
      status: []
      statusText: []
      version: []
      headers: []
  }
  for testcase in testcases
    for {request, response} in testcase.content
      # Ignore data: requests
      continue  if request.url.indexOf('data:') is 0
      # Ignore status:0 responses
      continue  if response.status is 0

      pushUnique request.method, content.request.method
      pushUnique fixHAR('url', request.url), content.request.url
      pushUnique request.version, content.request.version
      for header in request.headers
        content.request.headers[header.name] ?= []
        header.value = fixHAR 'url', header.value  if header.name.toLowerCase() in ['referer']
        pushUnique header.value, content.request.headers[header.name]

      pushUnique fixHAR('url', response.redirectURL), content.response.redirectURL
      pushUnique response.status.toString(), content.response.status
      pushUnique response.statusText, content.response.statusText
      pushUnique response.version, content.response.version
      for header in response.headers
        content.response.headers[header.name] ?= []
        header.value = fixHAR 'url', header.value  if header.name.toLowerCase() in ['location']
        pushUnique header.value, content.response.headers[header.name]
  content
testcases = uniqueTestcases loadTestcases {dir: 'http_samples', pattern: '**/*.har', cb}


http_sample_it = ({section, parser, inputs}) ->
  for input in inputs
    inputDesc = input.toString()#.replace("\r", "").replace("\n", "").substr 0, 50
    it "#{section} (#{inputDesc})", parserShouldNotThrow {parser, input}


describe 'pool.http_samples', () ->
  # method
  http_sample_it {
    section: 'request.method'
    parser: parsers.httpbis_p1 {startRule: 'method'}
    inputs: testcases.request.method
  }
  # URI
  http_sample_it {
    section: 'request.url'
    parser: parsers.uri {startRule: 'URI'}
    inputs: testcases.request.url
  }
  # URI_reference
  http_sample_it {
    section: 'response.redirectURL'
    parser: parsers.uri {startRule: 'URI_reference'}
    inputs: testcases.response.redirectURL
  }
  # HTTP_version
  http_sample_it {
    section: 'request.version'
    parser: parsers.httpbis_p1 {startRule: 'HTTP_version'}
    inputs: testcases.request.version
  }
  http_sample_it {
    section: 'response.version'
    parser: parsers.httpbis_p1 {startRule: 'HTTP_version'}
    inputs: testcases.request.version
  }
  # status_code
  http_sample_it {
    section: 'response.status'
    parser: parsers.httpbis_p1 {startRule: 'status_code'}
    inputs: testcases.response.status
  }
  # reason_phrase
  http_sample_it {
    section: 'response.statusText'
    parser: parsers.httpbis_p1 {startRule: 'reason_phrase'}
    inputs: testcases.response.statusText
  }
  # headers
  for direction in ['request', 'response']
    for header, inputs of testcases[direction].headers
      # Ignore some poorly used headers
      # FIXME CHECKME
      continue  if header.toLowerCase() in ['date', 'etag', 'server', 'via']

      parser = undefined
      for parserGroup in ['httpbis_p1', 'httpbis_p2', 'httpbis_p4']
        parser ?= parsers[parserGroup] {startRule: header.replace(/\-/g, '_')}
      continue  unless parser?

      http_sample_it {
        section: "#{direction}.headers.#{header}"
        parser
        inputs
      }
