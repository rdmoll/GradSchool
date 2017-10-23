PROGRAM CreateParamFile_rot
  implicit none

  INTEGER             :: argnum,fNum,ierr
  CHARACTER(len=35)   :: header,endLine
  CHARACTER(len=35)   :: restartDump,restartNetCDF,xfourier,yfourier,zfourier,dealias
  CHARACTER(len=35)   :: Therm_bouy,Comp_bouy,Visc_diff,Therm_diff,Comp_diff,Therm_strat,Comp_strat
  CHARACTER(len=35)   :: Rot_param,Rot_angle
  CHARACTER(len=35)   :: x_dim,y_dim,z_dim,init_ts,max_ts,CFL_fac,num_ts,save_state,save_netCDF
  CHARACTER(len=35)   :: restart_info,comp_diag,write_spec,write_prof
  CHARACTER(len=35)   :: write_state_comp,write_state_netCDF
  CHARACTER(len=35)   :: name_in_restart,name_out_restart
  CHARACTER(len=35)   :: name_comp,name_netCDF,name_diag,name_horiz,name_vert,name_prof
  CHARACTER(len=35)   :: use_FFTW_wisdom,name_FFTW_wisdom,num_task_1trans,num_task_2trans
  CHARACTER(len=30)   :: param_filename
  CHARACTER(len=30)   :: DUMP_prev,DUMP_new,j__data,simdat,OUT_new,XY_SPEC,Z_SPEC,ZPROF
  CHARACTER(len=4)    :: fNumStr
  CHARACTER(len=10)   :: Pr_str,tau_str,Rm1_str,rot_param_str,rot_angle_str
  CHARACTER(len=10)   :: xres_str,yres_str,zres_str,Lx_str,Ly_str,Lz_str
  CHARACTER(len=10)   :: restart_str,numTs_str,proc1_str,proc2_str
  CHARACTER(len=2)    :: str_num,str_num_prev,eqSgn

  param_filename  = 'sample_parameter_file'
  OPEN(20,FILE=adjustl(trim(param_filename)),STATUS='UNKNOWN',IOSTAT=ierr)

  header              = achar(38) // 'input_values'
  restartDump         = 'Restart_from_dumped_data          ='
  restartNetCDF       = 'Restart_from_netCDF_output_file   ='
  xfourier            = 'max_degree_of_x_fourier_modes     ='
  yfourier            = 'max_degree_of_y_fourier_modes     ='
  zfourier            = 'max_degree_of_z_fourier_modes     ='
  dealias             = 'dealiasing                        ='
  Therm_bouy          = 'Thermal_buoyancy_param            ='
  Comp_bouy           = 'Compositional_buoyancy_param      ='
  Visc_diff           = 'Viscous_diffusion_coeff           ='
  Therm_diff          = 'Thermal_diffusion_coeff           ='
  Comp_diff           = 'Compositional_diffusion_coeff     ='
  Therm_strat         = 'Thermal_stratif_param             ='
  Comp_strat          = 'Compositional_stratif_param       ='
  Rot_param           = 'Rotational_param                  ='
  Rot_angle           = 'Angle_rot_axis_gravity            ='
  x_dim               = 'x_extent_of_the_box               ='
  y_dim               = 'y_extent_of_the_box               ='
  z_dim               = 'z_extent_of_the_box               ='
  init_ts             = 'initial_time_step_length          ='
  max_ts              = 'maximum_time_step_length          ='
  CFL_fac             = 'CFL_safety_factor                 ='
  num_ts              = 'number_of_time_steps              ='
  save_state          = 'save_state_every_nth_timestep     ='
  save_netCDF         = 'save_state_netCDF_ev_nth_step     ='
  restart_info        = 'restart_info_every_nth_timestep   ='
  comp_diag           = 'comp_diagno_every_nth_timestep    ='
  write_spec          = 'write_spec_every_nth_timestep     ='
  write_prof          = 'write_prof_every_nth_timestep     ='
  write_state_comp    = 'write_state_to_compressed_file    ='
  write_state_netCDF  = 'write_state_to_netCDF_file        ='
  name_in_restart     = 'Name_of_input_restart_file        ='
  name_out_restart    = 'Name_of_output_restart_file       ='
  name_comp           = 'Name_of_compressed_data_file      ='
  name_netCDF         = 'Name_of_netCDF_data_file          ='
  name_diag           = 'Name_of_diagnostics_data_file     ='
  name_horiz          = 'Name_of_horizontal_spectra_file   ='
  name_vert           = 'Name_of_vertical_spectra_file     ='
  name_prof           = 'Name_of_z_profile_file            ='
  use_FFTW_wisdom     = 'Use_an_FFTW_wisdom_file           ='
  name_FFTW_wisdom    = 'Name_of_FFTW_wisdom_file          ='
  num_task_1trans     = 'number_of_tasks_1st_transpose     ='
  num_task_2trans     = 'number_of_tasks_2nd_transpose     ='
  endLine             = achar(92)

  argnum = COMMAND_ARGUMENT_COUNT()
  IF (argnum .NE. 15) THEN
    WRITE(*,*)
    STOP 'WRONG NUMBER OF INPUT ARGUMENTS!'
  END IF

  CALL GET_COMMAND_ARGUMENT(1,fNumStr)
  READ(fNumStr,*) fNum
  CALL GET_COMMAND_ARGUMENT(2,Pr_str)
  CALL GET_COMMAND_ARGUMENT(3,tau_str)
  CALL GET_COMMAND_ARGUMENT(4,Rm1_str)
  CALL GET_COMMAND_ARGUMENT(5,rot_param_str)
  CALL GET_COMMAND_ARGUMENT(6,rot_angle_str)
  CALL GET_COMMAND_ARGUMENT(7,xres_str)
  CALL GET_COMMAND_ARGUMENT(8,yres_str)
  CALL GET_COMMAND_ARGUMENT(9,zres_str)
  CALL GET_COMMAND_ARGUMENT(10,Lx_str)
  CALL GET_COMMAND_ARGUMENT(11,Ly_str)
  CALL GET_COMMAND_ARGUMENT(12,Lz_str)
  CALL GET_COMMAND_ARGUMENT(13,numTs_str)
  CALL GET_COMMAND_ARGUMENT(14,proc1_str)
  CALL GET_COMMAND_ARGUMENT(15,proc2_str)

  IF (fNum .LT. 10) THEN
    str_num = "0" // fNumStr
  ELSE IF (fNum .LT. 100) THEN
    str_num = fNumStr
  ELSE
    WRITE(*,*)
    STOP 'NUMBERS ARE TOO BIG!'
  END IF

  WRITE(fNumStr,'(I4)') (fNum - 1)
  IF (fNum .EQ. 1) THEN
    str_num_prev = str_num
  ELSE IF (fNum .LE. 10) THEN
    str_num_prev = "0" // adjustl(trim(fNumStr))
  ELSE IF (fNum .LT. 100) THEN
    str_num_prev = adjustl(trim(fNumStr))
  END IF

  IF (fNum .EQ. 1) THEN
    restart_str = ".FALSE."
  ELSE
    restart_str = ".TRUE."
  END IF

  WRITE(*,*)
  WRITE(*,*) "Generating parameter file..."
  WRITE(*,*) "Extension: ",str_num
  WRITE(*,*)

  DUMP_prev  = achar(34) // 'DUMP' // str_num_prev // achar(34)
  DUMP_new   = achar(34) // 'DUMP' // str_num // achar(34)
  j__data    = achar(34) // 'j__data' // str_num // achar(34)
  simdat     = achar(34) // 'simdat' // str_num // achar(34)
  OUT_new    = achar(34) // 'OUT' // str_num // achar(34)
  XY_SPEC    = achar(34) // 'XY_SPEC' // str_num // achar(34)
  Z_SPEC     = achar(34) // 'Z_SPEC' // str_num // achar(34)
  ZPROF      = achar(34) // 'ZPROF' // str_num // achar(34)

  WRITE(20,'(A)',ADVANCE='yes') adjustl(trim(header))
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(restartDump)),' ',adjustl(trim(restart_str))
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(restartNetCDF)),' ','.FALSE.'
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(xfourier)),' ',adjustl(trim(xres_str))
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(yfourier)),' ',adjustl(trim(yres_str))
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(zfourier)),' ',adjustl(trim(zres_str))
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(dealias)),' ','.TRUE.'
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(Therm_bouy)),' ',adjustl(trim(Pr_str))
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(Comp_bouy)),' ',adjustl(trim(Pr_str))
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(Visc_diff)),' ',adjustl(trim(Pr_str))
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(Therm_diff)),' ','1.'
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(Comp_diff)),' ',adjustl(trim(tau_str))
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(Therm_strat)),' ','-1.'
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(Comp_strat)),' ',adjustl(trim(Rm1_str))
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(Rot_param)),' ',adjustl(trim(rot_param_str))
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(Rot_angle)),' ',adjustl(trim(rot_angle_str))
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(x_dim)),' ',adjustl(trim(Lx_str))
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(y_dim)),' ',adjustl(trim(Ly_str))
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(z_dim)),' ',adjustl(trim(Lz_str))
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(init_ts)),' ','5.E-6'
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(max_ts)),' ','1.E-2'
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(CFL_fac)),' ','0.9'
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(num_ts)),' ',adjustl(trim(numTs_str))
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(save_state)),' ','1000'
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(save_netCDF)),' ','1000'
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(restart_info)),' ','500'
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(comp_diag)),' ','10'
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(write_spec)),' ','200'
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(write_prof)),' ','200'
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(write_state_comp)),' ','.TRUE.'
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(write_state_netCDF)),' ','.TRUE.'
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(name_in_restart)),' ',adjustl(trim(DUMP_prev))
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(name_out_restart)),' ',adjustl(trim(DUMP_new))
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(name_comp)),' ',adjustl(trim(j__data))
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(name_netCDF)),' ',adjustl(trim(simdat))
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(name_diag)),' ',adjustl(trim(OUT_new))
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(name_horiz)),' ',adjustl(trim(XY_SPEC))
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(name_vert)),' ',adjustl(trim(Z_SPEC))
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(name_prof)),' ',adjustl(trim(ZPROF))
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(use_FFTW_wisdom)),' ','.TRUE.'
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(name_FFTW_wisdom)),' ',achar(34) // 'FFTW_WISDOM' // achar(34)
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(num_task_1trans)),' ',adjustl(trim(proc1_str))
  WRITE(20,'(3A)',ADVANCE='yes') adjustl(trim(num_task_2trans)),' ',adjustl(trim(proc2_str))
  WRITE(20,'(A)') '/'

  CLOSE(20)

END PROGRAM CreateParamFile_rot
