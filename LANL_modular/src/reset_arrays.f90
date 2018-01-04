SUBROUTINE reset_arrays

  use exp_params_mod

  u(:,1)    = u(:,2)
  r(:,1)    = r(:,2)
  dr(:,1)   = dr(:,2)
  V(:,1)    = V(:,2)
  rho(:,1)  = rho(:,2)
  Temp(:,1) = Temp(:,2)
  P(:,1)    = P(:,2)
  Comp(:,1) = Comp(:,2)

END SUBROUTINE reset_arrays
