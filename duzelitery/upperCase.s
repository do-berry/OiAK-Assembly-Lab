syscall32 = 0x80
exit = 1
stdin = 0
read = 3
stdout = 1
write = 4
buf_size = 254

.data
bufor: .space buf_size

.globl _start

.text
_start:
    movl $buf_size, %edx
    movl $bufor, %ecx
    movl $stdin, %ebx
    movl $read, %eax
    int $syscall32

    movl %eax, %edx                     # eax -> edx
    dec %edx                            # zmniejszenie edx - bez uwzgledniania entera
    movl $0, %ebx                       # licznik

petla:
    movb bufor(,%ebx,1), %cl
    xor $0x20, %cl
    movb %cl, bufor(,%ebx,1)

    inc %ebx                            # zwiekszenie licznika
    cmp %edx, %ebx                      # porown edx i ebx
    jl petla                            # skok jesli mniejsze

pisz:
    movl $buf_size, %edx
    movl $bufor, %ecx
    movl $stdout, %ebx
    movl $write, %eax
int $syscall32

    movl $exit, %eax
int $syscall32
