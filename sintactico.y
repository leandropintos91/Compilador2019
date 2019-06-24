
%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
#include <string.h>
#include "pilaDeArbol.h"
#include "sintactico.h"
#include "tablaDeSimbolos.h"
#include "lista.h"

int yystopparser=0;
FILE  *yyin;
char *yyltext;
char *yytext;
FILE *archivoTablaDeSimbolos;
FILE *archivoCodigoIntermedio;
FILE *archivoAssembler;

int cantidadTokens = 0;
char* numeroFibonacci;
int contadorVariableAssembler = 1;

// TABLA SIMBOLOS
typedef struct
{
    char nombre[100];
    int tipo;
    char valor [100];
    int longitud;
} struct_tabla_de_simbolos;

struct_tabla_de_simbolos tablaDeSimbolos[200];
char tipoVariableActual[20];
tipoNodoLista* listaCodigo;

tipoNodoArbol *punteroFactor = NULL;
tipoNodoArbol *punteroTermino = NULL;
tipoNodoArbol *punteroExpresion = NULL;
tipoNodoArbol *punteroSalida = NULL;
tipoNodoArbol *punteroEntrada = NULL;
tipoNodoArbol *hijoIzquierdoComparacion = NULL;
tipoNodoArbol *hijoDerechoComparacion = NULL;
tipoNodoArbol *punteroCondicionSimple = NULL;
tipoNodoArbol *punteroCondicion = NULL;
tipoNodoArbol *punteroCondicionCompuesta = NULL;
tipoNodoArbol *hijoIzquierdoCondicionCompuesta = NULL;
tipoNodoArbol *punteroEvaluable = NULL;
tipoNodoArbol *punteroAsignacion = NULL;
tipoNodoArbol *punteroCicloEspecial = NULL;
tipoNodoArbol *punteroDecision = NULL;
tipoNodoArbol *punteroIteracion = NULL;
tipoNodoArbol *punteroSentencia = NULL;
tipoNodoArbol *punteroListaSentencia = NULL;
tipoNodoArbol *punteroAsignable = NULL;
tipoNodoArbol *punteroThen = NULL;
tipoNodoArbol *punteroListaExpresiones = NULL;
tipoNodoArbol *punteroId = NULL;
tipoNodoArbol *punteroIn = NULL;
tipoNodoArbol *punteroPrograma = NULL;

PilaDeArbol *pilaListaSentencias = NULL;



tipoNodoArbol *Pfib;
tipoNodoArbol *Paux;
PilaDeArbol *pilaArbol;
char lineaDeAsssembler[300];
int numeroIf = 1;
int numeroCondicion = 1;
int numeroComparacion = 1;
int numeroWhile = 1;

void copiarCharEn(char **, char*);
char* operadorAux;
char* idAux;

int yylex();
int yyerror();

char* crearNombreID(char*);
struct_tabla_de_simbolos* buscarEnTablaDeSimbolos(char*);
void mostrarError(char *mensaje);
void guardarTipo(const char * tipoVariable);
int existeCadenaEnTablaDeSimbolos(char* valor);
int existeTokenEnTablaDeSimbolos(char* nombre);
void guardarTablaDeSimbolos();
char* guardarEnteroEnTablaDeSimbolos(int token);
char* guardarCadenaEnTablaDeSimbolos(char* token);
char* guardarIDEnTablaDeSimbolos(char* token, int tipo);
char* guardarRealEnTablaDeSimbolos(double token);
void crearArbolFibonacci();
char* buscarCadenaEnTablaDeSimbolos(char *valor);
void apilarListaSentenciasConNodo(tipoNodoArbol *listaSentencias, tipoNodoArbol *sentencia);
void apilarListaSentencias(tipoNodoArbol *sentencia);
int obtenerTipo(char*);
int esCondicionMultiple(tipoNodoArbol*);
int esCondicionNot(tipoNodoArbol*);
int esSentenciaControl(char*);
char* crearEtiqueta(char*,char*);
int esIfElse(tipoNodoArbol*);

void escribirAsembler();
void escribirCabecera();
void escribirTablaDeSimbolos();
void procesarInicioCodigo();
void escribirFinal();
char* procesarCodigoIntermedio(tipoNodoArbol*);
char* escribirAsemblerDeSubarbol(tipoNodoArbol*);
int obtenerOperador(char*);
char* escribirAsemblerSuma(tipoNodoArbol*);
void assemblerCargarEntero(char*);
void assemblerCargarReal(char*);
char* assemblerGuardarResultado();
char* proximaVariableAuxiliarAssembler(int);
char* escribirAsemblerSalida(tipoNodoArbol*);
char* escribirAsemblerEntrada(tipoNodoArbol*);
char* escribirAsemblerAsignacion(tipoNodoArbol*);
char* procesarCondicion(tipoNodoArbol*);
char* procesarCondicionSimple(tipoNodoArbol*);
char* procesarCondicionCompuesta(char*, char*, char*);
void procesarComparacion();
char* procesarComparador(char*);
void negarCondicion(char*);
void cargarSimbolo(char*);
char* escribirAsemblerIf(tipoNodoArbol*);
void procesarResultadoCondicion(char*);
void procesarSaltoFinIf(int);
void procesarFinIf(int);
void procesarSaltoElse(int);
void procesarElse(int);
char* escribirAsemblerWhile(tipoNodoArbol*);
void procesarSaltoFinWhile(int);
void procesarFinWhile(int);
void procesarEtiquetaWhile(char*);
void procesarSaltoWhile(char*);
char* procesarAsemblerDelSubarbolMasALaIzquierda(tipoNodoArbol*);
char* procesarAsemblerIn(tipoNodoArbol*, char*);
void procesarSaltoCondicionVerdaderaWhile(char*);
void procesarEtiquetaCondicionVerdaderaWhile(char*);
char* procesarExpresion(tipoNodoArbol*);
void autoeliminarHijo(tipoNodoArbol*);
void preguntarPorFalso(char*);
void procesarSaltoFinCicloEspecial(int);

%}

%union {
int int_val;
double float_val;
char *str_val;
}

%start start_programa

%token COMENTARIOS 
COMENTARIOS_ANIDADOS 
WHILE 
ENDWHILE 
IN 
DO
ID
OPERACION_SUMA
OPERACION_RESTA
OPERACION_MULTIPLICACION
OPERACION_DIVISION
ENTERO
REAL
PARENTESIS_ABIERTO
PARENTESIS_CERRADO
COMA
OPERADOR_ASIGNACION
CADENA
OPERADOR_ENTRADA
OPERADOR_SALIDA
OPERADOR_IF 
THEN
ELSE
ENDIF
OPERADOR_AND
OPERADOR_OR
OPERADOR_NOT
OPERADOR_MAYOR_A
OPERADOR_MENOR_A
OPERADOR_MAYOR_O_IGUAL_A
OPERADOR_MENOR_O_IGUAL_A
OPERADOR_IGUAL_A
OPERADOR_DISTINTO_A
DEFVAR
ENDDEF
DOS_PUNTOS
PUNTO_Y_COMA
TIPO_ENTERO
TIPO_REAL
TIPO_CADENA
FIBONACCI

%%
start_programa : programa 
  {
    printf("Compilación OK\n");
    recorrerArbolPreorderConNivel(punteroPrograma, 0);
    escribirAsembler();
  };
