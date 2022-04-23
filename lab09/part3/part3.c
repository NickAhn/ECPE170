#include <stdio.h>

int main()
{
   int Z=2;
   int i;

   i=0;
   while(1){
     if(i>20)
       break;
    Z++;
    i+=2;
   }
 
   do {
      Z++;
   } while (Z<100);
  
   while(i > 0) {
      Z--;
      i--;
   }

   printf("%d, %d", Z, i);
    return 0;
}