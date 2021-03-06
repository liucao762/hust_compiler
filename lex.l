%{
	//@hwz
//#include "parser.tab.h"/*配合bison的头文件*/
#include "string.h"
#include "def.h"
int yycolumn=1;
#define YY_USER_ACTION    	yylloc.first_line=yylloc.last_line=yylineno; \
	yylloc.first_column=yycolumn;	yylloc.last_column=yycolumn+yyleng-1; yycolumn+=yyleng;
typedef union {
	int type_int;
	float type_float;
	char type_char;
	char type_id[32];
	struct node *ptr;
} YYLVAL;
#define YYSTYPE YYLVAL

%}
%option yylineno

id   [A-Za-z][A-Za-z0-9]*  
int    [0-9]+
float  ([0-9]*\.[0-9]+)|([0-9]+\.)
char \'(\\.|[^'])\'


%%
\/\/[^\n]*  {;} /*注释*/
\/\*(\s|.)*?\*\/    {;}
{int}        {yylval.type_int=atoi(yytext); return INT;}
{float}      {yylval.type_float=atof(yytext); return FLOAT;}
{char}		 {yylval.type_char=get_middle_char(yytext);return CHAR;}
"int"        {strcpy(yylval.type_id,  yytext);return TYPE;}
"float"      {strcpy(yylval.type_id,  yytext);return TYPE;}
"char"		 {stpcpy(yylval.type_id,  yytext);return TYPE;}

"return"     {return RETURN;}
"if"         {return IF;}
"else"       {return ELSE;}
"while"      {return WHILE;}

"for"		 {return FOR;}
"break"		 {return BREAK;}
"continue"	 {return CONTINUE;}
"switch"	 {return SWITCH;}
"case"		 {return CASE;}
"default"	 {return DEFAULT;}

{id}       {strcpy(yylval.type_id,  yytext); return ID;/*由于关键字的形式也符合标识符的规则，所以把关键字的处理全部放在标识符的前面，优先识别*/}
";"			{return SEMI;}
","			{return COMMA;}
">"|"<"|">="|"<="|"=="|"!=" {strcpy(yylval.type_id, yytext);;return RELOP;}
"="			{return ASSIGNOP;}

"++"     {return AUTOPLUS;}
"--"     {return AUTOMINUS;}

"+"			{return PLUS;}
"-"			{return MINUS;}
"*"			{return STAR;}
"/"			{return DIV;}



"&&"         {return AND;}
"||"            {return OR;}
"!"			{return NOT;}
"("			{return LP;}
")"			{return RP;}
"{"			{return LC;}
"}"			{return RC;}

"["      {return LB;}
"]"      {return RB;}



[\n]           {yycolumn=1;}   
[ \r\t]          {;}   
.			{printf("Error type A :Mysterious character \"%s\"\n\t at Line %d\n",yytext,yylineno);}
/*作为实验内容，还需要考虑识别出2种形式的注释注释部分时，直接舍弃 */
%%

/* 和bison联用时，不需要这部分*/
/*void main()
{
yylex();
return 0;
}

int yywrap()
{
return 1;
}*/
 