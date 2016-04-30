#pragma once

#include <vector>
#include <string>

enum node_type {
  N_NOTSET,
  N_PROGRAM,
  N_PROGRAM_HEADING,
  N_BLOCK,
  N_LABEL_DECL_PART,
  N_CONSTANT_DEF_PART,
  N_CONSTANT_DEFINITION,
  N_CONSTANT,
  N_CONSTANT_STRING,
  N_TYPE_DEF_PART,
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
  N_VARIABLE_DECL_PART,
  N_PROC_OR_FUNC_DECL_PART,
  N_PROCEDURE_DECL,
  N_PROCEDURE_HEADING,
  N_FUNCTION_DECL,
  N_FUNCTION_HEADING,
  N_FUNCTION_IDENT_HEADING,
  N_FORMAL_PARAMETER_LIST,
  N_EXPRESSION,
  N_TERM_LIST,
  N_FACTOR_LIST,
  N_FACTOR,
  N_PARENS_EXPRESSION,
  N_NOT_FACTOR,
  N_VARIABLE_ACCESS_SIMPLE,
  N_VARIABLE_ACCESS_ARRAY_ACCESS,
  N_VARIABLE_ACCESS_FIELD_DESIGNATOR,
  N_VARIABLE_ACCESS_BUFFER_VARIABLE,
  N_INDEX_EXPRESSION_LIST,
  N_UNSIGNED_CONSTANT_NUMBER,
  N_UNSIGNED_CONSTANT_STRING,
  N_UNSIGNED_CONSTANT_NIL,
  N_SET_CONSTRUCTOR,
  N_SET_MEMBER_DESIGNATOR_LIST,
  N_SET_MEMBER_DESIGNATOR,
  N_ASTERISK,
  N_SLASH,
  N_DIV,
  N_MOD,
  N_AND,
  N_PLUS,
  N_MINUS,
  N_OR,
  N_EQUAL,
  N_LTGT,
  N_LT,
  N_GT,
  N_LTE,
  N_GTE,
  N_IN,
  N_FUNCTION_DESIGNATOR,
  N_ACTUAL_PARAMETER_LIST,
  N_ACTUAL_PARAMETER,
  N_EMPTY_STATEMENT,
  N_ASSIGNMENT_STATEMENT,
  N_PROC_OR_FUNC_STATEMENT,
  N_PROC_FUNC_OR_VARIABLE,
  N_GOTO,
  N_STATEMENT_PART,
  N_IF,
  N_CASE,
  N_CASE_ELEMENT_LIST,
  N_CASE_ELEMENT,
  N_REPEAT,
  N_WHILE,
  N_FOR_TO,
  N_FOR_DOWNTO,
  N_WITH,
  N_RECORD_VARIABLE_LIST
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

std::string type_to_str(node_type type);
void print_ast(ast_node *root);
void delete_ast();

// vim: et:ts=2:sw=2

