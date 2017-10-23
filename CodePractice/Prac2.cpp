// Prac2 -- Finds 2 intgers in an array of integers that sum to 10

#include <iostream>

int main()
{
  int i,j;
  int ten = 0;
  int iPos1 = 0;
  int iPos2 = 0;
  int int1 = 0;
  int int2 = 0;
  int TestArr[] = {9,14,14,16,2,7,8,8,9,4};
  int NumInts = sizeof(TestArr)/sizeof(TestArr[0]);

  for(j=iPos1; j<NumInts; j++)
  {
    for(i=iPos1; i<NumInts; i++)
    {
      if(TestArr[i] < 10)
      {
        int1 = TestArr[i];
        iPos1 = i;
        break;
      }
    }

    for(i=iPos1+1; i<NumInts; i++)
    {
      if(TestArr[i] == (10-int1))
      {
        int2 = TestArr[i];
        ten = 1;
        break;
      }
    }
    if(ten)
    {
      break;
    }
    else
    {
      iPos1++;
    }
  }

  std::cout << "int1: " << int1 << std::endl;
  std::cout << "int2: " << int2 << std::endl;

  return 0;
}
