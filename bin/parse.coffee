#!/usr/bin/env coffee

apiPEG = require '../'

[_, _, parser, startRule] = process.argv

parse = apiPEG[parser]? {startRule}
throw new Error 'Unknown parser or start rule'  unless parse?

input = process.stdin
input.setEncoding 'utf8'
input.resume()
data = ''
input.on 'data', (chunk) ->
  data += chunk
input.on 'end', () ->
  result = JSON.stringify parse(data), null, 2
  process.stdout.write result
