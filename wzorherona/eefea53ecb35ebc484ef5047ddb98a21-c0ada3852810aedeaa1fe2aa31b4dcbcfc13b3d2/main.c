#include <stdio.h>
#include <stdlib.h>

// wzor Herona dla podwojnej precyzji
extern double heron(double a, double b, double c);

int main(int argc, char * argv[]) {
  double a = atof(argv[1]);
  double b = atof(argv[2]);
  double c = atof(argv[3]);

  printf("Boki trojkata: %lf, %lf, %lf\n", a, b, c);
  printf("Jego pole wynosi: %lf\n", heron(a, b, c));
}
