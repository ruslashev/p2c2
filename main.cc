#include "utils.hh"
#include "parser.hh"
#include "ast.hh"
#include "codegen.hh"
#include <cstdio>
#include <iostream>
#include <fstream>
#include <cstdarg>

bool debug = false, color = false;
std::string line_ending = "\n";

int main(int argc, char **argv)
{
  extern FILE *yyin;
  extern ast_node *root;

  std::string filename;
  if (argc == 2)
    filename = std::string(argv[1]);
  else
    die("Usage: %s <input file>", argv[0]);

  yyin = fopen(filename.c_str(), "r");
  if (!yyin)
    die("Can't open file \"%s\"", filename.c_str());

  yyparse();

  // puts("");
  // print_ast(root);

  std::string code = "";
  generate_code(root, &code);
  printf("\nGenerated code: {{{\n%s}}}\n", code.c_str());

  delete_ast();
  fclose(yyin);
}

// vim: et:ts=2:sw=2

