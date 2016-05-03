#include "codegen.hh"
#include "utils.hh"
#include "ast.hh"
#include <cstdarg>
#include <map>
#include <memory>

static std::string *output_ptr;

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
  std::unique_ptr<block> body;
  std::string returns;
};

struct block {
  std::vector<std::string> valid_labels;
  std::map<std::string, ast_node*> const_defs;
  std::map<std::string, ast_node*> type_defs;
  std::map<std::string, ast_node*> var_decls;
  std::vector<func_decl> func_decls;
};

static void write(const char *format, ...);
static void parse_block(ast_node *node, block *out_block);
static void parse_formal_parameter_list(ast_node *formal_parameter_list,
    func_decl *decl);

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
          out_block->const_defs[const_def->data] = const_def->children[0];
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
          func_decl decl { "", 0 };
          if (proc_or_func_decl->type == N_PROCEDURE_DECL) {
            ast_node *proc_heading = proc_or_func_decl->children[0];
            decl.name = proc_heading->data;
            if (proc_heading->children.size())
              parse_formal_parameter_list(proc_heading, &decl);
            if (proc_or_func_decl->children.size() == 1)
              decl.forward = true;
            else {
              decl.body = std::unique_ptr<block>(new block);
              parse_block(proc_or_func_decl->children[1], decl.body.get());
            }
            decl.returns = "";
          } else
        }
        break;
      }
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

