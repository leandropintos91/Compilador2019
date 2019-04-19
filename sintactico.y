
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
%%
programa : while {printf("Compilación OK\n");};

while: WHILE {printf("Reconocí WHILE\n");} 
        ID {printf("Reconocí ID\n");} 
        IN {printf("Reconocí IN\n");} 
        lista_expresiones DO sentencias ENDWHILE;

lista_expresiones: LISTAEXPRESIONES;

sentencias: SENTENCIAS;

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