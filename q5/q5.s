.section .data
filename: .asciz "input.txt"
yes: .asciz "Yes\n"
no: .asciz "No\n"

.section .bss
left: .skip 1
right: .skip 1

.section .text
.globl _start


#lseek(fd, 0, SEEK_END) for the first lseek, then we change it by setting an offset and indicate this with SEEK_SET
#openat(AT_FDCWD, "input.txt", O_RDONLY, 0)

_start:

    li a7, 56 # sys call openat
    li a0, -100 #AT_FDCWD
    la a1, filename
    li a2, 0 # O_RDONLY
    li a3, 0
    ecall

    bltz a0, exit #error

    mv s0, a0 #fd is in s0 now

    #lseek

    li a7, 62 #lseek sys call
    mv a0, s0 #fd
    li a1, 0 #offset
    li a2, 2 #SEEK_END
    ecall

    mv s1, a0 #s1=file size

    li s2, 0 #left = 0
    addi s3, s1, -1 #right = size-1

loop:

    bge s2, s3, isPal
    
    # left char

    li a7, 62 #lseek syscall
    mv a0, s0
    mv a1, s2 #offset = left
    li a2, 0 #SEEK_SET
    ecall

    li a7, 63 #read
    mv a0, s0
    la a1, left
    li a2, 1 #reading 1 byte
    ecall

    #right char
    li a7, 62 #lseek
    mv a0, s0
    mv a1, s3 #offset = right
    li a2, 0 #SEEK_SET
    ecall

    li a7, 63 #read
    mv a0, s0
    la a1, right
    li a2, 1
    ecall

    #comparing char

    la t0, left
    lb t1, 0(t0)

    la t0, right
    lb t2, 0(t0)

    bne t1, t2, notPal

    addi s2, s2, 1 #left++
    addi s3, s3, -1 #right--
    j loop

isPal:

    li a7, 64 #write
    li a0, 1 #stdout

    la a1, yes
    li a2, 4
    ecall
    j exit

notPal:

    li a7, 64 #write
    li a0, 1 #stdout

    la a1, no
    li a2, 3
    ecall

exit:

    li a7, 93 #exit
    li a0, 0
    ecall



