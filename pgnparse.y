%{
#define _GNU_SOURCE
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <json.h>

extern FILE* yyin;
extern int yylex();
extern int yyparse();
extern char *yytext;
 
void yyerror(const char *str)
{
        fprintf(stderr,"\nERROR: %s\n",str);
        fprintf(stderr, "CAUSED BY: %\n\n", yytext);
}
 
int yywrap()
{
        return 1;
} 


#define INIT_TOTAL 0
#define DEFAULT_START 0
#define DEFAULT_END 99

int movec = 0;
long buffer_len = 0;
long buffer_initial_len = 1024 * 1024 * 20;
long start = DEFAULT_START;
long end = DEFAULT_END;
long current = INIT_TOTAL;
long only_count = 0;

const char *seven_tag_roster[] = {"Event", "Site", "Date", "Round", "White", "Black", "Result"};
const char *terminations[] = {"abandoned", "adjudication", "death", "emergency", "normal", "rules infraction", "time forfeit", "unterminated"};
const char *default_fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";

char * game_buffer;

json_object * games;
json_object * headers;
json_object * moves;


long game_count(const char *filename)
{
  
  long numgames;
  
  FILE *filehandle;
  
  if (filename != NULL) {
   filehandle = fopen(filename, "r");
  }
  else {
   filehandle = NULL;
  }
  
  if (filehandle) {
   yyin = filehandle;
  }
  else {
   yyin = stdin;
  } 
  
  only_count = 1;

  yylex();
  
  if (filehandle) {
   fclose(filehandle);
  }
  
  only_count = 0;
  
  numgames = current;
  
  current = INIT_TOTAL;
  
  return numgames;
  
}

void init_json_objs() {
  moves = json_object_new_array();
  headers = json_object_new_object();
}

  
char * parser(char* filename, long gstart, long gend)
{

  FILE *filehandle;
  
  only_count = 0;
  
  if (filename != NULL) {
   filehandle = fopen(filename, "r");
  }
  else {
   filehandle = NULL;
  }
  
  if (filehandle) {
   yyin = filehandle;
  }
  else {
   yyin = stdin;
  } 
  
  start = --gstart;
  end = --gend;
  
 // game_buffer = strdup("");

  games = json_object_new_array();
  init_json_objs();
      
  yyparse();
  
  if (filehandle) {
   fclose(filehandle);
  }
   
 
  current = INIT_TOTAL;
  start = DEFAULT_START;
  end = DEFAULT_END;
  
  game_buffer = strdup(json_object_to_json_string_ext(games, JSON_C_TO_STRING_PRETTY)); 
  json_object_put(games);
  return game_buffer;


} 


%}

%union {
  char* str;
}

%token <str> TOKLABEL
%token <str> TOKVALUE
%token <str> TOKMOVE
%token <str> TOKRESULT

%%

evts:   /* empty */
        | evts evt
        ;

evt:
        header
        |
        move
        |
        result
        ;

header:
        TOKLABEL TOKVALUE
        {
            //    asprintf(&game_buffer, "%s[%s '%s']\n", game_buffer, $1, $2);
            json_object_object_add(headers, $1, json_object_new_string($2));
        }
        ;

move:
        TOKMOVE
        {
            //    asprintf(&game_buffer, "%s%d. %s ", game_buffer, movec, $1);
                json_object_array_add(moves, json_object_new_string($1));
        }
        ;

result:
        TOKRESULT
        {
                // asprintf(&game_buffer, "%s\nResult: %s\n\n", game_buffer, $1);
                json_object * new_game = json_object_new_object();
                json_object * missing_prop;
                json_object_object_get_ex(headers, "FEN", &missing_prop);
                json_object_object_get_ex(headers, "PlyCount", &missing_prop);
                if (json_object_is_type(missing_prop, json_type_null)) 
                  json_object_object_add(headers, "PlyCount", json_object_new_int(json_object_array_length(moves)));
                if (json_object_is_type(missing_prop, json_type_null)) 
                  json_object_object_add(headers, "FEN", json_object_new_string(default_fen));
                json_object_object_get_ex(headers, "Termination", &missing_prop);
                if (json_object_is_type(missing_prop, json_type_null)) 
                  json_object_object_add(headers, "Termination", json_object_new_string(!strcmp($1, "*") ? terminations[7] : terminations[4]));
                json_object_object_add(new_game, "headers", headers);
                json_object_object_add(new_game, "moves", moves);
                json_object_object_add(new_game, "result", json_object_new_string($1));
                json_object_array_add(games, new_game);
                json_object_put(missing_prop);
                init_json_objs();
        }
        ;

%%


#ifdef __EXE__

int main(int argc, char* argv[]) {
  long mstart = start +1, mend = end + 1;
  char* filename;
  
  switch(argc) {
    case 4:;
      mend = atol(argv[3]);   
    case 3:
      mstart = atol(argv[2]);
    case 2:
      filename = argv[1];
      break;
    default:
     filename = NULL;
  }
  
  if (filename != NULL) {
    if (strlen(filename) < 1) {
      filename = NULL;
    }
  }
  
  char *resp_buffer = parser(filename, mstart, mend);
  
  printf("%s\n", resp_buffer);

  return EXIT_SUCCESS;
 
}

#endif
