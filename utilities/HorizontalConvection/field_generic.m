function [success] = field_generic(Nx,Ny,Nz,field,time,yslice,PlotDim,PlotDat)

    [VarYav,Varslice] = ReadData(Nx,Ny,Nz,field,time,yslice);        
    
    figure;
    if(strcmp(PlotDim,'2D'))
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
        %[cv,ch] = contourf(plotdat(1:end,1:(Nx-1)),50);
        set(ch,'edgecolor','none')
        colorbar;
        
    end

    if(strcmp(PlotDim,'1D'))
        plotdat1D = squeeze(mean(VarYav(395:405,:),1));
        plot(plotdat1D(1:end),'r');
    end
    plottitle = strcat(field,' , ts=',num2str(time));
    title(plottitle)
    
    success = 1;
end