programa : definicion_variables lista_sentencias 
  {
    punteroPrograma = desapilarArbol(pilaListaSentencias);
    printf("Programa OK\n");
  };

definicion_variables: DEFVAR lista_definiciones ENDDEF {printf("definicion_variables OK\n");};

lista_definiciones: lista_definiciones definicion {printf("definicion en lista_definiciones OK\n");} | definicion {printf("lista_definiciones OK\n");};

definicion: tipo_variable DOS_PUNTOS lista_ids {printf("definicion OK\n");};

lista_ids: 
  lista_ids PUNTO_Y_COMA ID 
    {
      printf("%s\n", yylval.str_val);
      guardarIDEnTablaDeSimbolos(yylval.str_val, obtenerTipo(tipoVariableActual));
      printf("ID en lista_ids OK\n");
    }
  | ID
    {
      printf("%s\n", yylval.str_val);
      guardarIDEnTablaDeSimbolos(yylval.str_val, obtenerTipo(tipoVariableActual));
      printf("ID en lista_ids OK\n");
    }

tipo_variable: 
  TIPO_ENTERO 
    {
      guardarTipo(TIPO_VARIABLE_ENTERO);
      printf("TIPO_ENTERO en tipo_variable OK\n");
    }
  | TIPO_REAL 
    {
      guardarTipo(TIPO_VARIABLE_REAL);
      printf("TIPO_REAL en tipo_variable OK\n");
    }
  | TIPO_CADENA
    {
      guardarTipo(TIPO_VARIABLE_CADENA);
      printf("TIPO_CADENA en tipo_variable OK\n");
    }

ciclo_especial: WHILE ID 
  {
    copiarCharEn(&idAux, crearNombreID(yylval.str_val));
    punteroId = crearHoja(idAux);
  } IN lista_expresiones 
  {
    punteroIn = crearNodo("IN", punteroId, punteroListaExpresiones);
  } DO lista_sentencias ENDWHILE 
  {
    punteroCicloEspecial = crearNodo("WHILE", punteroIn, desapilarArbol(pilaListaSentencias));
    printf("ciclo_especial OK\n");
  };

lista_sentencias: lista_sentencias sentencia 
{
  apilarListaSentenciasConNodo(desapilarArbol(pilaListaSentencias), punteroSentencia);
  printf("lista_sentencias OK\n");
} 
| sentencia 
{
  apilarListaSentencias(punteroSentencia);
  printf("lista_sentencias OK\n");
};

sentencia: 
  asignacion 
  {
    punteroSentencia = punteroAsignacion;
    printf("asignacion en sentencia OK\n");
  } 
  | expresion 
  {
    punteroSentencia = punteroExpresion;
    printf("expresion en sentencia OK\n");
  }
  | entrada 
  {
    punteroSentencia = punteroEntrada;
    printf("entrada en sentencia OK\n");
  }
  | salida 
  {
    punteroSentencia = punteroSalida;
    printf("salida en sentencia OK\n");
  }
  | ciclo_especial 
  {
    punteroSentencia = punteroCicloEspecial;
    printf("ciclo_especial en sentencia OK\n");
  }
  | decision 
  {
    punteroSentencia = punteroDecision;
    printf("decision en sentencia OK\n");
  }
  | iteracion 
  {
    punteroSentencia = punteroIteracion;
    printf("iteracion en sentencia OK\n");
  };

fibonacci: FIBONACCI PARENTESIS_ABIERTO ENTERO 
  { 
      printf("yylval: %d\n",yylval.int_val);
      numeroFibonacci = (char*)malloc(sizeof(char*)*6);
      sprintf(numeroFibonacci,"%d\n",yylval.int_val);
      printf("numeroFibonacci: %s\n", numeroFibonacci);
  } PARENTESIS_CERRADO 
  {
    crearArbolFibonacci();
    printf("FIBONACCI OK\n");
  };

asignacion: ID 
  {
    copiarCharEn(&idAux, crearNombreID(yylval.str_val));
    printf("ID %s en asignacion\n", yylval.str_val);
  } 
  OPERADOR_ASIGNACION asignable 
  {
    punteroAsignacion = crearNodo(":=", crearHoja(idAux), punteroAsignable);
    printf("asignacion OK\n");
  };

asignable: 
  expresion 
  {
    punteroAsignable = punteroExpresion;
    printf("expresion en asignable OK\n");}
  | cadena 
  {
    punteroAsignable = crearHoja(buscarCadenaEnTablaDeSimbolos(yylval.str_val));
    printf("cadena en asignable OK\n");
  };

cadena: CADENA
  {
      guardarCadenaEnTablaDeSimbolos(yylval.str_val);
      printf("cadena OK\n");
  };

lista_expresiones:  lista_expresiones COMA expresion 
  {
    punteroListaExpresiones = crearNodo("LISTA_EXPRESION", punteroListaExpresiones, punteroExpresion);
    printf("lista_expresiones OK\n");}
  | expresion 
  {
    punteroListaExpresiones = punteroExpresion;
    printf("lista_expresiones OK\n");
  };

decision: 
  OPERADOR_IF evaluable THEN lista_sentencias ENDIF 
  {
    punteroDecision = crearNodo("IF", punteroEvaluable, desapilarArbol(pilaListaSentencias));
    printf("decision OK\n");
  }
  | OPERADOR_IF evaluable THEN lista_sentencias 
  {
    punteroThen = desapilarArbol(pilaListaSentencias);
  } 
  ELSE lista_sentencias ENDIF 
  {
    tipoNodoArbol *punteroCuerpo = crearNodo("CUERPO_IF", punteroThen, desapilarArbol(pilaListaSentencias));
    punteroDecision = crearNodo("IF", punteroEvaluable, punteroCuerpo);
    printf("decision OK\n");
  };

evaluable: PARENTESIS_ABIERTO condicion PARENTESIS_CERRADO 
  {
    punteroEvaluable = punteroCondicion;
    printf("evaluable OK\n");
  };

condicion: condicion_simple 
  {
    punteroCondicion = punteroCondicionSimple;
    printf("condicion OK\n");
  } 
  | condicion_compuesta 
  {
    punteroCondicion = punteroCondicionCompuesta;
    printf("condicion OK\n");
  };

condicion_compuesta: condicion_simple 
  {
    hijoIzquierdoCondicionCompuesta = punteroCondicionSimple;
  } 
  OPERADOR_AND condicion_simple 
  {
    punteroCondicionCompuesta = crearNodo("AND", hijoIzquierdoCondicionCompuesta, punteroCondicionSimple);
    printf("condicion AND en condicion_compuesta OK\n");
  }
  | condicion_simple
  {
    hijoIzquierdoCondicionCompuesta = punteroCondicionSimple;
  }  
  OPERADOR_OR condicion_simple 
  {
    punteroCondicionCompuesta = crearNodo("OR", hijoIzquierdoCondicionCompuesta, punteroCondicionSimple);
    printf("condicion OR en condicion_compuesta OK\n");
  }
  | OPERADOR_NOT PARENTESIS_ABIERTO condicion_simple PARENTESIS_CERRADO 
  {
    punteroCondicionCompuesta = crearNodo("NOT", punteroCondicionSimple, NULL);
    printf("condicion NOT condicion_compuesta OK\n");
  };

