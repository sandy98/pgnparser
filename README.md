## PGNParser
A simple utility to parse PGN chess files and retrieve the collection of games
within in JSON format.
Could be regarded as a PGN compiler, being JSON the 'object format' produced by the compiler.

### Build
Just type 'make' and get:
* pgnparser: executable that reads the provided file (or stdin), from game
(second arg, defaults to 1) to game (third arg, defaults to 100) and prints
the json resulting array to stdout.
* libpgnparser.so: shared dynamic link library which basically exports 2
functions: game_count(pgn_filename) and parser(pgn_filename, start_game, 
end_game).
       
### Usage
There are a bunch of files under tests directory which provide example of using
the library from python, ruby, node.js (js and coffee-script) and clojure.
Their contents is pretty self-explanatory as to how to use them.
It's also provided the directory 'pgnfiles' containing some pgn files for test purpose, 
and 'jsonfiles' directory, home for files generated using 'make-json.sh' script.

### Comments
Library generated using legendary unix tools 'lex' and 'yacc' (see Makefile),
which in the system they were made map to 'flex' and 'bison' respectively.


