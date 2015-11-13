#ifndef MAIN_HH
#define MAIN_HH

#include <string>
#include <vector>

void yyerror(const char *s);
void die(const char *format, ...);
void printvector(std::vector<std::string*> *v);

#endif

