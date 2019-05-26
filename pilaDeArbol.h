#include <string.h>
#include "arbol.h"


typedef struct _nodoP {
   tipoNodoArbol *valor;
   struct _nodoP *anterior;
} tipoNodoPilaArbol;

typedef tipoNodoPilaArbol *pNodoPilaArbol;

typedef struct _pila {
   pNodoPilaArbol tope;
   pNodoPilaArbol base;
} PilaDeArbol;



/* Funciones con pila: */
void apilarArbol(PilaDeArbol *p, tipoNodoArbol *v);
tipoNodoArbol* desapilarArbol(PilaDeArbol *p);
void mostrarPilaArbol(PilaDeArbol *p);
/*int buscarEnPilaArbol(PilaDeArbol *p, tipoNodoArbol *v);*/

PilaDeArbol crearPilaArbol();
void vaciarPilaArbol(PilaDeArbol *p);