FC = gfortran
SRC = DensGrad.f90
MOD = DensGrad_mod.f90
EXE = DensGrad

all:
	$(FC) $(MOD) $(SRC) -o $(EXE)

clean:
	rm -f $(EXE)
	rm -f *.mod
	rm -f *.o
