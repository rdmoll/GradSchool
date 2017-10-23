// Prac9 -- Test of std::stack

#include <iostream>
#include <stack>

int main()
{
  int i,minVal;

  int TestArr[] = {65,64,33,82,55,48,31,74,92};
  std::stack<int> TestStack;

  int numInt = sizeof(TestArr)/sizeof(TestArr[0]);

  for(i=0; i<numInt; i++)
  {
    TestStack.push(TestArr[i]);
  }

  minVal = TestStack.top();
  TestStack.pop();
  while(!TestStack.empty())
  {
    if(TestStack.top() < minVal)
    {
      minVal = TestStack.top();
    }
    TestStack.pop();
  }

  std::cout << minVal << std::endl;

  return 0;
}
