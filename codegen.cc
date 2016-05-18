#include "codegen.hh"
#include "utils.hh"
#include "ast.hh"
#include <cstring>
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
  bool function;
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
  std::vector<std::tuple<std::string, int, int>> init_sets;
  std::vector<std::vector<std::string>> enums;
  std::vector<std::vector<ast_node*>> records;
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
    std::string var_name, bool *allow_merged_decl, bool full_decl);
static void write_block_functions(block *b, bool root);
static void write(const char *format, ...);
static void writeln(const char *format, ...);

static std::string *output_ptr;
static std::vector<block*> allocated_bodies;
static int indent = 0;
static bool line_start = true;

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
          out_block->type_defs[to_lower(type_def->data)] =
            type_def->children[0];
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
          p.function = false;
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
        p.function = true;
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
        p.function = true;
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
    /*
    writeln("#include \"p2c2stdlib.h\"");
    writeln("");
    */
  }
    write_block_constants(b);
    write_block_variables(b);
    write_block_functions(b, root);
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
        names[0], &allow_merged_decl, true);
    write("%s ", type_denoter_str.c_str());
    if (allow_merged_decl)
      writeln("%s;", join(names, ", ").c_str());
    else {
      std::string pointers = "";
      for (size_t i = 0; i < names.size() - 1; i++)
        pointers += "*" + names[i] + ", ";
      pointers += "*" + names[names.size() - 1] + ";";
      writeln("%s", pointers.c_str());
    }
  }
  if (b->var_decls.size())
    writeln("");
}

