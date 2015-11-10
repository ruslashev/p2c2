%{
#include <fstream>
#include <cstring>

#include "main.hh"

extern "C" int yylex();
#define YYDEBUG 1
%}

%union {
  char *identv;
  char *numberv;
  /* char *labelv; */
  char *opv;
  char *strv;
  /* char letterv; */
  /* char digitv; */
  /* (^) used in lex. (v) used in bison */
  char *string;
}

%token <opv> PLUS MINUS ASTERISK SLASH EQUAL LT GT LBRACKET RBRACKET DOT COMMA COLON
%token <opv> SEMICOLON QUOTE LPAREN RPAREN LTGT LTE GTE COLEQUAL ELLIPSIS
%token AND ARRAY TOKBEGIN CASE CONST DIV DO DOWNTO ELSE END TOKFILE FOR FUNCTION
%token GOTO IF IN LABEL MOD NIL NOT OF OR OTHERWISE PACKED PROCEDURE PROGRAM
%token RECORD REPEAT SET THEN TO TYPE UNTIL VAR WHILE WITH

%token <identv> IDENTIFIER;
%token <numberv> NUMBER;
%token <strv> STRING;

%start program

%%

program: program term
       | term;

term: identifer | number | string;

identifer: IDENTIFIER { printf("ident: <%s>\n", $1); };

number: NUMBER { printf("num: <%s>\n", $1); };

string: STRING { printf("str: <%s>\n", $1); };

/*
string: QUOTE string_elements QUOTE { printf("str: <%%s>\n"); }
string_elements: string_element | string_elements string_element;
string_element: string_character | apostrophe_image;
apostrophe_image: "''";
string_character: LETTER
                | "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
                | "!" | "@" | "#" | "$" | "%" | "^" | "&" | "*" | "(" | ")"
                | "_" | "-" | "=" | "+" | "[" | "]" | "{" | "}" | ";" | ":"
                | "\"" | "," | "." | "<" | ">" | "/" | "?" ;
*/

%%

// vim: et:ts=2:sw=2

