%{
#include "ast.hh"
#include "utils.hh"
#include <string>
#include <cstring>
#include <vector>

extern int yylex();

#define YYDEBUG 1

ast_node *root = nullptr;
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
  std::vector<std::string> *strvector;
  struct ast_node *node;
}

%token <opv> PLUS MINUS ASTERISK SLASH EQUAL LT GT LBRACKET RBRACKET DOT COMMA
%token <opv> COLON SEMICOLON UPARROW LPAREN RPAREN LTGT LTE GTE COLEQUAL ELLIPSIS
%token AND ARRAY TOKBEGIN CASE CONST DIV DO DOWNTO ELSE END TOKFILE FOR FUNCTION
%token GOTO IF IN MOD NIL NOT OF OR PACKED PROCEDURE PROGRAM RECORD REPEAT SET
%token THEN TO TYPE UNTIL VAR WHILE WITH FORWARD LABEL
%token <identv> IDENTIFIER;
%token <numberv> NUMBER;
%token <strv> STRING;
%token <labelv> LABELN;

%type <string> identifier number string sign label constant relational_operator;
%type <strvector> identifier_list label_list constant_list;
%type <node> program_heading optional_program_heading block;
%type <node> label_declaration_part constant_definition_part constant_definition;
%type <node> constant_definition_list type_definition_part type_definition_list;
%type <node> type_definition type_denoter enumeration subrange structured_type;
%type <node> array index_type_list ordinal_type list_with_type variant;
%type <node> record_section_list variant_part variant_selector variant_list;
%type <node> field_list record set file_type new_pointer_type;
%type <node> variable_declaration_part variable_declaration_list;
%type <node> procedure_and_function_declaration_part procedure_declaration;
%type <node> procedure_or_function_declaration_list function_declaration;
%type <node> procedure_or_funcion_declaration procedure_heading;
%type <node> function_heading formal_parameter_list function_identification;
%type <node> formal_parameter_section formal_parameter_section_list;
%type <node> expression simple_expression term_list;

%nonassoc simple_if
%nonassoc ELSE

%start program

%%

/* ----------------------------------------------------------------------------
 * Program */
program: empty { yyerror("empty program"); }
       | optional_program_heading block DOT
       {
           root = make_node(N_PROGRAM);
           root->add_child($1);
           root->add_child($2);
           green(); puts("<parsed program>"); reset();
       };
empty: ;
optional_program_heading: program_heading SEMICOLON { $$ = $1; }
                        | empty { $$ = nullptr; };
program_heading: PROGRAM identifier optional_identifier_list_in_parens
               {
                 $$ = make_node(N_PROGRAM_HEADING);
                 $$->data = *($2);
                 dprintf("program <%s>\n", $2->c_str());
               };
optional_identifier_list_in_parens: empty
                                  | LPAREN identifier_list RPAREN;
identifier_list: identifier_list COMMA identifier { $$->push_back(*($3)); }
               | identifier
               {
                 $$ = new std::vector<std::string>;
                 $$->push_back(*($1));
                 /* delete $1*/
               };
identifier: IDENTIFIER { $$ = new std::string($1); };
block: label_declaration_part
       constant_definition_part
       type_definition_part
       variable_declaration_part
       procedure_and_function_declaration_part
       statement_part
       {
         $$ = make_node(N_BLOCK);
         $$->add_child($1);
         $$->add_child($2);
         $$->add_child($3);
         $$->add_child($4);
         $$->add_child($5);
         dputs("parsed block");
       };

/* ----------------------------------------------------------------------------
 * Label declarations */
label_declaration_part: empty
                      {
                        $$ = nullptr;
                        dputs("(no labels)");
                      }
                      | LABEL label_list SEMICOLON
                      {
                        $$ = make_node(N_LABEL_DECL);
                        $$->list = *($2);
                        dputs("(parsed labels)");
                      };
label_list: label_list COMMA label { $$->push_back(*($3)); }
          | label
          {
            $$ = new std::vector<std::string>;
            $$->push_back(*($1));
          };
label: LABELN { $$ = new std::string($1); }

/* ----------------------------------------------------------------------------
 * Constant definitions */
constant_definition_part: empty
                        {
                          $$ = nullptr;
                          dputs("(no consts)");
                        }
                        | CONST constant_definition_list SEMICOLON
                        {
                          $$ = $2;
                          dputs("(parsed consts)");
                        };
constant_definition_list: constant_definition_list SEMICOLON constant_definition
                        { $$->add_child($3); }
                        | constant_definition
                        {
                          $$ = make_node(N_CONSTANT_DEFINITION_LIST);
                          $$->add_child($1);
                        };
constant_definition: identifier EQUAL constant
                   {
                     $$ = make_node(N_CONSTANT_DEFINITION);
                     $$->list = {*($1), *($3)};
                     dprintf("const %s = %s\n", $1->c_str(), $3->c_str());
                   };
