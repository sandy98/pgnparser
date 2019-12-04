%{
#include <string.h>
#include <memory.h>
#include "y.tab.h"


extern int movec;
extern long buffer_len;
extern long buffer_initial_len;
extern long start;
extern long end;
extern long current;
extern long only_count;

char tmp_buffer[256] = {'\0'};

%}

%s header
%s comment1
%s comment2

begin-header    \[
end-header      \]

value           \".+?\"
label           [A-Za-z]+
ww              1-0
bw              0-1
draw            (1\/2-1\/2)|(1\/2)
undefined       [ \t]+\*
result          ({ww}|{bw}|{draw}|{undefined})
cm1		#
cm2		\+\+
column		[a-h]
rank		[1-8]
figure		[NBRQK]
crownable       [NBRQ]
pawn-move 	{column}{rank}
pawn-capture 	{column}x{column}{rank}
crowning	({pawn-move}|{pawn-capture})=?{crownable}
figure-move	{figure}{column}?{rank}?{column}{rank}
figure-capture	{figure}{column}?{rank}?x{column}{rank}
short-castle	(0-0|O-O)
long-castle	(0-0-0|O-O-O)
any		({short-castle}|{long-castle}|{pawn-move}|{pawn-capture}|{crowning}|{figure-move}|{figure-capture})
check		\+
check-mate	({cm1}|{cm2})
move            {any}({check}|{check-mate})?
comment		\([ \t\r\n]*([^\(\)]|\n)*[ \t\r\n]*\)
alt-move	\{[ \t\r\n]*([^\{\}]|\n)*[ \t\r\n]*\}
extra		({comment}|{alt-move})
%%

{begin-header}          BEGIN(header);

<header>{label}         {if (!only_count && current >= start && current <= end) {
                          yylval.str = strdup(yytext);
                          return TOKLABEL; 
                          }
                        }

<header>{value}         {if (!only_count && current >= start && current <= end) {
                          memset(tmp_buffer, 0, sizeof(tmp_buffer));
                          memcpy(tmp_buffer, &yytext[1], strlen(yytext) - 2);
                          yylval.str = strdup(tmp_buffer);
                          return TOKVALUE;
                          }
                        }

{end-header}            BEGIN(INITIAL);

{extra}			{   
			    // fprintf(stderr, "Found an extra thing: %s\n", yytext);
			    yylval.str = strdup("");
			    return TOKEXTRA;
			}

{move}		        { if (!only_count && current >= start && current <= end) {
                            movec++;
                            yylval.str = strdup(yytext);
                            return TOKMOVE;
                            }
                        }

{result}                { movec = 0;
                          if (!only_count && current >= start && current <= end) {
                            yylval.str = strdup(yytext);
                            current++;
                            return TOKRESULT;
                          }
                          current++; 
                          if (current > end && !only_count) return 0;
                        }

[ \t\n]			/* do nothing with spaces */
.			/* and do nothing with the rest */

%%


