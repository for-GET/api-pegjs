module.exports = ({pegModule, startRule}) ->
  parser = module.exports.parsers[pegModule][startRule]
  return parser()  unless parser is true
  require("./core/#{pegModule}") {startRule}


module.exports.moduleToSource = ({pegModule, startRule}) ->
  {_} = require './_misc'
  pegjs = require 'pegjs'

  {PEG, options} = require("./core/#{pegModule}")({startRule})._
  options = _.assign options, {
    output: 'source'
  }
  pegjs.buildParser PEG, options


module.exports.precompile = () ->
  throw new Error 'Precompiling PEG parsers is only allowed for published/JS sources'  unless /.js$/.test module.filename
  require 'coffee-script'

  fs = require 'fs'
  path = require 'path'
  moduleFilename = module.filename
  moduleSource = fs.readFileSync moduleFilename, 'utf8'

  count = 0

  for pegModule, startRules of module.exports.parsers
    for startRule of startRules
      count += 1
      precompiledModuleFilename = "#{moduleFilename}-#{count}.js"
      precompiledModuleSource = module.exports.moduleToSource {pegModule, startRule}
      precompiledModuleSource = "\nmodule.exports = #{precompiledModuleSource}.parse;\n"
      fs.writeFileSync precompiledModuleFilename, precompiledModuleSource, 'utf8'
      precompiledModuleFilename = path.relative __dirname, precompiledModuleFilename
      precompiledModuleFilename = "./#{precompiledModuleFilename}"
      moduleSource += "\nmodule.exports.parsers['" + pegModule + "']['" + startRule + "'] = function() { return require('" + precompiledModuleFilename + "'); }\n"
  moduleSource += "\ndelete module.exports.moduleToSource;\n"
  moduleSource += "\ndelete module.exports.precompile;\n"
  fs.writeFileSync module.filename, moduleSource, 'utf8'


module.exports.parsers =
  'for-get/request':
    'HTTP_message': true
  'for-get/response':
    'HTTP_message': true
  'ietf/draft_ietf_httpbis_p1_messaging':
    'Content_Type': true
  'ietf/draft_ietf_httpbis_p2_semantics':
    'Accept': true
    'Accept_Language': true
    'token': true
  'for-get/media_subtype':
    'media_subtype': true


module.exports.precompile()  if require.main is module
