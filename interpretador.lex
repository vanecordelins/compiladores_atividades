// Compiladores 2017.1
// Alunos: Jorge Veloso, Vanessa Lins e Anderson Melo
//
//
// Última alteração: inclusão dos operadores de multiplicação e divisão (com precedência)

%{
#include <stdlib.h>
void yyerror(char *);
#include "y.tab.h"
%}

letra	[a-z|A-Z|_] 
numero	[0-9]
identificador	{letra}({letra}|{numero})*

%%



{numero}+	{ yylval = atoi(yytext);
		  return NUMBER;
		}

int		{	yylval = INT;
			return TYPE;
		}
float		{
			yylval = FLOAT;
			return TYPE;
		}

PRINT		{	return PRINT; 
		}

{identificador}	{
			yylval = (int) strdup(yytext);
			return ID;
		}	

[-+*//=(){};]	{	return *yytext; } /* Aqui foram adicionados os operadores matemáticos seguindo a ordem de 
					     precedência que deve ser lida pra direita pra esquerda*/




[ \t\n] 	; /* skip whitespace */
. 	yyerror("invalid character");
%%
int yywrap(void) {
return 1;
}
