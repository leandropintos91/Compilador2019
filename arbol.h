typedef struct nodo_arbol {
   char *valor;
   struct nodo_arbol *hijoIzquierdo;
   struct nodo_arbol *hijoDerecho;
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

void recorrerArbolInorder(tipoArbol);
void recorrerArbolPostorder(tipoArbol);
void recorrerArbolInorderConNivel(tipoArbol, int);