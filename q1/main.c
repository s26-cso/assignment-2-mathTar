#include <stdio.h>
#include <stdlib.h>

struct Node {
    int val;
    struct Node* left;
    struct Node* right;
};

struct Node* make_node(int val);
struct Node* insert(struct Node*, int);
struct Node* get(struct Node*, int);
int getAtMost(int, struct Node*);

// to print sorted order
void inorder(struct Node* root) {
    if (!root) return;
    inorder(root->left);
    printf("%d ", root->val);
    inorder(root->right);
}

int main() {
    struct Node* root = NULL;

    int values[] = {5, 3, 7, 2, 4, 6, 8};
    int n = 7;
    for (int i = 0; i < n; i++) {
        root = insert(root, values[i]); // make_node will be called internally for the first insert
    }

    printf("Inorder traversal (should be sorted hopefully):\n");
    inorder(root);
    printf("\n");
    
    printf("Testing get():\n");

    int test_vals[] = {5, 2, 8, 10};
    for (int i = 0; i < 4; i++) {
        struct Node* res = get(root, test_vals[i]);

        if (res)
            printf("Found %d at %p\n", res->val, (void*)res);
        else
            printf("%d not found\n", test_vals[i]);
    }

    printf("\n");

    // Expected:
    // Found 5
    // Found 2
    // Found 8
    // 10 not found


    printf("Testing getAtMost():\n");

    int queries[] = {1, 2, 5, 6, 9};
    for (int i = 0; i < 5; i++) {
        int ans = getAtMost(queries[i], root);
        printf("getAtMost(%d) = %d\n", queries[i], ans);
    }

    printf("\n");

    // Expected:
    // getAtMost(1) = -1
    // getAtMost(2) = 2
    // getAtMost(5) = 5
    // getAtMost(6) = 6
    // getAtMost(9) = 8

    return 0;
}