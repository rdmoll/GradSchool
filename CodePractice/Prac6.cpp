// Prac6 -- multiplies 2 integers without using "*" operator

#include <iostream>
#include <cstdlib>
#include <string>

int main(int argc, char* argv[])
{
  int i;
  int prod=0;

  int int1 = std::atoi(argv[1]);
  int int2 = std::atoi(argv[2]);

  for(i=0; i<int2; i++)
  {
    prod += int1;
  }

  std::cout << prod << std::endl;
}
