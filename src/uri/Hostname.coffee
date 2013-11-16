{
  _
  core
} = require '../_misc'
_parser = core {
  pegModule: 'ietf/rfc3986_uri'
  startRule: 'hostname'
}
AbstractBase = require '../abstract/Base'


module.exports = class Hostname extends AbstractBase
  _type: 'uri-host'
  _parser: _parser


  _defaultAst: () ->
    {
      __type: @type
      ip:
        __type: 'IPv4address'
        version: '4'
        address: '127.0.0.1'
    }


  toString: () ->
    return @ast.reg_name  if @ast.reg_name?
    return @ast.ip.address  if @ast.ip.version is '4'
    return "[#{@ast.ip.address}]"  if @ast.ip.version is '6'
    "[v#{@ast.ip.version}.#{@ast.ip.address}]"