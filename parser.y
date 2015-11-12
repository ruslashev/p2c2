%{
#include <string>
#include <fstream>
#include <cstring>
#include <vector>

#include "main.hh"

extern "C" int yylex();
#define YYDEBUG 1
%}

%glr-parser
/* %expect 2 */

%union {
  char *identv;
  char *numberv;
  char *opv;
  char *strv;
  char *labelv;
  /* (^) used in lex. (v) used in bison */
  std::string *string;
  std::vector<std::string*> *strvector;
}

%token <opv> PLUS MINUS ASTERISK SLASH EQUAL LT GT LBRACKET RBRACKET DOT COMMA
%token <opv> COLON SEMICOLON UPARROW LPAREN RPAREN LTGT LTE GTE COLEQUAL ELLIPSIS
%token AND ARRAY TOKBEGIN CASE CONST DIV DO DOWNTO ELSE END TOKFILE FOR FUNCTION
%token GOTO IF IN MOD NIL NOT OF OR OTHERWISE PACKED PROCEDURE PROGRAM RECORD
%token REPEAT SET THEN TO TYPE UNTIL VAR WHILE WITH

%token <identv> IDENTIFIER;
%token <numberv> NUMBER;
%token <strv> STRING;
%token LABEL LABELCOMMA LABELSEMICOLON;
%token <labelv> LABELN;

%type <string> identifier number string sign label constant;
%type <string> type_identifier type_denoter;
%type <strvector> identifier_list;

%start program

%%

program: program term
       | term;

term: block;

identifier: IDENTIFIER { $$ = new std::string($1); /* printf("ident: <%s>\n", $1); */ };
number: NUMBER { $$ = new std::string($1); /* printf("num: <%s>\n", $1); */ };
string: STRING { $$ = new std::string($1); /* printf("str: <%s>\n", $1); */ };

block: label_declaration_part
       constant_definition_part
       type_definition_part
       variable_declaration_part
       /*
       procedure_and_function_declaration_part
       statement_part ;
       */
       ;

/* ----------------------------------------------------------------------------
 * Label declarations */
label_declaration_part: | LABEL label_list LABELSEMICOLON;
label_list: label_list LABELCOMMA label
          | label;
label: LABELN { printf("label %s\n", $1); }

/* ----------------------------------------------------------------------------
 * Constant definitions */
constant_definition_part: | CONST constant_definition_list SEMICOLON;
constant_definition_list: constant_definition_list SEMICOLON constant_definition
                        | constant_definition;
constant_definition: identifier EQUAL constant
                   { printf("const %s = %s\n", $1->c_str(), $3->c_str()); };
constant: sign number { $$ = new std::string(*($1)); $$->append(*($2)); }
        | sign identifier { $$ = new std::string(*($1)); $$->append(*($2)); }
        | number { $$ = new std::string(*($1)); }
        | identifier { $$ = new std::string(*($1)); }
        | string { $$ = new std::string(*($1)); };
sign: PLUS { $$ = new std::string($1, strlen($1)); }
    | MINUS { $$ = new std::string($1, strlen($1)); };

/* ----------------------------------------------------------------------------
 * Type definitions */
type_definition_part: TYPE type_definition_list
type_definition_list: type_definition_list type_definition
                    | type_definition;
type_definition: identifier EQUAL type_denoter SEMICOLON
                 { printf("type <%s>\n", ($1)->c_str()); };
type_denoter: type_identifier { printf("type identifier <%s>\n", ($1)->c_str()); }
            | new_type { printf("<new type>\n"); };
new_type: new_ordinal_type | new_structured_type | new_pointer_type;
/* simple_type_identifier: type_identifier; */
/* structured_type_identifier: type_identifier; */
/* pointer_type_identifier: type_identifier; */
type_identifier: identifier;
/* -> Simple-types */
/* simple_type: ordinal_type | real_type_identifier; */
ordinal_type: new_ordinal_type | ordinal_type_identifier;
new_ordinal_type: enumerated_type | subrange_type;
ordinal_type_identifier: type_identifier;
/* real_type_identifier: type_identifier; */
/* -> Enumerated-types */
enumerated_type: LPAREN identifier_list RPAREN { printf("enumerated type ");
               printvector($2); puts(""); };
