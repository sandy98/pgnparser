#!/usr/bin/env ruby

require 'ffi'

module PGN
  extend FFI::Library

  ffi_lib 'libpgnparser.so'
  ffi_convention :stdcall

  attach_function :count, :game_count,[ :string], :long
end

#puts "Cantidad de argumentos: #{ARGV.length}"

#for a in ARGV
#  puts a
#end

def main()
  if ARGV.length == 0
    puts(PGN.count nil)
  else
    puts(PGN.count ARGV[0])
  end
end

main()



