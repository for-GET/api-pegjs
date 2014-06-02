#!/usr/bin/env coffee

apiPEG = require '../'

[_, _, parser, startRule] = process.argv

parser = apiPEG parser
throw new Error 'Unknown parser'  unless parser?
parse = parser {startRule}
throw new Error 'Unknown start rule'  unless parse?

input = process.stdin
input.setEncoding 'utf8'
input.resume()
data = ''
input.on 'data', (chunk) ->
  data += chunk
input.on 'end', () ->
  result = parse data
  result = JSON.stringify result, null, 2  unless typeof result is 'string'
  process.stdout.write result