condicion_simple: expresion
  {
    hijoIzquierdoComparacion = punteroExpresion;
  } comparador expresion 
  {
    hijoDerechoComparacion = punteroExpresion;
    punteroCondicionSimple = crearNodo(operadorAux, hijoIzquierdoComparacion, hijoDerechoComparacion );
    printf("condicion_simple OK\n");
  };

comparador: OPERADOR_MAYOR_A 
  {
    copiarCharEn(&operadorAux, ">");
    printf("comparador MAYOR A OK\n");
  }
  | OPERADOR_MENOR_A 
  {
    copiarCharEn(&operadorAux, "<");
    printf("comparador MENOR A OK\n");
  }
  | OPERADOR_MAYOR_O_IGUAL_A 
  {
    copiarCharEn(&operadorAux, ">=");
    printf("comparador MAYOR O IGUAL A OK\n");
  }
  | OPERADOR_MENOR_O_IGUAL_A 
  {
    copiarCharEn(&operadorAux, "<=");
    printf("comparador MENOR O IGUAL A OK\n");
  }
  | OPERADOR_IGUAL_A 
  {
    copiarCharEn(&operadorAux, "=");
    printf("comparador IGUAL A OK\n");
  }
  | OPERADOR_DISTINTO_A 
  {
    copiarCharEn(&operadorAux, "!=");
    printf("comparador DISTINTO A OK\n");
  };

iteracion: WHILE evaluable THEN lista_sentencias ENDWHILE 
  {
    punteroIteracion = crearNodo("WHILE", punteroEvaluable, desapilarArbol(pilaListaSentencias));
    printf("iteracion OK\n");
  };

entrada: OPERADOR_ENTRADA ID 
  {
      char* aux = (char*)malloc(sizeof(char*)*50);
      sprintf(aux, "%s\n", yylval.str_val);
      punteroEntrada = crearNodo("ENTRADA", crearHoja(crearNombreID(yylval.str_val)), NULL);
    printf("entrada OK\n");
  };

salida: OPERADOR_SALIDA ID 
    {
      char* aux = (char*)malloc(sizeof(char*)*50);
      sprintf(aux, "%s\n", yylval.str_val);
      punteroSalida = crearNodo("SALIDA", crearHoja(crearNombreID(yylval.str_val)), NULL);
      printf("salida OK\n");
    } 
  | OPERADOR_SALIDA cadena 
    {
      punteroSalida = crearNodo("SALIDA", crearHoja(buscarCadenaEnTablaDeSimbolos(yylval.str_val)), NULL);
      printf("salida OK\n");
    };

expresion:
  termino
  {
    punteroExpresion = punteroTermino;
  }
  |expresion OPERACION_RESTA termino
    {
      printf("Resta en expresion OK\n");
      punteroExpresion = crearNodo("-", punteroExpresion, punteroTermino);
    }
  |expresion OPERACION_SUMA termino
    {
      printf("Suma en expresion OK\n");
      punteroExpresion = crearNodo("+", punteroExpresion, punteroTermino);
    };

termino: 
  factor 
  {
    punteroTermino = punteroFactor;
  }
  |termino OPERACION_MULTIPLICACION factor  
    {
      printf("Multiplicación en termino OK\n");
      punteroTermino = crearNodo("*", punteroTermino, punteroFactor);
    }
  |termino OPERACION_DIVISION factor  
    {
      printf("División en termino OK\n");
      punteroTermino = crearNodo("/", punteroTermino, punteroFactor);
    };

factor: 
  ID
    {
      printf(" ID %s \n",yylval.str_val);
      printf("ID en FACTOR es: %s \n", yylval.str_val);
      punteroFactor = crearHoja(crearNombreID(yylval.str_val));
    }
  | ENTERO 
    {
      printf("ENTERO en FACTOR es: %d \n", $<int_val>$);
      punteroFactor = crearHoja(guardarEnteroEnTablaDeSimbolos($<int_val>$));
    }
  | REAL 
    {
      printf("REAL en FACTOR es: %f \n", $<float_val>$);
      punteroFactor = crearHoja(guardarRealEnTablaDeSimbolos($<float_val>$));
    }
  |PARENTESIS_ABIERTO expresion PARENTESIS_CERRADO 
  {
    punteroFactor = punteroExpresion;
  }
  | fibonacci 
    {
      punteroFactor = Pfib;
    };

%%






int main(int argc,char *argv[])
{
  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	   printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
  }
  else
  {
      if(pilaListaSentencias == NULL) {
        PilaDeArbol pilaArbol = crearPilaArbol();
        pilaListaSentencias = &pilaArbol;
      }
	    yyparse();
      if ((archivoTablaDeSimbolos = fopen ("ts.txt","w"))== NULL)
      {
        printf("No se puede crear el archivo de la tabla de simbolos");
        exit(1);
      }
      guardarTablaDeSimbolos();
      if(fclose(archivoTablaDeSimbolos)!=0)
      {
        printf("No se puede CERRAR el archivo de la tabla de simbolos");
        exit(1);
      }
      if ((archivoCodigoIntermedio = fopen ("intermedia.txt","w"))== NULL)
      {
        printf("No se puede crear el archivo del código intermedio");
        exit(1);
      }
      guardarArbolInorder(punteroPrograma, archivoCodigoIntermedio);
      fclose(archivoCodigoIntermedio);

  }
  fclose(yyin);
  return 0;
}

int yyerror(void)
 {
    printf("ERROR EN COMPILACIÓN.\n");
    system ("Pause");
    exit (1);
 }

void mostrarError(char *mensaje) {
  printf("%s\n", mensaje);
  yyerror();
}

char* crearNombreID(char* id) {
  char* variable = (char*)malloc(100);
  strcpy(variable, "_");
  strcat(variable,id);
  return variable;
}

char* guardarIDEnTablaDeSimbolos(char* token, int tipo)
{
  char mensajeError[200];
  char* nombreToken = (char*)malloc(100);
  strcpy(nombreToken, "_");
  strcat(nombreToken, token);
  if(!existeTokenEnTablaDeSimbolos(nombreToken))
  {
    strcpy(tablaDeSimbolos[cantidadTokens].nombre, nombreToken);
    tablaDeSimbolos[cantidadTokens].tipo = tipo;
    cantidadTokens++;
    return nombreToken;
  } else {
    sprintf(mensajeError, "El ID %s está duplicado.", token);
    mostrarError(mensajeError);
    return NULL;
  }
}

char* guardarCadenaEnTablaDeSimbolos(char* token)
{
  char* nombreToken = crearNombreID(token);
  char numeroCadena[5];
  itoa(cantidadTokens, numeroCadena,10);
  strcat(nombreToken, numeroCadena);
  if(!existeCadenaEnTablaDeSimbolos(token))
  {
    strcpy(tablaDeSimbolos[cantidadTokens].nombre, nombreToken);
    tablaDeSimbolos[cantidadTokens].tipo = CONSTANTE_CADENA;
    strcpy(tablaDeSimbolos[cantidadTokens].valor, token);
    tablaDeSimbolos[cantidadTokens].longitud = (strlen(token));
    cantidadTokens++;
  }
  return nombreToken;
}

