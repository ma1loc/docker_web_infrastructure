#include <stdio.h>

int main() {
    char name[50]; // Declare a character array (string)

    printf("Enter your name (single word): ");
    scanf("%s", name); // Read a single word

    printf("Hello, %s!\n", name);

    return 0;
}

