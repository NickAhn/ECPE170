// ECPE 170 Presentation 2 Problem
//  Recursive function to sum elements in an array
//  e.g. arraySum([2,3,5,7,11]) has a result of 28

#include <stdio.h>

int arraySum(int* array, int arraySize);

int main()
{
   int array[] = {2, 3, 5, 7, 11};
   int arraySize = 5;
   int i;

   for(i=0; i<arraySize; i++)
    {
      printf("Array[%i]=%i\n", i, array[i]);
    }
   printf("Sum of array is %i\n", arraySum(array, arraySize ));
}

int arraySum(int* array, int arraySize)
{
   int result;

   if(arraySize == 0)
      result = 0;
   else
      result = *array + arraySum(&array[1], arraySize-1);

   return result;
}