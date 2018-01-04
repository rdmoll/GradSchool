SUBROUTINE comp_mat_coeffs (a,b,c)

  use prec_param_mod
  use exp_params_mod
  use phys_const_mod

  REAL(prec), DIMENSION(nr+1), INTENT(out)  ::  a,b,c
  REAL(prec)                                ::  dr_minus, dr_plus, alpha, beta1, Temp_keV
  REAL(prec)                                ::  D, rho_plus, rho_minus, DD_mass, CH_mass

  Temp_keV = Temp(i,2)/(1000*JeV_conv)
  DD_mass = mm_DD/(1 + ionized(i))
  CH_mass = mm_CH/(1 + ionized(i))

  if (i .EQ. 1) then
    dr_minus = dr(i,2)
    rho_minus = rho(i,2)
  else
    dr_minus = .5*(dr(i,2) + dr(i-1,2))
    rho_minus = .5*(rho(i,2) + rho(i-1,2))
  end if
  dr_plus  = .5*(dr(i+1,2) + dr(i,2))
  rho_plus = .5*(rho(i+1,2) + rho(i,2))
  alpha    = dt
  D        = (1e-4)*2470*(.2)*(Temp_keV**(5./2))/ &
             (sqrt(DD_mass)*(1e-3)*rho(i,2)*(2.4*Comp(i,2)/DD_mass + 12.25*(1-Comp(i,2))/CH_mass))
  beta1    = 1/(rho(i,2)*r_bar_sq*dr(i,2))

  if (i .EQ. 1) then
    a(i) = 0
  else
    a(i)   = -alpha*beta1*r_sq(i)*rho_minus*D/dr_minus
  end if

  if (i .EQ. nr) then
    c(i) = 0
  else
    c(i) = -alpha*beta1*r_sq(i+1)*rho_plus*D/dr_plus
  end if
  b(i)   = 1 - (a(i) + c(i))

!print *, D/(Temp_keV**(5./2))

END SUBROUTINE comp_mat_coeffs
