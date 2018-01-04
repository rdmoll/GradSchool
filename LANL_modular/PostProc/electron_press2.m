%script for visualizing test data
%clear all

%withElec = importdata('./../1D_ICF/electron_pressure/DataOUT_withElec.dat');
%noElec   = importdata('./../1D_ICF/electron_pressure/DataOUT_noElec.dat');
%params   = importdata('./../1D_ICF/param_file');

%nr = params.data(1);
%[rows, cols] = size(noElec);
%timesteps = floor(rows/(nr+1));

t_with    = [];
t_no      = [];
data_with = [];
data_no   = [];
for i = 1:timesteps
    
    I_begin = 1 + (i-1)*(nr+1);
    I_end = (nr+1) + (i-1)*(nr+1);
    
    if ( (noElec((I_begin + 5),7) == 1) &&  (withElec((I_begin + 5),7) == 1))
        break;
    end
    
    for j = 6:nr-4
        if ( (noElec((I_begin + j + 4),6) > 100000*noElec(1,6)) && (noElec((I_begin + (j - 5)),6) < 1.001*noElec(1,6)) )
            t_no = [t_no,noElec(I_begin,1)];
            pressDiff = (noElec((I_begin + j + 4),6) - noElec((I_begin + (j - 5)),6))/noElec((I_begin + (j - 5)),6);
            data_no = [data_no,pressDiff];
        end
        if ( (withElec((I_begin + (j - 1)),7) == 0) && (withElec((I_begin + j),7) == 1) && (withElec((I_begin + 5),7) == 0) )
            t_with = [t_with,withElec(I_begin,1)];
            pressDiff = (withElec((I_begin + j + 2),6) - withElec((I_begin + (j - 4)),6))/withElec((I_begin + (j - 4)),6);
            data_with = [data_with,pressDiff];
        end
    end
    
end

hold off
semilogy(t_with,data_with,'g');
hold on
semilogy(t_no,data_no,'r');
hold on
   
    