SUBROUTINE solve_eqns

  use exp_params_mod
  use phys_const_mod
  !use solver_routines_mod

  ! update time
  time = time + dt

  ! find artificial viscosity
  do i = 1,(nr+1)
    du = u(i+1,1) - u(i,1)
    if (du .LT. 0) then
      q(i) = rho(i,1)*abs(du)*( cQ*abs(du) + cL*cs(i) )
    else
      q(i) = 0
    end if
  end do

  ! find new velocity
  do i = 2,(nr+1)
    dr_bar = .5 * (dr(i,1) + dr(i-1,1))
    inv_rho_bar =  ( (V(i,1)+V(i-1,1))/(M(i)+M(i-1)) )
    vel_fac(i) = inv_rho_bar * (P(i,1) + q(i) - P(i-1,1) - q(i-1)) / dr_bar
    call visc_mat_coeffs(subdiag,diag,supdiag)
  end do
  !u(:,2)  = u(:,1) - dt*vel_fac(:)
  vel_RHS(:) = u(:,1) - dt*vel_fac(:)
  call tri_diag(subdiag,diag,supdiag,vel_RHS(2:nr+1),u(2:nr+1,2),nr)
  u(nr+2,2) = u(nr+1,2)

  ! find new grid locations and cell lengths
  r(:,2)  = r(:,1) + .5*dt*(u(:,2) + u(:,1))
  r_sq(:) = r(:,2)*r(:,2)
  do i = 1,(nr+1)
    dr(i,2) = r(i+1,2) - r(i,2)
  end do

  ! find new volumes
  do i = 1,(nr+1)
    V(i,2) = vol_fac*(r(i+1,2)**3 - r(i,2)**3)
  end do

  ! find new densities
  rho(:,2) = rho(:,1) * (V(:,1)/V(:,2))
  rho((nr+1),2) = out_density

  ! continue forcing for 1 ns
  if (time .LT. 1e-9) then
    forcing((nr-forced_zones+1):nr)  =  (.3*(vol_fac/((4./3)*pi))*init_en_pulse*dt / forced_zones)*(gamma-1) / &
                                        N_part((nr-forced_zones+1):nr)
  else
    forcing(:) = 0
  end if

  ! find new temperatures
  do i = 1,nr
    r_bar = .5*(r(i+1,2)+r(i,2))
    r_bar_sq = r_bar*r_bar
    !Temp(i,2) = ( Temp(i,1) - dt*(gamma-1)*(V(i,2)/N_part(i))*(.5*P(i,1) + q(i))*(u(i+1,2) - u(i,2))/dr(i,2) + forcing(i) ) / &
    !            (1 + .5*dt*(gamma - 1)*(u(i+1,2) - u(i,2))/dr(i,2))
    call temp_mat_coeffs(subdiag,diag,supdiag)
    temp_RHS(i) =  Temp(i,1) - dt*(gamma-1)*(V(i,2)/N_part(i))*(.5*P(i,1) + q(i))*(r_sq(i+1)*u(i+1,2) - r_sq(i)*u(i,2)) &
                               /(r_bar_sq*dr(i,2)) + forcing(i)
  end do
  call tri_diag(subdiag,diag,supdiag,temp_RHS(1:nr),Temp(1:nr,2),nr)
  Temp((nr+1),2) = k_boltz*JeV_conv*out_temp

  ! determine if zone is ionized based on temperature change
  do i = 1,nr
    if ( (ionized(i) .EQ. 0) .AND. (Temp(i,2) .GT. (1.3*Temp(i,1))) ) then
      ionized(i) = ion_frac;
    end if
  end do
  N_elec(:) = 1*Comp(:,2) + 3.5*(1-Comp(:,2))
  N_part(:) = N_av*(Comp(:,2)/mm_DD + (1-Comp(:,2))/mm_CH)*M(:)* &
              (1+ionized(:))*(1+ionized(:)*N_elec(:))

  ! find new species mass fractions and number of particles
  do i = 1,nr
    r_bar = .5*(r(i+1,2)+r(i,2))
    r_bar_sq = r_bar*r_bar
    call comp_mat_coeffs(subdiag,diag,supdiag)
  end do
  call tri_diag(subdiag,diag,supdiag,Comp(1:nr,1),Comp(1:nr,2),nr)
  Comp((nr+1),2) = 0

  ! find new pressures
  P(:,2) = (N_part(:)/V(:,2)) * Temp(:,2)
  P((nr+1),2) = out_press

  ! find sound speed
  cs(:) = sqrt( gamma * P(:,2) / rho(:,2) )

  ! calculate new time step
  dt = cfl_fac * .5 * minval( dr(:,2)/(cs(:) + abs(u(:,2))) )

END SUBROUTINE solve_eqns
