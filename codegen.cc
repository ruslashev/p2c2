#include "codegen.hh"
#include "utils.hh"
#include "ast.hh"
#include <cstdarg>
#include <map>

static std::string *output_ptr;
struct block {
  std::map<std::string, ast_node> type_defs;
  std::map<std::string, std::string> const_defs;
  std::vector<std::string> valid_labels;
};

static void write(const char *format, ...);
static void parse_block(ast_node *node, block *out_block);

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
      block new_block;
      parse_block(child, &new_block);
    }
  }

  if (!program_name.empty())
    write("/* program %s */", program_name.c_str());
}

static void parse_block(ast_node *node, block *out_block)
{
  for (ast_node *child : node->children) {
    switch (child->type) {
      case N_LABEL_DECL_PART:
        break;
      case N_CONSTANT_DEF_PART:
        for (ast_node *const_def : child->children) {
          out_block->const_defs[const_def->list[0]] = const_def->list[1];
          printf("%s = %s\n", const_def->list[0].c_str(), const_def->list[1].c_str());
        }
        break;
      case N_TYPE_DEF_PART:
        break;
      case N_VARIABLE_DECL_PART:
        break;
      case N_PROC_OR_FUNC_DECL_PART:
        break;
      default:
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

