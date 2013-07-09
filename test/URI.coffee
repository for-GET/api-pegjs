{
  should
} = require './_utils'
URI = require '../src/URI'

describe 'URI', () ->
  it 'should parse common URIs', () ->
    u = new URI 'http://127.0.0.1:80/qwe?qwe=qwe#qwe=qwe'
    u.scheme.should.eql 'http'
    u.protocol.should.eql 'http:'
    u.slashes.should.eql '//'
    u.hostname.should.eql '127.0.0.1'
    u.port.should.eql '80'
    u.path.should.eql '/qwe'
    u.query.should.eql 'qwe=qwe'
    u.fragment.should.eql 'qwe=qwe'

  it 'should cast to string', () ->
    u = new URI 'http://127.0.0.1:80/qwe?qwe=qwe#qwe=qwe'
    u.toString().should.eql 'http://127.0.0.1:80/qwe?qwe=qwe#qwe=qwe'