char* guardarEnteroEnTablaDeSimbolos(int token)
{     
  char* nombreToken = (char*)malloc(100);
  char nombreEntero[20];

  sprintf(nombreEntero, "%d", token);

  strcpy(nombreToken,"_");
  strcat(nombreToken, "entero");
  char numeroCadena[5];
  itoa(cantidadTokens, numeroCadena,10);
  strcat(nombreToken, numeroCadena);
  if(!existeTokenEnTablaDeSimbolos(nombreToken))
  {
    strcpy(tablaDeSimbolos[cantidadTokens].nombre, nombreToken);
    tablaDeSimbolos[cantidadTokens].tipo = CONSTANTE_ENTERO;
    strcpy(tablaDeSimbolos[cantidadTokens].valor, nombreEntero);
    cantidadTokens++;
  }
  return nombreToken;
}

char* guardarRealEnTablaDeSimbolos(double token)
{     
  char* nombreToken = (char*)malloc(100);
  char nombreReal[20];
  
  sprintf(nombreReal, "%lf", token);

  strcpy(nombreToken,"_");
  strcat(nombreToken, "real");
  char numeroCadena[5];
  itoa(cantidadTokens, numeroCadena,10);
  strcat(nombreToken, numeroCadena);
  if(!existeTokenEnTablaDeSimbolos(nombreToken))
  {
    strcpy(tablaDeSimbolos[cantidadTokens].nombre, nombreToken);
    tablaDeSimbolos[cantidadTokens].tipo = CONSTANTE_REAL;
    strcpy(tablaDeSimbolos[cantidadTokens].valor, nombreReal);
    cantidadTokens++;
  }
  return nombreToken;
}

void guardarTablaDeSimbolos()
{
  int i;
  char longitud[100];
  //crear header
  for (i=0; i<cantidadTokens; i++)
  {
    sprintf(longitud, "%d", tablaDeSimbolos[i].longitud);
    if(strcmp(longitud, "0") == 0)
      longitud[0] = '\0';
    fprintf(
      archivoTablaDeSimbolos,
      "Nombre: %s  | Tipo: %d   | Valor: %s | Longitud: %s \n",
      tablaDeSimbolos[i].nombre, tablaDeSimbolos[i].tipo, tablaDeSimbolos[i].valor, longitud);
  }
}

int existeTokenEnTablaDeSimbolos(char* nombre)
{
  int i;
  for (i=0; i<cantidadTokens; i++)
    {
    if(strcmp(tablaDeSimbolos[i].nombre, nombre) == 0)
    {
      return 1;
    }
  }
  
  return 0;
}

int existeCadenaEnTablaDeSimbolos(char* valor)
{
  int i;
  for (i=0; i<cantidadTokens; i++)
    {
    if(strcmp(tablaDeSimbolos[i].valor, valor) == 0)
    {
      return 1;
    }
  }
  
  return 0;
}

char* buscarCadenaEnTablaDeSimbolos(char* valor)
{
  int i;
  for (i=0; i<cantidadTokens; i++)
    {
    if(strcmp(tablaDeSimbolos[i].valor, valor) == 0)
    {
      return tablaDeSimbolos[i].nombre;
    }
  }
  
  return 0;
}

struct_tabla_de_simbolos* buscarEnTablaDeSimbolos(char* nombre) {
  int i;
  for (i=0; i<cantidadTokens; i++)
    {
    if(strcmp(tablaDeSimbolos[i].nombre, nombre) == 0)
    {
      
      return &tablaDeSimbolos[i];
    }
  }
  
  return NULL;
}

void guardarTipo(const char * tipoVariable) {
  strcpy(tipoVariableActual, tipoVariable);
}

void crearArbolFibonacci() {

  if(pilaArbol == NULL) {
    PilaDeArbol pilaAux = crearPilaArbol();
    pilaArbol = &pilaAux;
  }

  tipoNodoArbol* hijoDerecho;
  tipoNodoArbol* hijoIzquierdo;



  Paux = crearNodo("+",crearHoja("i"),crearHoja("1"));
  Paux = crearNodo("=",crearHoja("i"),Paux);
  apilarArbol(pilaArbol, Paux);
  Paux = crearNodo("=",crearHoja("acum"),crearHoja("suma"));
  apilarArbol(pilaArbol, Paux);
  Paux = crearNodo("=",crearHoja("ant"),crearHoja("acum"));
  apilarArbol(pilaArbol, Paux);
  hijoIzquierdo = desapilarArbol(pilaArbol);
  hijoDerecho = desapilarArbol(pilaArbol);
  Paux = crearNodo("AUX",hijoIzquierdo,hijoDerecho);
  apilarArbol(pilaArbol, Paux);
  Paux = crearNodo("+",crearHoja("acum"),crearHoja("ant"));
  Paux = crearNodo("=",crearHoja("suma"),Paux);
  apilarArbol(pilaArbol, Paux);
  hijoIzquierdo = desapilarArbol(pilaArbol);
  hijoDerecho = desapilarArbol(pilaArbol);
  Paux = crearNodo("AUX",hijoIzquierdo,hijoDerecho);
  apilarArbol(pilaArbol, Paux);
  Paux = crearNodo("=",crearHoja("acum"),crearHoja("1"));
  apilarArbol(pilaArbol, Paux);

  hijoIzquierdo = desapilarArbol(pilaArbol);
  hijoDerecho = desapilarArbol(pilaArbol);
  Paux = crearNodo("CUERPO_IF",hijoIzquierdo,hijoDerecho);
  apilarArbol(pilaArbol, Paux);
  Paux = crearNodo("==",crearHoja("i"),crearHoja("2"));
  apilarArbol(pilaArbol, Paux);

  hijoIzquierdo = desapilarArbol(pilaArbol);
  hijoDerecho = desapilarArbol(pilaArbol);
  Paux = crearNodo("IF",hijoIzquierdo,hijoDerecho);
  apilarArbol(pilaArbol, Paux);
  Paux = crearNodo("=",crearHoja("acum"),crearHoja("0"));
  apilarArbol(pilaArbol, Paux);

  hijoIzquierdo = desapilarArbol(pilaArbol);
  hijoDerecho = desapilarArbol(pilaArbol);
  Paux = crearNodo("CUERPO_IF",hijoIzquierdo,hijoDerecho);
  apilarArbol(pilaArbol, Paux);
  Paux = crearNodo("==",crearHoja("i"),crearHoja("1"));
  apilarArbol(pilaArbol, Paux);

  hijoIzquierdo = desapilarArbol(pilaArbol);
  hijoDerecho = desapilarArbol(pilaArbol);
  Paux = crearNodo("IF",hijoIzquierdo,hijoDerecho);
  apilarArbol(pilaArbol, Paux);

  hijoIzquierdo = desapilarArbol(pilaArbol);
  hijoDerecho = desapilarArbol(pilaArbol);
  Paux = crearNodo("AUX",hijoIzquierdo,hijoDerecho);
  apilarArbol(pilaArbol, Paux);
  Paux = crearNodo("<=",crearHoja("i"),crearHoja(numeroFibonacci));
  apilarArbol(pilaArbol, Paux);

  hijoIzquierdo = desapilarArbol(pilaArbol);
  hijoDerecho = desapilarArbol(pilaArbol);
  Paux = crearNodo("WHILE",hijoIzquierdo,hijoDerecho);
  apilarArbol(pilaArbol, Paux);
  Paux = crearNodo("=",crearHoja("i"),crearHoja("0"));
  apilarArbol(pilaArbol, Paux);

  hijoIzquierdo = desapilarArbol(pilaArbol);
  hijoDerecho = desapilarArbol(pilaArbol);
  Paux = crearNodo("FOR",hijoIzquierdo,hijoDerecho);
  apilarArbol(pilaArbol, Paux);
  Paux = crearNodo("=",crearHoja("acum"),crearHoja("0"));
  apilarArbol(pilaArbol, Paux);
  Paux = crearNodo("=",crearHoja("ant"),crearHoja("0"));
  apilarArbol(pilaArbol, Paux);

  hijoIzquierdo = desapilarArbol(pilaArbol);
  hijoDerecho = desapilarArbol(pilaArbol);
  Paux = crearNodo("AUX", hijoIzquierdo, hijoDerecho);
  apilarArbol(pilaArbol, Paux);

  hijoIzquierdo = desapilarArbol(pilaArbol);
  hijoDerecho = desapilarArbol(pilaArbol);
  Pfib = crearNodo("FIB", hijoIzquierdo,hijoDerecho);
}


