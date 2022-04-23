#include <stdio.h>

int main()
{
  char string[256];
  int i=0;
  char *result = NULL;  // NULL pointer is binary zero
  
  // Obtain string from user, e.g. "Constantinople"
  scanf("%255s", string); 
  
  // Search string for letter 'e'.
  // Result is pointer to first e (if it exists)
  // or NULL pointer if it does not exist
  while(string[i] != '\0') {
    if(string[i] == 'e') {
      result = &string[i]; 
      break; // exit from while loop early
    }
    i++;
  }

  if(result != NULL) {
    printf("First match at address %d\n", result);
    printf("The matching character is %c\n", *result);
  }
  else
    printf("No match found\n");
}