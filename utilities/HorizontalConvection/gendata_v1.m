clear all;

ieee = 'b';
prec = 'real*8';

noiseFac = 1e-4;

nx = 1024;
ny = 64;
nz = 512;

dx = 0.001;
dy = 0.001;
dz = 0.001;

Lx = nx*dx;
Ly = ny*dy;
Lz = nz*dz;

alpha = 2.0E-4;
beta  = 7.5E-4;
Rrho  = 0.5;

Ttc = 15.0;
Tb  = 10.0;
Sb  = 34.1;
dTx = 0.125;

deltaMid = 128;
deltaSide = 24;
Tt = zeros(1,nx);
St = zeros(1,nx);
for ii = 1:nx
    Tt(ii) = dTx*tanh((ii-nx/2)/deltaMid) + Ttc;
    St(ii) = Rrho*(alpha/beta)*(Tt(ii) - Tb) + Sb;
end
for ii = 1:nx
    Tt(ii) = (dTx*tanh((ii-nx/2)/deltaMid) + Ttc) + 0.5*(Ttc-dTx-Tb)*(tanh((ii-64)/deltaSide) - 1);
    St(ii) = Rrho*(alpha/beta)*(Tt(ii) - Tb) + Sb;
end

T = zeros(nx,ny,nz);
S = zeros(nx,ny,nz);
for ii = 1:nx
    dTdz = (Tt(ii) - Tb)/(1.0*(nz-1));
    dSdz = (St(ii) - Sb)/(1.0*(nz-1));
    for jj = 1:ny
        for kk = 1:nz
            T(ii,jj,kk) = dTdz*(nz-kk) + Tb + noiseFac*(2*rand-1.0);
            S(ii,jj,kk) = dSdz*(nz-kk) + Sb + noiseFac*(2*rand-1.0);
        end
    end
end

figure;
[cv,ch] = contourf(squeeze(S(:,1,:)),50,'EdgeColor','none');
set(ch,'edgecolor','none')
colorbar;

fid=fopen('T.bin','w',ieee); fwrite(fid,T,prec); fwrite(fid,T,prec); fclose(fid);
fid=fopen('S.bin','w',ieee); fwrite(fid,S,prec); fwrite(fid,S,prec); fclose(fid);

clear T S;

M = zeros(nx,ny,nz);
C_top  = 1.0e-3;
C_bot  = 1.0e-3;
C_side = 1.0e-3;
deltaMTop = 24.0;
deltaMBot = 24.0;
deltaMSide = 64.0;
for ii = 1:nx
    for jj = 1:ny
        for kk = 1:nz
            %M(ii,jj,kk) = min(C_top*exp(-(kk-1)/24.0) + C_bot*exp((kk-nz)/24.0) + C_side*(exp(-(ii-1)/64.0)),1);
            M(ii,jj,kk) = min(C_top*exp(-(kk-1)/24.0) + C_bot*exp((kk-nz)/24.0),1);
        end
    end
end

fid=fopen('rbcs_mask.bin','w',ieee); fwrite(fid,M,prec); fclose(fid);

clear M;

A = 0.0;
UR = zeros(nx,ny,nz);
UL = zeros(nx,ny,nz);
for ii = 1:nx
    for jj = 1:ny
        for kk = (nz-36):nz
            UR(ii,jj,kk) = A;
            UL(ii,jj,kk) = A;
        end
    end
end

fid=fopen('U.bin','w',ieee); fwrite(fid,UR,prec); fwrite(fid,UL,prec); fclose(fid);

clear UR UL;

M_vel = zeros(nx,ny,nz);
A  = 1.0;
mu = 64.0;
sigma = 7.5;
for ii = 1:nx
    for jj = 1:ny
        for kk = 1:nz
            M_vel(ii,jj,kk) = (1-(exp(-(ii-1)/64.0)+exp((ii-1024)/64.0)))*A*exp(-((kk-mu).^2)./(2*sigma^2));
            %M_vel(ii,jj,kk) = (1-(exp(-(kk-1)/64.0)+exp((kk-512)/64.0)))*A*exp(-((ii-mu).^2)./(2*sigma^2));
        end
    end
end

fid=fopen('rbcs_vel.bin','w',ieee); fwrite(fid,M_vel,prec); fclose(fid);

%figure;
%[cv,ch] = contourf(squeeze(M_vel(:,1,:)),50,'EdgeColor','none');
%set(ch,'edgecolor','none')
%colorbar;

clear M_vel;

topogMult = 1.5*Lz;
avgNum = 8;
wtFac = 0.25;
RndTopogInit = topogMult*(2*rand(nx+2*avgNum,ny+2*avgNum)-1.0);
RndTopog = zeros(nx,ny);

for jj = (avgNum+1):(avgNum+ny)
    for ii = (avgNum+1):(avgNum+nx)
        smoothSum = 0;
        count = 0;
        for nn = -avgNum:avgNum
            for mm = -avgNum:avgNum
                xindex = ii-mm;
                yindex = jj-nn;
                smoothSum = smoothSum + RndTopogInit(xindex,yindex)/((wtFac*nn*nn+wtFac*mm*mm+1)*1.0);
                count = count + 1;
            end
        end
        RndTopog(ii-avgNum,jj-avgNum) = smoothSum/count;
    end
end

h = RndTopog - Lz*ones(nx,ny);
% walls bounding x-direction
h(end,:) = 0;
% walls bounding y-direction
h(:,end) = 0;

fid=fopen('topog.bin','w',ieee); fwrite(fid,h,prec); fclose(fid);

clear h;