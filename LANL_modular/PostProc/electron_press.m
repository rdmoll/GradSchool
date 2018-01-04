%script for visualizing test data
clear all

withElec = importdata('./../1D_ICF/electron_pressure/DataOUT_withElec.dat');
noElec   = importdata('./../1D_ICF/electron_pressure/DataOUT_noElec.dat');
params   = importdata('./../1D_ICF/param_file');

nr = params.data(1);
[rows, cols] = size(noElec);
timesteps = floor(rows/(nr+1)); 

time  = .1e-10;
flag1 = 0;
flag2 = 0;

for j = 1:50

for i = 1:timesteps
    
    I_begin = 1 + (i-1)*(nr+1);
    I_end = (nr+1) + (i-1)*(nr+1);
   
    if ((withElec(I_begin,1) > time) && (flag1 == 0))
        t_with = withElec(I_begin,1);
        r_with = withElec(I_begin:I_end,2);
        P_with = withElec(I_begin:I_end,6);
        flag1 = 1;
    end 
    
    if ((noElec(I_begin,1) > time) && (flag2 == 0))
        t_no = noElec(I_begin,1);
        r_no = noElec(I_begin:I_end,2);
        P_no = noElec(I_begin:I_end,6);
        flag2 = 1;
    end 
    
    if ((flag1 == 1) && (flag2 == 1))
        break;
    end
    
end

flag1 = 0;
flag2 = 0;

t_with
t_no

hold off
plot(r_with,P_with,'g');
hold on
plot(r_no,P_no,'r');
    
ylim([0,1e13]);
xlim([0,5e-4]);

time = time + (.1e-10);

pause;

end