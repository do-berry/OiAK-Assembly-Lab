SYS_CALL = 0X80
FN_EXIT = 1

.globl _start
_start:
  pushl $4                      # argument na stos
  call xFactorial               # wywolanie funkcji z .c
  popl %ebp                     # przywrocenie
                                # wynik -> %eax
  movl %eax, %ebx               # %eax -> %ebx
  movl $FN_EXIT, %eax           # zakonczenie -> %eax
  int $SYS_CALL
