!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!
!!  Filename        : WvNumExpVal.f90
!!  Author          : Ryan Moll
!!  Date Modified   : July 11, 2015
!!
!!  Purpose         : Finds total spectral energy and expectation values of the
!!                    horizontal and vertical wave numbers for each time step in
!!                    the Z_SPEC and XY_SPEC.
!!  Expected Input  : ./[executable] [start file index] [end file index] [num x modes] [num z modes]
!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

PROGRAM WvNumExpVal

  REAL(8),PARAMETER   :: small  = 1e-6
  REAL(8),PARAMETER   :: param  = ( acos(-1.0) )/50.0

  REAL(8)             :: time
  INTEGER             :: tmstp,old_tmstp1,old_tmstp2,i,ierrR,ierrO,skipLine,readLine
  INTEGER             :: iStart,iEnd,xmodes,zmodes
  REAL(8)             :: kx,ky,kz,uKE,vKE,wKE,totKE,TKE,MuKE
  REAL(8)             :: EValXY,EValZ,sumKE
  CHARACTER(len=100)  :: filename,baseFileNameXY,baseFileNameZ,outfile
  CHARACTER(len=30)   :: fmt1
  CHARACTER(len=2)    :: indexStr
  CHARACTER(len=10)   :: strNum,temp1,temp2,temp3,temp4,temp5
  CHARACTER(len=200)  :: line

  fmt1            = '()'
  baseFileNameXY  = 'XY_SPEC'
  baseFileNameZ   = 'Z_SPEC'

  ! Read command line arguments
  call getarg(1,strNum)
  READ(strNum,*) iStart
  call getarg(2,strNum)
  READ(strNum,*) iEnd
  call getarg(3,strNum)
  READ(strNum,*) xmodes
  call getarg(4,strNum)
  READ(strNum,*) zmodes
  call getarg(5,outfile)

  ! Open file for writing data
  OPEN(30,file=outfile,status='unknown',action='write')

  tmstp       = 0
  old_tmstp1  = 0
  old_tmstp2  = 0

  ! Iterate through output files
  DO i = iStart,iEnd

    WRITE(*,*) "File index   : ",i

    IF(i .LT. 10) THEN
      WRITE(indexStr,'(A1,I1)') '0', i
    ELSE
      WRITE(indexStr,'(I2)') i
    ENDIF

    ! Open XY_SPEC file for reading
    filename = trim( trim( adjustl(baseFileNameXY) ) // indexStr )
    OPEN(10,file=filename,status='old',iostat=ierrO,action='read')
    IF(ierrO .NE. 0) THEN
      WRITE(*,*) "File does not exist!"
      EXIT
    ENDIF
    WRITE(*,*) "XY_SPEC file : ",filename

    ! Open Z_SPEC file for reading
    filename = trim( trim( adjustl(baseFileNameZ) ) // indexStr )
    OPEN(20,file=filename,status='old',iostat=ierrO,action='read')
    IF(ierrO .NE. 0) THEN
      WRITE(*,*) "File does not exist!"
      EXIT
    ENDIF
    WRITE(*,*) "Z_SPEC file  : ",filename

    DO skipLine = 1,42
      READ(10,'(A)',iostat=ierrR,advance='yes') line
      READ(20,'(A)',iostat=ierrR,advance='yes') line
    ENDDO

    ! Read block of data for timestep
    DO
      IF( (2*tmstp - old_tmstp1) .LT. 1e7 ) THEN
        old_tmstp2 = tmstp
        READ(10,*,iostat=ierrR) temp1,temp2,temp3,tmstp,temp4,temp5,time
        READ(20,*,iostat=ierrR) temp1,temp2,temp3,tmstp,temp4,temp5,time

        IF(ierrR .NE. 0) THEN
          CLOSE(10)
          CLOSE(20)
          EXIT
        ENDIF
      ELSE
        READ(10,*,iostat=ierrR) temp1,temp2,temp3,temp4,temp5,time
        READ(20,*,iostat=ierrR) temp1,temp2,temp3,temp4,temp5,time

        IF(ierrR .NE. 0) THEN
          CLOSE(10)
          CLOSE(20)
          EXIT
        ENDIF
        temp3(1:1) = " "
        READ(temp3,*) tmstp
      ENDIF
      old_tmstp1 = old_tmstp2

      ! Calculate expectation value of horizontal wave number
      EValXY = 0
      sumKE  = 0
      DO readLine = 1,(xmodes+1)
        READ(10,*,iostat=ierrR) kx,ky,uKE,vKE,wKE,totKE,TKE,MuKE
        EValXY = EValXY + totKE*sqrt(kx**2 + ky**2)
        sumKE = sumKE + totKE
      ENDDO
      EValXY = EValXY / sumKE

      ! Calculate expectation value of z wave number
      EValZ = 0
      sumKE = 0
      DO readLine = 1,(2*zmodes)
        READ(20,*,iostat=ierrR) kz,uKE,vKE,wKE,totKE,TKE,MuKE
        EValZ = EValZ + totKE*sqrt(kz**2)
        sumKE = sumKE + totKE
      ENDDO
      EValZ = EValZ / sumKE

      ! Write data to file
      WRITE(30,'(I10,ES14.3,3ES14.6)') tmstp,time,sumKE,EValXY,EValZ

      ! Skip lines to go to read data from next time step
      DO skipLine = 1,2
        READ(10,'(A)',iostat=ierrR,advance='yes') line
        READ(20,'(A)',iostat=ierrR,advance='yes') line
      ENDDO

    ENDDO
  ENDDO

  ! Close output file
  CLOSE(30)

END PROGRAM WvNumExpVal
