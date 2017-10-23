function [datYav,datSlice] = ReadData(Nx,Ny,Nz,field,time,yslice)

    Varraw = rdmds(field,time);
    if (yslice > 1)
        Var = Varraw(1:(Nx-1),1:(Ny-1),2:Nz);
    else
        Var = Varraw(1:(Nx-1),:,2:Nz);
    end

    Varslice = squeeze(Var(:,yslice,:));
    Varslice = fliplr(Varslice);
    datSlice = Varslice';

    VarYav = squeeze(mean(Var,2));
    VarYav = fliplr(VarYav);
    datYav = VarYav';

end