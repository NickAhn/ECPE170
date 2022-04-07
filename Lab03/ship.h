// Nicolas Ahn
// n_ahn2@u.pacific.edu
#ifndef SHIP_H
#define SHIP_H

#include <stdio.h>
#include <stdbool.h>
#include "board.h"

struct Ship{
    int row, col;
    int length; //use as "hp", everytime it is shot, -= 1. if it is <70%, isDead = true;
    int isVertical;
    char type;
};

void generateShips(struct Board* b);

void generateShipsFromFile(struct Board* b, char* file);

// struct Ship* generateRandomShip(char type, int boardSize);

#endif



