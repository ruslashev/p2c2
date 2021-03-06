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

std::string type_to_str(node_type type)
{
  const std::map<node_type,std::string> strings = {
    { N_NOTSET, "N_NOTSET" },
    { N_PROGRAM, "N_PROGRAM" },
    { N_PROGRAM_HEADING, "N_PROGRAM_HEADING" },
    { N_BLOCK, "N_BLOCK" },
    { N_LABEL_DECL_PART, "N_LABEL_DECL_PART" },
    { N_CONSTANT_DEF_PART, "N_CONSTANT_DEF_PART" },
    { N_CONSTANT_DEFINITION, "N_CONSTANT_DEFINITION" },
    { N_CONSTANT, "N_CONSTANT" },
    { N_CONSTANT_STRING, "N_CONSTANT_STRING" },
    { N_CONSTANT_LIST, "N_CONSTANT_LIST" },
    { N_TYPE_DEF_PART, "N_TYPE_DEF_PART" },
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
    { N_VARIABLE_DECL_PART, "N_VARIABLE_DECL_PART" },
    { N_PROC_OR_FUNC_DECL_PART, "N_PROC_OR_FUNC_DECL_PART" },
    { N_PROCEDURE_DECL, "N_PROCEDURE_DECL" },
    { N_PROCEDURE_HEADING, "N_PROCEDURE_HEADING" },
    { N_FUNCTION_DECL, "N_FUNCTION_DECL" },
    { N_FUNCTION_HEADING, "N_FUNCTION_HEADING" },
    { N_FUNCTION_IDENT_HEADING, "N_FUNCTION_IDENT_HEADING" },
    { N_FORMAL_PARAMETER_LIST, "N_FORMAL_PARAMETER_LIST" },
    { N_EXPRESSION, "N_EXPRESSION" },
    { N_TERM_LIST, "N_TERM_LIST" },
    { N_FACTOR_LIST, "N_FACTOR_LIST" },
    { N_FACTOR, "N_FACTOR" },
    { N_FACTOR_PARENS_EXPRESSION, "N_FACTOR_PARENS_EXPRESSION" },
    { N_FACTOR_NOT_FACTOR, "N_FACTOR_NOT_FACTOR" },
    { N_VARIABLE_ACCESS_SIMPLE, "N_VARIABLE_ACCESS_SIMPLE" },
    { N_VARIABLE_ACCESS_ARRAY_ACCESS, "N_VARIABLE_ACCESS_ARRAY_ACCESS" },
    { N_VARIABLE_ACCESS_FIELD_DESIGNATOR, "N_VARIABLE_ACCESS_FIELD_DESIGNATOR" },
    { N_VARIABLE_ACCESS_BUFFER_VARIABLE, "N_VARIABLE_ACCESS_BUFFER_VARIABLE" },
    { N_INDEX_EXPRESSION_LIST, "N_INDEX_EXPRESSION_LIST" },
    { N_UNSIGNED_CONSTANT_NUMBER, "N_UNSIGNED_CONSTANT_NUMBER" },
    { N_UNSIGNED_CONSTANT_STRING, "N_UNSIGNED_CONSTANT_STRING" },
    { N_UNSIGNED_CONSTANT_NIL, "N_UNSIGNED_CONSTANT_NIL" },
    { N_SET_CONSTRUCTOR, "N_SET_CONSTRUCTOR" },
    { N_SET_MEMBER_DESIGNATOR_LIST, "N_SET_MEMBER_DESIGNATOR_LIST" },
    { N_SET_MEMBER_DESIGNATOR, "N_SET_MEMBER_DESIGNATOR" },
    { N_ASTERISK, "N_ASTERISK" },
    { N_SLASH, "N_SLASH" },
    { N_DIV, "N_DIV" },
    { N_MOD, "N_MOD" },
    { N_AND, "N_AND" },
    { N_PLUS, "N_PLUS" },
    { N_MINUS, "N_MINUS" },
    { N_OR, "N_OR" },
    { N_EQUAL, "N_EQUAL" },
    { N_LTGT, "N_LTGT" },
    { N_LT, "N_LT" },
    { N_GT, "N_GT" },
    { N_LTE, "N_LTE" },
    { N_GTE, "N_GTE" },
    { N_IN, "N_IN" },
    { N_FUNCTION_DESIGNATOR, "N_FUNCTION_DESIGNATOR" },
    { N_ACTUAL_PARAMETER_LIST, "N_ACTUAL_PARAMETER_LIST" },
    { N_ACTUAL_PARAMETER, "N_ACTUAL_PARAMETER" },
    { N_EMPTY_STATEMENT, "N_EMPTY_STATEMENT" },
    { N_ASSIGNMENT_STATEMENT, "N_ASSIGNMENT_STATEMENT" },
    { N_PROC_OR_FUNC_STATEMENT, "N_PROC_OR_FUNC_STATEMENT" },
    { N_PROC_FUNC_OR_VARIABLE, "N_PROC_FUNC_OR_VARIABLE" },
    { N_GOTO, "N_GOTO" },
    { N_STATEMENT_PART, "N_STATEMENT_PART" },
    { N_IF, "N_IF" },
    { N_CASE, "N_CASE" },
    { N_CASE_ELEMENT_LIST, "N_CASE_ELEMENT_LIST" },
    { N_CASE_ELEMENT, "N_CASE_ELEMENT" },
    { N_REPEAT, "N_REPEAT" },
    { N_WHILE, "N_WHILE" },
    { N_FOR_TO, "N_FOR_TO" },
    { N_FOR_DOWNTO, "N_FOR_DOWNTO" },
    { N_WITH, "N_WITH" },
    { N_RECORD_VARIABLE_LIST, "N_RECORD_VARIABLE_LIST" },
    { N_FACTOR_SET_CONS, "N_FACTOR_SET_CONS" },
    { N_FACTOR_FUNC_DESIGNATOR, "N_FACTOR_FUNC_DESIGNATOR" },
    { N_LABELLED_STATEMENT, "N_LABELLED_STATEMENT" }
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
    if (node->children.size() == 1)
      printf(" (1 child) {\n");
    else
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