static std::string type_denoter_to_str(ast_node *type_denoter, block *b,
    std::string var_name, bool *allow_merged_decl, bool full_decl)
{
  std::string out = "";
  if (allow_merged_decl)
    *allow_merged_decl = true;
  switch (type_denoter->type) {
    case N_IDENTIFIER: {
      std::string simple_type = to_lower(type_denoter->data);
      if (simple_type == "integer")
        out = "int";
      else if (simple_type == "real")
        out = "float";
      else if (simple_type == "boolean")
        out = "bool";
      else if (simple_type == "char")
        out = "char";
      else if (simple_type == "string")
        out = "string";
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
              "of \"%s\"", type_denoter->data.c_str(), var_name.c_str());
        out = type_denoter_to_str(type_alias_data, b, var_name,
            allow_merged_decl, full_decl);
      }
      break;
    }
    case N_ENUMERATION: {
      bool this_enum_defined = false;
      size_t i;
      for (i = 0; i < b->enums.size() && !this_enum_defined; i++) {
        std::vector<std::string> itenum = b->enums[i];
        if (itenum == type_denoter->list)
          this_enum_defined = true;
      }
      if (this_enum_defined)
        out += "en" + std::to_string(i);
      else {
        std::string this_enum_name = "en" + std::to_string(b->enums.size() + 1);
        if (full_decl) {
          b->enums.push_back(type_denoter->list);
          out += "enum " + this_enum_name + " { ";
          for (size_t i = 0; i < type_denoter->list.size() - 1; i++) {
            out += type_denoter->list[i];
            if (i == 0)
              out += " = " + std::to_string(i) + "; ";
            out += "; ";
          }
          out += type_denoter->list[type_denoter->list.size() - 1];
          // out += " = " + std::to_string(type_denoter->list.size() - 1);
          out += " }";
        } else {
          out += this_enum_name;
        }
      }
      break;
    }
    case N_SUBRANGE: {
      ast_node *lhs = type_denoter->children[0],
        *rhs = type_denoter->children[1];
      out = "subrange<";

      if (lhs->type == N_CONSTANT)
        out += lhs->data + ",";
      else if (lhs->type == N_CONSTANT_STRING && lhs->data.size() == 1)
        out += "'" + lhs->data + "',";
      else
        die("Subrange \"%s\" left limit (>\"%s\"<..\"%s\"): strings cannot be "
            "bounds", var_name.c_str(), lhs->data.c_str(), rhs->data.c_str());

      if (rhs->type == N_CONSTANT)
        out += rhs->data + ">";
      else if (rhs->type == N_CONSTANT_STRING && rhs->data.size() == 1)
        out += "'" + rhs->data + "'>";
      else
        die("Subrange \"%s\" right limit (\"%s\"..>\"%s\"<): strings cannot be "
            "bounds", var_name.c_str(), lhs->data.c_str(), rhs->data.c_str());

      break;
    }
    case N_ARRAY: {
      ast_node *index_type_list = type_denoter->children[0],
        *array_type_denoter = type_denoter->children[1];
      std::string of_type = type_denoter_to_str(array_type_denoter, b,
          var_name, nullptr, full_decl);
      for (ast_node *ordinal_type : index_type_list->children) {
        bool found = false;
        ast_node *it_type = ordinal_type;
        while (!found) {
          switch (it_type->type) {
            case N_ENUMERATION: {
              out += "array<" + it_type->list[0] + "," + it_type->list.back() +
                ",";
              found = true;
              break;
            }
            case N_SUBRANGE: {
              ast_node *lhs = it_type->children[0], *rhs = it_type->children[1];
              out += "array<";
              if (lhs->type == N_CONSTANT)
                out += lhs->data + ",";
              else if (lhs->type == N_CONSTANT_STRING && lhs->data.size() == 1)
                out += "'" + lhs->data + "',";
              else
                die("Array \"%s\" left limit (>\"%s\"<..\"%s\"): strings "
                    "cannot be bounds", var_name.c_str(), lhs->data.c_str(),
                    rhs->data.c_str());
              if (rhs->type == N_CONSTANT)
                out += rhs->data + ",";
              else if (rhs->type == N_CONSTANT_STRING && rhs->data.size() == 1)
                out += "'" + rhs->data + "',";
              else
                die("Array \"%s\" right limit (\"%s\"..>\"%s\"<): strings "
                    "cannot be bounds", var_name.c_str(), lhs->data.c_str(),
                    rhs->data.c_str());
              found = true;
              break;
            }
            case N_IDENTIFIER: {
              std::string simple_type = to_lower(it_type->data);
              if (simple_type == "integer") {
                out += "array<INT_MIN,INT_MAX,";
                found = true;
              } else if (simple_type == "real")
                die("Array \"%s\": arrays cannot be indexed by real-type",
                    simple_type.c_str());
              else if (simple_type == "string")
                die("Array \"%s\": arrays cannot be indexed by string-type",
                    simple_type.c_str());
              else if (simple_type == "boolean") {
                out += "array<0,1,";
                found = true;
              } else if (simple_type == "char") {
                out += "array<-127,128,";
                found = true;
              } else {
                block *itb = b;
                ast_node *type_alias_data = nullptr;
                while (itb != nullptr && type_alias_data == nullptr) {
                  if (itb->type_defs.count(simple_type))
                    type_alias_data = itb->type_defs[simple_type];
                  else
                    itb = b->prev;
                }
                if (type_alias_data == nullptr)
                  die("Syntax error: unknown type \"%s\" in index type "
                      "declaration of array \"%s\"", it_type->data.c_str(),
                      var_name.c_str());
                it_type = type_alias_data;
              }
              break;
            }
            default:
              die("Unexpected ordinal type %s in array declaration of %s",
                  type_to_str(it_type->type).c_str(), var_name.c_str());
          }
        }
        if (ordinal_type == index_type_list->children.back()) {
          std::string closings = "";
          for (size_t i = 0; i < index_type_list->children.size(); i++)
            closings += ">";
          out += of_type + closings;
        }
      }
      break;
    }
    case N_RECORD: {
      if (type_denoter->children.size() == 2)
        die("record \"%s\": variant records with an explicit tag field are not "
            "supported in C", var_name.c_str());
      else {
        bool this_record_defined = false;
        size_t i;
        for (i = 0; i < b->records.size() && !this_record_defined; i++) {
          std::vector<ast_node*> record = b->records[i];
          if (record == type_denoter->children[0]->children)
            this_record_defined = true;
        }
        if (this_record_defined)
          out += "rec" + std::to_string(i);
        else {
          std::string this_record_name = "rec" + std::to_string(
              b->records.size() + 1);
          if (full_decl) {
            out += "struct " + this_record_name + " { ";
            if (type_denoter->children[0]->type == N_RECORD_VARIANT_PART)
              die("record \"%s\": variant records with an explicit tag field "
                  "are not supported in C", var_name.c_str());
            b->records.push_back(type_denoter->children[0]->children);
            for (ast_node *list_with_type :
                type_denoter->children[0]->children) {
              bool str_allow_merged_decl;
              out += type_denoter_to_str(list_with_type->children[0], b,
                  var_name, &str_allow_merged_decl, false);
              out += " ";
              if (str_allow_merged_decl)
                out += join(list_with_type->list, ", ");
              else {
                for (size_t i = 0; i < list_with_type->list.size() - 1; i++)
                  out += "*" + list_with_type->list[i] + ", ";
                out += "*" + list_with_type->list[list_with_type->list.size()
                  - 1];
              }
              out += "; ";
            }
            out += "}";
          } else
            out += this_record_name;
        }
      }
      break;
    }
    case N_SET: {
      if (full_decl) {
        out += "set(";
        ast_node *of_type = type_denoter->children[0];
        bool found = false;
        while (!found) {
          switch (of_type->type) {
            case N_ENUMERATION:
              out += type_denoter->children[0]->list[0] + "," +
                type_denoter->children[0]->list.back() + ")";
              found = true;
              break;
            case N_SUBRANGE: {
              ast_node *lhs = of_type->children[0], *rhs = of_type->children[1];
              if (lhs->type == N_CONSTANT)
                out += lhs->data + ",";
              else if (lhs->type == N_CONSTANT_STRING && lhs->data.size() == 1)
                out += "'" + lhs->data + "',";
              else
                die("Set \"%s\" left limit (>\"%s\"<..\"%s\"): strings "
                    "cannot be bounds", var_name.c_str(), lhs->data.c_str(),
                    rhs->data.c_str());
              if (rhs->type == N_CONSTANT)
                out += rhs->data + ",";
              else if (rhs->type == N_CONSTANT_STRING && rhs->data.size() == 1)
                out += "'" + rhs->data + "',";
              else
                die("Set \"%s\" right limit (\"%s\"..>\"%s\"<): strings "
                    "cannot be bounds", var_name.c_str(), lhs->data.c_str(),
                    rhs->data.c_str());
              found = true;
              break;
            }
            case N_IDENTIFIER: {
              std::string simple_type = to_lower(of_type->data);
              block *itb = b;
              ast_node *type_alias_data = nullptr;
              while (itb != nullptr && type_alias_data == nullptr) {
                if (itb->type_defs.count(simple_type))
                  type_alias_data = itb->type_defs[simple_type];
                else
                  itb = b->prev;
              }
              if (type_alias_data == nullptr)
                die("Syntax error: unknown type \"%s\" in index type "
                    "declaration of set \"%s\"", of_type->data.c_str(),
                    var_name.c_str());
              of_type = type_alias_data;
              break;
            }
            default:
              break;
          }
        }
      } else
        out += "set";
      break;
    }
    case N_FILE_TYPE:
      die("Variable declaration of \"%s\": Typed File-type variables are not "
          "supported in C", var_name.c_str());
      break;
    case N_POINTER_TYPE: {
      if (allow_merged_decl)
        *allow_merged_decl = false;
      ast_node alias;
      alias.type = N_IDENTIFIER;
      alias.data = type_denoter->data;
      out += type_denoter_to_str(&alias, b, var_name, nullptr, full_decl);
      break;
    }
    default:
      die("Syntax error: unhandled type \"%s\" in variable type",
          type_to_str(type_denoter->type).c_str());
  }
  return out;
}

