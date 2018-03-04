%script for visualizing test data
%clear all

%D = importdata('./../DataOUT.dat');
%params = importdata('./../param_file');

%nr            = params.data(1);
%[rows, cols]  = size(D);
%timesteps     = floor(rows/(nr+1));

var           = 6;
grid_zone     = 10;

T             = [];
field         = [];

plot_titles = cell(5);
plot_titles = {'time','velocity','temp','density','pressure'};

for i = 1:timesteps

    Index  = grid_zone + (i-1)*(nr+1);

    T      = [T,D(Index,1)];
    field  = [field,D(Index,var)];

end

plot(T,field,'g');

ylim([0 .1])
title([plot_titles(var),': zone ',num2str(grid_zone)]);
%ylim([0,1e4]);
