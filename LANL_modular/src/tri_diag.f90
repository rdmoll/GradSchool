SUBROUTINE tri_diag (a,b,c,d,u,n)

  use prec_param_mod

  INTEGER                                ::  j
  INTEGER, INTENT(in)                    ::  n
  REAL(prec), DIMENSION(n), INTENT(in)   ::  a, b, c, d
  REAL(prec), DIMENSION(n), INTENT(out)  ::  u
  REAL(prec)                             ::  bet, gam(n)

  if (b(1) .EQ. 0) then
    print *, 'tridiag failed w/ b(1) = 0'
    read(*,*)
  end if

  bet = b(1)
  u(1) = d(1) / bet

  do j = 2,n
    gam(j) = c(j-1)/bet
    bet = b(j) - a(j)*gam(j)
    if (bet .EQ. 0) then
      print *, 'tridiag failed w/ bet=0'
      read(*,*)
    end if
    u(j) = (d(j) - a(j)*u(j-1)) / bet
  end do

  do j = n-1, 1, -1
    u(j) = u(j) - gam(j+1)*u(j+1)
  end do

END SUBROUTINE tri_diag
