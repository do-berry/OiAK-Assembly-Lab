# built with: gcc -g -o zad2 zad2.s
SYS_CALL = 0X80
exit = 1
.extern printf
.extern scanf
size = 100

.data
format_string: .ascii "Hello, %s!\n\0"
format_scanf: .ascii "%s"
buffer: .space size

.text
.globl main

main:
    mov $buffer, %rsi
    mov $format_scanf, %rdi
    mov $0, %rax

    call scanf

    mov $format_string, %rdi
    mov $buffer, %rsi
    mov $0, %rax
    
    call printf
    ret
        
    movl $exit, %eax
    int $SYS_CALL