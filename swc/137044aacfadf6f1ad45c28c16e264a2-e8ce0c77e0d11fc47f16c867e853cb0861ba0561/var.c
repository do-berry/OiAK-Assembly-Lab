#include <stdio.h>
#include <stdlib.h>
extern int funAsm();                                      // function from .s
extern int varAsm;                                         // variable from .s

void funC() {
  int result = funAsm(varAsm);
  printf("%d ^ 2 = %d", varAsm, result);
}

int main() {
  funC();
  return 0;
}
