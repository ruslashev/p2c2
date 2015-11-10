%{
#include <string>
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
  std::string *string;
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

%type <string> identifer;
%type <string> constant;
%type <string> number;
%type <string> string;
%type <string> sign;

%start program

%%

program: program term
       | term;

term: constant_definition_part;

identifer: IDENTIFIER { $$ = new std::string($1); printf("ident: <%s>\n", $1); };
number: NUMBER { $$ = new std::string($1); printf("num: <%s>\n", $1); };
string: STRING { $$ = new std::string($1); printf("str: <%s>\n", $1); };

/*
block: label_declaration_part
       constant_definition_part
       type_definition_part
       variable_definition_part
       procedure_and_function_declaration_part
       statement_part ;
*/

label_declaration_part: LABEL label_list LABELSEMICOLON;
label_list: label_list LABELCOMMA LABELN
          | LABELN;

constant_definition_part: CONST constant_definition_list;
constant_definition_list: constant_definition_list constant_definition
                        | constant_definition;
constant_definition: identifer EQUAL constant SEMICOLON
                   { printf("const %s = %s\n", $1->c_str(), $3->c_str()); };
constant: sign number { $$ = new std::string(*($1)); $$->append(*($2)); }
        | sign identifer { $$ = new std::string(*($1)); $$->append(*($2)); }
        | number { $$ = new std::string(*($1)); }
        | identifer { $$ = new std::string(*($1)); }
        | string { $$ = new std::string(*($1)); };
sign: PLUS { $$ = new std::string($1, strlen($1)); }
    | MINUS { $$ = new std::string($1, strlen($1)); };

%%

// vim: et:ts=2:sw=2

