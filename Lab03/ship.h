// Nicolas Ahn
// n_ahn2@u.pacific.edu
#ifndef SHIP_H
#define SHIP_H

#include <stdio.h>
#include <stdbool.h>

struct ship{
    int row, col;
    int size;
    bool isDead;
    bool isVertical;
    char type[10];
};

#endif