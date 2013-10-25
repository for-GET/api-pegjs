fs = require 'fs'
path = require 'path'
_ = require 'lodash'
glob = require 'glob'
pctEncode = require 'pct-encode'
testRoot = path.resolve './test.pool'


module.exports = {
  pctEncode
}

module.exports.loadTestcases = ({dir, cb, pattern}) ->
  cb ?= module.exports.loadTestcaseCallback
  pattern ?= '*.json'
  dir = path.resolve testRoot, dir
  files = glob.sync path.join dir, pattern
  testcases = []
  for file in files
    content = fs.readFileSync file, 'utf-8'
    name = path.basename file, path.extname(file)
    content = JSON.parse content  if path.extname(file) is '.json'
    content = cb {file, name, content}
    testcases.push {file, name, content}
  testcases


module.exports.maybeLoad$ref = ({file, obj}) ->
  $ref = obj?.$ref
  return obj  unless $ref
  $ref = path.resolve path.dirname(file), $ref
  content = fs.readFileSync $ref, 'utf-8'
  content = JSON.parse content  if path.extname($ref) is '.json'
  content


module.exports.loadTestcaseCallback = ({file, name, content}) ->
  for test in content
    test[1] = module.exports.maybeLoad$ref {file, obj: test[1]}
    test[2] = module.exports.maybeLoad$ref {file, obj: test[2]}
  content


module.exports.runTestcase = (parser, testcases) ->
  () ->
    for {file, name, content} in testcases
      describe name, do () ->
        parser_ = parser
        name_ = name
        content_ = content
        () ->
          for [description, input, expected] in content_
            inputDesc = input.toString()#.replace("\r", "").replace("\n", "").substr 0, 50
            it "#{description} (#{inputDesc})", do () ->
              parser__ = parser_
              name__ = name_
              input__ = input
              expected__ = expected
              () ->
                if expected__ isnt undefined
                  actual = parser__[name__] input__
                  actual = JSON.parse JSON.stringify actual
                  actual.should.eql expected__
                else
                  fun = () ->
                    parser__[name__] input__
                  fun.should.Throw()

module.exports.parserShouldNotThrow = ({parser, input}) ->
  () ->
    fun = () ->
      try
        parser input
      catch e
        # Get around a chaijs "bug" see https://github.com/chaijs/chai/pull/201
        throw new Error e.message
    fun.should.not.Throw()  if input isnt undefined