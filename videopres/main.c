#include <time.h>
#include <stdlib.h>
#include <stdio.h>

int main(){
    int size = 5;
    //Allocate memory for 2D array
    // int** matrix;
    int** matrix = (int**)malloc(sizeof(int*)*size);
    for(int i = 0; i<size; i++){
        matrix[i] = (int*)malloc(sizeof(int)*size);
    }

    int sum = 0;
    for(int i = 0; i<size; i++){
        for(int j = 0; j<size; j++){
            matrix[i][j] = 1;
            // printf("%d ", matrix[i][j]);
            sum += matrix[i][j];
        }
    }
	

    printf("Sum of all elements in matrix: %d", sum);

    // Deallocating 2D array
    for(int i = 0; i<size; i++){
	    free(matrix[i]);
    }
    free(matrix);
}
