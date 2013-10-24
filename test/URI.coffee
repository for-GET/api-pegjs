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
    u.hostname.should.equal '127.0.0.1'
    u.port.should.eql '80'
    u.path.should.equal '/qwe'
    u.query.should.equal 'qwe=qwe'
    u.fragment.should.equal 'qwe=qwe'

  it 'should cast to string', () ->
    u = new URI 'http://127.0.0.1:80/qwe?qwe=qwe#qwe=qwe'
    u.toString().should.eql 'http://127.0.0.1:80/qwe?qwe=qwe#qwe=qwe'
