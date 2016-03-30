#pragma once

#include <vector>
#include <string>

enum node_type {
  N_NOTSET,
  N_PROGRAM,
  N_PROGRAM_HEADING,
  N_BLOCK,
  N_LABEL_DECL,
  N_CONSTANT_DEFINITION_LIST,
  N_CONSTANT_DEFINITION,
  N_TYPE_DEFINITION_LIST,
  N_TYPE_DEFINITION,
  N_ENUMERATION,
  N_SUBRANGE,
  N_IDENTIFIER,
  N_ARRAY_INDEX_TYPE_LIST,
  N_ARRAY,
  N_LIST_WITH_TYPE,
  N_RECORD_SECTION_LIST,
  N_RECORD_VARIANT_PART,
  N_RECORD_VARIANT_SELECTOR,
  N_RECORD_VARIANT_LIST,
  N_RECORD_VARIANT,
  N_RECORD,
  N_SET,
  N_FILE_TYPE,
  N_POINTER_TYPE,
  N_VARIABLE_DECL,
  N_PROC_OR_FUNC_DECL_LIST,
  N_PROCEDURE_DECL,
  N_PROCEDURE_HEADING,
  N_FUNCTION_DECL,
  N_FUNCTION_HEADING,
  N_FUNCTION_IDENT_HEADING,
  N_FORMAL_PARAMETER_LIST,
};

struct ast_node {
  node_type type;
  std::string data;
  std::vector<std::string> list;
  ast_node *parent;
  std::vector<ast_node*> children;
  void add_child(ast_node *child);
};

ast_node *make_node();
ast_node *make_node(node_type type);

void print_ast(ast_node *root);
void delete_ast();

// vim: et:ts=2:sw=2

