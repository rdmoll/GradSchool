// Prac3 -- Determines if array is a rearranged version of another array

#include <stdio.h>
//#include <iostream>

int main()
{
  int i,j;
  int iNum1,iNum2,iNum3,iNum4;
  int count = 0;

  int testAr1[] = {1,2,3,4,5};
  int testAr2[] = {2,5,1,4,3};
  int testAr3[] = {1,2,7,4,5};
  int testAr4[] = {1,2,7,4,5,6};

  iNum1 = sizeof(testAr1)/sizeof(testAr1[0]);
  iNum2 = sizeof(testAr2)/sizeof(testAr2[0]);
  iNum3 = sizeof(testAr3)/sizeof(testAr3[0]);
  iNum4 = sizeof(testAr4)/sizeof(testAr4[0]);

  printf("array1 and array2\n");
  if(iNum1 != iNum2)
  {
    printf("no.\n");
  }
  else
  {
    for(i=0; i<iNum1; i++)
    {
      for(j=0; j<iNum2; j++)
      {
        if(testAr1[i]==testAr2[j])
        {
          count++;
        }
      }
    }
    if(count==iNum1)
    {
      printf("yes.\n");
    }
    else
    {
      printf("no.\n");
    }
  }

  count = 0;

  printf("array1 and array3\n");
  if(iNum1 != iNum3)
  {
    printf("no.\n");
  }
  else
  {
    for(i=0; i<iNum1; i++)
    {
      for(j=0; j<iNum3; j++)
      {
        if(testAr1[i]==testAr3[j])
        {
          count++;
        }
      }
    }
    if(count==iNum1)
    {
      printf("yes.\n");
    }
    else
    {
      printf("no.\n");
    }
  }

  count = 0;

  printf("array1 and array4\n");
  if(iNum1 != iNum4)
  {
    printf("no.\n");
  }
  else
  {
    for(i=0; i<iNum1; i++)
    {
      for(j=0; j<iNum4; j++)
      {
        if(testAr1[i]==testAr4[j])
        {
          count++;
        }
      }
    }
    if(count==iNum1)
    {
      printf("yes.\n");
    }
    else
    {
      printf("no.\n");
    }
  }

  count = 0;

  return 0;
}
