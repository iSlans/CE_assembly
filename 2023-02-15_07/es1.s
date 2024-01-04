.text

# cl
# +-----------------------+
# |  s[0..3]  |           | 0
# +-----------------------+
# |          v[0]         |
# +-----------------------+
# |          v[1]         | 16
# +-----------------------+
# |          v[2]         |
# +-----------------------+
# |          v[3]         | 32
# +-----------------------+
.set cl_s, 0
.set cl_v, 8

.set st1_vc, 0

# stack
#           +4|         +0
#           -4|         -8
# +-----------------------+
# |           |     |     | -32
# +-----------------------+
# |     i     |    s2     | -24
# +-----------------------+
# |           *c          | -16
# +-----------------------+
# |          this         | -8
# +-----------------------+
# |         old rbp       | <- rbp
# +-----------------------+

.set this, -8
.set c, -16
.set i, -20
.set s2, -24

.GLOBAL _ZN2clC1EPc3st1
_ZN2clC1EPc3st1:
    push %RBP
    movq %RSP, %RBP
    sub $32, %RSP

    movq %RDI, this(%RBP)
    movq %RSI, c(%RBP)
    movl %EDX, s2(%RBP)

    movl $0, i(%RBP)
for_loop:
    cmpl $4, i(%RBP)
    jge end_for

    movslq i(%RBP), %RCX

    # s.vc[i] = *c;
    movq c(%RBP), %RDX
    movb (%RDX), %AL

    movq this(%RBP), %RDX
    movb %AL, cl_s + st1_vc(%RDX, %RCX, 1)

    # v[i] = s2.vc[i] - *c;
    leaq s2(%RBP), %RDX
    movb st1_vc(%RDX, %RCX, 1), %DL
    subb %AL, %DL
    movsbq %DL, %RAX

    movq this(%RBP), %RDX
    movq %RAX, cl_v(%RDX, %RCX, 8)

    incl i(%RBP)
    jmp for_loop
end_for:
    leave 
    ret


# stack
#           +4|         +0
#           -4|         -8
# +-----------------------+
# |           |     i     | -64
# +-----------------------+
# |           |cla:s[3..0]| -56
# +-----------------------+
# |        cla:v[0]       | -48
# +-----------------------+
# |        cla:v[1]       |
# +-----------------------+
# |        cla:v[2]       | -32
# +-----------------------+
# |        cla:v[3]       |
# +-----------------------+
# |          &s1          | -16
# +-----------------------+
# |          this         | -8
# +-----------------------+
# |         old rbp       | <- rbp
# +-----------------------+
.set this, -8
.set s1, -16
.set cla, -56
.set i, -64

.GLOBAL _ZN2cl5elab1ER3st1
_ZN2cl5elab1ER3st1:
    push %RBP
    movq %RSP, %RBP
    subq $64, %RSP

    movq %RDI, this(%RBP)
    movq %RSI, s1(%RBP)

    leaq cla(%RBP), %RDI
    movq this(%RBP), %RDX
    leaq cl_s + st1_vc(%RDX), %RSI

    movq s1(%RBP), %RDX
    movl (%RDX), %EDX
    
    call _ZN2clC1EPc3st1

    movl $0, i(%RBP)
for_loop_due:
    cmpl $4, i(%RBP)
    jge end_for_due

    movslq i(%RBP), %RCX

    movq this(%RBP), %RDX
    movb cl_s + st1_vc(%RDX, %RCX, 1), %AL
    movq s1(%RBP), %RDX
    movb st1_vc(%RDX, %RCX, 1), %AH

    cmpb %AH, %AL
    jae end_if

    leaq cla(%RBP), %RDX
    movb cl_s + st1_vc(%RDX, %RCX, 1), %AL
    movq this(%RBP), %RDX
    movb %AL, cl_s + st1_vc(%RDX, %RCX, 1)


    leaq cla(%RBP), %RDX
    movq cl_v(%RDX, %RCX, 8), %RAX
    addq %RCX, %RAX
    movq this(%RBP), %RDX
    movq %RAX, cl_v(%RDX, %RCX, 8)

end_if:

    incl i(%RBP)
    jmp for_loop_due
end_for_due:
    leave
    ret
