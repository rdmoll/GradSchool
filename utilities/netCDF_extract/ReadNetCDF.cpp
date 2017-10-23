#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <fstream>
#include <string>
#include <iomanip>
#include <vector>
#include <netcdf.h>

#include "ReadNetCDF.h"

namespace ReadNetCDF
{
  ReadNetCDF::ReadNetCDF(const char* filename)
  {
    int totLength;

    // Open file for read
    if ((retval = nc_open(filename,NC_NOWRITE,&ncid))){ERR(retval);}

    // Get dimension sizes
    if ((retval = nc_inq_dimid(ncid,"X",&dimid_x))){ERR(retval);}
    if ((retval = nc_inq_dimlen(ncid,dimid_x,&dimlen_x))){ERR(retval);}
    if ((retval = nc_inq_dimid(ncid,"Y",&dimid_y))){ERR(retval);}
    if ((retval = nc_inq_dimlen(ncid,dimid_y,&dimlen_y))){ERR(retval);}
    if ((retval = nc_inq_dimid(ncid,"Z",&dimid_z))){ERR(retval);}
    if ((retval = nc_inq_dimlen(ncid,dimid_z,&dimlen_z))){ERR(retval);}
    if ((retval = nc_inq_dimid(ncid,"TIME",&dimid_time))){ERR(retval);}
    if ((retval = nc_inq_dimlen(ncid,dimid_time,&dimlen_time))){ERR(retval);}

    // Get lengths
    if ((retval = nc_inq_varid(ncid,"Gammax",&varid_Gx))){ERR(retval);}
    if ((retval = nc_get_var_float(ncid,varid_Gx,&Gammax))){ERR(retval);}
    if ((retval = nc_inq_varid(ncid,"Gammay",&varid_Gy))){ERR(retval);}
    if ((retval = nc_get_var_float(ncid,varid_Gy,&Gammay))){ERR(retval);}
    if ((retval = nc_inq_varid(ncid,"Gammaz",&varid_Gz))){ERR(retval);}
    if ((retval = nc_get_var_float(ncid,varid_Gz,&Gammaz))){ERR(retval);}

    // Get variable ID
    if ((retval = nc_inq_varid(ncid,"ux",&varid_ux))){ERR(retval);}
    if ((retval = nc_inq_varid(ncid,"uy",&varid_uy))){ERR(retval);}
    if ((retval = nc_inq_varid(ncid,"uz",&varid_uz))){ERR(retval);}
    if ((retval = nc_inq_varid(ncid,"Temp",&varid_T))){ERR(retval);}
    if ((retval = nc_inq_varid(ncid,"Chem",&varid_C))){ERR(retval);}

    totLength = dimlen_x*dimlen_y*dimlen_z;

    ux.resize(totLength,0.0);
    uy.resize(totLength,0.0);
    uz.resize(totLength,0.0);
    T.resize(totLength,0.0);
    C.resize(totLength,0.0);

    AllFuncs.push_back(&ReadNetCDF::Tav);
    AllFuncs.push_back(&ReadNetCDF::Cav);
    AllFuncs.push_back(&ReadNetCDF::uzT);
    AllFuncs.push_back(&ReadNetCDF::uzC);
    AllFuncs.push_back(&ReadNetCDF::KEav);

    funcNum = AllFuncs.size();

    CalcVars.resize(funcNum,std::vector<float>(dimlen_z,0.0));
  }

  ReadNetCDF::~ReadNetCDF()
  {
    if ((retval = nc_close(ncid))){ERR(retval);}
  }

  void ReadNetCDF::PrintParams()
  {
    // Print out experiment parameters
    std::cout << "-- Experiment Parameters --" << std::endl;
    std::cout << std::endl;
    std::cout << "Time Steps = " << dimlen_time << std::endl;
    std::cout << std::endl;
    std::cout << "Nx         = " << dimlen_x << std::endl;
    std::cout << "Ny         = " << dimlen_y << std::endl;
    std::cout << "Nz         = " << dimlen_z << std::endl;
    std::cout << std::endl;
    std::cout << "Lx         = " << Gammax << std::endl;
    std::cout << "Ly         = " << Gammay << std::endl;
    std::cout << "Lz         = " << Gammaz << std::endl;
    std::cout << std::endl;
  }

  void ReadNetCDF::ReadData(size_t ts)
  {
    size_t start[4],count[4];

    count[0] = 1;
    count[1] = dimlen_x;
    count[2] = dimlen_y;
    count[3] = dimlen_z;
    start[1] = 0;
    start[2] = 0;
    start[3] = 0;

    start[0] = ts;

    if ((retval = nc_get_vara_float(ncid,varid_ux,start,count,&ux[0]))){ERR(retval);}
    if ((retval = nc_get_vara_float(ncid,varid_uy,start,count,&uy[0]))){ERR(retval);}
    if ((retval = nc_get_vara_float(ncid,varid_uz,start,count,&uz[0]))){ERR(retval);}
    if ((retval = nc_get_vara_float(ncid,varid_T,start,count,&T[0]))){ERR(retval);}
    if ((retval = nc_get_vara_float(ncid,varid_C,start,count,&C[0]))){ERR(retval);}
  }

  void ReadNetCDF::Tav(int i,int j,int k,int var)
  {
    int index = dimlen_y*dimlen_x*k + dimlen_x*j + i;
    CalcVars[var][k] = CalcVars[var][k] + T[index];
  }

  void ReadNetCDF::Cav(int i,int j,int k,int var)
  {
    int index = dimlen_y*dimlen_x*k + dimlen_x*j + i;
    CalcVars[var][k] = CalcVars[var][k] + C[index];
  }

  void ReadNetCDF::uzT(int i,int j,int k,int var)
  {
    int index = dimlen_y*dimlen_x*k + dimlen_x*j + i;
    CalcVars[var][k] = CalcVars[var][k] + uz[index]*T[index];
  }

  void ReadNetCDF::uzC(int i,int j,int k,int var)
  {
    int index = dimlen_y*dimlen_x*k + dimlen_x*j + i;
    CalcVars[var][k] = CalcVars[var][k] + uz[index]*C[index];
  }

  void ReadNetCDF::KEav(int i,int j,int k,int var)
  {
    int index = dimlen_y*dimlen_x*k + dimlen_x*j + i;
    CalcVars[var][k] = CalcVars[var][k] + 0.5*(ux[index]*ux[index]
                                             + uy[index]*uy[index]
                                             + uz[index]*uz[index]);
  }

  void ReadNetCDF::Calc(int var)
  {
    funCount.push_back(var);
    for(int k=0; k<dimlen_z; k++)
    {
      for(int j=0; j<dimlen_y; j++)
      {
        for(int i=0; i<dimlen_x; i++)
        {
          (this->*AllFuncs[var])(i,j,k,var);
        }
      }
      CalcVars[var][k] /= dimlen_x*dimlen_y;
    }
  }

  void ReadNetCDF::WriteData(const char* cppOutput)
  {
    std::ofstream fileHandle;
    fileHandle.open(cppOutput);

    for(int k=0; k<dimlen_z; k++)
    {
      std::cout << k << " : ";
      fileHandle << std::setw(15) << std::right << k;
      for(int fun=0; fun<funCount.size(); fun++)
      {
        std::cout << CalcVars[fun][k] << "  ";
        fileHandle << std::setw(15) << std::right << CalcVars[funCount[fun]][k];
      }
      std::cout << std::endl;
      fileHandle << std::endl;
    }

    fileHandle.close();
  }
}
