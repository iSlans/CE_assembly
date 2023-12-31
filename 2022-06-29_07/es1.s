
# st
# +-----------------------+
# |[     vv1       ]      |
# +-----------------------+
# |        vv2[0]         |
# +-----------------------+
# |        vv2[1]         |
# +-----------------------+
# |        vv2[2]         |
# +-----------------------+
.set st_vv1, 0
.set st_vv2, 8

# cl
# +-----------------------+
# |          s            |
# +-----------------------+
# |          s            |
# +-----------------------+
# |          s            |
# +-----------------------+
# |          s            | +24
# +-----------------------+
.set cl_s, 0

# stack
#           +4|         +0
#           -4|         -8
# +-----------------------+
# |           |     |     | -32
# +-----------------------+
# |           |     i     | -24
# +-----------------------+
# |           &v          | -16
# +-----------------------+
# |          this         | -8
# +-----------------------+
# |         old rbp       | <- rbp
# +-----------------------+

.set this, -8
.set v, -16
.set i, -24

.GLOBAL _ZN2clC1EPc
_ZN2clC1EPc:
    push %RBP
    mov %RSP, %RBP
    subq $32, %RSP

    movq %RDI, this(%RBP)
    movq %RSI, v(%RBP)

    movl $0, i(%RBP)
for_loop:
    CMP $3, i(%RBP)
    JGE end_for

    movslq i(%RBP), %RCX

    movq v(%RBP), %RDX
    movb (%RDX, %RCX, 1), %AL

    movq this(%RBP), %RDX
    movsbq %AL, %RAX
    movq %RAX, cl_s + st_vv2(%RDX, %RCX, 8)

    addq $3, %RCX
    movb %AL, cl_s + st_vv1(%RDX, %RCX, 1)

    movslq i(%RBP), %RCX
    movb %AL, cl_s + st_vv1(%RDX, %RCX, 1)

    incl i(%RBP)
    JMP for_loop
end_for:
    leave
    ret


# stack
#           +4|         +0
#           -4|         -8
# +-----------------------+
# |           |     |     | -32
# +-----------------------+
# |     i     |     d     | -24
# +-----------------------+
# |          &ss          | -16
# +-----------------------+
# |          this         | -8
# +-----------------------+
# |         old rbp       | <- rbp
# +-----------------------+


.set this, -8
.set ss, -16
.set i, -20
.set d, -24

.GLOBAL _ZN2cl5elab1EiR2st
_ZN2cl5elab1EiR2st:
    push %RBP
    mov %RSP, %RBP
    subq $32, %RSP

    movq %RDI, this(%RBP)
    movl %ESI, d(%RBP)
    movq %RDX, ss(%RBP)

    movl $0, i(%RBP)
for_loop_due:
    cmpl $3, i(%RBP)
    JGE end_for_due

    movslq i(%RBP), %RCX

    movq ss(%RBP), %RDX
    movq st_vv2(%RDX, %RCX, 8), %RAX
    movl d(%RBP), %ESI
    movslq %ESI, %RSI

    cmp %RAX, %RSI
    JL else_branch

    movq ss(%RBP), %RDX
    movb st_vv1(%RDX, %RCX, 1), %AL

    movq this(%RBP), %RDX
    addb %AL, cl_s + st_vv1(%RDX, %RCX, 1)

    movl d(%RBP), %ESI
    movslq %ESI, %RSI
    subq %RSI, cl_s + st_vv2(%RDX, %RCX, 8)

    jmp end_if
else_branch:

    movslq i(%RBP), %RCX

    movq ss(%RBP), %RDX
    movb st_vv1(%RDX, %RCX, 1), %AL

    movq this(%RBP), %RDX
    movq %RCX, %R8
    addq $3, %R8
    subb %AL, cl_s + st_vv1(%RDX, %R8, 1)

    movl d(%RBP), %ESI
    movslq %ESI, %RSI
    addq %RSI, cl_s + st_vv2(%RDX, %RCX, 8)

end_if:
    incl i(%RBP)
    jmp for_loop_due
end_for_due:
    leave
    ret
