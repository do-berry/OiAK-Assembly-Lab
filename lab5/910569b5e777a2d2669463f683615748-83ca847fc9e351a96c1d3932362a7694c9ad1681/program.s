.data
READ = 0
WRITE = 1
OPEN = 2
CLOSE = 3
FREAD = 0
FWRITE = 1
EXIT = 60
EXIT_SUCCESS = 0
buf_size = 1024
readFile: .ascii "a.txt\0"
writeFile: .ascii "w.txt\0"
in: .space buf_size

.text
.globl _start

_start:
    mov $OPEN, %rax         # otwarcie pliku do odczytu
    mov $readFile, %rdi
    mov $FREAD, %rsi
    mov $0, %rdx     
    syscall
    mov %rax, %r10          # identyf otwartego pliku -> r10

readFromFile:
    mov $READ, %rax         # odczyt do bufora
    mov %r10, %rdi
    mov $in, %rsi
    mov $1024, %rdx
    syscall
    mov %rax, %r8

    mov $CLOSE, %rax        # zamkniecie pliku do odczytu
    mov %r10, %rdi
    mov $0, %rsi
    mov $0, %rdx
    syscall

    mov $OPEN, %rax         # otwarcie do zapisu
    mov $writeFile, %rdi
    mov $FWRITE, %rsi
    mov $0644, %rdx
    syscall
    mov %rax, %r10

writeToFile:
    mov $WRITE, %rax
    mov %r10, %rdi
    mov $in, %rsi
    mov %r8, %rdx
    syscall

    mov $CLOSE, %rax        # zamkniecie pliku do zapisu
    mov %r10, %rdi
    mov $0, %rsi
    mov %r8, %rdx
    syscall

escape:
    mov $EXIT, %rax
    mov $EXIT_SUCCESS, %rdi
    syscall
