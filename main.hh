#ifndef MAIN_HH
#define MAIN_HH

#include <string>
#include <vector>

void yyerror(const char *s);
void die(const char *format, ...);
void dputs(std::string s);
void dprintf(const char *format, ...);
void printvector(std::vector<std::string*> *v);
void green();
void reset();

#endif

