%{
#include "main.hh"

#include <fstream>

extern "C" int yylex();
%}

%union {
	char *str;
}

%token PLUS TILDE ASTERISK SLASH EQUAL LT GT LBRACKET RBRACKET DOT COMMA COLON
%token SEMICOLON QUOTE LPAREN RPAREN NEQUAL LTE GTE ASSIGN ELLIPSIS
%token AND ARRAY TOKBEGIN CASE CONST DIV DO DOWNTO ELSE END TOKFILE FOR FUNCTION GOTO
%token IF IN LABEL MOD NIL NOT OF OR PACKED PROCEDURE PROGRAM RECORD REPEAT SET
%token THEN TO TYPE UNTIL VAR WHILE WITH
%token <str> IDENTIFIER

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
  | program TOKBEGIN    { printf("TOKBEGIN\n"); }
  | program CASE        { printf("CASE\n"); }
  | program CONST       { printf("CONST\n"); }
  | program DIV         { printf("DIV\n"); }
  | program DO          { printf("DO\n"); }
  | program DOWNTO      { printf("DOWNTO\n"); }
  | program ELSE        { printf("ELSE\n"); }
  | program END         { printf("END\n"); }
  | program TOKFILE     { printf("TOKFILE\n"); }
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
  | PLUS                { printf("PLUS\n"); }
  | TILDE               { printf("TILDE\n"); }
  | ASTERISK            { printf("ASTERISK\n"); }
  | SLASH               { printf("SLASH\n"); }
  | EQUAL               { printf("EQUAL\n"); }
  | LT                  { printf("LT\n"); }
  | GT                  { printf("GT\n"); }
  | LBRACKET            { printf("LBRACKET\n"); }
  | RBRACKET            { printf("RBRACKET\n"); }
  | DOT                 { printf("DOT\n"); }
  | COMMA               { printf("COMMA\n"); }
  | COLON               { printf("COLON\n"); }
  | SEMICOLON           { printf("SEMICOLON\n"); }
  | QUOTE               { printf("QUOTE\n"); }
  | LPAREN              { printf("LPAREN\n"); }
  | RPAREN              { printf("RPAREN\n"); }
  | NEQUAL              { printf("NEQUAL\n"); }
  | LTE                 { printf("LTE\n"); }
  | GTE                 { printf("GTE\n"); }
  | ASSIGN              { printf("ASSIGN\n"); }
  | ELLIPSIS            { printf("ELLIPSIS\n"); }
  | AND                 { printf("AND\n"); }
  | ARRAY               { printf("ARRAY\n"); }
  | TOKBEGIN            { printf("TOKBEGIN\n"); }
  | CASE                { printf("CASE\n"); }
  | CONST               { printf("CONST\n"); }
  | DIV                 { printf("DIV\n"); }
  | DO                  { printf("DO\n"); }
  | DOWNTO              { printf("DOWNTO\n"); }
  | ELSE                { printf("ELSE\n"); }
  | END                 { printf("END\n"); }
  | TOKFILE             { printf("TOKFILE\n"); }
  | FOR                 { printf("FOR\n"); }
  | FUNCTION            { printf("FUNCTION\n"); }
  | GOTO                { printf("GOTO\n"); }
  | IF                  { printf("IF\n"); }
  | IN                  { printf("IN\n"); }
  | LABEL               { printf("LABEL\n"); }
  | MOD                 { printf("MOD\n"); }
  | NIL                 { printf("NIL\n"); }
  | NOT                 { printf("NOT\n"); }
  | OF                  { printf("OF\n"); }
  | OR                  { printf("OR\n"); }
  | PACKED              { printf("PACKED\n"); }
  | PROCEDURE           { printf("PROCEDURE\n"); }
  | PROGRAM             { printf("PROGRAM\n"); }
  | RECORD              { printf("RECORD\n"); }
  | REPEAT              { printf("REPEAT\n"); }
  | SET                 { printf("SET\n"); }
  | THEN                { printf("THEN\n"); }
  | TO                  { printf("TO\n"); }
  | TYPE                { printf("TYPE\n"); }
  | UNTIL               { printf("UNTIL\n"); }
  | VAR                 { printf("VAR\n"); }
  | WHILE               { printf("WHILE\n"); }
  | WITH                { printf("WITH\n"); }
  | IDENTIFIER          { printf("IDENTIFIER: \"%s\"\n", $1); }
  ;

%%

