#include <stdio.h>
#include <stdlib.h>
#include "pilaDeArbol.h"

PilaDeArbol crearPilaArbol()
{
   PilaDeArbol pila;
   pila.base = NULL;
   pila.tope = NULL;
   return pila;
}

void vaciarPilaArbol(PilaDeArbol *pila)
{
   pila->base = NULL;
   pila->tope = NULL;
}

void apilarArbol(PilaDeArbol *pila, tipoNodoArbol *v){
   /* Crear un nodo nuevo */
   pNodoPilaArbol nuevo = (pNodoPilaArbol)malloc(sizeof(tipoNodoPilaArbol));
   nuevo->valor = v;

   if(pila->tope == NULL)
   {
      pila->base = pila->tope = nuevo;
      nuevo->anterior = NULL;
   } else {
      nuevo->anterior = pila->tope;
      pila->tope = nuevo;
   }
}

tipoNodoArbol* desapilarArbol(PilaDeArbol *pila){
   tipoNodoArbol *nodoAux;
	if(pila->tope == NULL){
		return NULL;
	}
   nodoAux = pila->tope->valor;

	pNodoPilaArbol aux;
	aux = pila->tope;
	pila->tope = pila->tope->anterior;
	free(aux);
   return nodoAux;

}

/*int buscarEnPilaArbol(PilaDeArbol *pila, tipoNodoArbol *v){
	if(pila->tope == NULL){
		return 0;
	}
	pNodoPilaArbol aux;
	aux = pila->tope;
	while(aux != NULL)
	{
		if (strcmp(v, aux->valor) == 0)
		{
			return 1;
		}
		aux = aux->anterior;
	}
	return 0;

}*/

void mostrarPilaArbol(PilaDeArbol *pila)
{
   pNodoPilaArbol nodo = pila->tope;
   while(nodo)
   {
      printf("Valor: %dL, anterior: %dL\n", nodo->valor, nodo->anterior);
      nodo = nodo->anterior;
   }

}