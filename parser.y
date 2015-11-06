%{
#include "main.hh"

#include <iostream>

extern "C" int yylex();

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
	snazzle INT      { cout << "bison found an int: " << $2 << endl; }
	| snazzle FLOAT  { cout << "bison found a float: " << $2 << endl; }
	| snazzle STRING { cout << "bison found a string: " << $2 << endl; }
	| INT            { cout << "bison found an int: " << $1 << endl; }
	| FLOAT          { cout << "bison found a float: " << $1 << endl; }
	| STRING         { cout << "bison found a string: " << $1 << endl; }
	;

%%

