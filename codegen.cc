#include "codegen.hh"
#include "utils.hh"
#include "ast.hh"
#include <cstdarg>

static std::string *output_ptr;

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

void generate_code(ast_node *root, std::string *output)
{
  *output = "";
  output_ptr = output;

  std::string program_name = "";

  ast_node *p = root;
  for (ast_node *child : p->children) {
    if (child->type == N_PROGRAM_HEADING)
      program_name = child->data;
  }

  if (!program_name.empty())
    write("/* program %s */", program_name.c_str());
}

