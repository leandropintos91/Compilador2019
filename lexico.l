%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "y.tab.h"

#define LIM_ID 30

int validarLongitud(int);

FILE  *yyin;
char auxS[100];

%}
%option noyywrap  
%option yylineno 


DIGITO					[0-9]
LETRA					[a-zA-Z]
COMENTARIOS				\-\/([^"\/\-"|"\-\/"]|\n)*\/\-
COMENTARIOS_ANIDADOS	\-\/([^"\/\-"|"\-\/"]|\n)*{COMENTARIOS}*([^"\/\-"|"\-\/"]|\n)*\/\-
ID						{LETRA}({LETRA}|{DIGITO}|_)*

%%

{COMENTARIOS}			{return COMENTARIOS;}
{COMENTARIOS_ANIDADOS}	{return COMENTARIOS_ANIDADOS;}

"WHILE"   				{return WHILE;}
"ENDWHILE"				{return ENDWHILE;}
"IN"					{return IN;}
"sentencias"				{return SENTENCIAS;}
"listaexpresiones"				{return LISTAEXPRESIONES;}
"DO"					{return DO;}

{ID}		{	sprintf(auxS,"%s", yytext);
				if(validarLongitud(ID) == 0) 
	 				mostrarError(yytext);
				yylval.str_val=auxS;
				return ID;
			}

"\n"      		
"\r"
"\r\n"
"\t"
" "

%%

int validarLongitud(int tipo){
	int entero;
	int real;
	switch(tipo){
		case ID:
			if(strlen(yytext) <= LIM_ID)
				return 1;
			return 0;
			break;
	}
	return 0;
}
