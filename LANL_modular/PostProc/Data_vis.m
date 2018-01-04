%script for visualizing test data
%clear all

%D = importdata('./../1D_ICF/DataOUT.dat');
%params = importdata('./../1D_ICF/param_file');

%nr = params.data(1);
%[rows, cols] = size(D);
%timesteps = floor(rows/(nr+1)); 

tStart = D(1,1)
tEnd = D(1 + (timesteps - 1)*(nr+1),1)

viewStart = 1;
for i = 1:timesteps
    if (D(1 + (i-1)*(nr+1),1) > -1)
        viewStart = i;
        break;
    end
end

var = 7;

figure, set(gcf, 'Color','white');
set(gca, 'nextplot','replacechildren','Visible','off');

%vidObj = VideoWriter('DensityMovie.avi');
%vidObj.Quality = 100;
%vidObj.FrameRate = 100;
%open(vidObj);

for i = 1:timesteps
    
    I_begin = 1 + (i-1)*(nr+1);
    I_end = (nr+1) + (i-1)*(nr+1);
    str = num2str(D(I_begin,1));
    
    hold off
    plot(D(I_begin:I_end,2),D(I_begin:I_end,var),'g');
    hold on
    %plot(D((I_begin+376),2),D(I_begin+376,var),'r*');
    hold on
    %plot(D((I_begin+375),2),D(I_begin+375,var),'r*');
    hold on
    %plot(D((I_begin+384),2),D(I_begin+384,var),'r*');
    hold on
    %plot(D((I_begin+383),2),D(I_begin+383,var),'r*');
    hold on
    
    title(['t = ',str]);
    ylim([-.1,1.1]);
    xlim([0e-4,5e-4]);
    
    %writeVideo(vidObj, getframe(gca));
    
    pause;
    
end
%close(gcf)
%close(vidObj);
