#pragma once

#include <string>
#include <vector>

void yyerror(const char *s);
void die(const char *format, ...);
void dputs(std::string s);
void dprintf(const char *format, ...);
void green();
void reset();

