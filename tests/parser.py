#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import ctypes

libpgnparser = ctypes.CDLL("../libpgnparser.so")

parser = libpgnparser.parser

parser.argtypes = [ctypes.c_char_p, ctypes.c_int, ctypes.c_int]

parser.restype = ctypes.c_char_p

def main():

  if len(sys.argv) > 1:
    try:
      #print("Trying to use lexer with %s file.\n\n" % sys.argv[1]) 
      print(parser(ctypes.c_char_p(bytes(sys.argv[1], "ascii")), 1, 100).decode('utf8'))
    except:
      #print("Something failed, so will use lexer with sys.stdin\n\n")
      print(parser(None, 1, 100).decode('utf8'))
  else:
    #print("No file provided, will use lexer with sys.stdin\n\n")
    print(parser(None, 1, 100).decode('utf8'))
  
  return 0

if __name__ == '__main__':
  main()

