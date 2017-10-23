!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!
!!  Filename        : DensGrad_Calc1.f90
!!  Author          : Ryan Moll
!!  Date created    : July 11, 2015
!!  
!!  Purpose         : Calculates time avg of rho_tot(z) and drho/dz(z). Calculates avg.
!!                    drho/dz in specified range of z. All data taken from ZPROF files. 
!!                     
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

SUBROUTINE DensGrad_Calc1(iStart,iEnd,tStart,tEnd,zmodes,zUp,zLow,Lz,Rm1)

  REAL(8),INTENT(in)   :: tStart,tEnd,Lz,Rm1
  INTEGER,INTENT(in)   :: iStart,iEnd,zmodes,zUp,zLow

  REAL(8)              :: time
  INTEGER              :: tsteps
  INTEGER              :: tmstp,old_tmstp1,old_tmstp2,i,ierrR,ierrO,skipLine
  INTEGER              :: LineCt,N,maxMode,readLine
  
  REAL(8)              :: z,u,v,w,omx,omy,omz,T,Mu
  REAL(8)              :: uav,vav,wav,omxav,omyav,omzav,Tav,Muav
  
  REAL(8)              :: drhoPt,drhoAvPt,dz
  CHARACTER(len=100)   :: fileProf,baseNameProf,outfile
  CHARACTER(len=30)    :: fmt1
  CHARACTER(len=2)     :: indexStr
  CHARACTER(len=10)    :: strNum,temp1,temp2,temp3,temp4,temp5
  CHARACTER(len=200)   :: line

  REAL(8), ALLOCATABLE  :: rho(:),rhoAv(:),drho(:)

  LineCt  = 3*zmodes + 1
  N       = LineCt - 1
  dz      = Lz/(1.0*N)

  ALLOCATE( rho(LineCt) )
  ALLOCATE( drho(LineCt) )
  ALLOCATE( rhoAv(LineCt) )

  fmt1          = '()'
  baseNameProf  = 'ZPROF'

  tsteps      = 0
  tmstp       = 0
  old_tmstp1  = 0
  old_tmstp2  = 0
  rho(:)      = 0.0
  drho(:)     = 0.0
  rhoAv(:)    = 0.0
  
  ! Enter loop, step through multiple ZPROF files if necessary
  DO i = iStart,iEnd    

    WRITE(*,*) "File index   : ",i

    IF(i .LT. 10) THEN
      WRITE(indexStr,'(A1,I1)') '0', i
    ELSE
      WRITE(indexStr,'(I2)') i
    ENDIF

    fileProf = trim( trim( adjustl(baseNameProf) ) // indexStr )
    
    ! Open ZPROF file
    OPEN(10,file=fileProf,status='old',iostat=ierrO,action='read')
    IF(ierrO .NE. 0) THEN
      WRITE(*,*) "File does not exist!"
      EXIT
    ENDIF
    WRITE(*,*) "ZPROF file  : ",fileProf

    ! skip lines at the beginning of the file (rotation code skips 2 more lines)
    DO skipLine = 1,44
      READ(10,'(A)',iostat=ierrR,advance='yes') line
    ENDDO

    DO
    
      ! Read first line of block of data
      READ(10,*,iostat=ierrR) temp1,temp2,tmstp,temp3,time

	  ! Check for errors reading block header
      IF(ierrR .NE. 0) THEN
        CLOSE(10)
        EXIT
      ENDIF

      ! Exit loop if data block is outside of time range
      IF (time .GT. tEnd) THEN
        CLOSE(10)
        EXIT
      END IF

      ! Calculate perturbations to density profile
      DO readLine = 1,(LineCt-1)
        READ(10,*,iostat=ierrR) z,u,v,w,omx,omy,omz,T,Mu,uav,vav,wav,omxav,omyav,omzav,Tav,Muav
        rho(readLine) = Muav - Tav
      ENDDO
      rho(LineCt) = rho(1)

      ! When within time range, sum rho perturbations at each z level
      IF (time .GT. tStart) THEN

        tsteps = tsteps + 1
        
        DO readLine = 1,(LineCt-1)
          rhoAv(readLine) = rhoAv(readLine) + rho(readLine)
        ENDDO

      END IF

      ! Skip lines to go to read data from next time step
      DO skipLine = 1,2
        READ(10,'(A)',iostat=ierrR,advance='yes') line
        !PRINT*,"test",line
      ENDDO

    ENDDO

    ! Exit ZPROF loop if time outside of range 
    IF (time .GT. tEnd) THEN
      EXIT
    END IF
    
  ENDDO

  ! Calculate time average of density perturbations at each level
  DO readLine = 1,(LineCt-1)
    rhoAv(readLine) = rhoAv(readLine)/(1.0*tsteps)
  ENDDO
  rhoAv(LineCt) = rhoAv(1)

  ! Calculate rho pert. gradient at each point using simple centered difference method
  drho(1) = (rhoAv(2) - rhoAv(LineCt-1))/(2*dz)
  drho(LineCt) = drho(1)
  DO readLine = 2,(LineCt-1)
    drho(readLine) = (rhoAv(readLine+1) - rhoAv(readLine-1))/(2*dz)
  ENDDO
  
  ! Calculate average density gradient within z range 
  drhoPt = 0.0
  DO readLine = zLow,zUp
    drhoPt = drhoPt + drho(readLine)
  ENDDO
  drhoPt = (1.0-Rm1) + (drhoPt/(1.0*(zUp-zLow+1)))  ! Calculate rho_0 + rho_pert grad.

  ! Write data to file
  DO readLine = 1,LineCt
    z                = (readLine - 1)*dz              ! z level
    rhoAv(readLine)  = (1.0-Rm1)*z + rhoAv(readLine)  ! time av. tot. rho(z)
    drho(readLine)   = (1.0-Rm1) + drho(readLine)     ! time av. tot. drho/dz
    WRITE(30,'(ES14.3,2ES14.6)') z,rhoAv(readLine),drho(readLine)
  ENDDO

  ! Print out average rho_tot gradient in specified z range
  WRITE(*,*) "time steps avg : ", tsteps
  WRITE(*,*) "z range        : ", (zLow-1)*dz, " to ",(zUp-1)*dz
  WRITE(*,*) "drho in range  : ", drhoPt

  DEALLOCATE(rho,rhoAv,drho)

END SUBROUTINE DensGrad_Calc1
