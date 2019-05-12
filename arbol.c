#include "arbol.h"
#include <stdlib.h>
#include <stdio.h>

tipoArbol crearArbol() {
    return NULL;
}

tipoNodoArbol* crearNodo(char* valor, tipoNodoArbol* hijoIzquierdo, tipoNodoArbol* hijoDerecho) {
    tipoNodoArbol* nodo = (tipoNodoArbol*)malloc(sizeof(tipoNodoArbol));
    nodo->hijoDerecho = hijoDerecho;
    nodo->hijoIzquierdo = hijoIzquierdo;
    nodo->valor = valor;
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

void recorrerArbolInorder(tipoArbol arbol) {
    printf("%s\n", arbol->valor);
    if(arbol->hijoIzquierdo !=  NULL)
        recorrerArbolInorder(arbol->hijoIzquierdo);
    if(arbol->hijoDerecho !=  NULL)
        recorrerArbolInorder(arbol->hijoDerecho);
}