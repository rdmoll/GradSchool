MODULE exp_params_mod

  use prec_param_mod

  INTEGER             ::  i, t
  INTEGER             ::  nr, tsteps
  REAL(prec)          ::  time, dt, Lr

  LOGICAL             ::  nanDetected
  REAL(prec)          ::  gamma, cl, cQ, du, inv_rho_bar, dr_bar, ion_frac
  INTEGER             ::  forced_zones, in_bound
  REAL(prec)          ::  init_T_gas, init_press, rho_fac, vol_fac, dtheta, dphi, pi, r_bar, r_bar_sq
  REAL(prec)          ::  out_press, out_density, out_temp, cfl_fac, init_dt, init_en_pulse
  REAL(prec)          ::  highestPress, highestTemp, highestDensity, highEnergyTime

  CHARACTER(len=100)  ::  outfile, infile

  REAL(prec), ALLOCATABLE  ::  r(:,:), u(:,:), rho(:,:), Temp(:,:), P(:,:), Comp(:,:)
  REAL(prec), ALLOCATABLE  ::  dr(:,:), V(:,:), q(:), cs(:), N_part(:), M(:), vel_fac(:)
  REAL(prec), ALLOCATABLE  ::  ionized(:), N_elec(:), subdiag(:), diag(:), supdiag(:)
  REAL(prec), ALLOCATABLE  ::  vel_RHS(:), temp_RHS(:), forcing(:), r_sq(:)

END MODULE exp_params_mod
