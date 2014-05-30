{
  _
} = misc = require '../_misc'
PEG = require 'pegjs'
overrideAction = require 'pegjs-override-action'


module.exports = _.assign {}, misc, {
  createModule: (args) ->
    args.grammar ?= args.PEG
    args.PEG = PEG
    overrideAction.makeBuildParser args
}
