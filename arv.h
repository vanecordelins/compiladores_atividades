#ifndef ARVORE
#define ARVORE
#define grau 3

typedef struct dado{
	int valor;
	char oper;
	char nome[10];
}Dado;

typedef struct no{
	struct dado D;
	struct no* filhos[grau];
	int cont;
}No;

void imprimir(struct no*A);

No* criarNo(int valor, char *nome);

#endif
