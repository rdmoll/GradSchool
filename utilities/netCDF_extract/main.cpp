////////////////////////////////////////////////////////////////////////////////
//
//  Project Files  : main.cpp ReadNetCDF.cpp ReadNetCDF.h Makefile
//  Author         : Ryan Moll
//  Date Modified  : October 22, 2017
//  Purpose        : Reads simdat files and calculates average fluxes and KE as
//                  a function of depth
//
////////////////////////////////////////////////////////////////////////////////

#include <iostream>
#include <netcdf.h>
#include "ReadNetCDF.h"

int main(int argc, char *argv[])
{
  ReadNetCDF::ReadNetCDF simdatFile(argv[1]);

  // Print file name
  std::cout << std::endl;
  std::cout << "Filename: " << argv[1] << std::endl;
  std::cout << std::endl;

  // Open file for writing
  simdatFile.PrintParams();
  simdatFile.ReadData(2);

  simdatFile.Calc(0);
  simdatFile.Calc(1);
  simdatFile.Calc(2);
  simdatFile.Calc(3);
  simdatFile.Calc(4);

  simdatFile.WriteData(argv[2]);

  std::cout << std::endl;
  std::cout << "Program Complete!" << std::endl;
  std::cout << std::endl;
}
