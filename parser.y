%{
#include "main.hh"

#include <fstream>

extern "C" int yylex();
#define YYDEBUG 1
%}

%union {
  char *str;
  short digit;
  char *number;
}

%token PLUS MINUS ASTERISK SLASH EQUAL LT GT LBRACKET RBRACKET DOT COMMA COLON
%token SEMICOLON QUOTE LPAREN RPAREN LTGT LTE GTE COLEQUAL ELLIPSIS
%token AND ARRAY TOKBEGIN CASE CONST DIV DO DOWNTO ELSE END TOKFILE FOR FUNCTION
%token GOTO IF IN LABEL MOD NIL NOT OF OR OTHERWISE PACKED PROCEDURE PROGRAM
%token RECORD REPEAT SET THEN TO TYPE UNTIL VAR WHILE WITH

%token <str> IDENTIFIER
%token <digit> DIGIT;

%type <number> signed_number;

%start program

%%

program: program signed_number
       | signed_number
       ;

signed_number: signed_integer { puts("got si"); }
             | signed_real  { puts("got sr"); }
             ;
signed_real: sign unsigned_real
           | unsigned_real
           ;
signed_integer: sign unsigned_integer
              | unsigned_integer
              ;
unsigned_number: unsigned_integer
               | unsigned_real
               ;
sign: PLUS | MINUS;
unsigned_real: digit_sequence DOT fractional_part 'e' scale_factor
             | digit_sequence DOT fractional_part
             | digit_sequence 'e' scale_factor
             ;
unsigned_integer: digit_sequence;
fractional_part: digit_sequence;
scale_factor: sign digit_sequence
            | digit_sequence
            ;
digit_sequence: digit_sequence DIGIT
              | DIGIT
              ;

%%

// vim: et:ts=2:sw=2

