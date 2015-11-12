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
  extern char *yytext;
  extern int yylineno; // from lexer
	printf("error: %s at symbol \"%s\" on line %d\n", s, yytext, yylineno);
	exit(0);
}

void printvector(std::vector<std::string*> *v)
{
  printf("[");
  for (size_t i = 0; i < v->size()-1; i++)
    printf("%s, ", (v->at(i))->c_str());
  printf("%s]", (v->at(v->size()-1))->c_str());
}

// vim: et:ts=2:sw=2

