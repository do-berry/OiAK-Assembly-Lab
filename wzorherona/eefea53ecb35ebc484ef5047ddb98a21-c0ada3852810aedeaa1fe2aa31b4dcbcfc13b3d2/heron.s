# S = sqrt(p*(p-a)*(p-b)*(p-c));
.data
pol: .double 0.5

.text
.globl heron
.type heron, @function

heron:
  finit
  push %rbp
  mov %rsp, %rbp

  movsd %xmm0, -8(%rsp)             # a -> stos
  fldl -8(%rsp)                     # a -> st(0)
  movsd %xmm1, -16(%rsp)            # b -> stos
  fldl -16(%rsp)                    # b -> st(0), a -> st(1)
  movsd %xmm2, -24(%rsp)            # c -> stos
  fldl -24(%rsp)                    # c -> st(0), b -> st(1), a -> st(2)

  fldz                              # 0 -> st(0)

                                    # polowa obwodu
  fadd %st(3), %st                  # st(0) += st(3)
  fadd %st(2), %st                  # st(0) += st(2)
  fadd %st(1), %st                  # st(0) += st(1)
  fmull pol                         # st(0) *= 0.5

  fsub %st, %st(1)                  # st(1) -= st(0)
  fsub %st, %st(2)                  # st(2) -= st(0)
  fsub %st, %st(3)                  # st(3) -= st(0)

  fmul %st(1), %st                  # st(0) *= st(1)
  fmul %st(2), %st                  # st(0) *= st(2)
  fmul %st(3), %st                  # st(0) *= st(3)

  fsqrt                             # sqrt(st(0))

  fstpl -24(%rsp)                   # wynik
  movsd -24(%rsp), %xmm0

koniec:
  mov %rbp, %rsp                    # przywrocenie stosu
  pop %rbp
  ret                               # adres powrotu
