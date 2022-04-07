//Nicolas Ahn
//n_ahn2@u.pacific.edu
#include "ship.h"
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include "board.h"
#include <ctype.h>

void generateShips(struct Board* b){
    // srand(time(0)); //TODO: add seed
    char types[4] = {'c', 'b', 'f', 'f'};
    for(int i = 0; i<4; i++){  //for each type of ships
        bool isValid = false;
        while(isValid == false){
            struct Ship* temp = malloc(sizeof(struct Ship)*1);
            int row, col;
            int shipLength = 0;
            switch(types[i]){
                case 'c':
                    shipLength = 5;
                    break;
                case 'b':
                    shipLength = 4;
                    break;
                case 'f':
                    shipLength = 2;
                    break;
            }
            
            int isVert = rand()%2;
            if(isVert == true){
                row = rand()%(b->size - shipLength+1);
                col = rand()%b->size;
            }else{
                row = rand()%b->size;
                col = rand()%(b->size - shipLength+1);
            }
            temp->row = row;
            temp->col = col;
            temp->type = types[i];
            temp->length = shipLength;
            temp->isVertical = isVert;
            struct Ship s = {.row = row, .col = col, .type = types[i], .length = shipLength, .isVertical=isVert};

            isValid = addShipToBoard(*b, temp);
            if(isValid)
                b->ships[i] = s;
            free(temp);
        }

    }    

}

void generateShipsFromFile(struct Board* b, char* file){
    FILE* input_file;
    char buffer[1000];
    
    input_file = fopen(file, "r");
    if(!input_file){
        generateShips(b);
    }
    else{
        printf("Could read");
        int i = 0;
        while(fgets(buffer, 1000, input_file) != NULL){
            if(buffer[0] == '#'){ //ignore lines with #
                printf("ingoring #\n");
                continue;
            }
            else{
                struct Ship* tempShip = malloc(sizeof(struct Ship) * 1);
                
                if(buffer[0] == 'c'){
                    tempShip->type = 'c';
                    tempShip->length = 5;
                    if(buffer[2] == 'r'){
                        tempShip->isVertical = 0;
                    }
                    else{
                        tempShip->isVertical = 1;
                    }
                    tempShip->col = toupper(buffer[4]) - 65;
                    tempShip->row = buffer[5] - 49;
                }
                else if(buffer[0] == 'b'){
                    tempShip->type = 'b';
                    tempShip->length = 4;
                    if(buffer[2] == 'r'){
                        tempShip->isVertical = 0;
                    }
                    else{
                        tempShip->isVertical = 1;
                    }
                    tempShip->col = toupper(buffer[4]) - 65;
                    tempShip->row = buffer[5] - 49;
                }
                if(buffer[0] == 'f'){
                    tempShip->type = 'f';
                    tempShip->length = 2;
                    if(buffer[2] == 'r'){
                        tempShip->isVertical = 0;
                    }
                    else{
                        tempShip->isVertical = 1;
                    }
                    tempShip->col = toupper(buffer[4]) - 65;
                    tempShip->row = buffer[5] - 49;
                }
                addShipToBoard(*b, tempShip);
                struct Ship s = {.row = tempShip->row, .col = tempShip->col, .type = tempShip->type, .length = tempShip->length, .isVertical=tempShip->isVertical};
                b->ships[i] = s;
                i++;
            }
        }
    }
    fclose(input_file);
}