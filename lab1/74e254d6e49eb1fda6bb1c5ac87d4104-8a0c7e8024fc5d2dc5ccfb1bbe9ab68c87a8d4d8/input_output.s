syscall32 = 0x80
exit = 1                                 # zamykanie
stdin = 0                                # wejscie
read = 3                                 # odczyt
stdout = 1                               # wyjscie
write = 4                                # wypis
buf_size = 254                           # rozmiar bufora

.data
bufor: .space buf_size                   # dekl bufora

.globl _start

.text
_start:
  movl $buf_size, %edx
  movl $bufor, %ecx
  movl $stdin, %ebx
  movl $read, %eax
int $syscall32

  movl $buf_size, %edx
  movl $bufor, %ecx
  movl $stdout, %ebx
  movl $write, %eax
int $syscall32

  movl $exit, %eax
int $syscall32
