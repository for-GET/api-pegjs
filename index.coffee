fs = require 'fs'
path = require 'path'
glob = require 'glob'

module.exports =
  http:
    headers:
      Accept: 1
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
mappingFun(prefix) module.exports, key, value  for key, value of module.exports

module.exports.core = {}

ext = '.js'
ext = '.coffee'  if /.coffee$/.test module.filename

options =
  sync: true

glob "#{__dirname}/#{prefix}/core/**/*#{ext}", options, (err, files) ->
  for file in files
    continue  if path.basename(file)[0] is '_'
    mod = path.dirname path.relative "#{__dirname}/#{prefix}/core", file
    mod += '/' + path.basename file, ext
    module.exports.core[mod] = require file
