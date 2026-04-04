.section .data
filename: .asciz "input.txt"
mode: .asciz "r"
yes: .asciz "Yes"
no: .asciz "No"

.section .bss
left: .skip 1
right: .skip 1

.section .text
.globl main #to match libc expectations

#lseek(fd, 0, SEEK_END) for the first lseek, then we change it by setting an offset and indicate this with SEEK_SET
#openat(AT_FDCWD, "input.txt", O_RDONLY, 0)

# we use fopen and fseek now instead, and ftell and fgetc for char by char
# fopen("input.txt", "r")
# fseek(file, 0, SEEK_END)

main:

    la a0, filename
    la a1, mode
    call fopen
    beqz a0, exit
    mv s0, a0 #file* essentiallly

    #fseek

    mv a0, s0
    li a1, 0
    li a2, 2
    call fseek

    # size = ftell(file)
    mv a0, s0
    call ftell
    mv s1, a0 #size

    li s2, 0 #left = 0
    addi s3, s1, -1 #right = size-1

loop:

    bgt s2, s3, isPal
    
    # left char

    mv a0, s0
    mv a1, s2
    li a2, 0
    call fseek

    mv a0, s0
    call fgetc
    mv t1, a0


    #right char
    
    mv a0, s0
    mv a1, s3
    li a2, 0 #SEEK_SET
    call fseek 

    mv a0, s0
    call fgetc
    mv t2, a0

    #comparing char

    bne t1, t2, notPal

    addi s2, s2, 1 #left++
    addi s3, s3, -1 #right--
    j loop

isPal:

    la a0, yes
    call puts
    j done

notPal:

    la a0, no
    call puts

done:

    li a0, 0
    call exit
