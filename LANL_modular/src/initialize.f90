SUBROUTINE initialize

  use exp_params_mod
  use phys_const_mod

  ! allocate memory for data arrays
  allocate( r(nr+2,3)      )
  allocate( u(nr+2,3)      )
  allocate( rho(nr+1,3)    )
  allocate( Temp(nr+1,3)   )
  allocate( P(nr+1,3)      )
  allocate( Comp(nr+1,3)   )
  allocate( dr(nr+1,3)     )
  allocate( V(nr+1,3)      )
  allocate( q(nr+1)        )
  allocate( cs(nr+1)       )
  allocate( N_part(nr+1)   )
  allocate( M(nr+1)        )
  allocate( vel_fac(nr+1)  )
  allocate( ionized(nr+1)  )
  allocate( N_elec(nr+1)   )
  allocate( subdiag(nr+1)  )
  allocate( diag(nr+1)     )
  allocate( supdiag(nr+1)  )
  allocate( vel_RHS(nr+2)  )
  allocate( temp_RHS(nr+1) )
  allocate( forcing(nr+1)  )
  allocate( r_sq(nr+2)     )

  ! initialize constants
  pi       = 2 * acos(0.0)
  dtheta   = pi/64
  dphi     = pi/64
  cQ       = .25*(gamma + 1)
  cL       = .5
  vol_fac  = (dphi/3)*(1 - cos(dtheta))

  out_density = 1.225
  out_temp    = 300

  ! initialize matrix coefficients
  subdiag(:) = 0
  diag(:)    = 0
  supdiag(:) = 0

  ! initialize diagnostic variables
  nanDetected = .FALSE.

  ! initialize time variables
  time     = 0
  dt       = init_dt

  ! initialize velocity and grid positions
  u(:,:)  = 0
  dr(:,1) = Lr/nr
  r(1,1)  = 0
  do i = 2,(nr+2)
    r(i,1) = dr(i-1,1) * (i - 1)
  end do

  ! initialize volumes
  do i = 1,(nr+1)
    V(i,1) = vol_fac*( r(i+1,1)**3 - r(i,1)**3 )
  end do

  ! initialize density, cell masses, particle numbers
  rho(1:in_bound,1)               = (init_press*mm_DD)/(N_av*k_boltz*JeV_conv*init_T_gas)
  rho((in_bound+1):nr,1)          = rho_fac*rho(1,1)
  rho(nr+1,1)                     = out_density
  M(:)                            = rho(:,1)*V(:,1)
  N_part(1:in_bound)              = (N_av/mm_DD) * M(1:in_bound)
  N_part((in_bound+1):(nr+1))     = (N_av/mm_CH) * M((in_bound+1):(nr+1))

  ! initialize ionization state
  ionized(:)                       =  0.0
  ionized((nr-forced_zones+1):nr)  =  ion_frac
  N_elec(1:in_bound)               =  1.0
  N_elec((in_bound+1):nr)          =  3.5
  N_part((nr-forced_zones+1):nr)  =  (1+ionized((nr-forced_zones+1):nr))* &
                                      (1+ionized((nr-forced_zones+1):nr)*N_elec((nr-forced_zones+1):nr)) * &
                                      N_part((nr-forced_zones+1):nr)

  ! initialize temperature with forcing
  forcing(:)                       =  0
  !forcing((nr-forced_zones+1):nr)  =  (.3*(vol_fac/((4./3)*pi))*init_en_pulse*dt / forced_zones)*(gamma-1)/N_part(nr)
  Temp(1:in_bound,1)               =  k_boltz*JeV_conv*init_T_gas
  Temp((in_bound+1):nr,1)          =  (init_press * V((in_bound+1):nr,1)) / N_part((in_bound+1):nr)
  !Temp((nr-forced_zones+1):nr,1)   =  1000*Temp(1,1) !Temp((nr-forced_zones+1),1) + forcing((nr-forced_zones+1):nr)
  Temp((nr+1),1)                   =  k_boltz*JeV_conv*out_temp

  ! initialize Deuterium mass fraction
  Comp(:,:) = 0
  Comp(1:in_bound,:) = 1

  ! initialize pressure
  P(:,1)        =  (N_part(:) / V(:,1)) * Temp(:,1)
  out_press     =  (N_part(nr+1) / V(nr+1,1)) * k_boltz * JeV_conv * out_temp
  P((nr+1),1)   =  out_press

  ! find sound speed
  cs(:) = sqrt( gamma * P(:,1) / rho(:,1) )

  ! open output files
  open(20,file=outfile,status='unknown',action='write')

END SUBROUTINE initialize
