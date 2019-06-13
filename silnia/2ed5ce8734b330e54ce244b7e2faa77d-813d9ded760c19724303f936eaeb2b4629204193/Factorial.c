#include "Factorial.h"

int xFactorial(int x) {
  int result = 1;
  if (x > 0) {
    for (int i = 1; i <= x; i++) {
      result *= i;
    }
  } else {
    return -1;
  }
  return result;
}
