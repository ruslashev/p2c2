#include "main.hh"
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
	printf("error: %s\n", s);
	exit(0);
}


// vim: et:ts=2:sw=2

