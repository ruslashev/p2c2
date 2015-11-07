%option caseless
%option noyywrap
%option nounput

%{
#define YY_DECL extern "C" int yylex()
#include "parser.hh"
%}

%%

[ \t\n\r]                 /* ignore */;
"+"                       { return PLUS; }
"~"                       { return TILDE; }
"*"                       { return ASTERISK; }
"/"                       { return SLASH; }
"="                       { return EQUAL; }
"<"                       { return LT; }
">"                       { return GT; }
"["                       { return LBRACKET; }
"]"                       { return RBRACKET; }
"."                       { return DOT; }
","                       { return COMMA; }
":"                       { return COLON; }
";"                       { return SEMICOLON; }
"\""                      { return QUOTE; }
"("                       { return LPAREN; }
")"                       { return RPAREN; }
"<>"                      { return NEQUAL; }
"<="                      { return LTE; }
">="                      { return GTE; }
":="                      { return ASSIGN; }
".."                      { return ELLIPSIS; }
"and"                     { return AND; }
"array"                   { return ARRAY; }
"begin"                   { return BEGIN; }
"case"                    { return CASE; }
"const"                   { return CONST; }
"div"                     { return DIV; }
"do"                      { return DO; }
"downto"                  { return DOWNTO; }
"else"                    { return ELSE; }
"end"                     { return END; }
"file"                    { return FILE; }
"for"                     { return FOR; }
"function"                { return FUNCTION; }
"goto"                    { return GOTO; }
"if"                      { return IF; }
"in"                      { return IN; }
"label"                   { return LABEL; }
"mod"                     { return MOD; }
"nil"                     { return NIL; }
"not"                     { return NOT; }
"of"                      { return OF; }
"or"                      { return OR; }
"packed"                  { return PACKED; }
"procedure"               { return PROCEDURE; }
"program"                 { return PROGRAM; }
"record"                  { return RECORD; }
"repeat"                  { return REPEAT; }
"set"                     { return SET; }
"then"                    { return THEN; }
"to"                      { return TO; }
"type"                    { return TYPE; }
"until"                   { return UNTIL; }
"var"                     { return VAR; }
"while"                   { return WHILE; }
"with"                    { return WITH; }
[a-zA-Z][a-zA-Z0-9]*      { yylval.sval = strdup(yytext); return IDENTIFIER; }
<<EOF>>                   { return EOF; }
.                         ;

%%

