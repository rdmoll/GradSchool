#ifndef READNETCDF_H
#define READNETCDF_H

#include <iostream>
#include <netcdf.h>
#include <vector>

#include "ReadNetCDF.h"

#define ERRCODE 2
#define ERR(e) {printf("Error: %s\n", nc_strerror(e)); exit(ERRCODE);}

namespace ReadNetCDF
{
  class ReadNetCDF
  {
    public:
      int funcNum;

      ReadNetCDF( const char* );
      ~ReadNetCDF();
      void PrintParams();
      void ReadData( size_t );
      void Calc( int );
      void WriteData( const char* );

    protected:
      typedef void (ReadNetCDF::*functionArray)(int,int,int,int);

      int retval,ncid;
      int dimid_x,dimid_y,dimid_z,dimid_time;
      int varid_Gx,varid_Gy,varid_Gz;
      int varid_ux,varid_uy,varid_uz,varid_T,varid_C;
      size_t dimlen_x,dimlen_y,dimlen_z,dimlen_time;
      float Gammax,Gammay,Gammaz;

      std::vector<float> ux;
      std::vector<float> uy;
      std::vector<float> uz;
      std::vector<float> T;
      std::vector<float> C;

      std::vector<std::vector<float> > CalcVars;
      std::vector<functionArray> AllFuncs;
      std::vector<int> funCount;
      void Tav( int,int,int,int );
      void Cav( int,int,int,int );
      void uzT( int,int,int,int );
      void uzC( int,int,int,int );
      void KEav( int,int,int,int );
  };
}

#endif //READNETCDF_H
