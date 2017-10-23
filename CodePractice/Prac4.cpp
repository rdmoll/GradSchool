// Prac4 -- Generates numbers in the fibonacci series 

#include <iostream>

void FiboNums(int n,int m)
{
  if(n>25) return;

  std::cout << n << std::endl;

  FiboNums(m,n+m);
}

int main()
{

  int i,nOld,nNew,temp;
  int numVals = 10;

  nOld = 0;
  nNew = 1;

  std::cout << nNew << std::endl;
  for(i=0; i<numVals; i++)
  {
    temp = nNew;
    nNew = nNew + nOld;
    nOld = temp;
    std::cout << nNew << std::endl;
  }
  std::cout << std::endl;

  FiboNums(1,1);

  return 0;
}