void copiarCharEn(char **destino, char *origen) {
  if(*destino == NULL)
    *destino = (char *)malloc(sizeof(char *) * strlen(origen) + 1);

  strcpy(*destino, origen);
}

void apilarListaSentenciasConNodo(tipoNodoArbol *listaSentencias, tipoNodoArbol *sentencia) {
  punteroListaSentencia = crearNodo("AUX", listaSentencias, sentencia);
  apilarArbol(pilaListaSentencias, punteroListaSentencia);
}

void apilarListaSentencias(tipoNodoArbol *sentencia) {
  apilarArbol(pilaListaSentencias, sentencia);
}

void escribirAsembler(){
	
  archivoAssembler = fopen("Final.asm", "w");
  listaCodigo = crearLista();
	escribirCabecera();
  procesarInicioCodigo();
  procesarCodigoIntermedio(punteroPrograma);
  escribirTablaDeSimbolos();
  escribirLista(listaCodigo,archivoAssembler);
  escribirFinal();
	fclose(archivoAssembler); 
  recorrerLista(listaCodigo);
}

void escribirCabecera() {
	fprintf(archivoAssembler, "include macros2.asm \n");
  fprintf(archivoAssembler, "include number.asm \n");

  fprintf(archivoAssembler, ".MODEL LARGE\n");
  fprintf(archivoAssembler, ".386\n");
  fprintf(archivoAssembler, ".STACK 200h\n\n");

	fprintf(archivoAssembler, "MAXTEXTSIZE EQU %d\n\n", LIMITE_CADENA);
}

void escribirTablaDeSimbolos() {
  char valorAuxiliar[100];

  fprintf(archivoAssembler, ".DATA\n");
  fprintf(archivoAssembler, "NEW_LINE DB 0AH,0DH,'$'\n");
  fprintf(archivoAssembler, "CWprevio DW ?\n");

  for(int i=0; i < cantidadTokens; i++){
    fprintf(archivoAssembler, "%s ", tablaDeSimbolos[i].nombre);
    strcpy(valorAuxiliar, tablaDeSimbolos[i].valor);

    switch(tablaDeSimbolos[i].tipo){
      case CONSTANTE_ENTERO:
        fprintf(archivoAssembler, "dd %s\n", valorAuxiliar);
        break;

      case CONSTANTE_REAL:
        fprintf(archivoAssembler, "dd %s\n", valorAuxiliar);
        break;

      case CONSTANTE_CADENA:
        fprintf(archivoAssembler, "db \"%s\", '$'\n", valorAuxiliar);
        break;

      default: //Es una variable int, float o puntero a string
        fprintf(archivoAssembler, "dd ?\n");
    }
  }

  fprintf(archivoAssembler, "\n");
}

int obtenerTipo(char* tipo) {
  int valor;
  if(strcmp(tipo, TIPO_CONSTANTE_CADENA) == 0)
    valor = CONSTANTE_CADENA;

  else if(strcmp(tipo, TIPO_CONSTANTE_REAL) == 0)
    valor =  CONSTANTE_REAL;

  else if(strcmp(tipo, TIPO_CONSTANTE_ENTERO) == 0)
    valor =  CONSTANTE_ENTERO;

  else if(strcmp(tipo, TIPO_VARIABLE_CADENA) == 0)
    valor =  VARIABLE_CADENA;

  else if(strcmp(tipo, TIPO_VARIABLE_REAL) == 0)
    valor =  VARIABLE_REAL;

  else if(strcmp(tipo, TIPO_VARIABLE_ENTERO) == 0)
    valor =  VARIABLE_ENTERO;
  else
    valor =  -1;
  return valor;
}

void procesarInicioCodigo(){
  sprintf(lineaDeAsssembler, ".CODE\n\nSTART:\n\nMOV AX, @DATA\nMOV DS, AX\nFINIT\n\n");
  agregar(&listaCodigo,lineaDeAsssembler);
}

void escribirFinal(){
  fprintf(archivoAssembler, "\nMOV AH, 1\nINT 21h\nMOV AX, 4C00h\nINT 21h\n\nEND START\n");
}

char* procesarCodigoIntermedio(tipoNodoArbol* arbol) {
  tipoNodoArbol* subarbol = buscarSubarbolInicioAssembler(arbol);
  char* nuevaVariableAuxiliarDeAssembler;

  while(subarbol != NULL) {
    nuevaVariableAuxiliarDeAssembler = procesarAsemblerDelSubarbolMasALaIzquierda(subarbol);
    subarbol = buscarSubarbolInicioAssembler(arbol);
  }
  return nuevaVariableAuxiliarDeAssembler;
}

char* procesarAsemblerDelSubarbolMasALaIzquierda(tipoNodoArbol* subarbol) {
    char* nuevaVariableAuxiliarDeAssembler = escribirAsemblerDeSubarbol(subarbol);
    podarArbol(subarbol);
    if(nuevaVariableAuxiliarDeAssembler != NULL) {
      setValor(subarbol, nuevaVariableAuxiliarDeAssembler);
    }
    else {
      autoeliminarHijo(subarbol);
    }
    return nuevaVariableAuxiliarDeAssembler;
}

char* escribirAsemblerDeSubarbol(tipoNodoArbol* subarbol) {
  if(obtenerOperador(subarbol->valor) == OPERACION_SUMA) {
    return escribirAsemblerSuma(subarbol);
  }

  if(obtenerOperador(subarbol->valor) == OPERACION_RESTA) {

  }

  if(obtenerOperador(subarbol->valor) == OPERACION_MULTIPLICACION) {

  }

  if(obtenerOperador(subarbol->valor) == OPERACION_DIVISION) {

  }
  if(obtenerOperador(subarbol->valor) == OPERADOR_ASIGNACION) {
    escribirAsemblerAsignacion(subarbol);
    return NULL;
  }
  if(strcmp(subarbol->valor, "AUX") == 0) {
    return NULL;
  }
  if(obtenerOperador(subarbol->valor) == OPERADOR_SALIDA) {
    return escribirAsemblerSalida(subarbol);
  }
  if(obtenerOperador(subarbol->valor) == OPERADOR_ENTRADA) {
    return escribirAsemblerEntrada(subarbol);
  }
  if(obtenerOperador(subarbol->valor) == OPERADOR_IF) {
    return escribirAsemblerIf(subarbol);
  }
  if(obtenerOperador(subarbol->valor) == WHILE) {
    return escribirAsemblerWhile(subarbol);
  }
  if(obtenerOperador(subarbol->valor) == LISTA_EXPRESION) {
    return procesarExpresion(subarbol);
  }
}

