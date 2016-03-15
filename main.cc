#include "utils.hh"
#include "parser.hh"
#include "ast.hh"

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
    die("Usage: %s <input file>", argv[0]);

  yyin = fopen(filename.c_str(), "r");
  if (!yyin)
    die("Can't open file \"%s\"", filename.c_str());

  yyparse();

  puts("");

  ast_node *root = make_node(N_PROGRAM);

  ast_node *id = make_node(N_IDENTIFIER);
  ast_node *id2 = make_node(N_IDENTIFIER);

  root->add_child(id);
  root->add_child(id2);

  print_ast(root);
  delete_ast();
}

// vim: et:ts=2:sw=2

