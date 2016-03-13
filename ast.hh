#pragma once

#include <vector>

enum node_type {
  N_PROGRAM,
  N_IDENTIFIER
};

struct ast_node {
  node_type type;
  ast_node *parent;
  std::vector<ast_node*> children;
  void add_child(ast_node *child);
};

void print_ast(ast_node *root);

// vim: et:ts=2:sw=2

