//Nicolas Ahn
//n_ahn2@u.pacific.edu
#ifndef BOARD_H
#define BOARD_H
#include <stdbool.h>

struct Board{
    char** board; //shows current state of board
    char** shipLocations;
    int size;
    struct Ship* ships;
    int shipsSunk;
    int wins;
    int shells; //grid size^2/2
    int minShellsNeeded; //c = 4, b = 3, f = 2

};

void startGame(struct Board b);

struct Board initBoard(int size); //allocate memory and fill board

void freeBoard(struct Board b); 

void fillBoard(struct Board* b); 

void printBoard();

void printShipLocations();

void addShipsToBoard();

void shoot(struct Board* b, int row, int col); //row = number, col = letter

struct Ship whichShip(struct Board b, int row, int col);

bool isSunk(struct Board b, struct Ship);

void revealShip(struct Board* b, struct Ship s);

bool addShipToBoard(struct Board b, struct Ship *s);

void resetBoard(struct Board* b);


#endif