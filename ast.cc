#include "ast.hh"
#include <cstdio>

void ast_node::add_child(ast_node *child)
{
  child->parent = this;
  children.push_back(child);
}

static void print_type(int type) {
  switch (type) {
    case N_PROGRAM:
      printf("N_PROGRAM");
      break;
    case N_IDENTIFIER:
      printf("N_IDENTIFIER");
      break;
    default:
      printf("Unhandled type");
  }
}

static void print_node(ast_node *node, int depth)
{
  for (int i = 0; i < depth; i++)
    printf("  ");
  print_type(node->type);
  puts("{");
  for (ast_node *c : node->children)
    print_node(c, depth+1);
  printf("}");
}

void print_ast(ast_node *root)
{
  print_node(root, 0);
}

// vim: et:ts=2:sw=2

