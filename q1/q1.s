.section .text

.extern malloc

.globl make_node
.globl insert
.globl get
.globl getAtMost

# -----------------------------------
# struct Node* make_node(int val)
# a0 = val
# returns pointer in a0
# -----------------------------------

make_node:
    addi sp, sp, -16
    sd ra, 8(sp)

    mv t0, a0 #saving val

    li a0, 24 #to malloc 24
    call malloc

    #now a0 is the pointer
    mv t1, a0
    
    sw t0, 0(t1) #val
    sd zero, 8(t1) # left = NULL
    sd zero, 16(t1) # right = NULL

    mv a0, t1 #return pointer

    ld ra, 8(sp)
    addi sp, sp, 16
    ret
