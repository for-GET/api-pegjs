{
  should
} = require '../../_utils'
Accept = require('../../../').http.headers.Accept

describe 'Accept', () ->

  it 'should have getters'


  it 'should prefersOne', () ->
    a = new Accept 'text/plain, application/*;q=0.8'
    a.prefersOne(['text/plain', 'application/json']).Item.toString().should.eql 'text/plain'
    should.not.exist a.prefersOne ['text/html']


  it 'should matches', () ->
    a = new Accept 'text/plain, application/*;q=0.8'
    a.matches('application/xml').should.be.a 'number'
    a.matches('application/json').should.be.a 'number'
    a.matches('application/json;charset=utf-8').should.be.a 'number'
    a.matches('text/html').should.be.false


  it 'should cast to string', () ->
    a = new Accept 'application/*;charset=utf-8;q=0.5,*/*'
    a.toString().should.eql 'application/*;charset=utf-8;q=0.5,*/*'
