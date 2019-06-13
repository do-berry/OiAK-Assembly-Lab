// inline assembly
#include <stdio.h>
#include <stdlib.h>

int add(int x, int y) {
  int result;
  __asm__ __volatile__ (                                  // volatile: to execute where it's put
    "addl %%eax, %%ebx\n"                                 // ebx += eax
    : "=b" (result)                                       // return: b (ebx) = result; optional
    : "a" (x), "b" (y)                                    // args: a (eax) = x, b (ebx) = y; optional
    // no clobbered registers list, cuz it's optional too
  );
}

int main(int argc, char * argv[]) {
  int x = atoi(argv[1]);
  int y = atoi(argv[2]);

  printf("Result is %d", add(x,y));

  return 0;
}

// compiled with: gcc program.c -o program and works
