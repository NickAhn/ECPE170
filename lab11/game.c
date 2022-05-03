#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

m_w = 123;    /* must not be zero */ 
m_z = 456; /* must not be zero */
int board_size = 54;

/*
 Prompt the user for two random numbers to use as seeds (for m_w and m_z),
 so your program doesn't produce the same random number sequence each time.
*/
uint32_t get_random()
{
  m_z = 36969 * (m_z & 65535) + (m_z >> 16);
  m_w = 18000 * (m_w & 65535) + (m_w >> 16);
  return (m_z << 16) + m_w; /* 32-bit result */
}

uint32_t random_in_range(uint32_t low, uint32_t high)
{
  uint32_t range = high-low+1;
  uint32_t rand_num = get_random();

  return (rand_num % range) + low;
}

void print_board(char* board){

    printf("  1 2 3 4 5 6 7 \n");
    printf("-----------------");
    for(int i = 0; i<board_size; i++){
        if(i % 9 == 0){
            printf("\n");
        }
        printf("%c ", board[i]);
    }
    
    printf("\n-----------------\n");
}

/*
Function to drop 'token' in board at position 'pos'
If column is not full, drop token in the next available space and return 1.
Otherwise, return 0.
*/
int* drop_token(char* board, char token, int pos){
    int i = pos+45;
    int* location = calloc(2, sizeof(int));

    if(board[pos] == '.'){
        while(i >= pos){
            if(board[i] == '.'){
                board[i] = token;
                location[0] = 1;
                location[1] = i;
                return location;
            }

            i-=9;
       }
    }

    location[0] = 0;
    location[1] = 0;
    return location;
}

int check_direction(char* board, char player, int pos, int offset){
    int count = 1;
    
    int i; // index of position in board
    int startCol = (pos%9)+1; // counter to make sure it doesn't wrap around
    int colCounter = 1;
    for(int j = 0; j<2; j++){
        i = pos;
        while(i < board_size && i > 0 ){
            i +=  offset;
            if(startCol < 0 || startCol > 8) break;

            if(board[i] == player){
                count++;
            } else {
                break;
            }
            if(offset != 9)
                startCol += colCounter;
        }
        offset *= -1; // change direction of checking
        colCounter *= -1;
        startCol = (pos%9)+colCounter;
    }

    return count >= 5;
}

int check_win(char* board, char player, int pos){
    return check_direction(board, player, pos, 9) // check vertically 
        || check_direction(board, player, pos, 10) // check up-left/down-right
        || check_direction(board, player, pos, -8) // check down-left/up-right
        || check_direction(board, player, pos, 1) //horizontal check
        ;

}

int main(){
    printf("Welcome to Connect Four, Five-in-a-Row variant!\n");
    printf("Version 1.0\nImplemented by Nicolas Ahn\n\n");

    printf("Enter two positive numbers to initialize the random number generator.\n");
    printf("Number 1: ");
    scanf("%d", &m_w);
    printf("Number 2: ");
    scanf("%d", &m_z);

    printf("HUMAN player (H)\nCOMPUTER player (C)");

    //choose which player goes first
    int coin_flip = get_random() % 2; //if 1, HUMAN goes first. If 0, COMPUTER goes first.
    printf("Coin toss... ");
    if(coin_flip == 0) printf("HUMAN goes first.\n\n");
    else printf("COMPUTER goes first.\n\n");

    char* board = (char*)calloc(board_size, sizeof(char));

    // Set up board
    for(int i = 0; i<board_size; i++){
        if(i % 9 == 0 || (i+1) % 9 == 0){
            if(i%2 == 0)
                board[i] = 'C';
            else
                board[i] = 'H';
        }else
            board[i] = '.';
    }

    print_board(board);

    /* Start Game */
    int isOver = 0; //flag: 0 = game not over; 1 = game over;
    int pos; // Position to drop token
    int* location;
    while(isOver == 0){
        int isValidMove = 0;
        while(isValidMove == 0){
            if(coin_flip == 0){ // HUMAN's turn
                printf("What column would you like to drop token into? Enter 1-7: ");
                scanf("%d", &pos);

                location = drop_token(board, 'H', pos);
                isValidMove = location[0]; //0 or 1 
                if(!isValidMove){
                    printf("Column is full.\n\n");
                    continue;
                }
                isOver = check_win(board, 'H', location[1]); // check

            }else{ // COMPUTER's turn
                pos = random_in_range(1,7);

                location = drop_token(board, 'C', pos);
                isValidMove = location[0];
                if(isValidMove){
                    printf("COMPUTER player selected column %d\n\n", pos);
                    print_board(board);
                    isOver = check_win(board, 'C', location[1]);
                }
            }

        }
        coin_flip = (coin_flip + 1) % 2; //update coin to pass turn to other player
    }
    printf("\n - Final Board -\n");
    print_board(board);
    if(board[location[1]] == 'H')
        printf("Congratulations, Human Wins!\n");
    else
        printf("Congratulations, Computer Wins!\n");

}

