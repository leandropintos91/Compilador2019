typedef struct nodo_arbol {
   char *valor;
   tipoNodoArbol *hijoIzquierdo;
   tipoNodoArbol *hijoDerecho;
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