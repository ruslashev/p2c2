#pragma once

#include <vector>
#include <string>

enum node_type {
  N_NOTSET,
  N_PROGRAM,
  N_PROGRAM_HEADING,
  N_IDENTIFIER
};

struct ast_node {
  node_type type;
  std::string data;
  ast_node *parent;
  std::vector<ast_node*> children;
  void add_child(ast_node *child);
};

ast_node *make_node();
ast_node *make_node(node_type type);

void print_ast(ast_node *root);
void delete_ast();

// vim: et:ts=2:sw=2

