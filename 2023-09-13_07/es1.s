
# st1
# +-----------------------+
# | vc[0..3]  |           |
# +-----------------------+
.set st1_vc, 0

# st2
# +-----------------------+
# |   vd[0]   |   vd[1]   |
# +-----------------------+
# |   vd[2]   |   vd[3]   |
# +-----------------------+
.set st2_vd, 0

# cl
# +-----------------------+
# |  st1 s    |           | 0
# +-----------------------+
# |         v[0]          |
# +-----------------------+
# |         v[1]          | 16
# +-----------------------+
# |         v[2]          |
# +-----------------------+
# |         v[3]          | +32
# +-----------------------+
.set cl_s, 0
.set cl_v, 8

# stack
#           +4|         +0
#           -4|         -8
# +-----------------------+
# |          |    cla:s   | -72
# +-----------------------+
# |     cla:v[0]          | -64
# +-----------------------+
# |     cla:v[1]          | -56
# +-----------------------+
# |     cla:v[2]          | -48
# +-----------------------+
# |     cla:v[3]          | -40
# +-----------------------+
# |        st2:s2         | -32
# +-----------------------+
# |        st2:s2         | -24
# +-----------------------+
# |     i     |  st1:s1   | -16
# +-----------------------+
# |          this         | -8
# +-----------------------+
# |         old rbp       | <- rbp
# +-----------------------+
.set this, -8
.set i, -12
.set s1, -16
.set s2, -32
.set cla, -72

.GLOBAL _ZN2cl5elab1E3st13st2
_ZN2cl5elab1E3st13st2:
    push %RBP
    mov %RSP, %RBP
    sub $80, %RSP

    movq %RDI, this(%RBP)
    movl %ESI, s1(%RBP)
    movq %RDX, s2(%RBP)
    movq %RCX, 8 + s2(%RBP)

    leaq cla(%RBP), %RDI
    movb $'a', %sil
    leaq s2(%RBP), %RDX
    call _ZN2clC1EcR3st2

    movl $0, i(%RBP)

for_loop:
    cmpl $4, i(%RBP)
    JGE end_for

    movslq i(%RBP), %RCX

    movq this(%RBP),%RDX
    movb cl_s + st1_vc(%RDX, %RCX, 1), %AL

    leaq s1(%RBP), %RDX
    movb st1_vc(%RDX, %RCX, 1), %AH

    cmpb %AH, %AL
    JAE end_if

    leaq cla(%RBP), %RDX
    movb cl_s + st1_vc(%RDX, %RCX, 1), %AL
    movq this(%RBP),%RDX
    movb %AL, cl_s + st1_vc(%RDX, %RCX, 1)

    leaq cla(%RBP), %RDX
    movq cl_v(%RDX, %RCX, 8), %RAX
    movq this(%RBP),%RDX
    movq %RAX, cl_v(%RDX, %RCX, 8)  
end_if:
    incl i(%RBP)
    jmp for_loop
end_for:
    leave 
    ret
