// Prac1 -- Finds the most frequent integer in an array of integers

#include <iostream>
#include <vector>

int main()
{
  int i,j,maxVal,maxPos,present,count=0;
  int TestArr[] = {3,4,4,6,2,7,8,8,9,4};
  int NumInts = sizeof(TestArr)/sizeof(TestArr[0]);

  //std::cout << NumInts << std::endl;

  std::vector<int> vals(NumInts,0.0);
  std::vector<int> instances(NumInts,0.0);

  for(i=0; i<NumInts; i++)
  {
    for(j=0; j<NumInts; j++)
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

  for(i=0; i<NumInts; i++)
  {
    for(j=0; j<count; j++)
    {
      if(TestArr[i] == vals[j])
      {
        instances[j]++;
      }
    }
  }

  std::cout << std::endl;
  for(i=0; i<count; i++)
  {
    std::cout << instances[i] << std::endl;
  }

  for(i=0; i<count; i++)
  {
    if(instances[i]>maxVal)
    {
      maxVal = instances[i];
      maxPos = i;
    }
  }

  std::cout << std::endl;
  std::cout << "Max Val. : " << vals[maxPos] << "  Num. Inst. : " << maxVal << std::endl;

  return 0;
}