constant: sign number { $$ = new std::string(*($1)); $$->append(*($2)); }
        | sign identifier { $$ = new std::string(*($1)); $$->append(*($2)); }
        | number { $$ = new std::string(*($1)); }
        | identifier { $$ = new std::string(*($1)); }
        | string { $$ = new std::string(*($1)); };
sign: PLUS { $$ = new std::string($1, strlen($1)); }
    | MINUS { $$ = new std::string($1, strlen($1)); };
number: NUMBER { $$ = new std::string($1); };
string: STRING { $$ = new std::string($1); };

/* ----------------------------------------------------------------------------
 * Type definitions */
type_definition_part: empty
                    {
                      $$ = nullptr;
                      dputs("(no type defs)");
                    }
                    | TYPE type_definition_list
                    {
                      $$ = $2;
                      dputs("(parsed type defs)");
                    };
type_definition_list: type_definition_list type_definition { $$->add_child($2); }
                    | type_definition
                    {
                      $$ = make_node(N_TYPE_DEFINITION_LIST);
                      $$->add_child($1);
                    };
/* General */
type_definition: identifier EQUAL type_denoter SEMICOLON
                 {
                   $$ = make_node(N_TYPE_DEFINITION);
                   $$->data = *($1);
                   $$->add_child($3);
                   dprintf("typedef <%s>\n", ($1)->c_str());
                 };
type_denoter: identifier
            {
              $$ = make_node(N_IDENTIFIER);
              $$->data = *($1);
            }
            | enumeration { $$ = $1; }
            | subrange { $$ = $1; }
            | PACKED structured_type { $$ = $2; }
            | structured_type { $$ = $1; }
            | new_pointer_type { $$ = $1; };
enumeration: LPAREN identifier_list RPAREN
           {
             $$ = make_node(N_ENUMERATION);
             $$->list = *($2);
           };
subrange: constant ELLIPSIS constant
        {
          $$ = make_node(N_SUBRANGE);
          $$->list = {*($1), *($3)};
          dprintf("subrange <%s..%s>\n", $1->c_str(), $3->c_str());
        };
structured_type: array { $$ = $1; }
               | record { $$ = $1; }
               | set { $$ = $1; }
               | file_type { $$ = $1; };
/* -> Array-types */
array: ARRAY LBRACKET index_type_list RBRACKET OF type_denoter
          {
            $$ = make_node(N_ARRAY);
            $$->add_child($3);
            $$->add_child($6);
          };
index_type_list: index_type_list COMMA ordinal_type { $$->add_child($3); }
               | ordinal_type
               {
                 $$ = make_node(N_ARRAY_INDEX_TYPE_LIST);
                 $$->add_child($1);
               };
ordinal_type: enumeration { $$ = $1; }
            | subrange { $$ = $1; }
            | identifier
            {
              $$ = make_node(N_IDENTIFIER);
              $$->data = *($1);
            };
/* -> Record-types */
record: RECORD field_list END { $$ = $2; };
field_list: record_section_list SEMICOLON variant_part SEMICOLON
          {
            $$ = make_node(N_RECORD);
            $$->add_child($1);
            $$->add_child($3);
          }
          | record_section_list SEMICOLON variant_part
          {
            $$ = make_node(N_RECORD);
            $$->add_child($1);
            $$->add_child($3);
          }
          | record_section_list SEMICOLON
          {
            $$ = make_node(N_RECORD);
            $$->add_child($1);
          }
          | record_section_list
          {
            $$ = make_node(N_RECORD);
            $$->add_child($1);
          }
          | variant_part SEMICOLON
          {
            $$ = make_node(N_RECORD);
            $$->add_child($1);
          }
          | variant_part
          {
            $$ = make_node(N_RECORD);
            $$->add_child($1);
          }
          | empty { $$ = make_node(N_RECORD); };
record_section_list: record_section_list SEMICOLON list_with_type { $$->add_child($3); }
                   | list_with_type
                   {
                     $$ = make_node(N_RECORD_SECTION_LIST);
                     $$->add_child($1);
                   };
list_with_type: identifier_list COLON type_denoter
              {
                $$ = make_node(N_LIST_WITH_TYPE);
                $$->list = *($1);
                $$->add_child($3);
              };
variant_part: CASE variant_selector OF variant_list
            {
              $$ = make_node(N_RECORD_VARIANT_PART);
              $$->add_child($2);
              $$->add_child($4);
            };
variant_selector: identifier COLON identifier
                {
                  $$ = make_node(N_RECORD_VARIANT_SELECTOR);
                  $$->list = {*($1), *($3)};
                }
                | identifier
                {
                  $$ = make_node(N_RECORD_VARIANT_SELECTOR);
                  $$->list = {*($1)};
                };
