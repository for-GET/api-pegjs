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

module.exports.runTestcase = (parser, testcases) ->
  () ->
    for testcase in testcases
      {file, name, content} = testcase
      describe name, do () ->
        parser_ = parser
        name_ = name
        content_ = content
        () ->
          for test in content_
            [description, input, expected] = test
            it description, do () ->
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