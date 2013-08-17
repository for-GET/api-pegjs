{
  should
} = require '../../_utils'
httpbis_p1 = require '../../../src/core/ietf/draft_ietf_httpbis_p1_messaging'

describe 'draft_ietf_httpbis_p1_messaging', () ->

  describe 'version', () ->
    it 'should parse common versions', () ->
      httpbis_p1.version('HTTP/1.1').should.eql {
        __type: 'version'
        major: '1'
        minor: '1'
      }


  describe 'message', () ->
    # FIXME
    it.skip 'should parse simple request messages', () ->
      httpbis_p1.message('GET /qwe HTTP/1.1\r\nAccept: text/plain\r\n\r\n').should.eql [
        '__type'
        'subtype'
        'line'
        'headers'
        'body'
      ]


  describe 'request_line', () ->
    it 'should parse common request_lines', () ->
      httpbis_p1.request_line('GET /qwe HTTP/1.1\r\n').should.eql {
        __type: 'request_line'
        method: 'GET'
        target: '/qwe'
        version: {
          __type: 'version'
          major: '1'
          minor: '1'
        }
      }


  describe 'method', () ->
    it 'should parse common methods'


  describe 'response_line', () ->
    it 'should parse common response_lines', () ->
      httpbis_p1.response_line('HTTP/1.1 200 OK\r\n').should.eql {
        __type: 'response_line'
        version: {
          __type: 'version'
          major: '1'
          minor: '1'
        }
        status_code: '200'
        reason_phrase: 'OK'
      }


  describe 'status_code', () ->
    it 'should parse common status codes'


  describe 'reason_phrase', () ->
    it 'should parse common reason phrases'


  describe 'header', () ->
    it 'should parse common headers'


  describe 'Upgrade', () ->
    it 'should parse common Upgrade headers', () ->
      httpbis_p1.Upgrade('HTTP/2.0,HTTP/1.1').should.eql
        __type: "Upgrade"
        value: [
          __type: "protocol"
          name: "HTTP"
          version: "2.0"
        ,
          __type: "protocol"
          name: "HTTP"
          version: "1.1"
        ]

  describe.skip 'Via', () ->
    it 'should parse common Via headers', () ->
      a = httpbis_p1.Via('HTTP 123qwe (test)')
      console.error JSON.stringify a, null, 2
