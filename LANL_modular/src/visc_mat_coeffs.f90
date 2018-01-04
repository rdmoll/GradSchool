SUBROUTINE visc_mat_coeffs (a,b,c)

  use prec_param_mod
  use exp_params_mod
  use phys_const_mod

  REAL(prec), DIMENSION(nr), INTENT(out)  ::  a,b,c
  REAL(prec)                              ::  comb_dr, alpha, beta1, mu_plus, mu_minus
  REAL(prec)                              ::  eta_plus, eta_minus, r_plus, r_minus
  REAL(prec), PARAMETER                   ::  kb_ergeV = 1.6e-12

  Temp_eV        = Temp(i,1)/JeV_conv
  Temp_eV_minus  = Temp(i-1,1)/JeV_conv

  mu_plus  = 1000*(mm_DD*Comp(i,1)/(1+ionized(i)) + mm_CH*(1-Comp(i,1))/(1+ionized(i)))
  mu_minus = 1000*(mm_DD*Comp(i-1,1)/(1+ionized(i-1)) + mm_CH*(1-Comp(i-1,1))/(1+ionized(i-1)))

  comb_dr        = .5*(dr(i,1) + dr(i-1,1))
  alpha          = dt*inv_rho_bar
  r_plus         = .5*(r(i+1,1) + r(i,1))
  r_minus        = .5*(r(i,1) + r(i-1,1))
  eta_plus       = (1e-1)*(2.0064e7)*sqrt(mu_plus)*(.2)*kb_ergeV*(Temp_eV**2.5)
  eta_minus      = (1e-1)*(2.0064e7)*sqrt(mu_minus)*(.2)*kb_ergeV*(Temp_eV_minus**2.5)

  beta1          = 1/((r(i,1)**2)*comb_dr)

  a(i-1)         = -alpha*beta1*(r_minus**2)*eta_minus/dr(i-1,1)
  c(i-1)         = -alpha*beta1*(r_plus**2)*eta_plus/dr(i,1)
  b(i-1)         = 1 - (a(i-1) + c(i-1))

END SUBROUTINE visc_mat_coeffs
