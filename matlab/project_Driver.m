
close all
clear all

run('..\add_to_path.m');

%%
csvFile = '..\influenza-surveillance-data\public-health-laboratory-influenza-respiratory-virus-surveillance-data-by-region-and-influenza-season.csv';

fluData = loadFluData(csvFile);

%% naive fit of data (persistence model)


%% dhr() from CAPTAIN toolbox

% format fluData for input into dhr()

% determine which inputs to use and set values



%% call dhr routine
[fit,fitse,tr,trse,comp,e,amp,phs,ts,tsse,y0,dhrse,Xhat,Phat,ers,ykk1]...
    = dhr(y,P,IRWharm,NVR,alpha,P0,x0,smooth,ALG,Int,IntD,iout,pinv);

%% comparison of fit errors between dhr and naive model