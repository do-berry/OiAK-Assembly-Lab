# built with: gcc -g -o zad1 zad1.s
SYS_CALL = 0X80
exit = 1
.extern printf

.data
format_string: .ascii "Hello, %s!\n\0"
name: .ascii "Dominika\0"

.text
.globl main

main:
    mov $format_string, %rdi
    mov $name, %rsi
    mov $0, %rax
    
    call printf
    ret
        
    movl $exit, %eax
    int $SYS_CALL