%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "y.tab.h"

#define LIMITE_REAL 2147483647
#define LIMITE_ENTERO 32768
#define LIMITE_CADENA 30
#define LIMITE_ID 30

int validarLongitudId();
int validarLongitudReal();
int validarLongitudEntero();
int validarLongitudCadena();
void mostrarError(char*);
void quitarComillas();

FILE  *yyin;
char auxS[100];

%}
%option noyywrap  
%option yylineno 


DIGITO					[0-9]
LETRA					[a-zA-Z]
COMENTARIOS				\*\/([^"\/\-"|"\-\/"]|\n)*\/\*
COMENTARIOS_ANIDADOS	\*\/([^"\/\-"|"\-\/"]|\n)*{COMENTARIOS}*([^"\/\-"|"\-\/"]|\n)*\/\*
ID						{LETRA}({LETRA}|{DIGITO}|_)*
REAL					(\-)?({DIGITO}*"."{DIGITO}+|{DIGITO}+".")
ENTERO					(\-)?{DIGITO}+
CADENA					\"[^"\n]*\"

%%

{COMENTARIOS}				{}
{COMENTARIOS_ANIDADOS}		{}

"WHILE"   					{return WHILE;}
"ENDWHILE"					{return ENDWHILE;}
"IN"						{return IN;}
"DO"						{return DO;}
"+"							{return OPERACION_SUMA;}
"-"							{return OPERACION_RESTA;}
"*"							{return OPERACION_MULTIPLICACION;}
"/"							{return OPERACION_DIVISION;}
"\("						{return PARENTESIS_ABIERTO;}
"\)"						{return PARENTESIS_CERRADO;}
","							{return COMA;}
":="						{return OPERADOR_ASIGNACION;}
"GET"						{return OPERADOR_ENTRADA;}
"DISPLAY"					{return OPERADOR_SALIDA;}
"IF"						{return OPERADOR_IF;}
"THEN"						{return THEN;}
"ELSE"						{return ELSE;}
"ENDIF"						{return ENDIF;}
"AND"						{return OPERADOR_AND;}
"OR"						{return OPERADOR_OR;}
"NOT"						{return OPERADOR_NOT;}
">"							{return OPERADOR_MAYOR_A;}
"<"							{return OPERADOR_MENOR_A;}
">="						{return OPERADOR_MAYOR_O_IGUAL_A;}
"<="						{return OPERADOR_MENOR_O_IGUAL_A;}
"="							{return OPERADOR_IGUAL_A;}
"!="						{return OPERADOR_DISTINTO_A;}
"DEFVAR"					{return DEFVAR;}
"ENDDEF"					{return ENDDEF;}
";"							{return PUNTO_Y_COMA;}
":"							{return DOS_PUNTOS;}
"FLOAT"						{return TIPO_REAL;}
"STRING"					{return TIPO_CADENA;}
"INT"						{return TIPO_ENTERO;}

{ID}					{	sprintf(auxS,"%s", yytext);
							if(validarLongitudId() == 0) 
				 				mostrarError(yytext);
							yylval.str_val=auxS;
							return ID;
						}

{ENTERO}				{ 	if(validarLongitudEntero() == 0) 
				 				mostrarError(yytext);
				 			sscanf(yytext,"%d",&(yylval.int_val));
							return ENTERO;
						}

{REAL}					{	if(validarLongitudReal() == 0) 
				 				mostrarError(yytext);
				 			sscanf(yytext,"%lf",&(yylval.float_val));
							return REAL;
						}

{CADENA} 				{	if(validarLongitudCadena() == 0)
				 				mostrarError(yytext);
							sprintf(auxS,"%s", yytext);
							quitarComillas();
							yylval.str_val=auxS; 
							return CADENA;
						}

"\n"      		
"\r"
"\r\n"
"\t"
" "


.    					{
							printf("Caracter invalido!");
							exit(1);
						}

%%

int validarLongitudId(){
	if(strlen(yytext) <= LIMITE_ID)
		return 1;
	return 0;
}

int validarLongitudReal(){
	int real;
	sscanf(yytext,"%lf",&real);
	if(real >= -LIMITE_REAL && real <= LIMITE_REAL-1)
		return 1;
	return 0;
}

int validarLongitudEntero(){
	int entero;
	sscanf(yytext,"%d",&entero);
	if(entero >= -LIMITE_ENTERO && entero <= LIMITE_ENTERO-1)
		return 1;
	return 0;
}

int validarLongitudCadena(){
	if((strlen(yytext) - 2) <= LIMITE_CADENA) 
		return 1;
	return 0;
}

void quitarComillas() {
	int i = 0;
	while(auxS[i+1] != '\"') {
		auxS[i] = auxS[i+1];
		i++;
	}
	auxS[i] = '\0';
}