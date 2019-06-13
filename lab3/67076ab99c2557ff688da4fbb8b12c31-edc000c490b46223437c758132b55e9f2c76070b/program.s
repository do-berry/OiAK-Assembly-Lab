.data
    control_word: .short 0

.text
.globl sprawdz
.type sprawdz, @function

sprawdz:
    push %rbp                   # w argumentach wybrana precyzja
    mov %rsp, %rbp
    
    # control_word -> ax
    mov $0, %rax
    fstcw control_word
    fwait
    mov control_word, %ax
    
    and $0xFCFF, %ax            # wyzerowanie
    
    # 1 ? 2
    # domyslnie: single
    cmp $2, %rdi
    je db_prec
    jl koniec

db_extended:                    # 3 
    xor $0x300, %ax
    jmp koniec
    
db_prec:                        # 2
    xor $0x200, %ax

koniec:
    mov %ax, control_word
    fldcw control_word
                                 # przywrocenie stosu
    mov %rbp, %rsp
    pop %rbp
    ret