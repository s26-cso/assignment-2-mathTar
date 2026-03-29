#include <stdio.h>
#include <stdlib.h>

struct Node {
    int val;
    struct Node* left;
    struct Node* right;
};

// struct Node* make_node(int val);

// int main() {
//     struct Node* node = make_node(42);

//     if (node == NULL) {
//         printf("Allocation failed\n");
//         return 1;
//     }

//     printf("Value: %d\n", node->val);
//     printf("Left: %p\n", (void*)node->left);
//     printf("Right: %p\n", (void*)node->right);

//     return 0;
// }

// struct Node* insert(struct Node*, int);
// int getAtMost(int, struct Node*);

// int main() {
//     struct Node* root = NULL;

//     root = insert(root, 5);
//     root = insert(root, 3);
//     root = insert(root, 7);
//     root = insert(root, 6);

//     printf("%d\n", getAtMost(6, root)); // should print 6
// }