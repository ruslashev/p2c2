#include "utils.hh"
#include "parser.hh"

#include <cstdio>
#include <iostream>
#include <fstream>
#include <cstdarg>

extern "C" int yylex();
extern "C" FILE *yyin;

int main(int argc, char **argv)
{
  std::string filename;
  if (argc == 2)
    filename = std::string(argv[1]);
  else
    die("Usage: %s <input file>\n", argv[0]);

  yyin = fopen(filename.c_str(), "r");
  if (!yyin)
    die("Can't open file \"%s\"", filename.c_str());

  yyparse();
}

// vim: et:ts=2:sw=2

