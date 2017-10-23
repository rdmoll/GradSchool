!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!
!!  Filename        : DensGrad_Calc2.f90
!!  Author          : Ryan Moll
!!  Date created    : July 11, 2015
!!  
!!  Purpose         : Calculates rho_tot(z) and drho/dz(z) at each time.
!!                    All data taken from ZPROF files. 
!!                     
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

SUBROUTINE DensGrad_Calc2(iStart,iEnd,tStart,tEnd,zmodes,zUp,zLow,Lz,Rm1)

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
      
      IF (time .GT. tStart) THEN

        tsteps = tsteps + 1
 
        ! Calculate gradient of density perturbations
        drho(1) = (rho(2) - rho(LineCt-1))/(2*dz)
        drho(LineCt) = drho(1)
        DO readLine = 2,(LineCt-1)
          drho(readLine) = (rho(readLine+1) - rho(readLine-1))/(2*dz)
        ENDDO
        
        ! Write data to file at each time
        WRITE(30,*) "# time= ",time
        DO readLine = 1,LineCt
          z                = (readLine - 1)*dz
          rho(readLine)  = (1.0-Rm1)*z + rho(readLine)
          drho(readLine)   = (1.0-Rm1) + drho(readLine)
          WRITE(30,'(ES14.3,2ES14.6)') z,rho(readLine),drho(readLine)
        ENDDO
        WRITE(30,*)
        WRITE(30,*)

      END IF

      ! Skip lines to go to read data from next time step
      DO skipLine = 1,2
        READ(10,'(A)',iostat=ierrR,advance='yes') line
        !PRINT*,"test",line
      ENDDO

    ENDDO

    IF (time .GT. tEnd) THEN
      EXIT
    END IF
    
  ENDDO

  WRITE(*,*) "Number of time steps :  ",tsteps

  DEALLOCATE(rho,rhoAv,drho)

END SUBROUTINE DensGrad_Calc2
