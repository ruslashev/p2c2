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
%token GOTO IF IN MOD NIL NOT OF OR PACKED PROCEDURE PROGRAM RECORD REPEAT SET
%token THEN TO TYPE UNTIL VAR WHILE WITH FORWARD
%token <identv> IDENTIFIER;
%token <numberv> NUMBER;
%token <strv> STRING;
%token LABEL LABELCOMMA LABELSEMICOLON;
%token <labelv> LABELN;

%type <string> identifier number string sign label constant;
%type <string> type_identifier type_denoter;
%type <strvector> identifier_list;

%nonassoc simple_if
%nonassoc ELSE

%start program

%%

empty: ;

identifier: IDENTIFIER { $$ = new std::string($1); /* printf("ident: <%s>\n", $1); */ };
number: NUMBER { $$ = new std::string($1); /* printf("num: <%s>\n", $1); */ };
string: STRING { $$ = new std::string($1); /* printf("str: <%s>\n", $1); */ };

block: label_declaration_part
       constant_definition_part
       type_definition_part
       variable_declaration_part
       procedure_and_function_declaration_part
       statement_part;

/* ----------------------------------------------------------------------------
 * Label declarations */
label_declaration_part: empty { puts("no labels"); }
                      | LABEL label_list LABELSEMICOLON;
label_list: label_list LABELCOMMA label
          | label;
label: LABELN { printf("label %s\n", $1); }

/* ----------------------------------------------------------------------------
 * Constant definitions */
constant_definition_part: empty { puts("no consts"); }
                        | CONST constant_definition_list SEMICOLON;
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
type_definition_part: empty { puts("no types"); }
                    | TYPE type_definition_list
type_definition_list: type_definition_list type_definition
                    | type_definition;
type_definition: identifier EQUAL type_denoter SEMICOLON
                 { printf("type <%s>\n", ($1)->c_str()); };
type_denoter: type_identifier { printf("type identifier <%s>\n", ($1)->c_str()); }
            | new_type { printf("<new type>\n"); };
new_type: new_ordinal_type | new_structured_type | new_pointer_type;
type_identifier: identifier;
/* -> Simple-types */
ordinal_type: new_ordinal_type | ordinal_type_identifier;
new_ordinal_type: enumerated_type | subrange_type;
ordinal_type_identifier: type_identifier;
/* -> Enumerated-types */
enumerated_type: LPAREN identifier_list RPAREN { printf("enumerated type ");
               printvector($2); puts(""); };
identifier_list: identifier_list COMMA identifier { $$->push_back($3); }
               | identifier { $$ = new std::vector<std::string*>; $$->push_back($1); };
/* -> Subrange-types */
subrange_type: constant ELLIPSIS constant { printf("subrange <%s..%s>\n",
               $1->c_str(), $3->c_str()); };
/* -> Structured-types */
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
          /* fixed-part -> record-section-list */
field_list: record_section_list SEMICOLON variant_part SEMICOLON
          | record_section_list SEMICOLON variant_part
          | record_section_list SEMICOLON
          | record_section_list
          | variant_part SEMICOLON
          | variant_part
          | empty;
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
new_pointer_type: UPARROW domain_type;
domain_type: type_identifier;

/* ----------------------------------------------------------------------------
 * Variable declarations */
variable_declaration_part: empty | VAR variable_declaration_list SEMICOLON;
variable_declaration_list: variable_declaration_list SEMICOLON variable_declaration
                         | variable_declaration;
variable_declaration: identifier_list COLON type_denoter { printf("variables ");
                    printvector($1); printf("\n"); };
variable_access: entire_variable_or_function_call | component_variable
               | pointed_variable;
/* -> Entire variables */
entire_variable_or_function_call: identifier;
/* -> Component variables */
component_variable: indexed_variable | field_designator;
/* ->-> Indexed-variables */
/* array-variable */
indexed_variable: variable_access LBRACKET index_expression_list RBRACKET;
index_expression_list: index_expression_list COMMA index_expression
                     | index_expression;
index_expression: expression;
/* ->-> Field-designators */
/* record-variable */
field_designator: variable_access DOT field_specifier;
field_specifier: field_identifier;
field_identifier: identifier;
/* ->-> Identified-variables */
/* ->-> Buffer-variables */
pointed_variable: variable_access UPARROW; /* pointer-variable or file-variable */

/* ----------------------------------------------------------------------------
 * Procedure and function declarations */
procedure_and_function_declaration_part: empty { puts("no procs or funcs"); }
                                       | procedure_or_function_declaration_list
                                       {puts("over");};
procedure_or_function_declaration_list: procedure_or_function_declaration_list
                                        SEMICOLON procedure_or_funcion_declaration
                                       | procedure_or_funcion_declaration;
procedure_or_funcion_declaration: procedure_declaration | function_declaration;
/* -> Procedure declarations */
procedure_declaration: procedure_heading SEMICOLON FORWARD
                     | procedure_heading SEMICOLON procedure_block
                     { printf("procedure declaration end\n"); };
