#include "main.hh"
#include "parser.hh"

#include <cstdio>
#include <iostream>
#include <fstream>
#include <cstdarg>

extern "C" int yylex();
extern "C" FILE *yyin;

int main(int argc, char **argv)
{
  std::string filename = "input.pas";
  if (argc == 2)
    filename = std::string(argv[1]);
  else if (argc >= 3)
    die("Usage: %s [input-file]\n", argv[0]);

  yyin = fopen(filename.c_str(), "r");
  if (!yyin)
    die("can't open file \"%s\"", filename.c_str());

  yyparse();
}

void yyerror(const char *s)
{
  extern char *yytext;
  extern int yylineno; // from lexer
  printf("error: %s at symbol \"%s\" on line %d\n", s, yytext, yylineno);
  exit(0);
}

void die(const char *format, ...)
{
  va_list args;
  va_start(args, format);
  vprintf(format, args);
  va_end(args);
  printf("\n");
  exit(0);
}

const bool debug = false;

void dputs(std::string s)
{
  if (debug)
    puts(s.c_str());
}

void dprintf(const char *format, ...)
{
  va_list args;
  va_start(args, format);
  if (debug)
    vprintf(format, args);
  va_end(args);
}

void printvector(std::vector<std::string*> *v)
{
  dprintf("[");
  for (size_t i = 0; i < v->size()-1; i++)
    dprintf("%s, ", (v->at(i))->c_str());
  dprintf("%s]", (v->at(v->size()-1))->c_str());
}

void green()
{
  fputs("\x1b[32m", stdout);
}

void reset()
{
  fputs("\x1b[0m", stdout);
}

// vim: et:ts=2:sw=2

