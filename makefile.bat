flex lexico.l
pause
bison -dyv sintactico.y
pause
gcc.exe lex.yy.c y.tab.c -o ejecutable.exe
pause
pause
ejecutable.exe prueba.txt
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
del TPFinal.exe
pause
