MODULE DensGrad_mod
implicit none

REAL(8),PARAMETER    :: small  = 1e-6
REAL(8),PARAMETER    :: pi     = acos(-1.0)
REAL(8),PARAMETER    :: param  = ( acos(-1.0) )/50.0

CONTAINS

  INCLUDE "DensGrad_Calc1.f90"
  INCLUDE "DensGrad_Calc2.f90"

END MODULE DensGrad_mod
