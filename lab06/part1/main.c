#include <stdio.h>
#include <stdint.h>

int main(){
    int size = 2;
    printf("-- Memory Access of 2D Array in two different options:\n");
    printf(" - Option 1: Start at row=0, column=0. Step through each row until the end, then advance to the next column.\n");
    printf(" - Option 2: Start at row=0, column=0. Step through each column until the end, then advance to the next row.\n");


    printf("\nMemory addresses of Option 1:\n");
    uint32_t array[size][size];   // An 2-dimensional array of 4-byte (32-bit) unsigned integers, i.e. uint32_t
    for(int row = 0; row < size; row++){
        for(int col = 0; col < size; col++){
            printf("[%d][%d] = %0x \n", row, col, &array[row][col]);
        }
    }
    printf("\nMemory addresses of Option 2: \n");

    for(int col = 0; col < size; col++){
        for(int row = 0; row < size; row++){
            printf("[%d][%d] = %0x \n", row, col,&array[row][col]);
        }
    }

    printf("\n");

    uint32_t array2[size][size][size];  // 3D array    
    printf("\n-- Memory Access of 3D Array:");
    printf("\nMemory addresses in order i, j, k:\n");
    for(int i = 0; i < size; i++){
        for(int j = 0; j < size; j++){
            for(int k = 0; k < size; k++){
                printf("[%d][%d][%d] = %0x \n", i, j, k, &array2[i][j][k]);
            }
        }
    }

    printf("\nMemory addresses in order k, i, j:\n");
    for(int k = 0; k < size; k++){
        for(int i = 0; i < size; i++){
            for(int j = 0; j < size; j++){
                printf("[%d][%d][%d] = %0x \n", i, j, k, &array2[i][j][k]);
            }
        }
    }

    printf("\n\nAs shown, the memory addresses of 2D and 3D arrays are stored continguously. When we try to print the address of all cells of the array, its address representation increments by 4, which is the byte size of an unsigned int.");
}