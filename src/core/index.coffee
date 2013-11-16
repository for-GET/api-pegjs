module.exports = ({pegModule, startRule}) ->
  parser = module.exports.parsers[pegModule][startRule]
  return parser()  unless parser is true
  console.log "WARNING! Building PEG parser on the fly: #{pegModule} #{startRule}"  if /.coffee$/.test module.filename
  require("./#{pegModule}") {startRule}


module.exports.precompileParser = ({pegModule, startRule}) ->
  {_} = require '../_misc'
  pegjs = require 'pegjs'

  {PEG, options} = require("./#{pegModule}")({startRule})._
  options = _.assign options, {
    output: 'source'
  }
  pegjs.buildParser PEG, options


module.exports.precompile = () ->
  unless /.js$/.test module.filename
    throw new Error 'Precompiling PEG parsers is only allowed for published/JS sources'
  require 'coffee-script'

  fs = require 'fs'
  path = require 'path'
  moduleFilename = module.filename
  moduleSource = fs.readFileSync moduleFilename, 'utf8'

  for pegModule, startRules of module.exports.parsers
    for startRule of startRules
      precompiledParserFilename = "#{pegModule}.#{startRule}".replace /\//g, '.'
      precompiledParserFilename = "#{moduleFilename}.precompiled.#{precompiledParserFilename}.js"
      precompiledParserSource = module.exports.precompileParser {pegModule, startRule}
      precompiledParserSource = "\nmodule.exports = #{precompiledParserSource}.parse;\n"
      fs.writeFileSync precompiledParserFilename, precompiledParserSource, 'utf8'
      precompiledParserFilename = path.relative __dirname, precompiledParserFilename
      precompiledParserFilename = "./#{precompiledParserFilename}"
      moduleSource += "\nmodule.exports.parsers['" + pegModule + "']['" + startRule + "'] = " +
        "function() { return require('" + precompiledParserFilename + "'); }\n"
  moduleSource += "\ndelete module.exports.precompileParser;\n"
  moduleSource += "\ndelete module.exports.precompile;\n"
  fs.writeFileSync module.filename, moduleSource, 'utf8'


module.exports.parsers =
  'for-get/media_subtype':
    'media_subtype': true
  'for-get/request':
    'HTTP_message': true
  'for-get/response':
    'HTTP_message': true
  'ietf/draft_ietf_httpbis_p1_messaging':
    'Content_Type': true
  'ietf/draft_ietf_httpbis_p2_semantics':
    'Accept': true
    'Accept_item_': true
    'Accept_Language': true
    'Accept_Language_item_': true
    'token': true
  'ietf/rfc3986_uri':
    'hostname': true
    'URI': true

module.exports.precompile()  if require.main is module
