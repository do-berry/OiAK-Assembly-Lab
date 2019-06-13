# -> funAsm: factorial
.text
.globl funAsm
.type funAsm, @function

funAsm:
    push %rbp
    mov %rsp, %rbp              # rbp -> top
    mov 8(%rbp), %rax           # 4 -> rax
    cmp $1, %rax
    je ending
    dec %rax                    # --rax                
    push %rax
    call funAsm

retad:
    mov 8(%rbp), %rbx           
    mul %rbx

ending:
    mov %rbp, %rsp
    pop %rbp
ret