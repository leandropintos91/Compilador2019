
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

%start programa

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
ENDIF
OPERADOR_AND
OPERADOR_OR
OPERADOR_NOT
OPERADOR_MAYOR_A
OPERADOR_MENOR_A
OPERADOR_MAYOR_O_IGUAL_A
OPERADOR_MENOR_O_IGUAL_A
OPERADOR_MAYOR
OPERADOR_IGUAL_A
OPERADOR_DISTINTO_A
DEFVAR
ENDDEF
DOS_PUNTOS
PUNTO_Y_COMA
TIPO_ENTERO
TIPO_REAL
TIPO_CADENA

%%
programa : definicion_variables lista_sentencias {printf("Compilación OK\n");};

definicion_variables: DEFVAR lista_definiciones ENDDEF;

lista_definiciones: lista_definiciones definicion | definicion;

definicion: tipo_variable DOS_PUNTOS lista_ids;

lista_ids: 
  lista_ids PUNTO_Y_COMA ID 
    {
      printf("%s\n", yylval.str_val);
      guardarIDEnTablaDeSimbolos(yylval.str_val);
    }
  | ID
    {
      printf("%s\n", yylval.str_val);
      guardarIDEnTablaDeSimbolos(yylval.str_val);
    }

tipo_variable: 
  TIPO_ENTERO 
    {
      guardarTipo("ENTERO");
    }
  | TIPO_REAL 
    {
      guardarTipo("REAL");
    }
  | TIPO_CADENA
    {
      guardarTipo("CADENA");
    }

ciclo_especial: WHILE {printf("WHILE OK\n");} 
        ID {printf("Reconocí ID\n");} 
        IN {printf("Reconocí IN\n");} 
        lista_expresiones {printf("Reconocí lista_expresiones\n");} 
        DO {printf("Reconocí DO\n");} lista_sentencias ENDWHILE {printf("Ciclo Especial OK\n");};

lista_sentencias: lista_sentencias sentencia | sentencia;

sentencia: asignacion | expresion | entrada | salida | ciclo_especial | decision | iteracion;

asignacion: ID {printf("ID %s en asignacion\n", yylval.str_val);} OPERADOR_ASIGNACION asignable;

asignable: 
  expresion 
  | cadena;

cadena: CADENA
  {
      guardarCadenaEnTablaDeSimbolos(yylval.str_val);
  };

lista_expresiones:  lista_expresiones COMA expresion
  | expresion;

decision: OPERADOR_IF evaluable THEN lista_sentencias ENDIF;

evaluable: PARENTESIS_ABIERTO condicion PARENTESIS_CERRADO;

condicion: condicion_simple | condicion_compuesta;

condicion_compuesta: condicion_simple OPERADOR_AND condicion_simple
  | condicion_simple OPERADOR_OR condicion_simple
  | OPERADOR_NOT PARENTESIS_ABIERTO condicion_simple PARENTESIS_CERRADO;

condicion_simple: expresion comparador expresion;

comparador: OPERADOR_MAYOR_A
  | OPERADOR_MENOR_A
  | OPERADOR_MAYOR_O_IGUAL_A
  | OPERADOR_MENOR_O_IGUAL_A
  | OPERADOR_MAYOR
  | OPERADOR_IGUAL_A
  | OPERADOR_DISTINTO_A;

iteracion: WHILE evaluable THEN lista_sentencias ENDWHILE;

entrada: OPERADOR_ENTRADA ID;

salida: OPERADOR_SALIDA ID | OPERADOR_SALIDA cadena;

expresion:
  termino
  |expresion OPERACION_RESTA termino
    {
      printf("Resta OK\n");
    }
  |expresion OPERACION_SUMA termino
    {
      printf("Suma OK\n");
    };

termino: 
  factor
  |termino OPERACION_MULTIPLICACION factor  
    {
      printf("Multiplicación OK\n");
    }
  |termino OPERACION_DIVISION factor  
    {
    - printf("División OK\n");
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
  |PARENTESIS_ABIERTO expresion PARENTESIS_CERRADO;

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
      if ((archivoTablaDeSimbolos = fopen ("TablaDeSimbolos.txt","w"))== NULL)
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
    printf("Syntax Error\n");
    system ("Pause");
    exit (1);
 }

void mostrarError(char *mensaje) {
  printf("ERROR!!!: %s\n", mensaje);
  exit(1);
}

void guardarIDEnTablaDeSimbolos(char* token)
{
  char nombreToken[100];
  strcpy(nombreToken, "_");
  strcat(nombreToken, token);
  if(!existeTokenEnTablaDeSimbolos(nombreToken))
  {
    strcpy(tablaDeSimbolos[cantidadTokens].nombre, nombreToken);
    strcpy(tablaDeSimbolos[cantidadTokens].tipo,"ID" );
    strcpy(tablaDeSimbolos[cantidadTokens].valor, nombreToken);
    tablaDeSimbolos[cantidadTokens].longitud = strlen(token);
    cantidadTokens++;
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
    strcpy(tablaDeSimbolos[cantidadTokens].tipo,"CADENA" );
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
    strcpy(tablaDeSimbolos[cantidadTokens].tipo,"ENTERO");
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
    strcpy(tablaDeSimbolos[cantidadTokens].tipo,"REAL");
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

