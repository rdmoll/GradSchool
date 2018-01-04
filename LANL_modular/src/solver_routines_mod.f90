MODULE solver_routines_mod

CONTAINS

  INCLUDE "read_params.f90"
  INCLUDE "initialize.f90"
  INCLUDE "solve_eqns.f90"
  INCLUDE "comp_mat_coeffs.f90"
  INCLUDE "temp_mat_coeffs.f90"
  INCLUDE "visc_mat_coeffs.f90"
  INCLUDE "tri_diag.f90"
  INCLUDE "write_data.f90"
  INCLUDE "reset_arrays.f90"
  INCLUDE "finish.f90"

END MODULE solver_routines_mod
