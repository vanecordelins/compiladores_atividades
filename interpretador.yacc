%{
#include <stdio.h>
#include "tabela.h"
#include "arv.h"

int yylex(void);
void yyerror(char *);

pilha_contexto *pilha;

%}

%token TYPE INT FLOAT PRINT NUMBER ID
%left '+' '-'
%left '*' '/'
%%


program:
			
	program bloco		{ }
	|
	; 	

bloco: 
	'{' 			{ tabela *contexto = criar_contexto(topo_pilha(pilha));
				  pilha = empilhar_contexto(pilha, contexto);

				}

	decls stmts '}'		{ imprimir_contexto(topo_pilha(pilha));
				  desempilhar_contexto(&pilha); 
				};

decls: 
	decls decl		{ }
	|
	;
	
decl:
	TYPE	ID ';'		{	simbolo * s = criar_simbolo((char *) $2, $1); 
					inserir_simbolo(topo_pilha(pilha), s); 
				};

stmts: 
	stmts stmt
	| 	
	;

stmt:
	expr ';'
	| bloco
	| attr			
	| PRINT ID ';'		{ 	  
					  simbolo * s = localizar_simbolo(topo_pilha(pilha), (char *) $2);
					  if(s == NULL)
						yyerror("Identificador não declarado");
					  else  {
						printf(">>>%d\n", s->val.dval);
					  }
				};

attr: 
	ID '=' expr ';'		{ 
					  simbolo * s = localizar_simbolo(topo_pilha(pilha), (char *) $1);
					  if(s == NULL)
						yyerror("Identificador não declarado");
					  else  
						s->val.dval = ((No*)$3)->D.valor;
				  
				};


expr:

	 NUMBER			{ 
					  $$ = $1;
					  No* n_tipo = criarNo((int)$1, "int");
				  	  $$ = (int)n_tipo; 
				}


	| ID			{ 
					  simbolo * s = localizar_simbolo(topo_pilha(pilha), (char *) $1);
					  No* n_tipo = criarNo((int)s->val.dval, "ID");
					  if(s == NULL)
						yyerror("Identificador não declarado");
					  else  
						$$ = (int)n_tipo;
				}
				  

	| expr'+' expr		{ 
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

	| expr'*' expr		{ 
					int valor_expr = (( No *) $1)->D.valor * (( No *) $3)->D.valor;				
					No* no  = (No*) criarNo(valor_expr,"expr");                   		
					no->filhos[0] = (No*)$1;
					no->filhos[1] = criarNo(0, "*");  
		             		no->filhos[2] = (No*) $3;
					$$ = (int)no; 
				}

	| expr'/' expr		{ 
					int valor_expr = (( No *) $1)->D.valor / (( No *) $3)->D.valor;				
					No* no  = (No*) criarNo(valor_expr,"expr");                   		
					no->filhos[0] = (No*)$1;
					no->filhos[1] = criarNo(0, "/");  
		             		no->filhos[2] = (No*) $3;
					$$ = (int)no; 
				}

	| '(' expr ')'		{ $$ = $2;}
	; 

%%

void yyerror(char *s) {
	fprintf(stderr, "%s\n", s);
}

int main(void) {
	pilha = NULL;
	yyparse();
	return 0;
}
