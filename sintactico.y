
%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
#include <string.h>
int yystopparser=0;
FILE  *yyin;
char *yyltext;
char *yytext;
FILE *archivoTablaDeSimbolos;

int cantidadTokens = 0; 

// TABLA SIMBOLOS
typedef struct
{
    char nombre[100];
    char tipo  [11];
    char valor [100];
    int longitud;
} struct_tabla_de_simbolos;

struct_tabla_de_simbolos tablaDeSimbolos[200];
char tipoVariableActual[20];

int yylex();
int yyerror();

void mostrarError(char *mensaje);
void guardarTipo(char * tipoVariable);
int existeCadenaEnTablaDeSimbolos(char* valor);
int existeTokenEnTablaDeSimbolos(char* nombre);
void guardarTablaDeSimbolos();
void guardarEnteroEnTablaDeSimbolos(int token);
void guardarCadenaEnTablaDeSimbolos(char* token);
void guardarIDEnTablaDeSimbolos(char* token);
void guardarRealEnTablaDeSimbolos(double token);

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
start_programa : programa {printf("Compilación OK\n");};
programa : definicion_variables lista_sentencias {printf("Programa OK\n");};

definicion_variables: DEFVAR lista_definiciones ENDDEF {printf("definicion_variables OK\n");};

lista_definiciones: lista_definiciones definicion {printf("definicion en lista_definiciones OK\n");} | definicion {printf("lista_definiciones OK\n");};

definicion: tipo_variable DOS_PUNTOS lista_ids {printf("definicion OK\n");};

lista_ids: 
  lista_ids PUNTO_Y_COMA ID 
    {
      printf("%s\n", yylval.str_val);
      guardarIDEnTablaDeSimbolos(yylval.str_val);
      printf("ID en lista_ids OK\n");
    }
  | ID
    {
      printf("%s\n", yylval.str_val);
      guardarIDEnTablaDeSimbolos(yylval.str_val);
      printf("ID en lista_ids OK\n");
    }

tipo_variable: 
  TIPO_ENTERO 
    {
      guardarTipo("ENTERO");
      printf("TIPO_ENTERO en tipo_variable OK\n");
    }
  | TIPO_REAL 
    {
      guardarTipo("REAL");
      printf("TIPO_REAL en tipo_variable OK\n");
    }
  | TIPO_CADENA
    {
      guardarTipo("CADENA");
      printf("TIPO_CADENA en tipo_variable OK\n");
    }

ciclo_especial: WHILE ID IN lista_expresiones DO lista_sentencias ENDWHILE {printf("ciclo_especial OK\n");};

lista_sentencias: lista_sentencias sentencia {printf("lista_sentencias OK\n");} | sentencia {printf("lista_sentencias OK\n");};

sentencia: 
  asignacion {printf("asignacion en sentencia OK\n");} 
  | expresion {printf("expresion en sentencia OK\n");}
  | entrada {printf("entrada en sentencia OK\n");}
  | salida {printf("salida en sentencia OK\n");}
  | ciclo_especial {printf("ciclo_especial en sentencia OK\n");}
  | decision {printf("decision en sentencia OK\n");}
  | iteracion {printf("iteracion en sentencia OK\n");};

fibonacci: FIBONACCI PARENTESIS_ABIERTO expresion PARENTESIS_CERRADO {printf("FIBONACCI OK\n");};

asignacion: ID {printf("ID %s en asignacion\n", yylval.str_val);} OPERADOR_ASIGNACION asignable {printf("asignacion OK\n");};

asignable: 
  expresion {printf("expresion en asignable OK\n");}
  | cadena {printf("cadena en asignable OK\n");};

cadena: CADENA
  {
      guardarCadenaEnTablaDeSimbolos(yylval.str_val);
      printf("cadena OK\n");
  };

lista_expresiones:  lista_expresiones COMA expresion {printf("lista_expresiones OK\n");}
  | expresion {printf("lista_expresiones OK\n");};

decision: 
  OPERADOR_IF evaluable THEN lista_sentencias ENDIF {printf("decision OK\n");}
  | OPERADOR_IF evaluable THEN lista_sentencias ELSE lista_sentencias ENDIF {printf("decision OK\n");};

evaluable: PARENTESIS_ABIERTO condicion PARENTESIS_CERRADO {printf("evaluable OK\n");};

condicion: condicion_simple {printf("condicion OK\n");}; | condicion_compuesta {printf("condicion OK\n");};

condicion_compuesta: condicion_simple OPERADOR_AND condicion_simple {printf("condicion AND en condicion_compuesta OK\n");}
  | condicion_simple OPERADOR_OR condicion_simple {printf("condicion OR en condicion_compuesta OK\n");}
  | OPERADOR_NOT PARENTESIS_ABIERTO condicion_simple PARENTESIS_CERRADO {printf("condicion NOT condicion_compuesta OK\n");};

condicion_simple: expresion comparador expresion {printf("condicion_simple OK\n");};;

