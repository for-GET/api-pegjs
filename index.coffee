path = require 'path'
_ = require 'lodash'

[prefix, ext] = ['./lib', '.js']
[prefix, ext] = ['./src', '.coffee']  if /.coffee$/.test module.filename

module.exports = (id) ->
  parser = module.exports.cache[id]
  return parser  if parser?
  parserModule = "#{__dirname}/#{prefix}/#{id}#{ext}"
  parser = module.exports.cache[id] = require parserModule
  parser

module.exports.cache = {}