identifier_list: identifier_list COMMA identifier { $$->push_back($3); }
               | identifier { $$ = new std::vector<std::string*>; $$->push_back($1); };
/* -> Subrange-types */
subrange_type: constant ELLIPSIS constant { printf("subrange <%s..%s>\n",
               $1->c_str(), $3->c_str()); };
/* -> Structured-types */
/* structured_type: new_structured_type | structured_type_identifier; */
new_structured_type: PACKED unpacked_structured_type
                   | unpacked_structured_type;
unpacked_structured_type: array_type | record_type | set_type | file_type;
/* -> Array-types */
array_type: ARRAY LBRACKET index_type_list RBRACKET OF component_type;
index_type_list: index_type_list COMMA index_type
               | index_type;
index_type: ordinal_type;
component_type: type_denoter;
/* -> Record-types */
record_type: RECORD field_list END;
field_list: fixed_part SEMICOLON variant_part SEMICOLON
          | fixed_part SEMICOLON variant_part
          | fixed_part SEMICOLON
          | fixed_part
          | variant_part SEMICOLON
          | variant_part
          | /* empty */ ;
fixed_part: record_section_list;
record_section_list: record_section_list SEMICOLON record_section
                   | record_section;
record_section: identifier_list COLON type_denoter;
/* field_identifier: identifier; */
variant_part: CASE variant_selector OF variant_list;
variant_list: variant_list SEMICOLON variant
            | variant;
variant_selector: tag_field COLON tag_type
                | tag_type;
tag_field: identifier;
variant: case_constant_list COLON LPAREN field_list RPAREN
tag_type: ordinal_type_identifier;
case_constant_list: case_constant_list COMMA case_constant
                  | case_constant;
case_constant: constant;
/* -> Set-types */
set_type: SET OF base_type;
base_type: ordinal_type;
/* -> File-types */
file_type: TOKFILE OF component_type;
/* -> Pointer-types */
/* pointer_type: new_pointer_type | pointer_type_identifier; */
new_pointer_type: UPARROW domain_type;
domain_type: type_identifier;

/* ----------------------------------------------------------------------------
 * Variable declarations */
variable_declaration_part: | VAR variable_declaration_list SEMICOLON;
variable_declaration_list: variable_declaration_list SEMICOLON variable_declaration
                         | variable_declaration;
variable_declaration: identifier_list COLON type_denoter { printf("variables ");
                    printvector($1); printf("\n"); };
variable_access: entire_variable | component_variable /* | identified_variable */
               | buffer_variable;
/* -> Entire variables */
entire_variable: variable_identifier;
variable_identifier: identifier;
/* -> Component variables */
component_variable: indexed_variable | field_designator;
/* ->-> Indexed-variables */
indexed_variable: array_variable LBRACKET index_expression_list RBRACKET;
index_expression_list: index_expression_list COMMA index_expression
                     | index_expression;
array_variable: variable_access;
index_expression: expression;
/* ->-> Field-designators */
field_designator: record_variable DOT field_specifier;
                /* | field_designator_identifier; */
record_variable: variable_access;
field_specifier: field_identifier;
field_identifier: identifier;
/* ->-> Identified-variables */
/* ->-> Buffer-variables */
buffer_variable: file_variable UPARROW;
file_variable: variable_access;

/* ----------------------------------------------------------------------------
 * Procedure and function declarations */
procedure_and_function_declaration_part: procedure_and_function_declaration_list;
procedure_and_function_declaration_list:
  procedure_and_function_declaration_list SEMICOLON procedure_or_funcion_declaration
                                       | procedure_or_funcion_declaration;
procedure_or_funcion_declaration: procedure_declaration | function_declaration;
/* -> Procedure declarations */
procedure_declaration: procedure_heading SEMICOLON directive
                     | procedure_identification SEMICOLON procedure_block
                     | procedure_heading SEMICOLON procedure_block;
procedure_heading: PROCEDURE identifier
                 | PROCEDURE identifier formal_parameter_list;
procedure_identification: PROCEDURE procedure_identifier;
procedure_identifier: identifier;
procedure_block: block;

%%

// vim: et:ts=2:sw=2

