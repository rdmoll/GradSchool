SimDat = 'Testing_new_fing5/UW';

Nx = 1024;
Ny = 64;
Nz = 512;

field  = 'U';
yslice = 20;
time   = 100;

GenericField = true;
Density      = false;
FluxCalcT    = false;

PlotDim   = '2D';
PlotDat   = 'Yav';
fieldType = 'NuT';

addpath('/Users/rmoll/Documents/NPS/utilities');
DataPath = '/Users/rmoll/Documents/NPS/data/';
SimPath = strcat(DataPath,SimDat);
cd(SimPath);

if(GenericField)
    field_generic(Nx,Ny,Nz,field,time,yslice,PlotDim,PlotDat);
end

if(Density)
    field_density(Nx,Ny,Nz,time,yslice,PlotDim,PlotDat);
end