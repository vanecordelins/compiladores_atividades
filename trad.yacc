%{
#include <stdio.h>
#include <string.h>
#include "arv.h"
int yylex(void);
void yyerror(char *);
char buffer[256];
char *t;

%}

%token INTEGER
%left '+' '-'
%%

program:
	program expr '\n'	{ 
				  imprimir((No*)$2); 
				}
	|
	; 		
expr:
	INTEGER			{	
				No* n_tipo = (No*) criarNo((int)$1, "int");
				printf("%d, %d, %s\n", (int) n_tipo, n_tipo->D.valor, n_tipo->D.nome);
			  	$$ = (int)n_tipo;
	
			        }
	| expr '+' expr		{  
				int valor_expr = (( No *) $1)->D.valor + (( No *) $3)->D.valor;				
				No* no  = (No*) criarNo(valor_expr,"expr");                   		
				no->filhos[0] = (No*)$1;
				no->filhos[1] = criarNo(0, "+");  
                     		no->filhos[2] = (No*) $3;
				$$ = (int)no; 
				}
	
	| expr '-' expr		{
				int valor_expr = (( No *) $1)->D.valor - (( No *) $3)->D.valor;				
				No* no  = (No*) criarNo(valor_expr, "expr");                   		
				no->filhos[0] = (No*)$1;
				no->filhos[1] = criarNo(0, "-");  
                     		no->filhos[2] = (No*) $3;
				$$ = (int)no; 						
				}
	
	| '(' expr ')'		{ $$ = $2;
				}
	; 




%%



void yyerror(char *s) {
	fprintf(stderr, "%s\n", s);
}

int main(void) {
	yyparse();
	return 0;
}
