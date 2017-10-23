// Prac5 -- finds element in array that occurs only once

#include <iostream>
#include <vector>

int main()
{
  int i,j;
  int present=0;
  int count=0;
  int countInst=0;
  int TestArr[] = {3,3,5,6,4,5,4};

  int numInts = sizeof(TestArr)/sizeof(TestArr[0]);

  std::vector<int> vals(numInts,0);

  for(i=0; i<numInts; i++)
  {
    for(j=0; j<numInts; j++)
    {
      if(TestArr[i] == vals[j])
      {
        present = 1;
        break;
      }
    }
    if(!present)
    {
      vals[count] = TestArr[i];
      count++;
    }
    else
    {
      present = 0;
    }
  }

  for(i=0; i<count; i++)
  {
    std::cout << vals[i] << std::endl;
  }

  std::cout << std::endl;
  for(i=0; i<count; i++)
  {
    for(j=0; j<numInts; j++)
    {
      if(vals[i]==TestArr[j])
      {
        countInst++;
      }
    }
    if(countInst==1)
    {
      std::cout << vals[i] << std::endl;
      break;
    }
    countInst = 0;
  }

  return 0;
}
