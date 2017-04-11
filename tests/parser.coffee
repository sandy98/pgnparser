#!/usr/bin/env coffee

ref = require 'ref'
ffi = require 'ffi'

libpgnparser = ffi.Library '../libpgnparser.so', {'parser': ['string', ['string', 'int', 'int']]}

#console.log "Cantidad de argumentos: #{process.argv.length}"
#for a in process.argv
#  console.log a

if !!module.parent
  module.exports = libpgnparser.parser
else  
  if process.argv.length == 2
    #console.log "Calling parser without a file.\n\n"
    console.log(libpgnparser.parser(ref.NULL_POINTER, 1, 100))
  else
    #console.log "Calling parser with file: #{process.argv[2]}\n\n"
    console.log(libpgnparser.parser(process.argv[2], 1, 100))



