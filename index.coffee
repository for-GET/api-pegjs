path = require 'path'

module.exports =
  http:
    headers:
      AcceptItem: 1

mappingFun = (prefix) ->
  (obj, key, value) ->
    if {}.toString.call(value) is '[object Object]'
      fun = mappingFun "#{prefix}/#{key}"
      fun value, subkey, subvalue  for subkey, subvalue of value
      return obj
    obj[key] = require "#{prefix}/#{key}"

prefix = './lib'
prefix = './src'  if /.coffee$/.test module.filename
mappingFun(prefix) module.exports

module.exports.parser = require './src/parsers'
