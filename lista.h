#ifndef LISTA_DINAMICA_H_INCLUDED
#define LISTA_DINAMICA_H_INCLUDED

#include <stdio.h>

typedef struct nodo_lista {
   char *valor;
   struct nodo_lista *siguiente;
} tipoNodoLista;

typedef tipoNodoLista *tipoLista;

tipoNodoLista* crearLista();
void agregar(tipoLista*, char*);
void recorrerLista(tipoNodoLista*);
void escribirLista(tipoNodoLista*, FILE*);

#endif // LISTA_DINAMICA_H_INCLUDED