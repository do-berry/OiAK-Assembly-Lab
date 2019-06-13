main: main.o Factorial.o
	ld main.o Factorial.o -o main -m elf_i386

main.o: main.s Factorial.h
	as main.s -o main.o --32

Factorial.o: Factorial.c Factorial.h
	gcc -c -O0 Factorial.c -o Factorial.o -m32

clean:
	rm *.o