int obtenerOperador(char* operador) {
  if(strcmp(operador, "+") == 0) {
    return OPERACION_SUMA;
  }

  if(strcmp(operador, "-") == 0)
    return OPERACION_RESTA;

  if(strcmp(operador, "*") == 0)
    return OPERACION_MULTIPLICACION;

  if(strcmp(operador, "/") == 0)
    return OPERACION_DIVISION;

  if(strcmp(operador, ":=") == 0)
    return OPERADOR_ASIGNACION;
  if(strcmp(operador, "SALIDA") == 0) {
    return OPERADOR_SALIDA;
  }
  if(strcmp(operador, "ENTRADA") == 0) {
    return OPERADOR_ENTRADA;
  }
  if(strcmp(operador, "IF") == 0) {
    return OPERADOR_IF;
  }

  if(strcmp(operador, ">") == 0) {
    return OPERADOR_MAYOR_A;
  }
  if(strcmp(operador, "<") == 0) {
    return OPERADOR_MENOR_A;
  }
  if(strcmp(operador, ">=") == 0) {
    return OPERADOR_MAYOR_O_IGUAL_A;
  }
  if(strcmp(operador, "<=") == 0) {
    return OPERADOR_MENOR_O_IGUAL_A;
  }
  if(strcmp(operador, "=") == 0) {
    return OPERADOR_IGUAL_A;
  }
  if(strcmp(operador, "!=") == 0) {
    return OPERADOR_DISTINTO_A;
  } 
  if(strcmp(operador, "WHILE") == 0) {
    return WHILE;
  } 
  if(strcmp(operador, "LISTA_EXPRESION") == 0) {
    return LISTA_EXPRESION;
  }
  return -1;
}

char* escribirAsemblerSuma(tipoNodoArbol* subarbol) {
  struct_tabla_de_simbolos * punteroIzquierdo = buscarEnTablaDeSimbolos(subarbol->hijoIzquierdo->valor);
  struct_tabla_de_simbolos * punteroDerecho = buscarEnTablaDeSimbolos(subarbol->hijoDerecho->valor);

  int tipoIzquierdoEntero = (punteroIzquierdo->tipo == VARIABLE_ENTERO || punteroIzquierdo->tipo == CONSTANTE_ENTERO);
  int tipoDerechoEntero = punteroDerecho->tipo == VARIABLE_ENTERO || punteroDerecho->tipo == CONSTANTE_ENTERO;

  if(tipoIzquierdoEntero) {
    assemblerCargarEntero(subarbol->hijoIzquierdo->valor);
  } else {
    assemblerCargarReal(subarbol->hijoIzquierdo->valor);
  }

  if(tipoDerechoEntero) {
    assemblerCargarEntero(subarbol->hijoDerecho->valor);
  } else {
    assemblerCargarReal(subarbol->hijoDerecho->valor);
  }

  sprintf(lineaDeAsssembler, "FADD\n");
  agregar(&listaCodigo,lineaDeAsssembler);

  if(tipoIzquierdoEntero && tipoDerechoEntero)
    return assemblerGuardarResultado(VARIABLE_ENTERO);
  else
    return assemblerGuardarResultado(VARIABLE_REAL);
}

void assemblerCargarEntero(char* valor) {
  sprintf(lineaDeAsssembler, "FILD %s\n", valor);
  agregar(&listaCodigo,lineaDeAsssembler);
}

void assemblerCargarReal(char* valor) {
  sprintf(lineaDeAsssembler, "FLD %s\n", valor);
  agregar(&listaCodigo,lineaDeAsssembler);
}

char* assemblerGuardarResultado(int tipo) {
  char* variableAuxiliarAssembler = proximaVariableAuxiliarAssembler(tipo);
  if(tipo == VARIABLE_ENTERO)
    sprintf(lineaDeAsssembler, "FISTP %s\n", variableAuxiliarAssembler);
  else
    sprintf(lineaDeAsssembler, "FSTP %s\n", variableAuxiliarAssembler);
  agregar(&listaCodigo,lineaDeAsssembler);
  sprintf(lineaDeAsssembler, "FFREE\n");
  agregar(&listaCodigo,lineaDeAsssembler);
  return variableAuxiliarAssembler;
}

char* proximaVariableAuxiliarAssembler(int tipo) {
  char* nuevaVariableAssembler = (char*)malloc(100);
  char numero[4];
  sprintf(numero,"%d", contadorVariableAssembler);
  contadorVariableAssembler++;
  strcpy(nuevaVariableAssembler, "@aux");
  strcat(nuevaVariableAssembler, numero);
  return guardarIDEnTablaDeSimbolos(nuevaVariableAssembler, tipo);
}

char* escribirAsemblerAsignacion(tipoNodoArbol* subarbol) {
  sprintf(lineaDeAsssembler, "MOV eax, %s\n", subarbol->hijoDerecho->valor);
  agregar(&listaCodigo,lineaDeAsssembler);

  sprintf(lineaDeAsssembler, "MOV %s, eax\n", subarbol->hijoIzquierdo->valor);
  agregar(&listaCodigo,lineaDeAsssembler);

  return NULL;
}

char* escribirAsemblerSalida(tipoNodoArbol* subarbol) {
  int tipo = buscarEnTablaDeSimbolos(subarbol->hijoIzquierdo->valor)->tipo;
  switch(tipo) {
    case CONSTANTE_CADENA:
      sprintf(lineaDeAsssembler, "displayString %s\n", subarbol->hijoIzquierdo->valor);
      agregar(&listaCodigo,lineaDeAsssembler);
      break;

    case VARIABLE_CADENA:
      sprintf(lineaDeAsssembler, "displayString %s\n", subarbol->hijoIzquierdo->valor);
      agregar(&listaCodigo,lineaDeAsssembler);
      break;

    case VARIABLE_ENTERO:
      sprintf(lineaDeAsssembler, "DisplayInteger %s\n", subarbol->hijoIzquierdo->valor);
      agregar(&listaCodigo,lineaDeAsssembler);
      break;

    case VARIABLE_REAL:
      sprintf(lineaDeAsssembler, "DisplayFloat %s\n", subarbol->hijoIzquierdo->valor);
      agregar(&listaCodigo,lineaDeAsssembler);
      break;
    default:
      break;
  }

  sprintf(lineaDeAsssembler, "newLine 1\n");
  agregar(&listaCodigo,lineaDeAsssembler);
  
  return NULL;
}

char* escribirAsemblerEntrada(tipoNodoArbol* subarbol) {
  //DEBUG
  printf("Escribo subarbol assembler\n");
  int tipo = buscarEnTablaDeSimbolos(subarbol->hijoIzquierdo->valor)->tipo;
  switch(tipo) {
    case VARIABLE_CADENA:
      sprintf(lineaDeAsssembler, "GetString %s\n", subarbol->hijoIzquierdo->valor);
      break;

    case VARIABLE_ENTERO:
      sprintf(lineaDeAsssembler, "GetInteger %s\n", subarbol->hijoIzquierdo->valor);
      break;

    case VARIABLE_REAL:
      sprintf(lineaDeAsssembler, "GetFloat %s\n", subarbol->hijoIzquierdo->valor);
      break;
    default:
      break;
  }
  agregar(&listaCodigo,lineaDeAsssembler);
  return NULL;
}

