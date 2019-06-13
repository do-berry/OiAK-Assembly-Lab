.globl varAsm
#type varAsm, @object
.size varAsm, 4
varAsm: .long 3

.text
.globl funAsm
.type funAsm, @function

funAsm:
  movl $varAsm, %eax
  movl $varAsm, %ebx
  imull %ebx, %eax
  ret
