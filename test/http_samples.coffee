{
  should
  loadTestcases
} = require './_utils'
parsers =
  uri: require '../src/core/ietf/rfc3986_uri'
  httpbis_p1: require '../src/core/ietf/draft_ietf_httpbis_p1_messaging'
  httpbis_p2: require '../src/core/ietf/draft_ietf_httpbis_p2_semantics'
cb = ({file, name, content}) ->
  content = JSON.parse content
  content
testcases = loadTestcases {dir: 'http_samples', pattern: '**/*.har', cb}


parserShouldNotThrow = ({parser, input}) ->
  () ->
    fun = () ->
      parser input
    fun.should.not.Throw()  if input isnt undefined


describe 'http_samples', do () ->
  parsers_ = parsers
  testcases_ = testcases
  parserShouldNotThrow_ = parserShouldNotThrow
  () ->
    for testcase in testcases
      {file, name, content} = testcase
      describe name, do () ->
        parsers__ = parsers_
        parserShouldNotThrow__ = parserShouldNotThrow_
        file__ = file
        name__ = name
        content__ = content
        () ->
          for entry in content__.log.entries
            # Ignore data: requests
            continue  if entry.request.url.indexOf('data:') is 0
            # Ignore status:0 responses
            continue  if entry.response.status is 0

            # method
            it "#{name__} method", parserShouldNotThrow__ {
              parser: parsers__.httpbis_p1.method
              input: entry.request.method
            }
            # URI
            it "#{name__} URI", parserShouldNotThrow__ {
              parser: parsers__.uri.URI
              input: entry.request.url
            }
            # URI_reference
            it "#{name__} URI_reference", parserShouldNotThrow__ {
              parser: parsers__.uri.URI_reference
              input: entry.response.redirectURL or undefined
            }
            # HTTP_version
            it "#{name__} HTTP_version (request)", parserShouldNotThrow__ {
              parser: parsers__.httpbis_p1.version
              input: entry.request.httpVersion
            }
            it "#{name__} HTTP_version (response)", parserShouldNotThrow__ {
              parser: parsers__.httpbis_p1.version
              input: entry.response.httpVersion
            }
            # status_code
            it "#{name__} status_code", parserShouldNotThrow__ {
              parser: parsers__.httpbis_p1.status_code
              input: entry.response.status.toString()
            }
            # reason_phrase
            it "#{name__} reason_phrase", parserShouldNotThrow__ {
              parser: parsers__.httpbis_p1.reason_phrase
              input: entry.response.statusText or undefined
            }
            # headers
            for direction in ['request', 'response']
              for header in entry[direction].headers
                parser = parsers__.httpbis_p1[header.name] or parsers__.httpbis_p2[header.name]
                continue  unless parser
                do () ->
                  parser___ = parser
                  input___ = header.value
                  name___ = name__
                  header___ = header.name
                  direction___ = direction
                  it "#{name___} #{header___} (#{direction___})", parserShouldNotThrow__ {
                    parser: parser___
                    input: input___
                  }
