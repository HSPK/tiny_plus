/****************************************************/
/* File: tiny.l                                     */
/* Lex specification for TINY                       */
/* Compiler Construction: Principles and Practice   */
/* Kenneth C. Louden                                */
/****************************************************/

%{
#include "globals.h"
#include "util.h"
#include "scan.h"
/* lexeme of identifier or reserved word */
char tokenString[MAXTOKENLEN+1];
%}
%option noyywrap

digit       [0-9]
number      [-+]?{digit}+
letter      [a-zA-Z]
identifier  {letter}[0-9a-zA-Z_]*
newline     \n
whitespace  [ \t\r]+

%%

"if"            {return TK_IF;}
"then"          {return TK_THEN;}
"else"          {return TK_ELSE;}
"end"           {return TK_END;}
"repeat"        {return TK_REPEAT;}
"until"         {return TK_UNTIL;}
"read"          {return TK_READ;}
"write"         {return TK_WRITE;}
":="            {return TK_ASSIGN;}
"="             {return TK_EQ;}
"<"             {return TK_LT;}
"+"             {return TK_PLUS;}
"-"             {return TK_MINUS;}
"*"             {return TK_TIMES;}
"/"             {return TK_OVER;}
"("             {return TK_LPAREN;}
")"             {return TK_RPAREN;}
";"             {return TK_SEMI;}
{number}        {return TK_NUM;}
{identifier}    {return TK_ID;}
{newline}       {lineno++;}
{whitespace}    {/* skip whitespace */}
"{"             { char c;
                  do
                  { c = input();
                    if (c == EOF) break;
                    if (c == '\n') lineno++;
                  } while (c != '}');
                }
.               {return TK_ERROR;}

%%

TokenType getToken(void)
{ static int firstTime = TRUE;
  TokenType currentToken;
  if (firstTime)
  { firstTime = FALSE;
    lineno++;
    yyin = source;
    yyout = listing;
  }
  currentToken = yylex();
  strncpy(tokenString, yytext, MAXTOKENLEN);
  if (TraceScan) {
    fprintf(listing,"\t%d: ", lineno);
    printToken(currentToken, tokenString);
  }
  return currentToken;
}

