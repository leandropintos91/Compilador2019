
%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
int yystopparser=0;
FILE  *yyin;
char *yyltext;
char *yytext;

int yylex();
int yyerror();

void mostrarError(char *);

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

lista_ids: lista_ids PUNTO_Y_COMA ID | ID;

tipo_variable: TIPO_ENTERO | TIPO_REAL | TIPO_CADENA;

ciclo_especial: WHILE {printf("WHILE OK\n");} 
        ID {printf("Reconocí ID\n");} 
        IN {printf("Reconocí IN\n");} 
        lista_expresiones {printf("Reconocí lista_expresiones\n");} 
        DO {printf("Reconocí DO\n");} lista_sentencias ENDWHILE {printf("Ciclo Especial OK\n");};

lista_sentencias: lista_sentencias sentencia | sentencia;

sentencia: asignacion | expresion | entrada | salida | ciclo_especial | decision | iteracion;

asignacion: ID {printf("ID %s en asignacion\n", $<str_val>$);} OPERADOR_ASIGNACION asignable;

asignable: expresion | CADENA;

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

salida: OPERADOR_SALIDA ID | OPERADOR_SALIDA CADENA;

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
      printf(" ID %s \n",$<str_val>$);
      printf("ID en FACTOR es: %s \n", $<str_val>$);
    }
  | ENTERO 
    {
      printf("ENTERO en FACTOR es: %d \n", $<int_val>$);
    }
  | REAL 
    {
      printf("REAL en FACTOR es: %f \n", $<float_val>$);
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