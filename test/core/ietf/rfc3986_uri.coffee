{
  should
} = require '../../_utils'
uri = require '../../../src/core/ietf/rfc3986_uri'

describe '3986_uri', () ->
  describe 'URI', () ->
    it 'should parse common URIs', () ->
      u = uri.URI('http://127.0.0.1:80/qwe?qwe=qwe#qwe=qwe')
      u.should.eql
        __type: 'URI'
        scheme: 'http'
        slashes: '//'
        authority:
          __type: 'authority'
          userinfo: undefined,
          hostname: '127.0.0.1'
          port: '80'
        path: '/qwe'
        query: 'qwe=qwe'
        fragment: 'qwe=qwe'


  describe 'relative_ref', () ->
    it 'should parse common relative references', () ->
      u = uri.relative_ref '/foo/bar?foo=bar#foo=bar'
      u.should.eql
        __type: 'relative_ref'
        slashes: undefined
        authority: undefined
        path: '/foo/bar'
        query: 'foo=bar'
        fragment: 'foo=bar'
