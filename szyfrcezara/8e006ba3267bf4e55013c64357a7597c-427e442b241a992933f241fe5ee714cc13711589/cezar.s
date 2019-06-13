syscall32 = 0x80
exit = 1
stdin = 0
read = 3
stdout = 1
write = 4
buf_size = 254

.data
bufor: .space buf_size                              # zrodlo
tekst: .space buf_size                              # wyjscie

.globl _start

.text
_start:
    movl $buf_size, %edx
    movl $bufor, %ecx
    movl $stdin, %ebx
    movl $read, %eax
    int $syscall32

    movl %eax, %edx                                 # eax -> edx : dlugosc slowa
    dec %edx                                        # zmniejszenie edx - bez uwzgledniania entera
    movl $0, %ebx                                   # licznik : ebx

petla:
    movb bufor(,%ebx,1), %cl
    orb $0x20, %cl                                  # wszystkie -> male
    movb %cl, bufor(,%ebx,1)

    cmp $' ', %cl                                   # czy jest spacja
    je koniec                                       # jak jest to inkrementujemy -> ma byc BEZ spacji

    cmp $'w', %cl                                   # ($'w' < %cl) ? k : -26
    jle kodowanie
    subb $26, %cl                                   # cl -= 26

kodowanie:
    addb $3, %cl                                    # cl += 3
    addb %cl, tekst(,%ebx,1)                        # -> tekst

koniec:
    inc %ebx                                        # zwiekszenie licznika
    cmp %edx, %ebx                                  # porown edx i ebx
    jl petla                                        # skok jesli mniejsze

pisz:
    movl $buf_size, %edx
    movl $tekst, %ecx
    movl $stdout, %ebx
    movl $write, %eax
    int $syscall32

    movl $exit, %eax
    int $syscall32
