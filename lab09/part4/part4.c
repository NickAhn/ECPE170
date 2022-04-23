#include <stdio.h>

int main()
{
   int A[5]; // Empty memory region for 5 elements
   int B[5] = {1,2,3,4,5};
   int C=12;
   int i;

   for(i=0; i<5; i++)
   {
      A[i] = B[i] + C;
      printf("%d\n", A[i]);
   } 

   i--;
   while(i >= 0)
   {
      A[i]=A[i]*2;
      i--;
   } 
}