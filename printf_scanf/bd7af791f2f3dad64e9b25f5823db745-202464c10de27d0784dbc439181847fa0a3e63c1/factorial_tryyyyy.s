# -> funAsm: factorial
.text
.globl funAsm
.type funAsm, @function

funAsm:
    push %rbp
    mov %rsp, %rbp
    cmp $1, %rbx                # rbx -> counter
    jg recursion
    mov 8(%rbp), %rax
ret

recursion:
    dec %rbx                    # --rbx
    call funAsm
    inc %rbx
    mul %rbx
ret    
