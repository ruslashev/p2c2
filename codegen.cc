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
  std::vector<std::pair<std::string, ast_node*>> const_defs_numbers;
  std::vector<std::pair<std::string, ast_node*>> const_defs_strings;
  std::map<std::string, ast_node*> type_defs;
  std::vector<std::pair<std::vector<std::string>, ast_node*>> var_decls;
  std::vector<func_decl> func_decls;
  std::vector<ast_node*> statements;
  block *prev;
  block() : prev(nullptr) {};
};

static void parse_block(ast_node *node, block *out_block);
static void parse_formal_parameter_list(ast_node *formal_parameter_list,
    func_decl *decl);
static void write_block(block *b, bool root);
static void write_block_constants(block *b);
static void write_block_variables(block *b);
static std::string type_denoter_to_str(ast_node *type_denoter, block *b,
    std::string var_name, bool *allow_merged_decl);
static void write(const char *format, ...);
static void writeln(const char *format, ...);

static std::string *output_ptr;
static std::vector<block*> allocated_bodies;

void generate_code(ast_node *root, std::string *output)
{
  *output = "";
  output_ptr = output;

  std::string program_name = "";
  block root_block;

  ast_node *p = root;
  for (ast_node *child : p->children)
    if (child->type == N_PROGRAM_HEADING)
      program_name = child->data;
    else if (child->type == N_BLOCK)
      parse_block(child, &root_block);

  if (!program_name.empty())
    writeln("/* Program \"%s\" */", program_name.c_str());

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
          if (const_def->children[0]->type == N_CONSTANT)
            out_block->const_defs_numbers.push_back(
                std::make_pair(const_def->data, const_def->children[0]));
          else
            out_block->const_defs_strings.push_back(
                std::make_pair(const_def->data, const_def->children[0]));
        break;
      case N_TYPE_DEF_PART:
        for (ast_node *type_def : child->children)
          out_block->type_defs[type_def->data] = type_def->children[0];
        break;
      case N_VARIABLE_DECL_PART:
        for (ast_node *var_decl : child->children) {
          std::vector<std::string> variables;
          for (std::string &s : var_decl->list)
            variables.push_back(s);
          out_block->var_decls.push_back(std::make_pair(variables,
                var_decl->children[0]));
        }
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
              decl.body->prev = out_block;
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
              decl.body->prev = out_block;
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
        die("Unexpected block element type %s",
            type_to_str(child->type).c_str());
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

static void write_block(block *b, bool root)
{
  if (root) {
    writeln("#include <stdio.h>");
    writeln("#include <limits.h>");
    /*
    writeln("");
    writeln("#define maxint INT_MAX");
    writeln("#define minint INT_MIN");
    writeln("");
    writeln("#ifdef __cplusplus");
    writeln("template <int l, int h>");
    writeln("struct subrange {");
    writeln("  int v;");
    writeln("  subrange() {}"); // TODO
    writeln("  operator int() { return v; }");
    writeln("  subrange& operator=(const int nv) {");
    writeln("    (nv >= l && nv <= h) ? (v = nv) :");
    write  ("      printf(\"Error: subrange value %%d is out of ");
    writeln("its bounds\\n\", v);");
    writeln("    return *this;");
    writeln("  }");
    writeln("};");
    writeln("");
    writeln("template <int l, int h, class T>");
    writeln("struct array {");
    writeln("  T value[h - l + 1];");
    writeln("  T& operator[](const int i) {");
    writeln("    return (i >= l && i <= h)");
    writeln("      ? value[i - l] ");
    write  ("      : printf(\"Error: indexing array out of bounds ");
    writeln("(%%d)\\n\", i);");
    writeln("  }");
    writeln("};");
    writeln("#endif");
    writeln("");
    writeln("typedef float real;");
    writeln("");
    */
    writeln("");

    write_block_constants(b);
    write_block_variables(b);
  }
}

static void write_block_constants(block *b)
{
  bool end_nl = (b->const_defs_numbers.size() || b->const_defs_strings.size());
  if (b->const_defs_numbers.size()) {
    write("const int ");
    std::pair<std::string, ast_node*> last_def = b->const_defs_numbers.back();
    b->const_defs_numbers.pop_back();
    for (std::pair<std::string, ast_node*> const_def : b->const_defs_numbers)
      write("%s = %s, ", const_def.first.c_str(),
          const_def.second->data.c_str());
    writeln("%s = %s;", last_def.first.c_str(), last_def.second->data.c_str());
  }
  if (b->const_defs_strings.size()) {
    write("const char ");
    std::pair<std::string, ast_node*> last_def = b->const_defs_strings.back();
    b->const_defs_strings.pop_back();
    for (std::pair<std::string, ast_node*> const_def : b->const_defs_strings)
      write("*%s = \"%s\", ", const_def.first.c_str(),
          const_def.second->data.c_str());
    writeln("*%s = \"%s\";", last_def.first.c_str(),
        last_def.second->data.c_str());
  }
  if (end_nl)
    writeln("");
}

static void write_block_variables(block *b)
{
  for (std::pair<std::vector<std::string>, ast_node*> var_decl : b->var_decls) {
    std::vector<std::string> names = var_decl.first;
    ast_node *type_denoter = var_decl.second;
    bool allow_merged_decl;
    std::string type_denoter_str = type_denoter_to_str(type_denoter, b,
        names[0], &allow_merged_decl);
    if (allow_merged_decl) {
      writeln("%s %s;", type_denoter_str.c_str(), join(names, ", ").c_str());
    }
  }
  if (b->var_decls.size())
    writeln("");
}

static std::string type_denoter_to_str(ast_node *type_denoter, block *b,
    std::string var_name, bool *allow_merged_decl)
{
  std::string out = "";
  if (allow_merged_decl)
    *allow_merged_decl = true;
  switch (type_denoter->type) {
    case N_IDENTIFIER: {
      std::string simple_type = type_denoter->data,
        simple_type_lower = to_lower(simple_type);
      if (simple_type_lower == "integer")
        out = "int";
      else if (simple_type_lower == "real")
        out = "float";
      else if (simple_type_lower == "boolean")
        out = "bool";
      else if (simple_type_lower == "char")
        out = "char";
      else {
        block *itb = b;
        ast_node *type_alias_data = nullptr;
        while (itb != nullptr && type_alias_data == nullptr) {
          if (itb->type_defs.count(simple_type))
            type_alias_data = itb->type_defs[simple_type];
          else
            itb = b->prev;
        }
        if (type_alias_data == nullptr)
          die("Syntax error: unknown type \"%s\" in variable declaration "
              "of \"%s\"", simple_type, var_name.c_str());
        out = type_denoter_to_str(type_alias_data, b, var_name, nullptr);
      }
      break;
    }
    case N_ENUMERATION: {
      out += "enum {";
      for (size_t i = 0; i < type_denoter->list.size() - 1; i++) {
        out += type_denoter->list[i];
        out += " = " + std::to_string(i) + "; ";
      }
      out += type_denoter->list[type_denoter->list.size() - 1];
      out += " = " + std::to_string(type_denoter->list.size() - 1);
      out += " };";
      break;
    }
    case N_SUBRANGE: {
      ast_node *lhs = type_denoter->children[0],
        *rhs = type_denoter->children[1];
      if (lhs->type == N_CONSTANT_STRING || rhs->type == N_CONSTANT_STRING)
        die("Subrange \"%s\"(%s..%s): strings cannot be bounds",
            var_name.c_str(), lhs->data.c_str(), rhs->data.c_str());
      out = "subrange<" + lhs->data + "," + rhs->data + ">";
      break;
    }
    case N_ARRAY: {
      ast_node *index_type_list = type_denoter->children[0],
        *array_type_denoter = type_denoter->children[1];
      std::string of_type = type_denoter_to_str(array_type_denoter, b,
          var_name, nullptr);
      for (ast_node *ordinal_type : index_type_list->children) {
        switch (ordinal_type->type) {
          case N_ENUMERATION: {
            out += "array<" + ordinal_type->list[0] + "," +
              ordinal_type->list[1] + ",";
            break;
          }
          case N_SUBRANGE: {
            ast_node *lhs = ordinal_type->children[0],
              *rhs = ordinal_type->children[1];
            if (lhs->type == N_CONSTANT_STRING || rhs->type == N_CONSTANT_STRING)
              die("Array \"%s\"(%s..%s): strings cannot be bounds",
                  var_name.c_str(), lhs->data.c_str(), rhs->data.c_str());
            out += "array<" + lhs->data + "," + rhs->data + ",";
            break;
          }
          case N_IDENTIFIER: {
            std::string data = type_denoter_to_str(ordinal_type, b, var_name,
                nullptr);
            if (data == "bool")
              out += "array<0,1,";
            else if (data == "char")
              out += "array<-127,128,";
            else if (data == "int")
              out += "array<INT_MIN,INT_MAX,";
            else if (data == "float")
              die("Array \"%s\": arrays cannot be indexed by real-type",
                  var_name.c_str());
            else
              die("Array \"%s\": attempt to use unknown non-ordinal type "
                  "\"%s\"(\"%s\") for indexing", var_name.c_str(),
                  ordinal_type->data.c_str(), data.c_str());
            break;
          }
          default:
            die("Unexpected ordinal type %s in array declaration of %s",
                type_to_str(ordinal_type->type).c_str(), var_name.c_str());
        }
        if (ordinal_type == index_type_list->children.back()) {
          std::string closings = "";
          for (int i = 0; i < index_type_list->children.size(); i++)
            closings += ">";
          out += of_type + closings;
        }
      }
      break;
    }
    case N_RECORD:
      break;
    case N_SET:
      break;
    case N_FILE_TYPE:
      break;
    case N_POINTER_TYPE:
      break;
    default:
      die("Syntax error: unhandled type \"%s\" in variable type",
          type_to_str(type_denoter->type).c_str());
  }
  return out;
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
}

static void writeln(const char *format, ...)
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