variant_list: variant_list SEMICOLON variant { $$->add_child($3); }
            | variant
            {
              $$ = make_node(N_RECORD_VARIANT_LIST);
              $$->add_child($1);
            };
variant: constant_list COLON LPAREN field_list RPAREN
       {
         $$ = make_node(N_RECORD_VARIANT);
         $$->list = *($1);
         $$->add_child($4);
       };
constant_list: constant_list COMMA constant { $$->push_back(*($3)); }
             | constant
             {
               $$ = new std::vector<std::string>;
               $$->push_back(*($1));
             };
/* -> Set-types */
set: SET OF ordinal_type
   {
     $$ = make_node(N_SET);
     $$->add_child($3);
   };
/* -> File-types */
file_type: TOKFILE OF type_denoter
         {
           $$ = make_node(N_FILE_TYPE);
           $$->add_child($3);
         };
/* Pointer-types */
new_pointer_type: UPARROW identifier
                {
                  $$ = make_node(N_POINTER_TYPE);
                  $$->data = *($2);
                };

/* ----------------------------------------------------------------------------
 * Declarations and denotations of variables */
/* Variable declarations */
variable_declaration_part: empty { $$ = nullptr; }
                         | VAR variable_declaration_list SEMICOLON { $$ = $2; };
variable_declaration_list: variable_declaration_list SEMICOLON list_with_type
                         { $$->add_child($3); }
                         | list_with_type
                         {
                           $$ = make_node(N_VARIABLE_DECL);
                           $$->add_child($1);
                         };

/* ----------------------------------------------------------------------------
 * Procedure and function declarations */
procedure_and_function_declaration_part: empty { $$ = nullptr; }
                                       | procedure_or_function_declaration_list
                                       { $$ = $1; }
                                       | procedure_or_function_declaration_list SEMICOLON
                                       { $$ = $1; };
procedure_or_function_declaration_list: procedure_or_function_declaration_list
                                        SEMICOLON procedure_or_funcion_declaration
                                       { $$->add_child($3); }
                                       | procedure_or_funcion_declaration
                                       {
                                         $$ = make_node(N_PROC_OR_FUNC_DECL_LIST);
                                         $$->add_child($1);
                                       };
procedure_or_funcion_declaration: procedure_declaration { $$ = $1; }
                                | function_declaration { $$ = $1; };
/* Procedure declarations */
procedure_declaration: procedure_heading SEMICOLON FORWARD
                     {
                       $$ = make_node(N_PROCEDURE_DECL);
                       $$->add_child($1);
                     }
                     | procedure_heading SEMICOLON block
                     {
                       $$ = make_node(N_PROCEDURE_DECL);
                       $$->add_child($1);
                       $$->add_child($3);
                     };
procedure_heading: PROCEDURE identifier formal_parameter_list
                 {
                   $$ = make_node(N_PROCEDURE_HEADING);
                   $$->data = *($2);
                   $$->add_child($3);
                 }
                 | PROCEDURE identifier
                 {
                   $$ = make_node(N_PROCEDURE_HEADING);
                   $$->data = *($2);
                 };
/* Function declarations */
function_declaration: function_heading SEMICOLON FORWARD
                    {
                      $$ = make_node(N_FUNCTION_DECL);
                      $$->add_child($1);
                    }
                    | function_identification SEMICOLON block
                    {
                      $$ = make_node(N_FUNCTION_DECL);
                      $$->add_child($1);
                      $$->add_child($3);
                    }
                    | function_heading SEMICOLON block
                    {
                      $$ = make_node(N_FUNCTION_DECL);
                      $$->add_child($1);
                      $$->add_child($3);
                    };
function_heading: FUNCTION identifier formal_parameter_list COLON identifier
                {
                  $$ = make_node(N_FUNCTION_HEADING);
                  $$->list = {*($2), *($5)};
                  $$->add_child($3);
                }
                | FUNCTION identifier COLON identifier
                {
                  $$ = make_node(N_FUNCTION_HEADING);
                  $$->list = {*($2), *($4)};
                };
function_identification: FUNCTION identifier
                       {
                         $$ = make_node(N_FUNCTION_IDENT_HEADING);
                         $$->data = *($2);
                       };
/* Parameters */
formal_parameter_list: LPAREN formal_parameter_section_list RPAREN { $$ = $2; };
formal_parameter_section_list: formal_parameter_section_list SEMICOLON
                               formal_parameter_section { $$->add_child($3); }
                             | formal_parameter_section
                             {
                               $$ = make_node(N_FORMAL_PARAMETER_LIST);
                               $$->add_child($1);
                             };
formal_parameter_section: list_with_type { $$ = $1; }
                        | VAR list_with_type { $$ = $2; $$->data = "var"; }
                        | procedure_heading { $$ = $1; }
                        | function_heading { $$ = $1; };
