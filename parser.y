%{
#include "main.hh"

#include <fstream>

extern "C" int yylex();
#define YYDEBUG 1
%}

%union {
  char *strv;
  int intv;
  char *opv;
}

%token PLUS MINUS /* ASTERISK */ SLASH EQUAL LT GT LBRACKET RBRACKET DOT COMMA COLON
%token SEMICOLON QUOTE LPAREN RPAREN LTGT LTE GTE COLEQUAL ELLIPSIS
%token AND ARRAY TOKBEGIN CASE CONST DIV DO DOWNTO ELSE END TOKFILE FOR FUNCTION
%token GOTO IF IN LABEL MOD NIL NOT OF OR OTHERWISE PACKED PROCEDURE PROGRAM
%token RECORD REPEAT SET THEN TO TYPE UNTIL VAR WHILE WITH

%start program

%token <strv> IDENTIFIER
%token <intv> INT;
%type <intv> number;
%left PLUS
%left ASTERISK

%%

program:
       | number { printf("result: %d\n", $1); }
       ;

number: INT { $$ = $1; }
      | number PLUS number { $$ = $1 + $3; }
      | number ASTERISK number { $$ = $1 * $3; }
      ;

/*
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
*/

%%

// vim: et:ts=2:sw=2

