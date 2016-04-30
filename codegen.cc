#include "codegen.hh"
#include "utils.hh"
#include "ast.hh"
#include <cstdarg>
#include <map>

static std::string *output_ptr;
static struct {
  std::string name = "";
} program;

static void write(const char *format, ...);
static void parse_block(ast_node *node);

void generate_code(ast_node *root, std::string *output)
{
  *output = "";
  output_ptr = output;

  ast_node *p = root;
  for (ast_node *child : p->children) {
    if (child->type == N_PROGRAM_HEADING)
      program.name = child->data;
    else if (child->type == N_BLOCK) {
      parse_block(child);
    }
  }

  if (!program.name.empty())
    write("/* program %s */", program.name.c_str());
}

static void parse_block(ast_node *node)
{
  std::map<std::string, ast_node> type_defs;
  for (ast_node *child : node->children) {
    switch (child->type) {
      case N_LABEL_DECL_PART:
        break;
      case N_CONSTANT_DEF_PART:
        break;
      case N_TYPE_DEF_PART:
        break;
      case N_VARIABLE_DECL_PART:
        break;
      case N_PROC_OR_FUNC_DECL_PART:
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

