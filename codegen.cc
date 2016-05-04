#include "codegen.hh"
#include "utils.hh"
#include "ast.hh"
#include <cstdarg>
#include <map>
#include <memory>
#include <vector>

struct formal_parameter {
  std::string name;
  ast_node *type;
  bool var;
  ast_node *function_formal_parameters;
  std::string function_returns;
};

struct block;

struct func_decl {
  std::string name;
  bool forward;
  std::vector<formal_parameter> formal_parameters;
  block *body;
  std::string returns;
};

struct block {
  std::vector<std::string> valid_labels;
  std::vector<std::pair<std::string, ast_node*>> const_defs;
  std::map<std::string, ast_node*> type_defs;
  std::map<std::string, ast_node*> var_decls;
  std::vector<func_decl> func_decls;
  std::vector<ast_node*> statements;
};

static void write(const char *format, ...);
static void parse_block(ast_node *node, block *out_block);
static void parse_formal_parameter_list(ast_node *formal_parameter_list,
    func_decl *decl);
static void write_block(block *b, bool root);

static std::string *output_ptr;
static std::vector<block*> allocated_bodies;

void generate_code(ast_node *root, std::string *output)
{
  *output = "";
  output_ptr = output;

  std::string program_name = "";
  block root_block;

  ast_node *p = root;
  for (ast_node *child : p->children) {
    if (child->type == N_PROGRAM_HEADING)
      program_name = child->data;
    else if (child->type == N_BLOCK) {
      parse_block(child, &root_block);
    }
  }

  if (!program_name.empty())
    write("/* Program \"%s\" */", program_name.c_str());

  write_block(&root_block, true);

  for (block *body : allocated_bodies)
    delete body;
}

static void parse_block(ast_node *node, block *out_block)
{
  for (ast_node *child : node->children) {
    switch (child->type) {
      case N_LABEL_DECL_PART:
        for (std::string &s : child->list)
          out_block->valid_labels.push_back(s);
        break;
      case N_CONSTANT_DEF_PART:
        for (ast_node *const_def : child->children)
          out_block->const_defs.push_back(std::make_pair(const_def->data, const_def->children[0]));
        break;
      case N_TYPE_DEF_PART:
        for (ast_node *type_def : child->children)
          out_block->type_defs[type_def->data] = type_def->children[0];
        break;
      case N_VARIABLE_DECL_PART:
        for (ast_node *var_decl : child->children)
          for (std::string &s : var_decl->list)
            out_block->var_decls[s] = var_decl->children[0];
        break;
      case N_PROC_OR_FUNC_DECL_PART: {
        for (ast_node *proc_or_func_decl : child->children) {
          func_decl decl;
          if (proc_or_func_decl->type == N_PROCEDURE_DECL) {
            ast_node *proc_heading = proc_or_func_decl->children[0];
            decl.name = proc_heading->data;
            if (proc_heading->children.size())
              parse_formal_parameter_list(proc_heading->children[0], &decl);
            if (proc_or_func_decl->children.size() == 1)
              decl.forward = true;
            else {
              decl.forward = false;
              decl.body = new block;
              allocated_bodies.push_back(decl.body);
              parse_block(proc_or_func_decl->children[1], decl.body);
            }
            decl.returns = "";
          } else if (proc_or_func_decl->type == N_FUNCTION_DECL) {
            ast_node *heading_or_ident = proc_or_func_decl->children[0];
            if (heading_or_ident->type == N_FUNCTION_HEADING) {
              decl.name = heading_or_ident->list[0];
              decl.returns = heading_or_ident->list[1];
              if (heading_or_ident->children.size())
                parse_formal_parameter_list(heading_or_ident->children[0],
                    &decl);
            } else /* N_FUNCTION_IDENT_HEADING */ {
              decl.name = heading_or_ident->data;
              decl.returns = "";
            }
            if (proc_or_func_decl->children.size() == 1)
              decl.forward = true;
            else {
              decl.forward = false;
              decl.body = new block;
              allocated_bodies.push_back(decl.body);
              parse_block(proc_or_func_decl->children[1], decl.body);
            }
          }
          out_block->func_decls.push_back(decl);
        }
        break;
      }
      case N_STATEMENT_PART:
        for (ast_node *statement : child->children)
          out_block->statements.push_back(statement);
        break;
      default:
        break;
    }
  }
}

static void parse_formal_parameter_list(ast_node *formal_parameter_list,
    func_decl *decl)
{
  for (ast_node *formal_parameter_node : formal_parameter_list->children)
    switch (formal_parameter_node->type) {
      case N_LIST_WITH_TYPE: {
        for (std::string &s : formal_parameter_node->list) {
          formal_parameter p;
          p.name = s;
          p.type = formal_parameter_node->children[0];
          p.var = (formal_parameter_node->data == "var");
          decl->formal_parameters.push_back(p);
        }
        break;
      }
      case N_PROCEDURE_HEADING: {
        formal_parameter p;
        p.name = formal_parameter_node->data;
        p.var = false;
        if (formal_parameter_node->children.size())
          p.function_formal_parameters = formal_parameter_node->children[0];
        p.function_returns = "";
        decl->formal_parameters.push_back(p);
        break;
      }
      case N_FUNCTION_HEADING: {
        formal_parameter p;
        p.name = formal_parameter_node->list[0];
        p.var = false;
        if (formal_parameter_node->children.size())
          p.function_formal_parameters = formal_parameter_node->children[0];
        p.function_returns = formal_parameter_node->list[1];
        decl->formal_parameters.push_back(p);
        break;
      }
      default:
        die("Syntax error: unhandled type \"%s\" in formal parameter section",
            type_to_str(formal_parameter_node->type).c_str());
    }
}

static void write(const char *format, ...)
{
  char linebuffer[1024];
  va_list args;
  va_start(args, format);
  int wr = vsnprintf(linebuffer, 1024, format, args);
  if (wr < 0 || wr >= 1024)
    die("failed to write string");
  va_end(args);
  output_ptr->append(linebuffer);
  extern std::string line_ending;
  output_ptr->append(line_ending);
}

static void write_block(block *b, bool root)
{
  if (root) {
    write("#include <stdio.h>");
    write("");
    for (std::pair<std::string, ast_node*> const_def : b->const_defs) {
      if (const_def.second->type == N_CONSTANT)
        write("const int %s = %s;", const_def.first.c_str(),
            const_def.second->data.c_str());
      else
        write("const char *%s = \"%s\";", const_def.first.c_str(),
            const_def.second->data.c_str());
    }
  }
}

