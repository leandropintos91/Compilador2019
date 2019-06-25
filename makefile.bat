flex lexico.l
pause
bison -dyv sintactico.y
pause
gcc.exe lex.yy.c y.tab.c arbol.h arbol.c pilaDeArbol.h pilaDeArbol.c lista.h lista.c -o Grupo03.exe
pause
pause
Grupo03.exe prueba.txt
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
pause
