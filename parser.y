%{
#include "main.hh"

#include <fstream>

extern "C" int yylex();
%}

%union {
	char *str;
	short digit;
}

%token PLUS MINUS ASTERISK SLASH EQUAL LT GT LBRACKET RBRACKET DOT COMMA COLON
%token SEMICOLON QUOTE LPAREN RPAREN NEQUAL LTE GTE ASSIGN ELLIPSIS
%token AND ARRAY TOKBEGIN CASE CONST DIV DO DOWNTO ELSE END TOKFILE FOR FUNCTION
%token GOTO IF IN LABEL MOD NIL NOT OF OR PACKED PROCEDURE PROGRAM RECORD REPEAT
%token SET THEN TO TYPE UNTIL VAR WHILE WITH
%token <str> IDENTIFIER
%token <digit> DIGIT;

%%

program:
  | program signed_number
  | signed_number
  ;

signed_number: signed_integer | signed_real ;
signed_real: sign unsigned_real | unsigned_real ;
signed_integer: sign unsigned_integer | unsigned_integer ;
unsigned_number: unsigned_integer | unsigned_real ;
sign: PLUS | MINUS ;
unsigned_real: digit_sequence DOT fractional_part
			 | digit_sequence DOT fractional_part 'e' scale_factor
			 | digit_sequence 'e' scale_factor ;
unsigned_integer: digit_sequence ;
fractional_part: digit_sequence ;
scale_factor: sign digit_sequence | digit_sequence ;
digit_sequence: digit_sequence DIGIT | DIGIT ;

%%

