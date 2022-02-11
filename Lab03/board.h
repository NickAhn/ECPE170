#ifndef BOARD_H
#define BOARD_H

struct Board{
    char** board;
    int size;

};

struct Board initBoard(int size);
void freeBoard(struct Board b, int size);
void printBoard();


#endif