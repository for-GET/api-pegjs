{
  should
} = require '../_utils'
cosmogol = require '../../src/parsers/cosmogol'

describe 'cosmogol', () ->
  describe 'basic', () ->
    fsm = """
var1 = test;
var2 = test2;

state1,
state2
: states;

msg
: messages;

act
: actions;

state1:msg -> state2:act;
"""
    it.only 'should work', () ->
      c = cosmogol.state_machine fsm
      c.should.eql
        __type: 'state_machine'
        statements: [
          {__type: 'assignment', name: 'var1', value: 'test'}
          {__type: 'assignment', name: 'var2', value: 'test2'}
          {__type: 'declaration', names: ['state1', 'state2'], value: 'states'}
          {__type: 'declaration', names: ['msg'], value: 'messages'}
          {__type: 'declaration', names: ['act'], value: 'actions'}
          {
            __type: 'transition'
            states: ['state1']
            messages: ['msg']
            next_state: 'state2'
            action: 'act'
          }
        ]
