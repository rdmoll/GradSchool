SUBROUTINE finish

  use exp_params_mod

  ! close parameter file
  close(30)

  ! close data file
  close(20)

  ! deallocate memory from arrays
  deallocate( r        )
  deallocate( u        )
  deallocate( rho      )
  deallocate( Temp     )
  deallocate( P        )
  deallocate( Comp     )
  deallocate( dr       )
  deallocate( V        )
  deallocate( q        )
  deallocate( cs       )
  deallocate( N_part   )
  deallocate( M        )
  deallocate( vel_fac  )
  deallocate( ionized  )
  deallocate( N_elec   )
  deallocate( subdiag  )
  deallocate( diag     )
  deallocate( supdiag  )
  deallocate( vel_RHS  )
  deallocate( temp_RHS )
  deallocate( forcing  )
  deallocate( r_sq     )

END SUBROUTINE finish