procedure_heading: PROCEDURE identifier formal_parameter_list
                 { printf("procedure head <%s> with params\n", ($2)->c_str()); }
                 | PROCEDURE identifier
                 { printf("procedure head <%s> w/o params\n", ($2)->c_str()); };
procedure_block: block;
/* -> Function declarations */
function_declaration: function_heading SEMICOLON FORWARD
                    | function_identification SEMICOLON function_block
                    | function_heading SEMICOLON function_block;
function_heading: FUNCTION identifier formal_parameter_list COLON type_identifier
                { printf("function head <%s>:<%s> with params\n", ($2)->c_str(),
                    ($5)->c_str()); }
                | FUNCTION identifier COLON type_identifier
                { printf("function head <%s>:<%s> with params\n", ($2)->c_str(),
                    ($4)->c_str()); };
function_identification: FUNCTION identifier;
function_identifier: identifier;
function_block: block;
/* ->-> Parameters */
formal_parameter_list: LPAREN formal_parameter_section_list RPAREN;
formal_parameter_section_list: formal_parameter_section_list SEMICOLON
                               formal_parameter_section
                             | formal_parameter_section;
formal_parameter_section: value_parameter_specification
                        | variable_parameter_specification
                        | procedural_parameter_specification
                        | functional_parameter_specification;
value_parameter_specification: identifier_list COLON type_identifier;
variable_parameter_specification: VAR identifier_list COLON type_identifier;
procedural_parameter_specification: procedure_heading;
functional_parameter_specification: function_heading;
/* Expression */
expression: simple_expression relational_operator simple_expression
          | simple_expression;
simple_expression: sign term_list
                 | term_list;
term_list: term_list adding_operator term
         | term;
term: factor_list;
factor_list: factor_list multiplying_operator factor
           | factor;
factor: variable_access | unsigned_constant | function_designator | set_constructor
      | LPAREN expression RPAREN | NOT factor;
unsigned_constant: number | string | NIL;
set_constructor: LBRACKET member_designator_list RBRACKET
               | LBRACKET RBRACKET;
member_designator_list: member_designator_list COMMA member_designator
                      | member_designator;
member_designator: expression ELLIPSIS expression
                 | expression;
multiplying_operator: ASTERISK | SLASH | DIV | MOD | AND;
adding_operator: PLUS | MINUS | OR;
relational_operator: EQUAL | LTGT | LT | GT | LTE | GTE | IN;
boolean_expression: expression;
function_designator: function_identifier LPAREN actual_parameter_list RPAREN;
actual_parameter_list: LPAREN actual_parameter_list_aux RPAREN;
actual_parameter_list_aux: actual_parameter_list_aux COMMA actual_parameter
                     | actual_parameter;
actual_parameter: expression;
statement: label COLON simple_statement
         | label COLON structured_statement
         | simple_statement
         | structured_statement;
simple_statement: empty | assignment_statement | procedure_statement | goto_statement;
assignment_statement: variable_access COLEQUAL expression;
procedure_statement: identifier actual_parameter_list
                   { printf("parsed proc stmt <%s>\n", ($1)->c_str()); };
goto_statement: GOTO label;
/* Structured statements */
structured_statement: compound_statement | conditional_statement
                    | repetetive_statement | with_statement;
statement_sequence: statement_list;
statement_list: statement_list SEMICOLON statement
              | statement;
compound_statement: TOKBEGIN statement_sequence END
                  { puts("compund statement end"); };
/* Conditional statements */
conditional_statement: if_statement | case_statement;
/* if */
if_statement: if_then %prec simple_if { puts("parsed if"); }
            | if_then ELSE statement { puts("parsed if-else"); };
if_then: IF boolean_expression THEN statement;
/* case */
case_statement: CASE case_index OF case_list_element_list SEMICOLON END
              | CASE case_index OF case_list_element_list END
case_list_element_list: case_list_element_list SEMICOLON case_list_element
                      | case_list_element;
case_list_element: case_constant_list COLON statement;
case_index: expression;
/* repetetive statements */
repetetive_statement: repeat_statement | while_statement | for_statement;
repeat_statement: REPEAT statement_sequence UNTIL boolean_expression;
while_statement: WHILE boolean_expression DO statement;
for_statement: FOR control_variable COLEQUAL initial_value TO final_value DO statement
             | FOR control_variable COLEQUAL initial_value DOWNTO final_value DO statement;
control_variable: entire_variable_or_function_call;
initial_value: expression;
final_value: expression;
/* with statements */
with_statement: WITH record_variable_list DO statement;
record_variable_list: record_variable_list COMMA variable_access /* record-variable */
                    | variable_access; /* record-variable */

statement_part: compound_statement;

/* ----------------------------------------------------------------------------
 * Program */
program: program_heading SEMICOLON program_block DOT;
program_heading: PROGRAM identifier LPAREN program_parameter_list RPAREN
                 { printf("program <%s>\n", $2->c_str()); }
               | PROGRAM identifier { printf("program <%s>\n", $2->c_str()); };
program_parameter_list: identifier_list;
program_block: block;

%%

// vim: et:ts=2:sw=2

