%{
#include <fstream>
#include <cstring>

#include "main.hh"

extern "C" int yylex();
#define YYDEBUG 1
%}

%union {
  char *strv;
  char *numberv;
  char *opv;
  /* (^) used in lex. (v) used in bison */
  char *string;
}

%token PLUS MINUS ASTERISK SLASH EQUAL LT GT LBRACKET RBRACKET DOT COMMA COLON
%token SEMICOLON QUOTE LPAREN RPAREN LTGT LTE GTE COLEQUAL ELLIPSIS
%token AND ARRAY TOKBEGIN CASE CONST DIV DO DOWNTO ELSE END TOKFILE FOR FUNCTION
%token GOTO IF IN LABEL MOD NIL NOT OF OR OTHERWISE PACKED PROCEDURE PROGRAM
%token RECORD REPEAT SET THEN TO TYPE UNTIL VAR WHILE WITH

%start program

%token <strv> IDENTIFIER
%token <numberv> NUMBER;
/* %type <string> digit_sequence; */

%%

program: numbers;
numbers: number | numbers number;
number: NUMBER { printf("num: %s\n", $1); };


%%

// vim: et:ts=2:sw=2

