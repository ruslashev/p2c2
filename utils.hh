#pragma once

#include <string>
#include <vector>

void yyerror(const char *s);
void die(const char *format, ...);
void dputs(std::string s);
void dprintf(const char *format, ...);
void green();
void reset();
std::string to_lower(std::string &str);
std::string join(std::vector<std::string> &v, std::string delimiter);

