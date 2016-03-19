#include "ast.hh"
#include "utils.hh"
#include <cstdio>
#include <memory>
#include <string>
#include <vector>

static std::vector<ast_node*> allocated_nodes;

void ast_node::add_child(ast_node *child)
{
  if (!child)
    return;
  child->parent = this;
  children.push_back(child);
}

ast_node *make_node()
{
  ast_node *node = new ast_node;
  node->type = N_NOTSET;
  node->data = "";
  node->parent = nullptr;
  allocated_nodes.push_back(node);
  return node;
}

ast_node *make_node(node_type type)
{
  ast_node *node = new ast_node;
  node->type = type;
  node->data = "";
  node->parent = nullptr;
  allocated_nodes.push_back(node);
  return node;
}

static std::string type_to_str(node_type type) {
  switch (type) {
    case N_NOTSET:
      return "N_NOTSET";
    case N_PROGRAM:
      return "N_PROGRAM";
    case N_PROGRAM_HEADING:
      return "N_PROGRAM_HEADING";
    case N_BLOCK:
      return "N_BLOCK";
    case N_LABEL_DECL:
      return "N_LABEL_DECL";
    default:
      return "Unhandled type";
  }
}

static void indent(int depth)
{
  for (int i = 0; i < depth; i++)
    printf("  ");
}

static void print_node(ast_node *node, int depth)
{
  indent(depth);
  printf("<%s>", type_to_str(node->type).c_str());
  if (node->data.size())
    printf(" \"%s\"", node->data.c_str());
  if (node->list.size()) {
    printf(" ");
    printvector(&node->list);
  }
  if (node->children.size()) {
    printf(" (%zu children) {\n", node->children.size());
    for (ast_node *c : node->children)
      print_node(c, depth+1);
    indent(depth);
    printf("}\n");
  } else
    printf("\n");
}

void print_ast(ast_node *root)
{
  print_node(root, 0);
}

void delete_ast()
{
  for (size_t i = 0; i < allocated_nodes.size(); i++)
    delete allocated_nodes[i];
}

// vim: et:ts=2:sw=2

