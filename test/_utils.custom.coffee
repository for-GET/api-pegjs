fs = require 'fs'
path = require 'path'
_ = require 'lodash'
glob = require 'glob'
pkgRoot = path.resolve './node_modules'

module.exports.loadTestcases = ({dir, cb}) ->
  cb ?= module.exports.loadTestcaseCallback
  dir = path.resolve pkgRoot, dir
  files = glob.sync path.join dir, '**/*.json'
  testcases = []
  for file in files
    content = JSON.parse fs.readFileSync file, 'utf-8'
    name = path.basename file, '.json'
    file = cb {file, name, content}  if cb
    testcases.push {file, name, content}
  testcases

module.exports.loadTestcaseCallback = ({file, name, content}) ->
  for test in content
    $ref = test[1]?.$ref
    continue  unless $ref
    $ref = path.resolve path.dirname(file), $ref
    test[1] = fs.readFileSync $ref, 'utf-8'