syscall32 = 0x80
exit = 1                                 # zamykanie
stdin = 0                                # wejscie
read = 3                                 # odczyt
stdout = 1                               # wyjscie
write = 4                                # wypis
buf_size = 254                           # rozmiar bufora

.data
bufor: .space buf_size                   # dekl bufora

.text
.type _dodawanie_r @function             # przez rejestr
.type _dodawanie_s @function             # przez stos
.globl _start

_dodawanie_r:
    addl %eax, %ebx                      # ebx += eax
    ret                                  # -> adres powrotu

_dodawanie_s:
    pushl %ebp                           
    movl %esp, %ebp                      # w ebp: top
    movl 8(%ebp), %ebx                   # wartosc +8 bajtow od ebp
    addl 12(%ebp), %ebx                  # wynik w ebx
    # zwalnianie stosu
    movl %ebp, %esp                      # przywrocenie wskaznika szczytu stosu
    popl %ebp                            # odtworzenie starego wskaznika
    ret                                  # -> adres powrotu

.globl _start
_start:
    movl $3, %eax                        # eax = 3
    movl $1, %ebx                        # ebx = 1
    call _dodawanie_r                    # ebx += eax
    
    push %eax                            # eax na stos
    push %ebx                            # ebx na stos
    call _dodawanie_s                    # ebx += eax

    # to zawsze 
    movl $1, %eax
    int $syscall32