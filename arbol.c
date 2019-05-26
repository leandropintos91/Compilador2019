#include "arbol.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

tipoArbol crearArbol() {
    return NULL;
}

tipoNodoArbol* crearNodo(char* valor, tipoNodoArbol* hijoIzquierdo, tipoNodoArbol* hijoDerecho) {
    tipoNodoArbol* nodo = (tipoNodoArbol*)malloc(sizeof(tipoNodoArbol));
    nodo->hijoDerecho = hijoDerecho;
    nodo->hijoIzquierdo = hijoIzquierdo;
    nodo->valor = (char*)malloc(sizeof(char)*50);
    strcpy(nodo->valor, valor);
    return nodo;
}

tipoNodoArbol* crearHoja(char* valor) {
    return crearNodo(valor, NULL, NULL);
}

void setHijoDerecho(tipoArbol arbol, tipoNodoArbol* nodo) {
    arbol->hijoDerecho = nodo;
}

void setHijoIzquierdo(tipoArbol arbol, tipoNodoArbol* nodo) {
    arbol->hijoIzquierdo = nodo;
}

void setValor(tipoArbol arbol, char* valor) {
    arbol->valor = valor;
}

char* getValor(tipoArbol arbol) {
    return arbol->valor;
}

tipoNodoArbol* getHijoIzquierdo(tipoArbol arbol) {
    return arbol->hijoIzquierdo;
}

tipoNodoArbol* getHijoDerecho(tipoArbol arbol) {
    return arbol->hijoDerecho;
}

void recorrerArbolPreorder(tipoArbol arbol) {
    printf("%s\n", arbol->valor);
    if(arbol->hijoIzquierdo !=  NULL)
        recorrerArbolPreorder(arbol->hijoIzquierdo);
    if(arbol->hijoDerecho !=  NULL)
        recorrerArbolPreorder(arbol->hijoDerecho);
}

void recorrerArbolPostorder(tipoArbol arbol) {
    if(arbol->hijoIzquierdo !=  NULL)
        recorrerArbolPostorder(arbol->hijoIzquierdo);
    if(arbol->hijoDerecho !=  NULL)
        recorrerArbolPostorder(arbol->hijoDerecho);
    printf("%s\n", arbol->valor);
}

void recorrerArbolInorder(tipoArbol arbol) {
    if(arbol->hijoIzquierdo !=  NULL)
        recorrerArbolInorder(arbol->hijoIzquierdo);
    printf("%s\n", arbol->valor);
    if(arbol->hijoDerecho !=  NULL)
        recorrerArbolInorder(arbol->hijoDerecho);
}

void recorrerArbolPreorderConNivel(tipoArbol arbol, int nivel) {
    int i;
    for(i = 0; i < nivel; i++)
        printf("\t");
    printf("%s\n", arbol->valor);
    if(arbol->hijoIzquierdo !=  NULL) 
        recorrerArbolPreorderConNivel(arbol->hijoIzquierdo, nivel +1);
    if(arbol->hijoDerecho !=  NULL)
        recorrerArbolPreorderConNivel(arbol->hijoDerecho, nivel +1);
}

int tamanioArbol(tipoArbol arbol) {
    int tamanioDerecho = 0;
    int tamanioIzquierdo = 0;

    if(arbol->hijoDerecho == NULL && arbol->hijoIzquierdo == NULL)
        return 0;

    if(arbol->hijoDerecho != NULL) {
        tamanioDerecho = tamanioArbol(arbol->hijoDerecho);
    }
    if(arbol->hijoIzquierdo != NULL) {
        tamanioIzquierdo = tamanioArbol(arbol->hijoIzquierdo);
    }

    return  ((tamanioDerecho > tamanioIzquierdo) ? tamanioDerecho : tamanioIzquierdo) + 1;
}

