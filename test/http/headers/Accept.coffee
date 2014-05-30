{
  should
  thisModule
} = require '../../_utils'
Accept = thisModule 'http/headers/Accept'

describe 'Accept', () ->

  it 'should have getters', () ->
    a = new Accept 'text/plain, application/*;q=0.8'
    a.items[0].toString().should.eql 'text/plain'
    a.items[1].toString().should.eql 'application/*;q=0.8'


  it 'should add an item'


  it 'should remove an item'


  it 'should matches', () ->
    a = new Accept 'text/plain, application/*;q=0.8'
    a.matches('application/xml').should.be.a 'number'
    a.matches('application/json').should.be.a 'number'
    a.matches('application/json;charset=utf-8').should.be.a 'number'
    a.matches('text/html').should.be.false


  it 'should prefersOne', () ->
    a = new Accept 'text/plain, application/*;q=0.8'
    a.prefersOne(['text/plain', 'application/json']).Item.toString().should.eql 'text/plain'
    should.not.exist a.prefersOne ['text/html']


  it 'should cast to string', () ->
    a = new Accept 'application/*;charset=utf-8;q=0.5,*/*'
    a.toString().should.eql 'application/*;charset=utf-8;q=0.5,*/*'
