
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
WHILE ENDWHILE 
IN 
VARIABLE 
LISTAEXPRESIONES 
SENTENCIAS 
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


%%
programa : while {printf("Compilación OK\n");};

while: WHILE {printf("Reconocí WHILE\n");} 
        ID {printf("Reconocí ID\n");} 
        IN {printf("Reconocí IN\n");} 
        lista_expresiones DO sentencias ENDWHILE;

sentencias: SENTENCIAS;

lista_expresiones:  lista_expresiones COMA expresion
  | expresion;

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