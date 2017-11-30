#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "arv.h"
#define grau 3

void imprimir(struct no*A){
	int i;
	if(A==NULL){
		return;
	}
	for(i = 0; i < grau; i++)
		imprimir(A->filhos[i]);	
	printf("(%d, %s)\n", A->D.valor, A->D.nome);
	//imprimir(A->filhos[i]);
		
}
No* criarNo(int valor, char *nome){
		
	No *n = (No*) malloc(sizeof(No));
	strcpy(n->D.nome,nome);
	n->D.valor = valor;
	n->filhos[0] = NULL;
	n->filhos[1] = NULL;
	n->filhos[2] = NULL;
	//printf("%d, %d, %s\n", (int) n, n->D.valor, n->D.nome);		
	return n;
}