char* escribirAsemblerIf(tipoNodoArbol* subarbol) {
  char* variableResultadoCondicion = procesarCondicion(subarbol->hijoIzquierdo);
  int numeroIfLocal = numeroIf;
  //verificar si dio falso
  procesarResultadoCondicion(variableResultadoCondicion);
  if(esIfElse(subarbol)) {
    procesarSaltoElse(numeroIfLocal);
    procesarCodigoIntermedio(subarbol->hijoDerecho->hijoIzquierdo);
    procesarSaltoFinIf(numeroIfLocal);
    procesarElse(numeroIfLocal);
    procesarCodigoIntermedio(subarbol->hijoDerecho->hijoDerecho);
  } else {
    procesarSaltoFinIf(numeroIfLocal);
    procesarCodigoIntermedio(subarbol->hijoDerecho);
  }
  procesarFinIf(numeroIfLocal);
  numeroIf++;
  return NULL;
}

char* procesarCondicion(tipoNodoArbol* subarbol) {
  char* variableCondicionIzquierda = NULL;
  char* variableCondicionDerecha = NULL;
  int numeroCondicionLocal = numeroCondicion;
  if(esCondicionMultiple(subarbol)) {
    variableCondicionIzquierda = procesarCondicionSimple(subarbol->hijoIzquierdo);
    variableCondicionDerecha = procesarCondicionSimple(subarbol->hijoDerecho);
    return procesarCondicionCompuesta(subarbol->valor,variableCondicionIzquierda, variableCondicionDerecha);
  } else if(esCondicionNot(subarbol)) {
    variableCondicionIzquierda = procesarCondicionSimple(subarbol->hijoIzquierdo);
    negarCondicion(variableCondicionIzquierda);
    return variableCondicionIzquierda;
  } else {
    return procesarCondicionSimple(subarbol);
  }
}

int esCondicionMultiple(tipoNodoArbol* subarbol) {
  if(strcmp(subarbol->valor, "AND") == 0 || strcmp(subarbol->valor, "OR") == 0) {
    return 1;
  }
  return 0;
}

int esCondicionNot(tipoNodoArbol* subarbol) {
  return strcmp(subarbol->valor, "NOT") == 0;
}

char* procesarCondicionSimple(tipoNodoArbol* subarbol) {
  cargarSimbolo(subarbol->hijoIzquierdo->valor);
  cargarSimbolo(subarbol->hijoDerecho->valor);
  procesarComparacion(); //esta es la parte hardcodeada
  return procesarComparador(subarbol->valor);
}

void cargarSimbolo(char* simbolo) {
  //TODO refactorizar esto, es muy parecido a assembler suma y lo vamos a necesitar para multiplicacio y division
  struct_tabla_de_simbolos * punteroTablaDeSimbolo = buscarEnTablaDeSimbolos(simbolo);

  int tipoEntero = (punteroTablaDeSimbolo->tipo == VARIABLE_ENTERO || punteroTablaDeSimbolo->tipo == CONSTANTE_ENTERO);

  if(tipoEntero) {
    assemblerCargarEntero(simbolo);
  } else {
    assemblerCargarReal(simbolo);
  }
}

void procesarComparacion() {
  sprintf(lineaDeAsssembler, "FXCH\n");
  agregar(&listaCodigo,lineaDeAsssembler);

  sprintf(lineaDeAsssembler, "FCOMP\n");
  agregar(&listaCodigo,lineaDeAsssembler);

  sprintf(lineaDeAsssembler, "FFREE St(0)\n");
  agregar(&listaCodigo,lineaDeAsssembler);

  sprintf(lineaDeAsssembler, "fstsw ax\n");
  agregar(&listaCodigo,lineaDeAsssembler);

  sprintf(lineaDeAsssembler, "sahf\n");
  agregar(&listaCodigo,lineaDeAsssembler);
}

char* procesarComparador(char* comparador) {
  int numeroComparacionLocal = numeroComparacion;
  char charComparacionLocal[10];
  itoa(numeroComparacionLocal, charComparacionLocal,10);
  char* variableAuxiliar = proximaVariableAuxiliarAssembler(VARIABLE_ENTERO);
  char salto[5];

  if(obtenerOperador(comparador) == OPERADOR_MAYOR_A) {
    strcpy(salto, "JA");
  }
  if(obtenerOperador(comparador) == OPERADOR_MENOR_A) {
    strcpy(salto, "JB");
  }
  if(obtenerOperador(comparador) == OPERADOR_MAYOR_O_IGUAL_A) {
    strcpy(salto, "JAE");
  }
  if(obtenerOperador(comparador) == OPERADOR_MENOR_O_IGUAL_A) {
    strcpy(salto, "JBE");
  }
  if(obtenerOperador(comparador) == OPERADOR_IGUAL_A) {
    strcpy(salto, "JE");
  }
  if(obtenerOperador(comparador) == OPERADOR_DISTINTO_A) {
    strcpy(salto, "JNE");
  }



  sprintf(lineaDeAsssembler, "%s %s\n", salto, crearEtiqueta("ETIQUETA_CONDICION_VERDADERA_",charComparacionLocal));
  agregar(&listaCodigo,lineaDeAsssembler);

  sprintf(lineaDeAsssembler, "MOV %s, 0\n", variableAuxiliar);
  agregar(&listaCodigo,lineaDeAsssembler);

  sprintf(lineaDeAsssembler, "JMP %s\n", crearEtiqueta("ETIQUETA_FIN_CONDICION_",charComparacionLocal));
  agregar(&listaCodigo,lineaDeAsssembler);

  sprintf(lineaDeAsssembler, "%s:\n", crearEtiqueta("ETIQUETA_CONDICION_VERDADERA_",charComparacionLocal));
  agregar(&listaCodigo,lineaDeAsssembler);

  sprintf(lineaDeAsssembler, "MOV %s, 1\n", variableAuxiliar);
  agregar(&listaCodigo,lineaDeAsssembler);

  sprintf(lineaDeAsssembler, "%s:\n", crearEtiqueta("ETIQUETA_FIN_CONDICION_",charComparacionLocal));
  agregar(&listaCodigo,lineaDeAsssembler);

  numeroComparacion++;
  return variableAuxiliar;
}

char* procesarCondicionCompuesta(char* comparador, char* resultado1, char* resultado2) {
  char* variableResultado = proximaVariableAuxiliarAssembler(VARIABLE_ENTERO);

  sprintf(lineaDeAsssembler, "MOV eax, %s\n", resultado1);
  agregar(&listaCodigo,lineaDeAsssembler);

  sprintf(lineaDeAsssembler, "%s eax, %s\n", comparador, resultado2);
  agregar(&listaCodigo,lineaDeAsssembler);

  sprintf(lineaDeAsssembler, "MOV %s, eax\n", variableResultado);
  agregar(&listaCodigo,lineaDeAsssembler);

  return variableResultado;
}

void negarCondicion(char* resultado) {
  //TODO
}

char* crearEtiqueta(char* etiqueta, char* numero) {
  char* texto = (char*)malloc(100);
  strcpy(texto, etiqueta);
  strcat(texto, numero);
  return texto;
}

