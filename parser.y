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
  char *identv, *numberv, *opv, *strv, *labelv;
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

%type <string> identifier number string sign label;
%type <strvector> identifier_list label_list;
%type <node> constant constant_list program_heading optional_program_heading block;
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
%type <node> expression simple_expression term_list multiplying_operator;
%type <node> adding_operator factor_list factor;
%type <node> function_designator set_constructor variable_access;
%type <node> index_expression_list member_designator_list member_designator;
%type <node> relational_operator actual_parameter_list actual_parameter_list_aux;
%type <node> actual_parameter statement simple_statement structured_statement;
%type <node> compound_statement statement_list if_statement if_then;
%type <node> case_element_list case_element case_statement repeat_statement;
%type <node> while_statement for_statement with_statement statement_part record_variable_list;

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
         $$->add_child($6);
       };

/* ----------------------------------------------------------------------------
 * Label declarations */
label_declaration_part: empty { $$ = nullptr; }
                      | LABEL label_list SEMICOLON
                      {
                        $$ = make_node(N_LABEL_DECL_PART);
                        $$->list = *($2);
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
constant_definition_part: empty { $$ = nullptr; }
                        | CONST constant_definition_list SEMICOLON { $$ = $2; };
constant_definition_list: constant_definition_list SEMICOLON constant_definition
                        { $$->add_child($3); }
                        | constant_definition
                        {
                          $$ = make_node(N_CONSTANT_DEF_PART);
                          $$->add_child($1);
                        };
constant_definition: identifier EQUAL constant
                   {
                     $$ = make_node(N_CONSTANT_DEFINITION);
                     $$->data = *($1);
                     $$->add_child($3);
                   };
constant: sign number
        {
          $$ = make_node(N_CONSTANT);
          $$->data = *($1);
          $$->data.append(*($2));
        }
        | sign identifier
        {
          $$ = make_node(N_CONSTANT);
          $$->data = *($1);
          $$->data.append(*($2));
        }
        | number
        {
          $$ = make_node(N_CONSTANT);
          $$->data = *($1);
        }
        | identifier
        {
          $$ = make_node(N_CONSTANT);
          $$->data = *($1);
        }
        | string
        {
          $$ = make_node(N_CONSTANT_STRING);
          $$->data = *($1);
        }
sign: PLUS { $$ = new std::string("+"); }
    | MINUS { $$ = new std::string("-"); };
number: NUMBER { $$ = new std::string($1); };
string: STRING { $$ = new std::string($1); };

/* ----------------------------------------------------------------------------
 * Type definitions */
type_definition_part: empty { $$ = nullptr; }
                    | TYPE type_definition_list { $$ = $2; };
type_definition_list: type_definition_list type_definition { $$->add_child($2); }
                    | type_definition
                    {
                      $$ = make_node(N_TYPE_DEF_PART);
                      $$->add_child($1);
                    };
/* General */
type_definition: identifier EQUAL type_denoter SEMICOLON
                 {
                   $$ = make_node(N_TYPE_DEFINITION);
                   $$->data = *($1);
                   $$->add_child($3);
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
          $$->add_child($1);
          $$->add_child($3);
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
         $$->add_child($1);
         $$->add_child($4);
       };
constant_list: constant_list COMMA constant { $$->add_child($3); }
             | constant
             {
               $$ = make_node(N_CONSTANT_LIST);
               $$->add_child($1);
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
                           $$ = make_node(N_VARIABLE_DECL_PART);
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
                                         $$ = make_node(N_PROC_OR_FUNC_DECL_PART);
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
                 | term_list { $$ = $1; };
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
      {
        $$ = make_node(N_FACTOR);
        $$->add_child($1);
      }
      | number
      {
        $$ = make_node(N_UNSIGNED_CONSTANT_NUMBER);
        $$->data = *($1);
      }
      | string
      {
        $$ = make_node(N_UNSIGNED_CONSTANT_STRING);
        $$->data = *($1);
      }
      | NIL { $$ = make_node(N_UNSIGNED_CONSTANT_NIL); }
      | function_designator
      {
        $$ = make_node(N_FACTOR_FUNC_DESIGNATOR);
        $$->add_child($1);
      }
      | set_constructor
      {
        $$ = make_node(N_FACTOR_SET_CONS);
        $$->add_child($1);
      }
      | LPAREN expression RPAREN
      {
        $$ = make_node(N_FACTOR_PARENS_EXPRESSION);
        $$->add_child($2);
      }
      | NOT factor
      {
        $$ = make_node(N_FACTOR_NOT_FACTOR);
        $$->add_child($2);
      };
variable_access: identifier
               {
                 $$ = make_node(N_VARIABLE_ACCESS_SIMPLE);
                 $$->data = *($1);
               }
               | variable_access LBRACKET index_expression_list RBRACKET
               {
                 $$ = make_node(N_VARIABLE_ACCESS_ARRAY_ACCESS);
                 $$->add_child($1);
                 $$->add_child($3);
               }
               | variable_access DOT identifier
               {
                 $$ = make_node(N_VARIABLE_ACCESS_FIELD_DESIGNATOR);
                 $$->data = *($3);
                 $$->add_child($1);
               }
               | variable_access UPARROW
               {
                 $$ = make_node(N_VARIABLE_ACCESS_BUFFER_VARIABLE);
                 $$->add_child($1);
               };
index_expression_list: index_expression_list COMMA expression { $$->add_child($3); }
                     | expression
                     {
                       $$ = make_node(N_INDEX_EXPRESSION_LIST);
                       $$->add_child($1);
                     };
set_constructor: LBRACKET member_designator_list RBRACKET
               {
                 $$ = make_node(N_SET_CONSTRUCTOR);
                 $$->add_child($2);
               }
member_designator_list: member_designator_list COMMA member_designator
                      { $$->add_child($3); }
                      | member_designator
                      {
                        $$ = make_node(N_SET_MEMBER_DESIGNATOR_LIST);
                        $$->add_child($1);
                      };
member_designator: expression ELLIPSIS expression
                 {
                   $$ = make_node(N_SET_MEMBER_DESIGNATOR);
                   $$->add_child($1);
                   $$->add_child($3);
                 }
                 | expression
                 {
                   $$ = make_node(N_SET_MEMBER_DESIGNATOR);
                   $$->add_child($1);
                 };
multiplying_operator: ASTERISK { $$ = make_node(N_ASTERISK); }
                    | SLASH    { $$ = make_node(N_SLASH); }
                    | DIV      { $$ = make_node(N_DIV); }
                    | MOD      { $$ = make_node(N_MOD); }
                    | AND      { $$ = make_node(N_AND); };
adding_operator: PLUS  { $$ = make_node(N_PLUS); }
               | MINUS { $$ = make_node(N_MINUS); }
               | OR    { $$ = make_node(N_OR); };
relational_operator: EQUAL { $$ = make_node(N_EQUAL); }
                   | LTGT  { $$ = make_node(N_LTGT); }
                   | LT    { $$ = make_node(N_LT); }
                   | GT    { $$ = make_node(N_GT); }
                   | LTE   { $$ = make_node(N_LTE); }
                   | GTE   { $$ = make_node(N_GTE); }
                   | IN    { $$ = make_node(N_IN); };
/* Function designators */
function_designator: identifier actual_parameter_list /* divergence from standard */
                   {
                     $$ = make_node(N_FUNCTION_DESIGNATOR);
                     $$->data = *($1);
                     $$->add_child($2);
                   };
actual_parameter_list: LPAREN actual_parameter_list_aux RPAREN { $$ = $2; };
actual_parameter_list_aux: actual_parameter_list_aux COMMA actual_parameter
                         { $$->add_child($3); }
                         | actual_parameter
                         {
                           $$ = make_node(N_ACTUAL_PARAMETER_LIST);
                           $$->add_child($1);
                         };
actual_parameter: expression COLON expression COLON expression
                {
                  $$ = make_node(N_ACTUAL_PARAMETER);
                  $$->add_child($1);
                  $$->add_child($3);
                  $$->add_child($5);
                }
                | expression COLON expression
                {
                  $$ = make_node(N_ACTUAL_PARAMETER);
                  $$->add_child($1);
                  $$->add_child($3);
                }
                | expression
                {
                  $$ = make_node(N_ACTUAL_PARAMETER);
                  $$->add_child($1);
                };

/* ----------------------------------------------------------------------------
 * Statements */
statement_part: compound_statement { $$ = $1; };
compound_statement: TOKBEGIN statement_list END { $$ = $2; };
statement_list: statement_list SEMICOLON statement { $$->add_child($3); }
              | statement
              {
                $$ = make_node(N_STATEMENT_PART);
                $$->add_child($1);
              };
statement: label COLON simple_statement
         {
           $$ = make_node(N_LABELLED_STATEMENT);
           $$->data = *($1);
           $$->add_child($3);
         }
         | label COLON structured_statement
         {
           $$ = make_node(N_LABELLED_STATEMENT);
           $$->data = *($1);
           $$->add_child($3);
         }
         | simple_statement { $$ = $1; }
         | structured_statement { $$ = $1; };
simple_statement: empty { $$ = make_node(N_EMPTY_STATEMENT); }
                | variable_access COLEQUAL expression
                {
                  $$ = make_node(N_ASSIGNMENT_STATEMENT);
                  $$->add_child($1);
                  $$->add_child($3);
                }
                | function_designator
                {
                  $$ = make_node(N_PROC_OR_FUNC_STATEMENT);
                  $$->add_child($1);
                }
                | identifier
                {
                  $$ = make_node(N_PROC_FUNC_OR_VARIABLE);
                  $$->data = *($1);
                }
                | GOTO label
                {
                  $$ = make_node(N_GOTO);
                  $$->data = *($2);
                };
/* Structured statements */
structured_statement: compound_statement { $$ = $1; }
                    | if_statement { $$ = $1; }
                    | case_statement { $$ = $1; }
                    | repeat_statement { $$ = $1; }
                    | while_statement { $$ = $1; }
                    | for_statement { $$ = $1; }
                    | with_statement { $$ = $1; };
if_statement: if_then %prec simple_if { $$ = $1; }
            | if_then ELSE statement
            {
              $$ = $1;
              $$->add_child($3);
            };
if_then: IF expression THEN statement
       {
         $$ = make_node(N_IF);
         $$->add_child($2);
         $$->add_child($4);
       };
case_statement: CASE expression OF case_element_list SEMICOLON END
              {
                $$ = make_node(N_CASE);
                $$->add_child($2);
                $$->add_child($4);
              }
              | CASE expression OF case_element_list END
              {
                $$ = make_node(N_CASE);
                $$->add_child($2);
                $$->add_child($4);
              };
case_element_list: case_element_list SEMICOLON case_element { $$->add_child($3); }
                 | case_element
                 {
                   $$ = make_node(N_CASE_ELEMENT_LIST);
                   $$->add_child($1);
                 };
case_element: constant_list COLON statement
            {
              $$ = make_node(N_CASE_ELEMENT);
              $$->add_child($1);
              $$->add_child($3);
            };
repeat_statement: REPEAT statement_list UNTIL expression
                {
                  $$ = make_node(N_REPEAT);
                  $$->add_child($2);
                  $$->add_child($4);
                };
while_statement: WHILE expression DO statement
               {
                  $$ = make_node(N_WHILE);
                  $$->add_child($2);
                  $$->add_child($4);
               };
for_statement: FOR identifier COLEQUAL expression TO expression DO statement
             {
               $$ = make_node(N_FOR_TO);
               $$->data = *($2);
               $$->add_child($4);
               $$->add_child($6);
               $$->add_child($8);
             }
             | FOR identifier COLEQUAL expression DOWNTO expression DO statement
             {
               $$ = make_node(N_FOR_DOWNTO);
               $$->data = *($2);
               $$->add_child($4);
               $$->add_child($6);
               $$->add_child($8);
             };
with_statement: WITH record_variable_list DO statement
              {
                $$ = make_node(N_WITH);
                $$->add_child($2);
                $$->add_child($4);
              };
record_variable_list: record_variable_list COMMA variable_access
                    { $$->add_child($3); }
                    | variable_access
                    {
                      $$ = make_node(N_RECORD_VARIABLE_LIST);
                      $$->add_child($1);
                    };

%%

// vim: et:ts=2:sw=2

