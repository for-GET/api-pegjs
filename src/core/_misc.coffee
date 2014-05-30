{
  _
} = misc = require '../_misc'
pegjs = require 'pegjs'
overrideAction = require 'pegjs-override-action'


module.exports = _.assign {}, misc, {
  createModule: ({PEG, initializer, rules, mixins}) ->
    mixins ?= []
    _.defaults rules, mixin  for mixin in mixins
    mod = ({startRule, options}) ->
      options ?= {}
      _.assign options, {
        allowedStartRules: [startRule]
        plugins: [overrideAction]
        overrideActionPlugin: {
          initializer
          rules
        }
      }

      # FIXME pegjs should throw an exception if startRule is not defined
      {parse} = pegjs.buildParser PEG, options

      fun = (input) ->
        parse input, {startRule}
      fun._ = {
        PEG
        options
      }
      fun

    mod._ = {
      PEG
      initializer
      rules
    }

    mod


  funToString: (fun) ->
    fun = fun.toString()
    bodyStarts = fun.indexOf('{') + 1
    bodyEnds = fun.lastIndexOf '}'
    fun.substring bodyStarts, bodyEnds
}