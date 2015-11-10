#include "main.hh"
#include <string>
#include "parser.hh"

#include <cstdio>
#include <iostream>
#include <fstream>

extern "C" int yylex();
extern "C" FILE *yyin;

int main()
{
	yyin = fopen("input", "r");
	if (!yyin)
		yyerror("can't open file \"input\"");

  yyparse();
}

void yyerror(const char *s)
{
  extern char *yytext;
  extern int yylineno; // from lexer
	printf("error: %s at symbol \"%s\" on line %d\n", s, yytext, yylineno);
	exit(0);
}

// vim: et:ts=2:sw=2

