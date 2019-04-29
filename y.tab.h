
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     COMENTARIOS = 258,
     COMENTARIOS_ANIDADOS = 259,
     WHILE = 260,
     ENDWHILE = 261,
     IN = 262,
     DO = 263,
     ID = 264,
     OPERACION_SUMA = 265,
     OPERACION_RESTA = 266,
     OPERACION_MULTIPLICACION = 267,
     OPERACION_DIVISION = 268,
     ENTERO = 269,
     REAL = 270,
     PARENTESIS_ABIERTO = 271,
     PARENTESIS_CERRADO = 272,
     COMA = 273,
     OPERADOR_ASIGNACION = 274,
     CADENA = 275,
     OPERADOR_ENTRADA = 276,
     OPERADOR_SALIDA = 277,
     OPERADOR_IF = 278,
     THEN = 279,
     ELSE = 280,
     ENDIF = 281,
     OPERADOR_AND = 282,
     OPERADOR_OR = 283,
     OPERADOR_NOT = 284,
     OPERADOR_MAYOR_A = 285,
     OPERADOR_MENOR_A = 286,
     OPERADOR_MAYOR_O_IGUAL_A = 287,
     OPERADOR_MENOR_O_IGUAL_A = 288,
     OPERADOR_MAYOR = 289,
     OPERADOR_IGUAL_A = 290,
     OPERADOR_DISTINTO_A = 291,
     DEFVAR = 292,
     ENDDEF = 293,
     DOS_PUNTOS = 294,
     PUNTO_Y_COMA = 295,
     TIPO_ENTERO = 296,
     TIPO_REAL = 297,
     TIPO_CADENA = 298
   };
#endif
/* Tokens.  */
#define COMENTARIOS 258
#define COMENTARIOS_ANIDADOS 259
#define WHILE 260
#define ENDWHILE 261
#define IN 262
#define DO 263
#define ID 264
#define OPERACION_SUMA 265
#define OPERACION_RESTA 266
#define OPERACION_MULTIPLICACION 267
#define OPERACION_DIVISION 268
#define ENTERO 269
#define REAL 270
#define PARENTESIS_ABIERTO 271
#define PARENTESIS_CERRADO 272
#define COMA 273
#define OPERADOR_ASIGNACION 274
#define CADENA 275
#define OPERADOR_ENTRADA 276
#define OPERADOR_SALIDA 277
#define OPERADOR_IF 278
#define THEN 279
#define ELSE 280
#define ENDIF 281
#define OPERADOR_AND 282
#define OPERADOR_OR 283
#define OPERADOR_NOT 284
#define OPERADOR_MAYOR_A 285
#define OPERADOR_MENOR_A 286
#define OPERADOR_MAYOR_O_IGUAL_A 287
#define OPERADOR_MENOR_O_IGUAL_A 288
#define OPERADOR_MAYOR 289
#define OPERADOR_IGUAL_A 290
#define OPERADOR_DISTINTO_A 291
#define DEFVAR 292
#define ENDDEF 293
#define DOS_PUNTOS 294
#define PUNTO_Y_COMA 295
#define TIPO_ENTERO 296
#define TIPO_REAL 297
#define TIPO_CADENA 298




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 43 "sintactico.y"

int int_val;
double float_val;
char *str_val;



/* Line 1676 of yacc.c  */
#line 146 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


