// Prac7 -- Reverses string

#include <iostream>
#include <string>
#include <vector>

void reverseStr(std::string& testStr,std::string& revStr,int pos)
{
  if(pos<0) return;

  //std::cout << pos << "  " << testStr[pos] << std::endl;

  revStr.push_back(testStr[pos]);

  reverseStr(testStr,revStr,pos-1);
}

int main()
{
  int i;
  std::string test("teststring");
  std::string reversed;
  std::string reversedRec;

  for(i=0; i<test.size(); i++)
  {
    reversed.push_back(test[test.size()-i-1]);
  }

  std::cout << test << std::endl << reversed << std::endl;

  reverseStr(test,reversedRec,test.size()-1);

  std::cout << test << std::endl << reversedRec << std::endl;

  return 0;
}
