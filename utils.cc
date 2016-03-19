#include "utils.hh"

#include <cstdio>
#include <iostream>
#include <fstream>
#include <cstdarg>

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

void dputs(std::string s)
{
  extern int debug;
  if (debug)
    puts(s.c_str());
}

void dprintf(const char *format, ...)
{
  va_list args;
  va_start(args, format);
  extern int debug;
  if (debug)
    vprintf(format, args);
  va_end(args);
}

void printvector(std::vector<std::string> *v)
{
  dprintf("[");
  for (size_t i = 0; i < v->size()-1; i++)
    dprintf("%s, ", (v->at(i)).c_str());
  dprintf("%s]", (v->at(v->size()-1)).c_str());
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

