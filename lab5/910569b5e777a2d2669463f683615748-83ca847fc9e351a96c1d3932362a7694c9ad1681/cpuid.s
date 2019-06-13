# eng.wiki; built with gcc -g -o cpuid cpuid.s
.extern printf

.data
s0: .asciz  "CPUID: %x\n"
s1: .asciz  "Largest basic function number implemented: %i\n"
s2: .asciz  "Vendor ID: %.12s\n"

    .text

    .align  32
    .globl  main

main:
    pushq   %rbp
    movq    %rsp,%rbp
    subq    $16,%rsp

    movl    $1,%eax
    cpuid

    movq    $s0,%rdi
    movl    %eax,%esi
    xorl    %eax,%eax
    call    printf

    xorl    %eax,%eax
    cpuid

    movl    %ebx,0(%rsp)
    movl    %edx,4(%rsp)
    movl    %ecx,8(%rsp)

    movq    $s1,%rdi
    movl    %eax,%esi
    xorl    %eax,%eax
    call    printf

    movq    $s2,%rdi
    movq    %rsp,%rsi
    xorl    %eax,%eax
    call    printf

    movq    %rbp,%rsp
    popq    %rbp
//  ret
    movl    $1,%eax
    int $0x80