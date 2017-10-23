SimDat = 'Testing_new_fing5/UW';

Nx = 1024;
Ny = 64;
Nz = 512;

yslice = 10;
time   = 1000;

addpath('/Users/rmoll/Desktop/utilities');
DataPath = '/Users/rmoll/Desktop/new_data/';
SimPath = strcat(DataPath,SimDat);
cd(SimPath);

[UYav,Uslice] = ReadData(Nx,Ny,Nz,'U',time,yslice);
[WYav,Wslice] = ReadData(Nx,Ny,Nz,'W',time,yslice);

stPtX = 2;
enPtX = Nx-1-2;
numInteriorX = 8;
incrementX = (enPtX - stPtX)/(numInteriorX + 1);

stPtZ = 2;
enPtZ = Nz-1-2;
numInteriorZ = 8;
incrementZ = (enPtZ - stPtZ)/(numInteriorZ + 1);

startx = [];
startz = [];
for xpt = (stPtX:incrementX:enPtX)
    for zpt = (stPtZ:incrementZ:enPtZ)
        startx = [startx,xpt];
        startz = [startz,zpt];
    end
end

figure;
streamline(UYav,WYav,startx,startz)

skipx = 16;
skipz = 16;
Ured = zeros(floor((enPtZ - stPtZ)/skipz),floor((enPtX - stPtX)/skipx));
Wred = zeros(floor((enPtZ - stPtZ)/skipz),floor((enPtX - stPtX)/skipx));

indexx = 1;
indexz = 1;
for xpt = (stPtX:skipx:enPtX)
    for zpt = (stPtZ:skipz:enPtZ)
        Ured(indexz,indexx) = UYav(zpt,xpt);
        Wred(indexz,indexx) = WYav(zpt,xpt);
        indexz = indexz + 1;
    end
    indexz = 1;
    indexx = indexx + 1;
end

xpt = (stPtX:skipx:enPtX);
zpt = (stPtZ:skipz:enPtZ);

figure;
quiver(xpt,zpt,Ured,Wred,1)