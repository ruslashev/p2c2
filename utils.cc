#include "utils.hh"

#include <cstdio>
#include <iostream>
#include <fstream>
#include <cstdarg>
#include <locale>

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

void green()
{
  extern int color;
  if (color)
    fputs("\x1b[32m", stdout);
}

void reset()
{
  extern int color;
  if (color)
    fputs("\x1b[0m", stdout);
}

std::string to_lower(std::string &str)
{
  std::locale loc;
  std::string out = "";
  for (size_t i = 0; i < str.length(); i++)
    out.push_back(std::tolower(str[i], loc));
  return out;
}

std::string join(std::vector<std::string> &v, std::string delimiter)
{
  std::string out = "";
  for (size_t i = 0; i < v.size() - 1; i++) {
    out.append(v[i]);
    out.append(delimiter);
  }
  out.append(v[v.size() - 1]);
  return out;
}

// vim: et:ts=2:sw=2

