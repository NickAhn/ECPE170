//Nicolas Ahn
//n_ahn2@u.pacific.edu
#include "board.h"
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include "ship.h"
#include <time.h>

struct Board initBoard(int size){
    struct Board b;
    b.size = size;
    b.shipsSunk = 0;
    b.wins = 0;
    b.board = (char**)malloc(sizeof(char*)*b.size); 
    b.shipLocations = (char**)malloc(sizeof(char*)*b.size); 
    b.ships = malloc(sizeof(struct Ship)*4); 
    b.shells = (b.size*b.size)/2;
    b.minShellsNeeded = 11;

    for(int i=0; i<size; i++){
        b.board[i] = (char*)malloc(sizeof(char)*b.size); //Free
        b.shipLocations[i] = (char*)malloc(sizeof(char)*b.size); //free
    }
    
    fillBoard(&b);
    

    return b;
};

void resetBoard(struct Board* b){
    int size = b->size;
    fillBoard(b);
    generateShips(b);

    b->shipsSunk = 0;
    b->shells = (size*size)/2;
    b->minShellsNeeded = 11;
}


bool addShipToBoard(struct Board b, struct Ship *s){
    //check for any obstructions
    for(int i = 0; i<s->length; i++){
        if(s->isVertical){
            if(b.shipLocations[s->row+i][s->col] != '-') return false;
        }else{
            if(b.shipLocations[s->row][s->col+i] != '-') return false;
        }
    }

    //add ship to board
    for(int i = 0; i<s->length; i++){
        if(s->isVertical){
            b.shipLocations[s->row+i][s->col] = s->type;
        }else{
            b.shipLocations[s->row][s->col+i] = s->type;
        }
    }

    return true;
}


void freeBoard(struct Board b){
    for(int i=0; i<b.size; i++){
        free(b.board[i]);
        free(b.shipLocations[i]);
    }
    free(b.board);
    free(b.shipLocations);
    free(b.ships);
};


void fillBoard(struct Board* b){
    //FILL BOARD
    for(int row = 0; row<b->size; row++){
        for(int col = 0; col<b->size; col++){
            b->board[row][col] = '-';
            b->shipLocations[row][col] = '-';
        }
    }
}


void printBoard(struct Board b){
    for(int col = 0; col<b.size+1; col++){
        if(col == 0) 
            printf("   ");
        else{
            char ascii = (char)(65+col-1);
            printf("%c ", ascii);
        } 
    }

    printf("\n");

    for(int row=0; row<b.size; row++){
        int num = row+1;
        if(num >= 10) printf("%d|", num);
        else printf("%d |", num);

        for(int col=0; col<b.size; col++){
            printf("%c ", b.board[row][col]);
        }
        printf("\n");
    }
};


void printShipLocations(struct Board b){
    for(int col = 0; col<b.size+1; col++){
        if(col == 0) 
            printf("   ");
        else{
            char ascii = (char)(65+col-1);
            printf("%c ", ascii);
        } 
    }

    printf("\n");

    for(int row=0; row<b.size; row++){
        int num = row+1;
        if(num >= 10) printf("%d|", num);
        else printf("%d |", num);

        for(int col=0; col<b.size; col++){
            printf("%c ", b.shipLocations[row][col]);
        }
        printf("\n");
    }
};


void shoot(struct Board* b, int row, int col){
    //row = digit-1, col = letter-65
    if(row < 0 || row >= b->size || col < 0 || col >= b->size){//out of bounds
        printf("\nInvalid Coordinates... please enter something withing the board!\n\n");
        return;
    }

    if(b->shipLocations[row][col] != '-'){ //hit
        printf("\n%c%d is a Hit\n\n", col+65, row+1);
        b->board[row][col] = 'h';
        

        struct Ship shipHit = whichShip(*b, row, col);
        if(isSunk(*b, shipHit)){ //if ship is sunk
            revealShip(b, shipHit);
        }else{
            b->minShellsNeeded -= 1;
        }

        b->shells -= 1;
        return;
    }

    //miss
    printf("\n%c%d is a Miss\n\n", col+65, row+1);
    b->board[row][col] = 'm';
    b->shells -= 1;
    return;
};


/* Find which ship was hit */
struct Ship whichShip(struct Board b, int row, int col){
    struct Ship temp = { .row = 2, .col = 0, .length = 5, .isVertical=false, .type = 'c'};
    for(int i = 0; i<4; i++){ //each ship
        for(int j = 0; j<b.ships[i].length; j++){ //while not end of length
            if(b.ships[i].isVertical && b.ships[i].col == col){ //if is vertical and column matches shoot col
                if(b.ships[i].row+j == row){
                    return b.ships[i];
                }
            }else if(!b.ships[i].isVertical && b.ships[i].row == row){
                if(b.ships[i].col+j == col){
                    return b.ships[i];
                }
            }
        }
    }

    return temp;
}

// void printShipsInfo(struct Board b){
//     for(int i=0; i<4; i++){
//         printf("ship[%d] (%d,%d), type=%c, isVert=%d\n", i, b.ships[i].row, b.ships[i].col, b.ships[i].type, b.ships[i].isVertical);
//     }
// }

/* Check if 70% of the ship was hit */
bool isSunk(struct Board b, struct Ship s){ //pop ship after finding? better time?
    int hitNums = 0;
    for(int i = 0; i<s.length; i++){
        if(s.isVertical == true && b.board[s.row+i][s.col] == 'h'){
            hitNums += 1;
        }
        
        if(s.isVertical == false && b.board[s.row][s.col+i] == 'h'){
            hitNums += 1;
        }
    }

    if(hitNums > s.length*(0.7)){
        return true;
    }

    return false;
}


void revealShip(struct Board* b, struct Ship s){
    for(int i = 0; i<s.length; i++){
        if(s.isVertical == true && b->board[s.row+i][s.col] != 'h'){
            b->board[s.row+i][s.col] = s.type;
            b->minShellsNeeded -= 1;
        }else if(!s.isVertical && b->board[s.row+i][s.col] != 'h') {
            b->board[s.row][s.col+i] = s.type;
            b->minShellsNeeded -= 1;
        }
    }
    b->shipsSunk += 1;
}

