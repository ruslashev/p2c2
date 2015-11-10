%option caseless
%option noyywrap
%option nounput
%option yylineno

%{
#define YY_DECL extern "C" int yylex()
#include "parser.hh"
%}

letter [a-z]
identifier {letter}("_"({letter}|{digit}))*

number {signed_real}|{signed_integer}
signed_real {sign}?{unsigned_real}
signed_integer {sign}?{unsigned_integer}
unsigned_real {digit_sequence}(("."{fractional_part}("e"{scale_factor})?)|("e"{scale_factor}))
unsigned_integer {digit_sequence}
fractional_part {digit_sequence}
scale_factor {sign}?{digit_sequence}
digit_sequence {digit}+
sign [+\-]
digit [0-9]

%%

"+"                       { yylval.opv = strdup(yytext); return PLUS; }
"-"                       { yylval.opv = strdup(yytext); return MINUS; }
"*"                       { yylval.opv = strdup(yytext); return ASTERISK; }
"/"                       { yylval.opv = strdup(yytext); return SLASH; }
"="                       { yylval.opv = strdup(yytext); return EQUAL; }
"<"                       { yylval.opv = strdup(yytext); return LT; }
">"                       { yylval.opv = strdup(yytext); return GT; }
"["                       { yylval.opv = strdup(yytext); return LBRACKET; }
"]"                       { yylval.opv = strdup(yytext); return RBRACKET; }
"."                       { yylval.opv = strdup(yytext); return DOT; }
","                       { yylval.opv = strdup(yytext); return COMMA; }
":"                       { yylval.opv = strdup(yytext); return COLON; }
";"                       { yylval.opv = strdup(yytext); return SEMICOLON; }
"'"                       { yylval.opv = strdup(yytext); return QUOTE; }
"("                       { yylval.opv = strdup(yytext); return LPAREN; }
")"                       { yylval.opv = strdup(yytext); return RPAREN; }
"<>"                      { yylval.opv = strdup(yytext); return LTGT; }
"<="                      { yylval.opv = strdup(yytext); return LTE; }
">="                      { yylval.opv = strdup(yytext); return GTE; }
":="                      { yylval.opv = strdup(yytext); return COLEQUAL; }
".."                      { yylval.opv = strdup(yytext); return ELLIPSIS; }
"and"                     { return AND; }
"array"                   { return ARRAY; }
"begin"                   { return TOKBEGIN; }
"case"                    { return CASE; }
"const"                   { return CONST; }
"div"                     { return DIV; }
"do"                      { return DO; }
"downto"                  { return DOWNTO; }
"else"                    { return ELSE; }
"end"                     { return END; }
"file"                    { return TOKFILE; }
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
"otherwise"               { return OTHERWISE; }
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

[a-z][_a-z0-9]*           { yylval.strv = strdup(yytext); return IDENTIFIER; }
{number}                  { yylval.numberv = strdup(yytext); return NUMBER; }

[ \t\r]*                  /* ignore */;
[\n]                      { yylineno++; }
.                         { printf("unknown character %c\n", *yytext); }

%%

// vim: et:ts=2:sw=2

