.TEXT

# cl:
#   0                     7
# +-------------------------+
# |s.vc[0 1]                |
# +-------------------------+
# |          v[0]           |
# +-------------------------+
# |          v[1]           |
# +-------------------------+

.SET cl_s, 0
.SET cl_v, 8

# stack:
# |         -4|           -8|
# +-------------------------+
# |                         | -32
# +-------------------------+
# |          &s2            | -24
# +-------------------------+
# |     i     |         | c | -16
# +-------------------------+
# |          this           | -8
# +-------------------------+
# |       old rbp           | <-rbp
# +-------------------------+


.SET this, -8
.SET i, -12
.SET c, -16
.SET s2, -24
.GLOBAL _ZN2clC1EcR3st1
_ZN2clC1EcR3st1:
    pushq %rbp
    movq %rsp, %rbp
    sub $32, %rsp

    # *this, char, st1*

    movq %rdi, this(%rbp)
    movb %sil, c(%rbp)
    movq %rdx, s2(%rbp)

    movl $0, i(%RBP)
for_loop:
    cmpl $2, i(%RBP)
    JGE end_for

    movslq i(%RBP), %RCX

    # this->s.vc[i] = c
    movq this(%RBP), %RDI
    movb c(%RBP), %AL
    movb %AL, cl_s(%RDI, %RCX, 1)

    # this->v[i] = s2.vc[i] - c
    movq s2(%RBP), %RDX
    movb (%RDX, %RCX, 1), %AL
    subb c(%RBP), %AL
    movsbq %AL, %RAX
    movq %RAX, cl_v(%RDI, %RCX, 8)

    incl i(%RBP)
    jmp for_loop
end_for:
    leave 
    ret
    

# stack:
# |         -4|           -8|
# +-------------------------+
# |            cla.s.vc[1 0]| -48
# +-------------------------+
# |        cla.v[0]         | -40
# +-------------------------+
# |        cla.v[1]         | -32
# +-------------------------+
# |           |      i      | -24
# +-------------------------+
# |          &s1            | -16
# +-------------------------+
# |          this           | -8
# +-------------------------+
# |       old rbp           | <-rbp
# +-------------------------+

.SET this, -8
.SET s1, -16
.SET i, -24
.SET cla, -48
.GLOBAL _ZN2cl5elab1ER3st1
_ZN2cl5elab1ER3st1:
    pushq %rbp
    movq %rsp, %rbp
    sub $48, %rsp

    # *this, st1*
    movq %RDI, this(%rbp)
    movq %RSI, s1(%rbp)

	# cl cla('p', s1);
    leaq cla(%RBP), %RDI
    movb $'p', %sil
    movq s1(%RBP), %RDX
    call _ZN2clC1EcR3st1

    movl $0, i(%RBP)
for_loop_elab1:
    cmpl $2, i(%RBP)
    JGE end_loop_elab1

    movslq i(%RBP), %RCX

    movq this(%RBP), %RDX
    movb cl_s(%RDX, %RCX, 1), %AL

    movq s1(%RBP), %RDX
    movb (%RDX, %RCX, 1), %BL

    cmp %BL, %AL
    JAE end_if

    leaq cla(%RBP), %RDX
    movb cl_s(%RDX, %RCX, 1), %AL
    movq this(%RBP), %RDX
    movb %AL, cl_s(%RDX, %RCX, 1)

    leaq cla(%RBP), %RDX
    movq cl_v(%RDX, %RCX, 8), %RAX
    addq %RCX, %RAX
    movq this(%RBP), %RDX
    movq %RAX, cl_v(%RDX, %RCX, 8)
    
end_if:
    incl i(%RBP)
    jmp for_loop_elab1
end_loop_elab1:
    leave
    ret
