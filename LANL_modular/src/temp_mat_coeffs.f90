SUBROUTINE temp_mat_coeffs (a,b,c)

  use prec_param_mod
  use exp_params_mod
  use phys_const_mod

  REAL(prec), DIMENSION(nr+1), INTENT(out)  ::  a,b,c
  REAL(prec)                                ::  dr_minus, dr_plus, alpha, beta1
  REAL(prec)                                ::  kappa, Temp_eV_minus, Temp_eV, Temp_eV_plus
  REAL(prec), PARAMETER                     ::  kb_ergeV = 1.6e-12, ErgJ_conv = 1e-7, ccM_conv = 1e-6, gKg_conv = 1e-3, m_elec = 9.10938e-28

  Temp_eV        = Temp(i,1)/JeV_conv
  if (i .EQ. 1) then
    dr_minus   = dr(i,2)
  else
    dr_minus   = .5*(dr(i,2) + dr(i-1,2))
  end if
  dr_plus      = .5*(dr(i+1,2) + dr(i,2))
  alpha        = dt*(gamma - 1)*(V(i,2)/N_part(i))
  kappa        = (1e2)*(.2)*(1.933e21)*(Temp_eV**(5./2))
  beta1        = kappa/(dr(i,2)*r_bar_sq)

  a(i) = -alpha*beta1*r_sq(i)/dr_minus
  c(i) = -alpha*beta1*r_sq(i+1)/dr_plus
  b(i) = 1  + .5*dt*(gamma - 1)*(r_sq(i+1)*u(i+1,2) - r_sq(i)*u(i,2))/(r_bar_sq*dr(i,2)) - (a(i) + c(i))

END SUBROUTINE temp_mat_coeffs
