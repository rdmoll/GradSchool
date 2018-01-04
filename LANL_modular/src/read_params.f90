SUBROUTINE read_params

  use prec_param_mod
  use exp_params_mod

  INTEGER             ::  number_r_steps, time_steps
  REAL(prec)          ::  domain_size, cfl_factor, initial_time_step, adiabatic_index
  REAL(prec)          ::  inner_boundary, initial_pressure, initial_T_gas, density_change
  REAL(prec)          ::  initial_en_pulse, ionization_fraction
  CHARACTER(len=100)  ::  output_file_name

  ! create namelist of items in parameter file
  NAMELIST /input_values/ number_r_steps
  NAMELIST /input_values/ domain_size
  NAMELIST /input_values/ time_steps
  NAMELIST /input_values/ cfl_factor
  NAMELIST /input_values/ initial_time_step
  NAMELIST /input_values/ adiabatic_index
  NAMELIST /input_values/ inner_boundary
  NAMELIST /input_values/ forced_region_zones
  NAMELIST /input_values/ initial_pressure
  NAMELIST /input_values/ initial_T_gas
  NAMELIST /input_values/ density_change
  NAMELIST /input_values/ initial_en_pulse
  NAMELIST /input_values/ ionization_fraction
  NAMELIST /input_values/ output_file_name

  ! open parameter file for reading and read data into namelist
  infile = 'param_file'
  open(30, file=infile, action='read')
  read(30, NML=input_values)

  ! set experiment parameters to values read from parameter file
  nr                = number_r_steps             ! number of grid zones
  Lr                = domain_size                ! physical size of domain in meters
  tsteps            = time_steps                 ! number of time steps to use
  cfl_fac           = cfl_factor                 ! set max timestep as fraction of CFL limit
  init_dt           = initial_time_step          ! initial time step size
  gamma             = adiabatic_index            ! self explanatory
  in_bound          = floor(nr*inner_boundary)   ! location of shell/fuel boundary as a fraction of total radius
  forced_zones      = forced_region_zones        ! number of zones to apply laser forcing to
  init_press        = initial_pressure           ! initial pressure in capsule
  init_T_gas        = initial_T_gas              ! initial gas temperature
  rho_fac           = density_change             ! ratio of shell density to gas density
  init_en_pulse     = initial_en_pulse           ! Power in Watts supplied by laser
  ion_frac          = ionization_fraction        ! fraction of atoms ionized by laser forcing
  outfile           = output_file_name           ! name of output file

END SUBROUTINE read_params
