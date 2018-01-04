MODULE phys_const_mod

  use prec_param_mod

  ! defining physical parameters: k_boltz  = Boltzmann constant in [eV/Kelvin]
  !                               N_av     = Avogadro's number [particles/mol]
  !                               mm_DD    = molar mass of deuterium in [kg/mol]
  !                               mm_CH    = molar mass of the shell material [kg/mol]
  !                               JeV_conv = conversion factor between joules and eV [J/eV]
  REAL(prec),PARAMETER  :: k_boltz = 8.6173324e-5, N_av = 6.02214129e23, mm_DD = 4.029e-3, &
  &                        mm_CH = 13.018947e-3, JeV_conv = 1.602e-19, a_sbc = 7.5657e-16

END MODULE phys_const_mod
