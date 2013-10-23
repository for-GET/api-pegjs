{
  should
  loadTestcases
} = require './_utils'
parsers =
  uri: require '../src/core/ietf/rfc3986_uri'
  httpbis_p1: require '../src/core/ietf/draft_ietf_httpbis_p1_messaging'
  httpbis_p2: require '../src/core/ietf/draft_ietf_httpbis_p2_semantics'
cb = ({file, name, content}) ->
  content = JSON.parse(content).log.entries
  content
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
  pushUnique = (item, bucket) ->
    bucket.push item  unless item is '' or item in bucket
  for testcase in testcases
    for {request, response} in testcase.content
      # Ignore data: requests
      continue  if request.url.indexOf('data:') is 0
      # Ignore status:0 responses
      continue  if response.status is 0

      pushUnique request.method, content.request.method
      pushUnique request.url, content.request.url
      pushUnique request.version, content.request.version
      for header in request.headers
        content.request.headers[header.name] ?= []
        pushUnique header.value, content.request.headers[header.name]

      pushUnique response.redirectURL, content.response.redirectURL
      pushUnique response.status.toString(), content.response.status
      pushUnique response.statusText, content.response.statusText
      pushUnique response.version, content.response.version
      for header in response.headers
        content.response.headers[header.name] ?= []
        pushUnique header.value, content.response.headers[header.name]
  content
testcases = uniqueTestcases loadTestcases {dir: 'http_samples', pattern: '**/*.har', cb}

parserShouldNotThrow = ({parser, input}) ->
  () ->
    fun = () ->
      try
        parser input
      catch e
        throw new Error e.message
    fun.should.not.Throw()  if input isnt undefined


describe 'http_samples', do () ->
  parsers_ = parsers
  testcases_ = testcases
  parserShouldNotThrow_ = parserShouldNotThrow
  () ->
    # method
    for input in testcases_.request.method
      it "request.method #{input}", parserShouldNotThrow_ {
        parser: parsers_.httpbis_p1.method
        input
      }
    # URI
    for input in testcases_.request.url
      it "request.url #{input}", parserShouldNotThrow_ {
        parser: parsers_.uri.URI
        input
      }
    # URI_reference
    for input in testcases_.response.redirectURL
      it "response.redirectURL #{input}", parserShouldNotThrow_ {
        parser: parsers_.uri.URI_reference
        input
      }
    # HTTP_version
    for input in testcases_.request.version
      it "request.version #{input}", parserShouldNotThrow_ {
        parser: parsers_.httpbis_p1.version
        input
      }
    for input in testcases_.response.version
      it "response.version #{input}", parserShouldNotThrow_ {
        parser: parsers_.httpbis_p1.version
        input
      }
    # status_code
    for input in testcases_.response.status
      it "response.status #{input}", parserShouldNotThrow_ {
        parser: parsers_.httpbis_p1.status_code
        input
      }
    # reason_phrase
    for input in testcases_.response.statusText
      it "response.statusText #{input}", parserShouldNotThrow_ {
        parser: parsers_.httpbis_p1.reason_phrase
        input
      }
    # headers
    for direction in ['request', 'response']
      for header, values of testcases_[direction].headers
        for input in values
          parser = parsers_.httpbis_p1[header] or parsers_.httpbis_p2[header]
          continue  unless parser
          it "#{direction}.headers.#{header} #{input}", parserShouldNotThrow_ {
            parser
            input
          }
