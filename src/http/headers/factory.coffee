camelize = require 'camelize-http-headers'

module.exports = (name, value) ->
  name = camelize.fieldName(name).replace /-/g, ''
  try
    Header = require "./#{name}"
  catch e
    Header = require './Generic'
  new Header value
