// obrot w pionie
#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#pragma pack(push,1)
typedef struct {
    unsigned short naglowek; 
    unsigned int rozmiar;
    unsigned int reserved;
    unsigned int offset;
    unsigned int header_size;
    unsigned int szerokosc;
    unsigned int wysokosc;
    unsigned short liczba_warstw;
    unsigned short bity_na_pixel;
    unsigned int kompresja;
    unsigned int wielkosc_danych;
    unsigned int ypikselnametr;
    unsigned int xpikselnametr;
    unsigned int kolory_palety;
    unsigned int reszta;
} bitmap;

#pragma pack(pop)
int main (int argc , char *argv[]){
    FILE *dst = fopen("a.bmp","wb"); // zapis
    FILE *src = fopen("1.bmp","rb"); // odczyt
    bitmap *mapa = (bitmap*)calloc(1,sizeof(bitmap));
    unsigned int pixel_size, puste;
    int i, j;
    unsigned char zero[1];
    i = fread (mapa, 1, sizeof(bitmap), src);
    fwrite (mapa, 1, sizeof(bitmap), dst); 
    pixel_size = mapa->wysokosc*mapa->szerokosc;
    i = mapa->offset-i;
    while(i >=0)
    {
        fread (zero, 1, 1, src);
        fwrite (zero, 1, 1, dst); 
        i--;
    }
    zero[0]=0;
    unsigned char pixel[mapa->wysokosc][mapa->szerokosc]; 
    unsigned char pixel_tmp[mapa->wysokosc][mapa->szerokosc]; 
    puste = (mapa->szerokosc % 4);
    fseek(dst, mapa->offset, SEEK_SET);
    i = 0;
    while(i < mapa->wysokosc)
    {
        fread (pixel[i], 1, mapa->szerokosc, src);
        fseek(src, puste, SEEK_CUR);
        i++;
    }
    i = mapa->wysokosc - 1;
    while(i >= 0)
    {
        fwrite (pixel[i], 1, mapa->szerokosc, dst);
        fwrite (zero, 1, puste, dst);
        i--;
    }
    system("eog a.bmp"); // wyswietlenie obrazu
    fclose(src);
    fclose(dst);
    free(mapa);
}