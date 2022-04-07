#include <stdio.h>
#include <stdint.h>

#define ROWS 2
#define COLS 3

int sumarrayrows(int a[ROWS][COLS]) 
{ 
    int i, j, sum = 0;

    for (i = 0; i < ROWS; i++) {
        for (j = 0; j < COLS; j++){
            printf("[%d][%d] = %0x \n", i, j, &a[i][j]);
            sum += a[i][j];
        }
    }

   return sum; 
}

int sumarraycols(int a[ROWS][COLS]) 
{ 
    int i, j, sum = 0;

    for (j = 0; j < COLS; j++){
        for (i = 0; i < ROWS; i++) {
            printf("[%d][%d] = %0x \n", i, j, &a[i][j]);
            sum += a[i][j];
        }
    }

    return sum; 
}

int main(){
    int array[ROWS][COLS];
    int x = sumarrayrows(array);
    printf("\nsumarraycols:\n");
    int y = sumarraycols(array);
    printf("%d", x);
    printf("%d", x);
}