OBJS = lex.yy.o main.o util.o y.tab.o
CFLAGS = -lfl -I./ -I./YACC
CC = gcc
tiny_plus:$(OBJS)
	$(CC) $(OBJS) -o tiny_plus $(CFLAGS)

lex.yy.o:globals.h util.h
	flex ./LEX/TINY.L
	$(CC) -c lex.yy.c $(CFLAGS)

main.o:globals.h scan.h util.h
	$(CC) -c main.c

util.o:util.h
	$(CC) -c util.c

y.tab.o:
	yacc -d -v ./YACC/TINY.Y
	$(CC) -c y.tab.c $(CFLAGS)

.phony:clean
clean:
	-rm y.tab.c
	-rm y.tab.h
	-rm y.output
	-rm lex.yy.c
	-rm -rf $(OBJS)