static void write_block_functions(block *b, bool root)
{
  if (b->func_decls.size() && !root)
    die("Function definitions inside functions are not supported in C");
  for (func_decl &decl : b->func_decls) {
    std::string returns = decl.returns;
    if (!decl.returns.size())
      returns = "void";
    else {
      ast_node returns_ln;
      returns_ln.type = N_IDENTIFIER;
      returns_ln.data = returns;
      returns = type_denoter_to_str(&returns_ln, b, decl.name, nullptr, false);
    }
    write("%s %s(", returns.c_str(), decl.name.c_str());
    for (size_t i = 0; i < decl.formal_parameters.size(); i++) {
      formal_parameter fp = decl.formal_parameters[i];
      std::string parameter_str = "";
      if (fp.function) {
        die("Not implemented: functional formal parameters");
        ast_node returns;
        returns.type = N_IDENTIFIER;
        returns.data = fp.function_returns;
        parameter_str = type_denoter_to_str(&returns, b, decl.name, nullptr,
            false);
        parameter_str += " (*" + fp.name + ")";
      }
      parameter_str = type_denoter_to_str(fp.type, b, decl.name, nullptr,
          false) + " ";
      if (fp.var)
        parameter_str += "&";
      parameter_str += fp.name;
      if (i != decl.formal_parameters.size() - 1)
        parameter_str += ", ";
      write("%s", parameter_str.c_str());
    }
    write(")");
    if (decl.forward)
      writeln(";");
    else {
      writeln(" {");
      indent++;
      write_block(decl.body, false);
      indent--;
      writeln("}");
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
  if (line_start)
    output_ptr->append(std::string(indent * 2, ' '));
  output_ptr->append(linebuffer);
  line_start = false;
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
  if (strcmp(linebuffer, "") == 0)
    line_start = false;
  if (line_start)
    output_ptr->append(std::string(indent * 2, ' '));
  output_ptr->append(linebuffer);
  extern std::string line_ending;
  output_ptr->append(line_ending);
  line_start = true;
}

