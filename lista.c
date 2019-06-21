#include "lista.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

tipoLista crearLista() {
    return NULL;
}

void agregar(tipoLista *lista, char* valor) {
    tipoNodoLista** punteroNodo = lista;
    char* copiaValor = (char*)malloc(300);
    strcpy(copiaValor, valor);

    while(*punteroNodo != NULL && (*punteroNodo)->siguiente != NULL) {
        punteroNodo = &(*punteroNodo)->siguiente;
    }
    tipoNodoLista* nuevoNodo = (tipoNodoLista*)malloc(sizeof(tipoNodoLista));
    if(*lista == NULL)
        *lista = nuevoNodo;
    else
        (*punteroNodo)->siguiente = nuevoNodo;
    nuevoNodo->siguiente = NULL;
    nuevoNodo->valor = copiaValor;
}

void recorrerLista(tipoNodoLista* lista) {
    tipoNodoLista* punteroNodo = lista;
    while(punteroNodo != NULL) {
        printf("%s\n", punteroNodo->valor);
        punteroNodo = punteroNodo->siguiente;
    }
}

void escribirLista(tipoNodoLista* lista, FILE* archivo) {
    tipoNodoLista* punteroNodo = lista;
    while(punteroNodo != NULL) {
        fprintf(archivo,"%s\n", punteroNodo->valor);
        punteroNodo = punteroNodo->siguiente;
    }
}