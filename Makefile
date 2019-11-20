all:	lexer parser shared exe emcc

lexer:	pgnlex.lex
	lex pgnlex.lex
	
parser:	pgnparse.y
	yacc -d pgnparse.y
	
shared:	y.tab.h lex.yy.c y.tab.c
	cc -I/usr/include/json-c -ljson-c -shared -fPIC lex.yy.c y.tab.c -o libpgnparser.so
	
exe:	y.tab.h lex.yy.c y.tab.c
	cc -I/usr/include/json-c -ljson-c -D __EXE__ lex.yy.c y.tab.c -o pgnparser

#emcc:	y.tab.h lex.yy.c y.tab.c
#	emcc -I/usr/include/json-c -D __EXE__ lex.yy.c y.tab.c -o pgnparser.js

clean:
	$(RM) *.h *.c libpgnparser.so pgnparser
 

