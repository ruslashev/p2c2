%option caseless
%option noyywrap
%option nounput
%option yylineno

%{
#define YY_DECL extern int yylex()
#include <string>
#include <vector>
#include "parser.hh" /* all the tokens and yylval */
#include "utils.hh" /* yyerror */
%}

%x string
%x comment
%x line_comment
%x label

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

sign [\-]
digit [0-9]

label {digit_sequence}

string_element [^'\n]|"''"

%%

"+"                       { return PLUS; }
"-"                       { return MINUS; }
"*"                       { return ASTERISK; }
"/"                       { return SLASH; }
"="                       { return EQUAL; }
"<"                       { return LT; }
">"                       { return GT; }
"["|"(."                  { return LBRACKET; }
"]"|".)"                  { return RBRACKET; }
"."                       { return DOT; }
","                       { return COMMA; }
":"                       { return COLON; }
";"                       { return SEMICOLON; }
"^"|"@"                   { return UPARROW; }
"("                       { return LPAREN; }
")"                       { return RPAREN; }
"<>"                      { return LTGT; }
"<="                      { return LTE; }
">="                      { return GTE; }
":="                      { return COLEQUAL; }
".."                      { return ELLIPSIS; }
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
"forward"                 { return FORWARD; }

"label"                   { BEGIN(label); return LABEL; }
<label>{label}            { yylval.labelv = strdup(yytext);
                            if ((unsigned)atoi(yytext) > 9999)
                              yyerror("labels must be in the interval from 0 to 9999");
                            return LABELN; }
<label>","                { return COMMA; }
<label>";"                { BEGIN(INITIAL); return SEMICOLON; }
<label>" "                ;

"'"                       { BEGIN(string); }
<string>{string_element}+ { yylval.strv = strdup(yytext); return STRING; }
<string>"'"               { BEGIN(INITIAL); }
<string>\n                { yyerror("string cannot contain newline"); }

"{"|"(*"                  { BEGIN(comment); }
<comment>"}"|"*)"         { BEGIN(INITIAL); }
<comment>\n               ;
<comment>.                ;

"//"                      { BEGIN(line_comment); }
<line_comment>\n          { BEGIN(INITIAL); }
<line_comment>.           ;

[a-z][_a-z0-9\-]*         { yylval.identv = strdup(yytext); return IDENTIFIER; }
{number}                  { yylval.numberv = strdup(yytext); return NUMBER; }

[ \t\r\n]*                ;
.                         { printf("unknown character '%c' in string on line %d\n", *yytext, yylineno); }

%%
/*
<string>.                 { printf("unhandled character in string: %c\n", *yytext); }
 */

// vim: et:ts=2:sw=2

