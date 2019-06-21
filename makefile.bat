flex lexico.l
pause
bison -dyv sintactico.y
pause
gcc.exe lex.yy.c y.tab.c arbol.h arbol.c pilaDeArbol.h pilaDeArbol.c lista.h lista.c -o Primera.exe
pause
pause
Primera.exe prueba.txt
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
del primera.exe
pause