comparador: OPERADOR_MAYOR_A {printf("comparador MAYOR A OK\n");}
  | OPERADOR_MENOR_A {printf("comparador MENOR A OK\n");}
  | OPERADOR_MAYOR_O_IGUAL_A {printf("comparador MAYOR O IGUAL A OK\n");}
  | OPERADOR_MENOR_O_IGUAL_A {printf("comparador MENOR O IGUAL A OK\n");}
  | OPERADOR_IGUAL_A {printf("comparador IGUAL A OK\n");}
  | OPERADOR_DISTINTO_A {printf("comparador DISTINTO A OK\n");};

iteracion: WHILE evaluable THEN lista_sentencias ENDWHILE {printf("iteracion OK\n");};

entrada: OPERADOR_ENTRADA ID {printf("entrada OK\n");};

salida: OPERADOR_SALIDA ID {printf("salida OK\n");} | OPERADOR_SALIDA cadena {printf("salida OK\n");};

expresion:
  termino
  |expresion OPERACION_RESTA termino
    {
      printf("Resta en expresion OK\n");
    }
  |expresion OPERACION_SUMA termino
    {
      printf("Suma en expresion OK\n");
    };

termino: 
  factor
  |termino OPERACION_MULTIPLICACION factor  
    {
      printf("Multiplicación en termino OK\n");
    }
  |termino OPERACION_DIVISION factor  
    {
    - printf("División en termino OK\n");
    };

factor: 
  ID
    {
      printf(" ID %s \n",yylval.str_val);
      printf("ID en FACTOR es: %s \n", yylval.str_val);
    }
  | ENTERO 
    {
      printf("ENTERO en FACTOR es: %d \n", $<int_val>$);
      guardarEnteroEnTablaDeSimbolos($<int_val>$);
    }
  | REAL 
    {
      printf("REAL en FACTOR es: %f \n", $<float_val>$);
      guardarRealEnTablaDeSimbolos($<float_val>$);
    }
  |PARENTESIS_ABIERTO expresion PARENTESIS_CERRADO
  | fibonacci;

%%






int main(int argc,char *argv[])
{
  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	   printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
  }
  else
  {
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

void guardarIDEnTablaDeSimbolos(char* token)
{
  char mensajeError[200];
  char nombreToken[100];
  strcpy(nombreToken, token);
  if(!existeTokenEnTablaDeSimbolos(nombreToken))
  {
    strcpy(tablaDeSimbolos[cantidadTokens].nombre, nombreToken);
    strcpy(tablaDeSimbolos[cantidadTokens].tipo,tipoVariableActual );
    cantidadTokens++;
  } else {
    sprintf(mensajeError, "El ID %s está duplicado.", token);
    mostrarError(mensajeError);
  }
}

void guardarCadenaEnTablaDeSimbolos(char* token)
{
  char nombreToken[100];
  strcpy(nombreToken,"_");
  strcat(nombreToken, "cadena");
  char numeroCadena[5];
  itoa(cantidadTokens, numeroCadena,10);
  strcat(nombreToken, numeroCadena);
  if(!existeCadenaEnTablaDeSimbolos(token))
  {
    strcpy(tablaDeSimbolos[cantidadTokens].nombre, nombreToken);
    strcpy(tablaDeSimbolos[cantidadTokens].tipo,"CTE_CADENA" );
    strcpy(tablaDeSimbolos[cantidadTokens].valor, token);
    tablaDeSimbolos[cantidadTokens].longitud = (strlen(token));
    cantidadTokens++;
  }
}

void guardarEnteroEnTablaDeSimbolos(int token)
{     
  char nombreToken[100];
  char nombreEntero[20];
  sprintf(nombreEntero, "%d", token);
  strcpy(nombreToken,"_");
  strcat(nombreToken, nombreEntero);
  if(!existeTokenEnTablaDeSimbolos(nombreToken))
  {
    strcpy(tablaDeSimbolos[cantidadTokens].nombre, nombreToken);
    strcpy(tablaDeSimbolos[cantidadTokens].tipo,"CTE_ENTERO");
    strcpy(tablaDeSimbolos[cantidadTokens].valor, nombreEntero);
    cantidadTokens++;
  }
}

void guardarRealEnTablaDeSimbolos(double token)
{     
  char nombreToken[100];
  char nombreReal[20];
  sprintf(nombreReal, "%lf", token);
  strcpy(nombreToken,"_");
  strcat(nombreToken, nombreReal);
  if(!existeTokenEnTablaDeSimbolos(nombreToken))
  {
    strcpy(tablaDeSimbolos[cantidadTokens].nombre, nombreToken);
    strcpy(tablaDeSimbolos[cantidadTokens].tipo,"CTE_REAL");
    strcpy(tablaDeSimbolos[cantidadTokens].valor, nombreReal);
    cantidadTokens++;
  }
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
      "Nombre: %s  | Tipo: %s   | Valor: %s | Longitud: %s \n",
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

void guardarTipo(char * tipoVariable) {
  strcpy(tipoVariableActual, tipoVariable);
}

