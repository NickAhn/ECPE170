//Nicolas Ahn
//n_ahn2@u.pacific.edu
#include "ship.h"
#include "board.h"
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <errno.h>

void init(int argc, char *argv[]){
    int boardSize;
    char keepPlaying = 'y';
    int gamesPlayed = 0;
    printf("Welcome to Frigate!\n");
    printf("\nHow large should I make the grid? ");
    scanf("%d", &boardSize);
    if(boardSize < 5){
        printf("The minimum grid size is 5... I'll create one that size.\n");
        boardSize = 5;
    }

    printf("\n");
    // boardSize = 6;
    // printf("Making a 6x6 board...\n");

    while(keepPlaying == 'y' || keepPlaying == 'Y'){
        gamesPlayed += 1;
        struct Board b = initBoard(boardSize);
        if(argc > 1){
            generateShipsFromFile(&b, argv[1]);
        }else{
            generateShips(&b); 
        }
        
        startGame(b);
        // return; //TODO: return

        char answer;
        printf("\nPlay Again (y/N)?");
        scanf(" %c", &answer);
        if(answer == 'n' || answer == 'N'){
            printf("You won %d out of %d games\n", b.wins, gamesPlayed);
            freeBoard(b);
            break;
        }
        
        resetBoard(&b);
    }
}


void startGame(struct Board b){
    // printShipLocations(b);

    while(true){
        char test[10];

        if(b.minShellsNeeded > b.shells){
            printf("You do not have enough shells left to sink the remaining ships.\nHere is the original ship locations.\n");
            printShipLocations(b);
            printf("\nYou sunk %d ships.\n", b.shipsSunk);
            return;
        }

        printBoard(b);
        // return; //TODO: delete
        printf("\nEnter the coordinates for your shot (%d shots remaining): ", b.shells);
        scanf("%s", test);

        int i=0;
        char currChar = test[i];
        int digit = 0;
        int letter = 0;

        //parse coordinates
        if((int)currChar >= 65){
            letter = (int)(toupper(currChar)) - 65;
            currChar = test[++i];
        }
        while((int)currChar >= 48 && (int)currChar <= 57){
            digit = digit*10 + (currChar - 48);
            currChar = test[++i];
        }
        if((int)currChar >= 65){
            letter = (int)(toupper(currChar)) - 65;
            currChar = test[++i];
        }
        
        shoot(&b, digit-1, letter);

        //if all ships were sunk, end game.
        if(b.shipsSunk == 4){
            b.wins += 1; //TODO add loss function (+= counter)
            printf("\nYou win!\n");
            printf("\nYou sunk %d ships\n", b.shipsSunk);
            break;
        }
    }
}


int main(int argc, char *argv[]){
    init(argc, argv);
}
