{
  should
  thisModule
} = require '../../_utils'
AcceptItem = thisModule['http/headers/AcceptItem']

describe 'AcceptItem', () ->
  it 'should have getters', () ->
    a = new AcceptItem 'application/vnd.example-v1+json;charset=utf-8;q=0.5'
    a.type.should.eql 'application'
    a.subtype.should.eql 'vnd.example-v1+json'
    a.entity.should.eql 'vnd.example'
    a.version.should.eql '1'
    a.syntax.should.eql 'json'
    a.mediaParam('charset').should.eql 'utf-8'
    a.acceptParam('q').should.eql '0.5'


  it 'should have type setter', () ->
    a = new AcceptItem 'application/vnd.example-v1+json;charset=utf-8;q=0.5'
    a.type.should.eql 'application'
    a.type = 'text'
    a.type.should.eql 'text'


  it 'should have subtype setter', () ->
    a = new AcceptItem 'application/vnd.example-v1+json;charset=utf-8;q=0.5'
    a.subtype.should.eql 'vnd.example-v1+json'
    a.entity.should.eql 'vnd.example'
    a.version.should.eql '1'
    a.syntax.should.eql 'json'

    a.subtype = 'vnd.example2-v2+xml'
    a.subtype.should.eql 'vnd.example2-v2+xml'
    a.entity.should.eql 'vnd.example2'
    a.version.should.eql '2'
    a.syntax.should.eql 'xml'


  it 'should have entity setter', () ->
    a = new AcceptItem 'application/vnd.example-v1+json;charset=utf-8;q=0.5'
    a.subtype.should.eql 'vnd.example-v1+json'
    a.entity.should.eql 'vnd.example'
    a.version.should.eql '1'
    a.syntax.should.eql 'json'

    a.entity = 'vnd.example2'
    a.subtype.should.eql 'vnd.example2-v1+json'
    a.entity.should.eql 'vnd.example2'
    a.version.should.eql '1'
    a.syntax.should.eql 'json'


  it 'should have version setter', () ->
    a = new AcceptItem 'application/vnd.example-v1+json;charset=utf-8;q=0.5'
    a.subtype.should.eql 'vnd.example-v1+json'
    a.entity.should.eql 'vnd.example'
    a.version.should.eql '1'
    a.syntax.should.eql 'json'

    a.version = '2'
    a.subtype.should.eql 'vnd.example-v2+json'
    a.entity.should.eql 'vnd.example'
    a.version.should.eql '2'
    a.syntax.should.eql 'json'


  it 'should have syntax setter', () ->
    a = new AcceptItem 'application/vnd.example-v1+json;charset=utf-8;q=0.5'
    a.subtype.should.eql 'vnd.example-v1+json'
    a.entity.should.eql 'vnd.example'
    a.version.should.eql '1'
    a.syntax.should.eql 'json'

    a.syntax = 'xml'
    a.subtype.should.eql 'vnd.example-v1+xml'
    a.entity.should.eql 'vnd.example'
    a.version.should.eql '1'
    a.syntax.should.eql 'xml'


  it 'should have mediaParam setter', () ->
    a = new AcceptItem 'application/vnd.example-v1+json;charset=utf-8;q=0.5'
    a.mediaParam('charset').should.eql 'utf-8'

    a.mediaParam 'charset', 'utf-16'
    a.mediaParam('charset').should.eql 'utf-16'

    a.mediaParam 'charset', 'utf-16'
    a.mediaParam('charset').should.eql 'utf-16'

    a.mediaParam 'charset', null
    should.not.exist a.mediaParam 'charset'


  it 'should have acceptParam setter', () ->
    a = new AcceptItem 'application/vnd.example-v1+json;charset=utf-8;q=0.5'
    a.acceptParam('q').should.eql '0.5'

    a.acceptParam 'q', '1.0'
    a.acceptParam('q').should.eql '1.0'

    a.acceptParam 'q', null
    should.not.exist a.acceptParam 'q'


  it 'should match', () ->
    a = new AcceptItem 'application/*'
    a.matches('application/xml').should.be.a 'number'
    a.matches('application/json').should.be.a 'number'
    a.matches('application/json;charset=utf-8').should.be.a 'number'
    a.matches('text/html').should.be.false


  it 'should cast to string', () ->
    a = new AcceptItem 'application/vnd.example-v1+json;charset=utf-8;q=0.5'
    a.toString().should.eql 'application/vnd.example-v1+json;charset=utf-8;q=0.5'
