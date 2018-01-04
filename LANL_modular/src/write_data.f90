SUBROUTINE write_data

  use exp_params_mod
  use phys_const_mod

  ! write data to file
  do i = 1,(nr+1)
    if ( (r(i,1) .NE. r(i,1))       .OR. &
         (u(i,1) .NE. u(i,1))       .OR. &
         (Temp(i,1) .NE. Temp(i,1)) .OR. &
         (rho(i,1) .NE. rho(i,1))   .OR. &
         (P(i,1) .NE. P(i,1))            &
       ) then
         nanDetected = .TRUE.
    end if
    write(20,*) time, r(i,1), u(i,1), Temp(i,1)/JeV_conv, (rho(i,1)*N_part(i))/((1e6)*M(i)), P(i,1), Comp(i,1)
  end do

END SUBROUTINE write_data
