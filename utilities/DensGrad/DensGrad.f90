!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!
!!  Filename        : DensGrad.f90
!!  Author          : Ryan Moll
!!  Date created    : July 11, 2015
!!
!!  Purpose         : See descriptions in subroutines
!!  Expected input  : ./[executable] file_index0 file_index1 t0 t1 num_Z_modes Lz ... 
!!                                   Rm1 [outfile1] [outfile2]
!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

PROGRAM DensGrad
  USE DensGrad_mod
  implicit none

  INTEGER             :: ierr,argnum
  INTEGER             :: iStart,iEnd
  REAL(8)             :: tStart,tEnd
  INTEGER             :: zmodes,zUp,zLow
  REAL(8)             :: Lz,Rm1
  LOGICAL             :: ex
  CHARACTER(len=100)  :: outfile1,outfile2
  CHARACTER(len=10)   :: strNum

  argnum = COMMAND_ARGUMENT_COUNT()
  IF (argnum .NE. 10) THEN
    WRITE(*,*)
    STOP 'WRONG NUMBER OF INPUT ARGUMENTS!'
  END IF

  CALL getarg(1,strNum)
  READ(strNum,*) iStart
  CALL getarg(2,strNum)
  READ(strNum,*) iEnd
  CALL getarg(3,strNum)
  READ(strNum,*) tStart
  CALL getarg(4,strNum)
  READ(strNum,*) tEnd
  CALL getarg(5,strNum)
  READ(strNum,*) zmodes
  CALL getarg(6,strNum)
  READ(strNum,*) Lz
  CALL getarg(7,strNum)
  READ(strNum,*) Rm1
  CALL getarg(8,outfile1)
  CALL getarg(9,outfile2)

  INQUIRE(FILE=outfile1,EXIST=ex)
  IF (.NOT. ex) THEN
    OPEN(30,file=outfile1,status='unknown',iostat=ierr,action='write')
    IF (ierr .NE. 0) THEN
      WRITE(*,*) "Unable to open file to write"
      STOP
    ENDIF

    WRITE(*,*) "Calculating time averaged density gradients..."
    CALL DensGrad_Calc1(iStart,iEnd,tStart,tEnd,zmodes,zUp,zLow,Lz,Rm1) 

    CLOSE(30)
  ENDIF
  
  INQUIRE(FILE=outfile1,EXIST=ex)
  IF (.NOT. ex) THEN
    OPEN(30,file=outfile2,status='unknown',iostat=ierr,action='write')
    IF (ierr .NE. 0) THEN
      WRITE(*,*) "Unable to open file to write"
      STOP
    ENDIF

    WRITE(*,*) "Calculating density gradients for each time..." 
    CALL DensGrad_Calc2(iStart,iEnd,tStart,tEnd,zmodes,zUp,zLow,Lz,Rm1)

    CLOSE(30)
  ENDIF

END PROGRAM DensGrad
