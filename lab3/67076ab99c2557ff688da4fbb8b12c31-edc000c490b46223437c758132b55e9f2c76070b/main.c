#include <stdio.h>
#include <stdlib.h>
extern int sprawdz(int p);

/*
    zrob proste menu, bez wyswietlania precyzji, tylko opcje
 */

int main(int argc, char * argv[]) {
    int wybor = 1, precyzja = 1;
    int wybranaPrecyzja = precyzja;    
    
    do {
        printf("Opcje:\n");
        printf("1. Wybor precyzji\n");
        printf("0. Wyjscie\n");
        scanf("%d", &wybor);       
    
        switch(wybor) {
            case 1:
                printf("1. Single precision\n");
                printf("2. Double precision\n");
                printf("3. Double extended\n");
                scanf("%d", &precyzja);
                
                if ((precyzja > 0) && (precyzja < 4)) {
                if (sprawdz(precyzja) == 127) {
                    printf("Single precision\n");
                } else if (sprawdz(precyzja) == 639) {
                    printf("Double precision\n");
                } else if (sprawdz(precyzja) == 895) {
                    printf("Double extended\n");
                } } else {
                    printf("Zla precyzja\n");
                }
                break;
            case 0:
                break;
        }
    } while (wybor != 0);
    return 0;
}