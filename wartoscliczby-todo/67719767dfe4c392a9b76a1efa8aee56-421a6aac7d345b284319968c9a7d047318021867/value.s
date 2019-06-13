syscall32 = 0x80
exit = 1                                 # zamykanie
stdin = 0                                # wejscie
read = 3                                 # odczyt
stdout = 1                               # wyjscie
write = 4                                # wypis
buf_size = 254                           # rozmiar bufora

.data
bufor: .space buf_size                   # dekl bufora
wartosc: .long 0                         # wartosc = 0

.text
.type _wartosc @function
.globl _start

_wartosc:
petla:
    movb bufor(,%ebx,1), %cl             # od poczatku bufora
    
    subb $48, %cl                        # cl -= 48
    
    mulb $10, wartosc                    # wartosc = wartosc * 10
    addb %cl, wartosc                    # + cl

    inc %ebx                             # inkrementacja ebx
    cmp %edx, %ebx                       # edx : ebx ?
    jl petla                             # skok jesli mniejsze

_start:
  movl $buf_size, %edx
  movl $bufor, %ecx
  movl $stdin, %ebx
  movl $read, %eax
int $syscall32

  movl $buf_size, %edx
  movl $wartosc, %ecx
  movl $stdout, %ebx
  movl $write, %eax
int $syscall32

  movl $exit, %eax
int $syscall32