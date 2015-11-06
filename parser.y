%{
#include <cstdio>
#include <iostream>

extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
 
void yyerror(const char *s);
using namespace std;
%}

%union {
	int ival;
	float fval;
	char *sval;
}

%token <ival> INT
%token <fval> FLOAT
%token <sval> STRING

%%
snazzle:
	INT snazzle      { cout << "bison found an int: " << $1 << endl; }
	| FLOAT snazzle  { cout << "bison found a float: " << $1 << endl; }
	| STRING snazzle { cout << "bison found a string: " << $1 << endl; }
	| INT            { cout << "bison found an int: " << $1 << endl; }
	| FLOAT          { cout << "bison found a float: " << $1 << endl; }
	| STRING         { cout << "bison found a string: " << $1 << endl; }
	;
%%

int main(int, char**) {
	yyin = fopen("input", "r");
	if (!yyin)
		yyerror("can't open file \"input\"");

	do {
		yyparse();
	} while (!feof(yyin));
}

void yyerror(const char *s) {
	printf("error: %s\n", s);
	exit(0);
}

