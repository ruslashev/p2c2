%{
#include "main.hh"

#include <fstream>

extern "C" int yylex();
%}

%union {
	std::string sval;
}

%token PLUS TILDE ASTERISK SLASH EQUAL LT GT LBRACKET RBRACKET DOT COMMA COLON
%token SEMICOLON QUOTE LPAREN RPAREN NEQUAL LTE GTE ASSIGN ELLIPSIS
%token AND ARRAY BEGIN CASE CONST DIV DO DOWNTO ELSE END FILE FOR FUNCTION GOTO
%token IF IN LABEL MOD NIL NOT OF OR PACKED PROCEDURE PROGRAM RECORD REPEAT SET
%token THEN TO TYPE UNTIL VAR WHILE WITH EOF
%token <sval> IDENTIFIER

%%

program:
  | program PLUS        { printf("PLUS\n"); }
  | program TILDE       { printf("TILDE\n"); }
  | program ASTERISK    { printf("ASTERISK\n"); }
  | program SLASH       { printf("SLASH\n"); }
  | program EQUAL       { printf("EQUAL\n"); }
  | program LT          { printf("LT\n"); }
  | program GT          { printf("GT\n"); }
  | program LBRACKET    { printf("LBRACKET\n"); }
  | program RBRACKET    { printf("RBRACKET\n"); }
  | program DOT         { printf("DOT\n"); }
  | program COMMA       { printf("COMMA\n"); }
  | program COLON       { printf("COLON\n"); }
  | program SEMICOLON   { printf("SEMICOLON\n"); }
  | program QUOTE       { printf("QUOTE\n"); }
  | program LPAREN      { printf("LPAREN\n"); }
  | program RPAREN      { printf("RPAREN\n"); }
  | program NEQUAL      { printf("NEQUAL\n"); }
  | program LTE         { printf("LTE\n"); }
  | program GTE         { printf("GTE\n"); }
  | program ASSIGN      { printf("ASSIGN\n"); }
  | program ELLIPSIS    { printf("ELLIPSIS\n"); }
  | program AND         { printf("AND\n"); }
  | program ARRAY       { printf("ARRAY\n"); }
  | program BEGIN       { printf("BEGIN\n"); }
  | program CASE        { printf("CASE\n"); }
  | program CONST       { printf("CONST\n"); }
  | program DIV         { printf("DIV\n"); }
  | program DO          { printf("DO\n"); }
  | program DOWNTO      { printf("DOWNTO\n"); }
  | program ELSE        { printf("ELSE\n"); }
  | program END         { printf("END\n"); }
  | program FILE        { printf("FILE\n"); }
  | program FOR         { printf("FOR\n"); }
  | program FUNCTION    { printf("FUNCTION\n"); }
  | program GOTO        { printf("GOTO\n"); }
  | program IF          { printf("IF\n"); }
  | program IN          { printf("IN\n"); }
  | program LABEL       { printf("LABEL\n"); }
  | program MOD         { printf("MOD\n"); }
  | program NIL         { printf("NIL\n"); }
  | program NOT         { printf("NOT\n"); }
  | program OF          { printf("OF\n"); }
  | program OR          { printf("OR\n"); }
  | program PACKED      { printf("PACKED\n"); }
  | program PROCEDURE   { printf("PROCEDURE\n"); }
  | program PROGRAM     { printf("PROGRAM\n"); }
  | program RECORD      { printf("RECORD\n"); }
  | program REPEAT      { printf("REPEAT\n"); }
  | program SET         { printf("SET\n"); }
  | program THEN        { printf("THEN\n"); }
  | program TO          { printf("TO\n"); }
  | program TYPE        { printf("TYPE\n"); }
  | program UNTIL       { printf("UNTIL\n"); }
  | program VAR         { printf("VAR\n"); }
  | program WHILE       { printf("WHILE\n"); }
  | program WITH        { printf("WITH\n"); }
  | program IDENTIFIER  { printf("IDENTIFIER: \"%s\"\n", $2); }
  | EOF
  ;

%%

