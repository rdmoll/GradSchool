function [success] = field_density(Nx,Ny,Nz,time,yslice,PlotDim,PlotDat)

    alpha = 2.0E-4;
    beta = 7.5E-4;
    plottitle = strcat('Density, ts=',num2str(time));

    [TYav,Tslice] = ReadData(Nx,Ny,Nz,'T',time,yslice);
    [SYav,Sslice] = ReadData(Nx,Ny,Nz,'S',time,yslice);
    VarYav = beta*SYav - alpha*TYav;
    Varslice = beta*Sslice - alpha*Tslice;

    if(strcmp(PlotDim,'2D'))
        figure;
        if(strcmp(PlotDat,'Yav'))
            plotdat = VarYav(:,1:(Nx-1));
        end
        if(strcmp(PlotDat,'slice'))
            plotdat = Varslice(:,1:(Nx-1));
        end
        if(strcmp(PlotDat,'diff'))
            plotdat = Varslice(:,1:(Nx-1)) - VarYav(:,1:(Nx-1));
        end
        
        [cv,ch] = contourf(plotdat(25:end,1:(Nx-1)),50);
        set(ch,'edgecolor','none')
        colorbar;
        title(plottitle)
        success = 1;
    end

    if(strcmp(PlotDim,'1D'))
        figure;
        plotdat1D = squeeze(mean(VarYav(:,145:155),2));
        plot(plotdat1D(16:end),'r');
        title(plottitle)
        success = 1;
    end
    
    if(strcmp(PlotDim,'mult'))
        plotdat1D = squeeze(mean(VarYav,2));
        success = plotdat1D;
    end
    
end