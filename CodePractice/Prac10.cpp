// Prac10 -- Implementation of stack without using built-in functions

#include <iostream>
#include <vector>

template <class T>
class TestStack
{
  public:
    TestStack();
    ~TestStack();
    void TestPush( T );
    void TestPop( void );
    T TestLook( void );
  protected:
    int count;
    std::vector<T> stackVec;
    std::vector<T> tempVec;
};

template <class T>
TestStack<T>::TestStack()
{
  count=0;
}

template <class T>
TestStack<T>::~TestStack(){}

template <class T>
void TestStack<T>::TestPush(T val)
{
  int i;
  tempVec.resize(count+1);
  for(i=0; i<count; i++)
  {
    tempVec[i] = stackVec[i];
  }
  stackVec.resize(count+1);

  for(i=0; i<count; i++)
  {
    stackVec[i] = tempVec[i];
  }
  stackVec[count] = val;
  count++;
}

template <class T>
void TestStack<T>::TestPop()
{
  int i;

  if(count==0){ return; }

  tempVec.resize(count-1);
  for(i=0; i<count-1; i++)
  {
    tempVec[i] = stackVec[i];
  }
  stackVec.resize(count-1);

  for(i=0; i<count-1; i++)
  {
    stackVec[i] = tempVec[i];
  }
  count--;
}

template <class T>
T TestStack<T>::TestLook()
{
  if(count>0)
  {
    return stackVec[count-1];
  }
}

int main()
{
  TestStack <int> test;

  test.TestPush(5);
  test.TestPush(3);
  test.TestPush(7);
  test.TestPush(2);
  test.TestPush(1);
  test.TestPush(9);
  std::cout << test.TestLook() << std::endl;
  test.TestPop();
  test.TestPop();
  std::cout << test.TestLook() << std::endl;

  return 0;
}
