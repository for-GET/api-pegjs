#!/usr/bin/env coffee

apiPEG = require '../'

[_, _, parser, startRule] = process.argv

parser = apiPEG parser
throw new Error 'Unknown parser'  unless parser?
source = parser {startRule, options: {output: 'source'}}
throw new Error 'Unknown start rule'  unless source?

process.stdout.write source
