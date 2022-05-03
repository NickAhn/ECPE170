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
int drop_token(char* board, char token, int pos){
    int i = pos+45;
    if(board[pos] == '.'){
        while(i >= pos){
            if(board[i] == '.'){
                board[i] = token;
                return 1;
            }

            i-=9;
       }
   }

   return 0;
}

int main(){
    // int rows = 6;
    // int cols = 9;
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

    //choose which player goes first
    int coin_flip = get_random() % 2; //if 1, HUMAN goes first. If 0, COMPUTER goes first.

    /* Start Game */
    int isOver = 0; //flag: 0 = game not over; 1 = game over;
    int pos; // Position to drop token
    while(isOver == 0){
        int isValidMove = 0;
        while(isValidMove == 0){
            if(coin_flip == 0){ // HUMAN's turn
                printf("What column would you like to drop token into? Enter 1-7: ");
                scanf("%d", &pos);
                isValidMove = drop_token(board, 'H', pos);
                if(!isValidMove)
                    printf("Column is full.\n\n");

            }else{ // COMPUTER's turn
                pos = random_in_range(1,7);
                isValidMove = drop_token(board, 'C', pos);
                if(isValidMove){
                    printf("COMPUTER player selected column %d\n\n", pos);
                    print_board(board);
                }
            }

        }
        coin_flip = (coin_flip + 1) % 2; //update coin to pass turn to other player
    }

}

