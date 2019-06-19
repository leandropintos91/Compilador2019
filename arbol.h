#include <stdio.h>

typedef struct nodo_arbol {
   char *valor;
   struct nodo_arbol *hijoIzquierdo;
   struct nodo_arbol *hijoDerecho;
   struct nodo_arbol *padre;
} tipoNodoArbol;

typedef tipoNodoArbol *tipoArbol;

tipoNodoArbol* crearNodo(char*, tipoNodoArbol*, tipoNodoArbol*);
tipoNodoArbol* crearHoja(char*);
void setHijoDerecho(tipoArbol, tipoNodoArbol*);
void setHijoIzquierdo(tipoArbol, tipoNodoArbol*);
void setValor(tipoArbol, char*);
char* getValor(tipoArbol);
tipoNodoArbol* getHijoIzquierdo(tipoArbol);
tipoNodoArbol* getHijoDerecho(tipoArbol);

void recorrerArbolPreorder(tipoArbol);
void recorrerArbolPostorder(tipoArbol);
void recorrerArbolInorder(tipoArbol);
void recorrerArbolPreorderConNivel(tipoArbol, int);
void guardarArbolInorder(tipoArbol arbol, FILE *archivo);

tipoArbol buscarSubarbolInicioAssembler(tipoArbol arbol);