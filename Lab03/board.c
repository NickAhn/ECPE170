#include "board.h"
#include <stdio.h>
#include <stdbool.h>

struct Board initBoard(int size){
    struct Board b;
    b.size = size;
    b.board = (char*)malloc(sizeof(char*)*b.size);
    for(int i=0; i<size; i++)
        b.board[i] = (char)malloc(sizeof(char)*b.size);
 
    return b;
}