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
  char *opv;
  char *strv;
  char *labelv;
  /* (^) used in lex. (v) used in bison */
  char *string;
  char *label;
}

%token <opv> PLUS MINUS ASTERISK SLASH EQUAL LT GT LBRACKET RBRACKET DOT COMMA
%token <opv> COLON SEMICOLON UPARROW LPAREN RPAREN LTGT LTE GTE COLEQUAL ELLIPSIS
%token AND ARRAY TOKBEGIN CASE CONST DIV DO DOWNTO ELSE END TOKFILE FOR FUNCTION
%token GOTO IF IN MOD NIL NOT OF OR OTHERWISE PACKED PROCEDURE PROGRAM RECORD
%token REPEAT SET THEN TO TYPE UNTIL VAR WHILE WITH

%token <identv> IDENTIFIER;
%token <numberv> NUMBER;
%token <strv> STRING;
%token LABEL LABELCOMMA LABELSEMICOLON;
%token <labelv> LABELN;

%start program

%%

program: program term
       | term;

term: label;

identifer: IDENTIFIER { printf("ident: <%s>\n", $1); };
number: NUMBER { printf("num: <%s>\n", $1); };
string: STRING { printf("str: <%s>\n", $1); };

/*
block: label_declaration_part
       constant_definition_part
       type_definition_part
       variable_definition_part
       procedure_and_function_declaration_part
       statement_part ;
*/

label: LABEL label_list LABELSEMICOLON;
label_list: label_list LABELCOMMA LABELN
          | LABELN;

%%

// vim: et:ts=2:sw=2

