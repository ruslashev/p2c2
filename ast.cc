#include "ast.hh"
#include "utils.hh"
#include <cstdio>
#include <memory>
#include <string>
#include <vector>
#include <map>

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

static void print_vector(std::vector<std::string> *v)
{
  printf("[");
  for (size_t i = 0; i < v->size()-1; i++)
    printf("%s, ", (v->at(i)).c_str());
  printf("%s]", (v->at(v->size()-1)).c_str());
}

static std::string type_to_str(node_type type) {
  const std::map<node_type,std::string> strings = {
    { N_NOTSET, "N_NOTSET" },
    { N_PROGRAM, "N_PROGRAM" },
    { N_PROGRAM_HEADING, "N_PROGRAM_HEADING" },
    { N_BLOCK, "N_BLOCK" },
    { N_LABEL_DECL, "N_LABEL_DECL" },
    { N_CONSTANT_DEFINITION_LIST, "N_CONSTANT_DEFINITION_LIST" },
    { N_CONSTANT_DEFINITION, "N_CONSTANT_DEFINITION" },
    { N_TYPE_DEFINITION_LIST, "N_TYPE_DEFINITION_LIST" },
    { N_TYPE_DEFINITION, "N_TYPE_DEFINITION" },
    { N_ENUMERATION, "N_ENUMERATION" },
    { N_SUBRANGE, "N_SUBRANGE" },
    { N_IDENTIFIER, "N_IDENTIFIER" },
    { N_ARRAY_INDEX_TYPE_LIST, "N_ARRAY_INDEX_TYPE_LIST" },
    { N_ARRAY, "N_ARRAY" },
    { N_LIST_WITH_TYPE, "N_LIST_WITH_TYPE" },
    { N_RECORD_SECTION_LIST, "N_RECORD_SECTION_LIST" },
    { N_RECORD_VARIANT_PART, "N_RECORD_VARIANT_PART" },
    { N_RECORD_VARIANT_SELECTOR, "N_RECORD_VARIANT_SELECTOR" },
    { N_RECORD_VARIANT_LIST, "N_RECORD_VARIANT_LIST" },
    { N_RECORD_VARIANT, "N_RECORD_VARIANT" },
    { N_RECORD, "N_RECORD" },
    { N_SET, "N_SET" },
    { N_FILE_TYPE, "N_FILE_TYPE" },
    { N_POINTER_TYPE, "N_POINTER_TYPE" },
    { N_VARIABLE_DECL, "N_VARIABLE_DECL" },
  };
  if (strings.count(type))
    return strings.at(type);
  else
    return "Unknown node type";
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
    print_vector(&node->list);
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