/* Expression */
expression: simple_expression relational_operator simple_expression
          {
            $$ = make_node(N_EXPRESSION);
            $$->add_child($1);
            $$->add_child($2);
            $$->add_child($3);
          }
          | simple_expression
          {
            $$ = make_node(N_EXPRESSION);
            $$->add_child($1);
          };
simple_expression: sign term_list { $2->data = *($1); $$ = $2; }
                 | term_list { $$ = $1 };
term_list: term_list adding_operator factor_list { $$->add_child($2); $$->add_child($3); }
         | factor_list
         {
           $$ = make_node(N_TERM_LIST);
           $$->add_child($1);
         };
factor_list: factor_list multiplying_operator factor { $$->add_child($2); $$->add_child($3); }
           | factor
           {
             $$ = make_node(N_FACTOR_LIST);
             $$->add_child($1);
           };
factor: variable_access
      | unsigned_constant
      | function_designator
      | set_constructor
      | LPAREN expression RPAREN
      | NOT factor;
variable_access: identifier
               | variable_access LBRACKET index_expression_list RBRACKET { dputs("(indexed_variable)"); }
               | variable_access DOT identifier { dputs("(field_designator)"); }
               | variable_access UPARROW { dputs("(buffer_variable)"); };
index_expression_list: index_expression_list COMMA expression
                     | expression;
unsigned_constant: number | string | NIL;
set_constructor: LBRACKET member_designator_list RBRACKET;
member_designator_list: member_designator_list COMMA member_designator
                      | member_designator;
member_designator: expression ELLIPSIS expression
                 | expression;
multiplying_operator: ASTERISK | SLASH | DIV | MOD | AND;
adding_operator: PLUS | MINUS | OR;
relational_operator: EQUAL { $$ = new std::string($1); }
                   | LTGT { $$ = new std::string($1); }
                   | LT { $$ = new std::string($1); }
                   | GT { $$ = new std::string($1); }
                   | LTE { $$ = new std::string($1); }
                   | GTE { $$ = new std::string($1); }
                   | IN { $$ = new std::string($1); };
/* Function designators */
function_designator: identifier actual_parameter_list; /* divergence from standard */
actual_parameter_list: LPAREN actual_parameter_list_aux RPAREN;
actual_parameter_list_aux: actual_parameter_list_aux COMMA actual_parameter
                     | actual_parameter;
actual_parameter: two_expressions COLON expression
                | two_expressions
                | expression;
two_expressions: expression COLON expression;

/* ----------------------------------------------------------------------------
 * Statements */
/* Simple statements */
statement: label COLON simple_statement
         | label COLON structured_statement
         | simple_statement
         | structured_statement;
simple_statement: empty
                | variable_access COLEQUAL expression { dputs("(assignment_statement)"); }
                | identifier actual_parameter_list { dprintf("proc/func stmt <%s>\n", ($1)->c_str()); }
                | identifier { dprintf("proc/func stmt w/o parameters or variable <%s>\n", ($1)->c_str()); }
                | GOTO label;
/* Structured statements */
structured_statement: compound_statement
                    | conditional_statement
                    | repetetive_statement
                    | with_statement;
statement_sequence: statement_list;
statement_list: statement_list SEMICOLON statement
              | statement;
compound_statement: TOKBEGIN statement_sequence END
                  { dputs("(compund statement end)"); };
/* -> Conditional statements */
conditional_statement: if_statement | case_statement { dputs("(conditional_statement)"); };
/* -> If statements */
if_statement: if_then %prec simple_if { dputs("parsed if"); }
            | if_then ELSE statement { dputs("parsed if-else"); };
if_then: IF expression THEN statement;
/* -> Case statements */
case_statement: CASE case_index OF case_list_element_list SEMICOLON END
              { dputs("(case with ;)"); }
              | CASE case_index OF case_list_element_list END { dputs("(case w/o ;)"); }
case_list_element_list: case_list_element_list SEMICOLON case_list_element
                      | case_list_element { dputs("(case_list_element_list)"); };
case_list_element: constant_list COLON statement;
case_index: expression;
/* -> Repetetive statements */
repetetive_statement: repeat_statement | while_statement | for_statement;
repeat_statement: REPEAT statement_sequence UNTIL expression;
while_statement: WHILE expression DO statement;
for_statement: FOR control_variable COLEQUAL initial_value TO final_value DO statement
             | FOR control_variable COLEQUAL initial_value DOWNTO final_value DO statement;
control_variable: identifier;
initial_value: expression;
final_value: expression;
/* -> With statements */
with_statement: WITH record_variable_list DO statement;
record_variable_list: record_variable_list COMMA variable_access /* record-variable */
                    | variable_access; /* record-variable */

statement_part: compound_statement;

%%

// vim: et:ts=2:sw=2

