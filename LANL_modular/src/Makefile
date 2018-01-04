# Makefile for 1D ICF code
FC = gfortran
SRCS = solver_routines_mod.f90 exp_params_mod.f90 phys_const_mod.f90 prec_param_mod.f90 OneD_ICF.f90
OBJS = solver_routines_mod.o exp_params_mod.o phys_const_mod.o prec_param_mod.o OneD_ICF.o
FLAGS = -ffree-line-length-none
EXE = ../OneD_ICF

all:
	$(FC) $(FLAGS) -c prec_param_mod.f90
	$(FC) $(FLAGS) -c exp_params_mod.f90
	$(FC) $(FLAGS) -c phys_const_mod.f90
	$(FC) $(FLAGS) -c solver_routines_mod.f90
	$(FC) $(FLAGS) -c OneD_ICF.f90
	$(FC) $(FLAGS) -o $(EXE) $(OBJS)

clean:
	rm -f $(EXE)
	rm -f *.mod
	rm -f *.o
