FC = gfortran
SRC1 = WvNumExpVal.f90
SRC2 = WvNumExpVal_rot.f90
EXE1 = WvNumExpVal
EXE2 = WvNumExpVal_rot

all:
	$(FC) $(SRC1) -o $(EXE1)
	$(FC) $(SRC2) -o $(EXE2)

clean:
	rm -f $(EXE1)
	rm -f $(EXE2)
