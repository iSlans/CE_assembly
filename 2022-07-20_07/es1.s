
# st
# +-----------------------+
# |        vv2[0]         | 0
# +-----------------------+
# |        vv2[1]         | 8
# +-----------------------+
# |        vv2[2]         |
# +-----------------------+
# |        vv2[3]         | +24
# +-----------------------+
# |  vv1[0..4]|           | +32
# +-----------------------+
.set st_vv2, 0
.set st_vv1, 32
.set cl_s, 0

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
.GLOBAL _ZN2cl5elab1ER2sti
_ZN2cl5elab1ER2sti:
    push %RBP
    mov %RSP, %RBP
    sub $32, %RSP

    movq %RDI, this(%RBP)
    movq %RSI, ss(%RBP)
    movl %EDX, d(%RBP)

    movl $0, i(%RBP)

for_loop:
    cmpl $4, i(%RBP)
    JGE end_for

    movslq i(%RBP), %RCX

    movq ss(%RBP), %RDX
    movq st_vv2(%RDX, %RCX, 8), %RAX

    movl d(%RBP), %EDX
    movslq %EDX, %RDX

    CMP %RAX, %RDX
    JL end_if

    movq ss(%RBP), %RDX
    movb st_vv1(%RDX, %RCX, 1), %AL

    movq this(%RBP), %RDX
    subb %AL, cl_s + st_vv1(%RDX, %RCX, 1)
end_if:  

    movslq i(%RBP), %RAX 
    movl d(%RBP), %EDX
    movslq %EDX, %RDX
    subq %RDX, %RAX

    movq this(%RBP), %RDX
    movq %RAX, cl_s + st_vv2(%RDX, %RCX, 8)

    incl i(%RBP)
    jmp for_loop
end_for:
    leave 
    ret

