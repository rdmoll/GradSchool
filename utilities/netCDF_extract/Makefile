CPP = g++
FLAGS = -std=c++11
LIB = -L/opt/local/lib
INC = -I/opt/local/include
ADDLIB = -lnetcdf -lnetcdff
EXE = netCDF_extract_cpp
SRC = ReadNetCDF.cpp main.cpp

all:
	$(CPP) $(FLAGS) $(LIB) $(INC) $(SRC) $(ADDLIB) -o $(EXE)

clean:
	rm -f $(EXE)
