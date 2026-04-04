#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h> // for dynamic loading (dlopen, dlsym, dlclose)

#define MAX_LINE 256
#define MAX_OP_LEN 6

int main() {

    char line[MAX_LINE]; //buffer to store each i/p line
    while (1) {
        if (fgets(line, sizeof(line), stdin) == NULL) {
            break; //EOF
        }
        //removing trailing newline
        line[strcspn(line, "\n")] = '\0';
        
        char op[MAX_OP_LEN];
        
        //first token is the op
        char* token = strtok(line, " ");
        if (token == NULL) {
            continue; //invalid input
        }
        strncpy(op, token, MAX_OP_LEN - 1);
        op[MAX_OP_LEN - 1] = '\0';

        //second token is num1
        token = strtok(NULL, " ");
        if (token == NULL) {
            continue; //invalid input
        }

        char* endptr;
        long num1 = strtol(token, &endptr, 10);
        if (*endptr != '\0') {
            continue; //invalid number
        }

        //third token is num2
        token = strtok(NULL, " ");
        if (token == NULL) {
            continue; //invalid input
        }
        long num2 = strtol(token, &endptr, 10);
        if (*endptr != '\0') {
            continue; //invalid number
        }


        char libname[30];
        snprintf(libname, sizeof(libname), "./lib%s.so", op);

        void* handle = dlopen(libname, RTLD_LAZY);

        //if loading fails, we print error and continue
        if (handle == NULL) {
            fprintf(stderr, "Error: could not load %s\n", libname);
            continue;
        }

        dlerror();

        int (*func)(int, int);

        *(void **)(&func) = dlsym(handle, op); //avoids undefined behavior

        char* error = dlerror();
        if (error != NULL) {
            fprintf(stderr, "Error: could not find function %s\n", op);
            dlclose(handle); //freeing the library before continuing
            continue;
        }

        int res = func(num1, num2);
        printf("%d\n", res);

        dlclose(handle); //freeing the library after use to not exceed mem limits
    }


    return 0;
}

