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

%%

{COMENTARIOS}			{return COMENTARIOS;}
{COMENTARIOS_ANIDADOS}	{return COMENTARIOS_ANIDADOS;}

"WHILE"   				{return WHILE;}
"ENDWHILE"				{return ENDWHILE;}
"IN"					{return IN;}
"sentencias"			{return SENTENCIAS;}
"listaexpresiones"		{return LISTAEXPRESIONES;}
"DO"					{return DO;}
"+"						{return OPERACION_SUMA;}
"-"						{return OPERACION_RESTA;}
"*"						{return OPERACION_MULTIPLICACION;}
"/"						{return OPERACION_DIVISION;}
"\("					{return PARENTESIS_ABIERTO;}
"\)"					{return PARENTESIS_CERRADO;}
","						{return COMA;}

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

"\n"      		
"\r"
"\r\n"
"\t"
" "

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