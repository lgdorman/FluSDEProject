
close all
clear all

run('..\add_to_path.m');

%%
csvFile = '..\influenza-surveillance-data\public-health-laboratory-influenza-respiratory-virus-surveillance-data-by-region-and-influenza-season.csv';

[fluDates, fluTotals] = loadFluData(csvFile);

%% naive fit of data (persistence model)

sesData = singleExponentialSmoother(fluTotals);

sesRes = sesData - fluTotals; % is this the right order?

%% dhr() from CAPTAIN toolbox

% format fluData for input into dhr()

% determine which inputs to use and set values

y = fluTotals;
% y: Time series (*)

P = [0 12./(1:6)]; % need to figure this part out, start with an example
% P: Periodic components; set P(1)=0 to include a trend (*)

IRWharm = [1 0]; % use both model types , 

% TVP: Model type for each TVP (0-RW/AR(1), 1-IRW/SRW, 2-Trigonommetric) (0)   
%        (for LLT use RW and IRW trends simultaneously)

NVR = [0.001 0.01]; % not real clear on what these are yet
% nvr: NVR hyper-parameters (0)

alpha = [0.95 1];
% alpha: alpha parameters; set alpha=1 for RW or IRW model (1)

% leave other model parameters as default to start

% P0: Initial P matrix (1e6)
% x0: Initial state vector (0)
% sm: Smoothing on (1-default) or off (0-saves memory)
% ALG: Smoothing algorithm: P (0) or Q (1-default)
% Int: Vector of variance intervention points (zeros(length(y),1))
% IntD: Variance intervention matrix diagonal (1e2 for trend level)
% iout: (integer) intermediate results on (1) or off (0-default)
% pinv: Pseudoinverse on (1) or off (0-default)


%% call dhr routine
[fit,fitse,tr,trse,comp,e,amp,phs,ts,tsse,y0,dhrse,Xhat,Phat,ers,ykk1]...
    = dhr(y,P,IRWharm,NVR,alpha); %,P0,x0,smooth,ALG,Int,IntD,iout,pinv);

%% comparison of fit errors between dhr and naive model