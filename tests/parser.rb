#!/usr/bin/env ruby

require 'ffi'

module PGN
  extend FFI::Library

  ffi_lib '../libpgnparser.so'
  ffi_convention :stdcall

  attach_function :parser, :parser,[ :string, :int, :int ], :string
end

#puts "Cantidad de argumentos: #{ARGV.length}"

#for a in ARGV
#  puts a
#end

def main()
  if ARGV.length == 0
    puts(PGN.parser nil, 1, 100)
  else
    puts(PGN.parser ARGV[0], 1, 100)
  end
end

main()



