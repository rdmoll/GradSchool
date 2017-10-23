// Prac8 -- Determines if there are repeat characters in a string

#include <iostream>
#include <string>

int main()
{
  int i,j;
  int count;
  std::string testStr1("djnritrwp");
  std::string testStr2 = testStr1;

  for(i=0; i<testStr1.size(); i++)
  {
    for(j=0; j<testStr2.size(); j++)
    {
      if(testStr1[i] == testStr2[j])
      {
        count++;
      }
    }
    if(count>1)
    {
      std::cout << "Not unique" << std::endl;
      return 0;
    }
    count = 0;
  }

  std::cout << "All characters unique" << std::endl;

  return 0;
}
