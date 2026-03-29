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

# -----------------------------------
# struct Node* insert(Node* root, int val)
# a0 = root, a1 = val
# -----------------------------------

insert:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd a0, 16(sp) #saving the root
    sd a1, 8(sp) #saving the val

    #if root == NULL
    beqz a0, insert_make

    #loading root->val
    lw t0, 0(a0)

    #comparing val with root->val
    blt a1, t0, go_left
    bgt a1, t0, go_right

    #if equal, return root - not storing count of nodes with same val - NEED TO CLARIFY
    j insert_return_root

insert_make:
    mv a0, a1
    call make_node
    j insert_end #new root essentially as this was called when bst was empty

go_left:
    ld t1, 8(a0) #root->left

    mv a0, t1 #pointer of left node
    ld a1, 8(sp) #val of left node
    call insert #recursing down left subtree

    ld t2, 16(sp) #og root
    sd a0, 8(t2) #root->left = returned node
    mv a0, t2
    j insert_end

go_right:
    ld t1, 16(a0) # root->right

    mv a0, t1 #pointer of right node
    ld a1, 8(sp) #val of right node
    call insert #recursing down the right subtree

    ld t2, 16(sp) #og root
    sd a0, 16(t2) # root->right = returned node
    mv a0, t2
    j insert_end

insert_return_root:
    ld a0, 16(sp)

insert_end:
    ld ra, 24(sp)
    addi sp, sp, 32
    ret
# -----------------------------------
# struct Node* get(Node* root, int val)
# a0 = root, a1 = val
# -----------------------------------

get:
    addi sp, sp, -16
    sd ra, 8(sp)

    #if root == NULL
    beqz a0, get_null

    lw t0, 0(a0) #val of root

    beq a1, t0, get_found
    blt a1, t0, get_left

    #go right
    ld a0, 16(a0) #pointer of right node
    call get #recursing down right subtree
    j get_end

get_left:
    ld a0, 8(a0) #pointer of left node
    call get
    j get_end

get_found:
    #a0 is already the root
    j get_end

get_null:
    mv a0, zero

get_end:
    ld ra, 8(sp)
    addi sp, sp, 16
    ret

# -----------------------------------
# int getAtMost(int val, Node* root)
# a0 = val, a1 = root
# returns int in a0
# -----------------------------------

getAtMost:
    addi sp, sp, -16
    sd ra, 8(sp)

    mv t0, a1 #current node
    li t1, -1 #initialized to -1

loop:
    beqz t0, done

    lw t2, 0(t0) #node->val

    ble t2, a0, update

    #go left
    ld t0, 8(t0) #node->left
    j loop

update:
    mv t1, t2 #ans = node->val - temp update
    ld t0, 16(t0) #going right
    j loop

done:
    mv a0, t1 #my node val in a0 now

    ld ra, 8(sp)
    addi sp, sp, 16
    ret

