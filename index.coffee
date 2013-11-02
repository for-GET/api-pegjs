path = require 'path'
glob = require 'glob'
_ = require 'lodash'

[prefix, ext] = ['./lib', '.js']
[prefix, ext] = ['./src', '.coffee']  if /.coffee$/.test module.filename

glob "#{__dirname}/#{prefix}/**/*#{ext}", {sync: true}, (err, files) ->
  for file in files
    continue  if path.basename(file)[0] is '_'
    mod = path.dirname path.relative "#{__dirname}/#{prefix}", file
    mod += '/' + path.basename file, ext
    module.exports[mod] = require file
