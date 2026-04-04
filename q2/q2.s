.section .rodata
fmt_out:
.string "%d "
fmt_last:
.string "%d"
newline:
.string "\n"

.section .text
.extern malloc
.extern atoi
.extern printf

.globl main

main:
    #shifting by 2 assuming integers, not long long - may have to change
    addi sp, sp, -64
    sd ra, 56(sp)
    sd s0, 48(sp)
    sd s1, 40(sp)
    sd s2, 32(sp)
    sd s3, 24(sp)
    sd s4, 16(sp)
    sd s5, 8(sp)

    #argc (no of args) = a0, argv (actual integers) = a1
    mv s0, a0 #argc
    mv s1, a1 #argv

    addi s0, s0, -1 #n = argc -1
    mv s2, s0 #storing n

    #malloc (n*4)
    slli a0, s2, 2
    call malloc
    mv s3, a0 #arr pointer

    #i=0
    li t0, 0

parseLoop:

    bge t0, s2, parseDone
    
    #argv[i+1]
    addi t1, t0, 1
    slli t1, t1, 3
    add t2, s1, t1
    ld a0, 0(t2)

    call atoi #to convert string to int

    #store in arr[i]
    slli t3, t0, 2
    add t4, s3, t3
    sw a0, 0(t4)

    addi t0, t0, 1
    j parseLoop

parseDone:

    #debug: printing array
    li t0, 0

#currently: arr in s3, n in s2

#malloc res (n*4)
slli a0, s2, 2
call malloc
mv s4, a0 #arr res

#malloc stack (n*4)
slli a0, s2, 2
call malloc
mv s5, a0 # arr stack

li t0, -1 #top pointer
mv s6, t0 #storing top in s6

addi t1, s2, -1 # i = n-1 in MAIN LOOP IN ALGO

outerLoop:

    bltz t1, done

whileLoop: #pop 

    bltz s6, whileDone #stack empty - break

    #stack[top]
    slli t2, s6, 2
    add t3, s5, t2
    lw t4, 0(t3) #index at top

    #arr[stack[top]]
    slli t5, t4, 2
    add t6, s3, t5
    lw t0, 0(t6)

    # arr[i]
    
    slli t2, t1, 2
    add t2, s3, t2
    lw t2, 0(t2)

    ble t0, t2, popStack
    j whileDone

popStack:

    addi s6, s6, -1
    j whileLoop

whileDone:

    #if stack empty
    bltz s6, minus1

    # res[i] = stack[top]

    slli t2, s6, 2
    add t3, s5, t2
    lw t4, 0(t3)

    slli t5, t1, 2
    add t6, s4, t5
    sw t4, 0(t6)
    j pushStep

minus1:

    slli t5, t1, 2
    add t6, s4, t5
    li t4, -1
    sw t4, 0(t6)

pushStep:

    addi s6, s6, 1
    slli t2, s6, 2
    add t3, s5, t2
    sw t1, 0(t3)

addi t1, t1, -1
j outerLoop

done:
    li t0, 0

printLoop:

    bge t0, s2, printDone
    
    slli t1, t0, 2
    add t2, s4, t1 #the res array s4
    lw a1, 0(t2)

    #we have to check if last element: i == n-1?
    addi t3, s2, -1
    beq t0, t3, printLast

    #normal case
    la a0, fmt_out
    call printf

    j nextIter

printLast:
    la a0, fmt_last
    call printf

nextIter:
    addi t0, t0, 1
    j printLoop

printDone:

    la a0, newline
    call printf

    ld ra, 56(sp)
    ld s0, 48(sp)
    ld s1, 40(sp)
    ld s2, 32(sp)
    ld s3, 24(sp)
    ld s4, 16(sp)
    ld s5, 8(sp)
    addi sp, sp, 64
    ret


