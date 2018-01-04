!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!                                                                                                                         !!
!!   OneD_ICF.f90                                                                                                          !!
!!   Description: Test of 1D problem in spherical geometry                                                                 !!
!!   Author: Ryan Moll                                                                                                     !!
!!   Date Created: July 22, 2013                                                                                           !!
!!                                                                                                                         !!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

PROGRAM OneD_ICF

  use exp_params_mod
  use phys_const_mod
  use solver_routines_mod

  ! read parameter file
  call read_params

  ! initialize variables
  call initialize

  ! write initial data to file
  call write_data

  ! initialize diagnostic variables
  highestPress   = P(1,1)
  highestTemp    = Temp(1,1)
  highestDensity = rho(1,1)

  ! enter time stepping loop
  do t = 1,tsteps

    ! solve equations
    call solve_eqns

    ! reset indicies of data arrays
    call reset_arrays

    ! perform diagnostics
    if (P(1,1) .GT. highestPress) then
      highestPress = P(1,1)
    end if

    if (Temp(1,1) .GT. highestTemp) then
      highestTemp = Temp(1,1)
      highEnergyTime = time
    end if

    if (rho(1,1) .GT. highestDensity) then
      highestDensity = rho(1,1)
    end if

    ! write to file (uncomment if statement to start saving data after certain time)
    !if (time .GT. 3.227e-9) then
    if (mod(t,250) .EQ. 0) then
      call write_data
    end if
    !end if

    !if (time .GT. 20e-9) then
    !  exit
    !end if

  end do

  ! print diagnostic results
  print *, '***PROGRAM COMPLETE***'
  if (nanDetected) then
  print *, 'With fatal errors              : YES'
  else
  print *, 'With fatal errors              : NO'
  end if
  print *, 'Final time                     : ', time
  print *, 'Highest pressure at origin     : ', highestPress
  print *, 'Highest temperature at origin  : ', highestTemp / JeV_conv
  Print *, 'Highest temperature occurs at  : ', highEnergyTime
  print *, 'Highest density at origin      : ', highestDensity * (N_part(1)-2*(N_av/mm_DD)*M(1)) / ((1e6)*M(1))

  ! complete program
  call finish

END PROGRAM OneD_ICF