void procesarResultadoCondicion(char* variableResultado) {
  sprintf(lineaDeAsssembler, "MOV eax, %s\n", variableResultado);
  agregar(&listaCodigo,lineaDeAsssembler);

  sprintf(lineaDeAsssembler, "CMP eax, 0\n");
  agregar(&listaCodigo,lineaDeAsssembler);
}

void preguntarPorFalso(char* variableResultado) {
  sprintf(lineaDeAsssembler, "MOV eax, %s\n", variableResultado);
  agregar(&listaCodigo,lineaDeAsssembler);

  sprintf(lineaDeAsssembler, "CMP eax, 1\n");
  agregar(&listaCodigo,lineaDeAsssembler);
}

void procesarSaltoFinIf(int numeroIfLocal) {
  char numeroSalto[10];
  itoa(numeroIfLocal, numeroSalto, 10);

  sprintf(lineaDeAsssembler, "JE %s\n", crearEtiqueta("FIN_IF_", numeroSalto));
  agregar(&listaCodigo,lineaDeAsssembler);
}

void procesarFinIf(int numeroIfLocal) {
  char numeroSalto[10];
  itoa(numeroIfLocal, numeroSalto, 10);

  sprintf(lineaDeAsssembler, "%s:\n", crearEtiqueta("FIN_IF_", numeroSalto));
  agregar(&listaCodigo,lineaDeAsssembler);
}

int esIfElse(tipoNodoArbol* subarbol) {
  if(strcmp(subarbol->hijoDerecho->valor, "CUERPO_IF") == 0) {
    return 1;
  } else {
    return 0;
  }
}

void procesarSaltoElse(int numeroIfLocal) {
  char numeroSalto[10];
  itoa(numeroIfLocal, numeroSalto, 10);

  sprintf(lineaDeAsssembler, "JE %s\n", crearEtiqueta("ELSE_", numeroSalto));
  agregar(&listaCodigo,lineaDeAsssembler);
}

void procesarElse(int numeroIfLocal) {
  char numeroSalto[10];
  itoa(numeroIfLocal, numeroSalto, 10);

  sprintf(lineaDeAsssembler, "%s:\n", crearEtiqueta("ELSE_", numeroSalto));
  agregar(&listaCodigo,lineaDeAsssembler);
}

char* escribirAsemblerWhile(tipoNodoArbol* subarbol) {
  char* variableResultadoCondicion = NULL;
  int numeroWhileLocal = numeroWhile;
  char charNumeroWhileLocal[5];
  itoa(numeroWhileLocal, charNumeroWhileLocal, 10);
  int esCicloEspecial = strcmp(subarbol->hijoIzquierdo->valor, "IN") == 0;

  procesarEtiquetaWhile(charNumeroWhileLocal);
  //TODO refactorizar, uno pregunta por V y otro por F, debería ser homogéneo.
  if(!esCicloEspecial) {
    variableResultadoCondicion = procesarCondicion(subarbol->hijoIzquierdo);
    procesarResultadoCondicion(variableResultadoCondicion); //solo hace la comparación, pregunta por falso
    procesarSaltoFinWhile(numeroWhileLocal);
  } else {
    variableResultadoCondicion= procesarAsemblerIn(subarbol->hijoIzquierdo, charNumeroWhileLocal);
    procesarSaltoFinCicloEspecial(numeroWhileLocal);
  }
  procesarEtiquetaCondicionVerdaderaWhile(charNumeroWhileLocal);
  procesarCodigoIntermedio(subarbol->hijoDerecho);
  procesarSaltoWhile(charNumeroWhileLocal);
  procesarFinWhile(numeroWhileLocal);
  numeroWhile++;
  return NULL;
}

void procesarSaltoFinWhile(int numeroIfLocal) {
  char numeroSalto[10];
  itoa(numeroIfLocal, numeroSalto, 10);

  sprintf(lineaDeAsssembler, "JE %s\n", crearEtiqueta("FIN_WHILE_", numeroSalto));
  agregar(&listaCodigo,lineaDeAsssembler);
}

void procesarSaltoFinCicloEspecial(int numeroIfLocal) {
  //TODO se puede refactorizar
  char numeroSalto[10];
  itoa(numeroIfLocal, numeroSalto, 10);

  sprintf(lineaDeAsssembler, "JMP %s\n", crearEtiqueta("FIN_WHILE_", numeroSalto));
  agregar(&listaCodigo,lineaDeAsssembler);
}

void procesarFinWhile(int numeroIfLocal) {
  char numeroSalto[10];
  itoa(numeroIfLocal, numeroSalto, 10);

  sprintf(lineaDeAsssembler, "%s:\n", crearEtiqueta("FIN_WHILE_", numeroSalto));
  agregar(&listaCodigo,lineaDeAsssembler);
}

void procesarEtiquetaWhile(char* charNumeroWhileLocal) {
  sprintf(lineaDeAsssembler, "%s:\n", crearEtiqueta("WHILE_", charNumeroWhileLocal));
  agregar(&listaCodigo,lineaDeAsssembler);
}

void procesarSaltoWhile(char* charNumeroWhileLocal) {
  sprintf(lineaDeAsssembler, "JMP %s\n", crearEtiqueta("WHILE_", charNumeroWhileLocal));
  agregar(&listaCodigo,lineaDeAsssembler);
}

char* procesarAsemblerIn(tipoNodoArbol* subarbol, char* charNumeroWhileLocal) {
  char* variableResultado = NULL;
  char* resultadoExpresion = NULL;
  tipoNodoArbol* subarbolExpresion = obtenerSiguienteExpresionDeLista(subarbol->hijoDerecho);


  while(subarbolExpresion != NULL) {
    cargarSimbolo(subarbol->hijoIzquierdo->valor);
    resultadoExpresion = procesarExpresion(subarbolExpresion);
    cargarSimbolo(resultadoExpresion);
    procesarComparacion();
    variableResultado = procesarComparador("=");
    preguntarPorFalso(variableResultado);
    procesarSaltoCondicionVerdaderaWhile(charNumeroWhileLocal);
    autoeliminarHijo(subarbolExpresion);
    subarbolExpresion = obtenerSiguienteExpresionDeLista(subarbol->hijoDerecho);
  }
  return NULL;
}

void procesarSaltoCondicionVerdaderaWhile(char* charNumeroWhileLocal) {
  sprintf(lineaDeAsssembler, "JE %s\n", crearEtiqueta("WHILE_VERDADERO_", charNumeroWhileLocal));
  agregar(&listaCodigo,lineaDeAsssembler);
}

void procesarEtiquetaCondicionVerdaderaWhile(char* charNumeroWhileLocal) {
  sprintf(lineaDeAsssembler, "%s:\n", crearEtiqueta("WHILE_VERDADERO_", charNumeroWhileLocal));
  agregar(&listaCodigo,lineaDeAsssembler);
}

char* procesarExpresion(tipoNodoArbol* arbol) {
  char* resultadoCodigoIntermedio = NULL;

  if(obtenerOperador(arbol->valor) < 0) {
    return arbol->valor;
  } else {
    return procesarCodigoIntermedio(arbol);
  }
}

void autoeliminarHijo(tipoNodoArbol* subarbol) {
  if(subarbol->padre != NULL) {
    if(subarbol->padre->hijoIzquierdo == subarbol) {
      subarbol->padre->hijoIzquierdo = NULL;
    }
    else {
      subarbol->padre->hijoDerecho = NULL;
    }
  }
}