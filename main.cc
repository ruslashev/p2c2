#include "utils.hh"
#include "parser.hh"
#include "ast.hh"
#include <cstdio>
#include <iostream>
#include <fstream>
#include <cstdarg>

extern int yylex();
extern FILE *yyin;
extern ast_node *root;

bool debug = false;

int main(int argc, char **argv)
{
  std::string filename;
  if (argc == 2)
    filename = std::string(argv[1]);
  else
    die("Usage: %s <input file>", argv[0]);

  yyin = fopen(filename.c_str(), "r");
  if (!yyin)
    die("Can't open file \"%s\"", filename.c_str());

  yyparse();

  puts("");

  if (root) {
    print_ast(root);
  }
}

// vim: et:ts=2:sw=2

