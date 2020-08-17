
close all
clear all

run('..\add_to_path.m');

%%
csvFile = '..\influenza-surveillance-data\public-health-laboratory-influenza-respiratory-virus-surveillance-data-by-region-and-influenza-season.csv';

[fluDates, fluTotals] = loadFluData(csvFile);

% set last date to use in training set
endDate = datetime(2017, 9, 30); 

%% BREAK OUT TRAINING DATA NEXT
trainingData = fluTotals(fluDates <= endDate);

%% naive fit of data (persistence model)

sesData = singleExponentialSmoother(trainingData, length(fluTotals));

sesRes = sesData - fluTotals;

%% seasonal naive (repeat previous season)

seasonalData = seasonalNaive(trainingData, length(fluTotals));
seasonalRes = seasonalData - fluTotals;

%% dhr() from CAPTAIN toolbox

% format fluData for input into dhr()

% determine which inputs to use and set values

y = [trainingData; nan(53, 1)];
% y: Time series (*)

P = [0 52 16 12 8 4 1 (1/7)]; % yearly, 1-4 months, weekly and daily

% P: Periodic components; set P(1)=0 to include a trend (*)

IRWharm = [1 0]; % 

% TVP: Model type for each TVP (0-RW/AR(1), 1-IRW/SRW, 2-Trigonommetric) (0)   
%        (for LLT use RW and IRW trends simultaneously)

NVR = [0.001 0.01]; % not real clear on what these are yet
% nvr: NVR hyper-parameters (0)

alpha = [0.95 1];
% alpha: alpha parameters; set alpha=1 for RW or IRW model (1)

% leave other model parameters as default to start

P0 = 100; % specifying this value resolves some fitting issues at the start of the time span
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
    = dhr(y,P,IRWharm,NVR,alpha, P0); %,x0,smooth,ALG,Int,IntD,iout,pinv);

%%
dhrRes = fit-fluTotals;

%% comparison of fit errors between dhr and naive model
close all

figure; plot(fluDates, fluTotals,'r'); hold on; 
plot(fluDates, fit, 'b'); grid on;
plot(fluDates, sesData, 'k'); 
plot(fluDates, seasonalData, 'm')
xline(endDate, 'k', 'End of Training Data', 'LineWidth', 2, 'LabelHorizontalAlignment', 'left');
legend('Raw Data', 'DHR', 'Naive', 'Seasonal Naive', 'Location', 'NorthWest')
set(gca, 'FontWeight', 'Bold', 'FontSize', 12);
xlabel('Date'); ylabel('Total Flu Cases in California')


figure; plot(fluDates, dhrRes, 'b');
hold on; plot(fluDates, sesRes, 'r');
plot(fluDates, seasonalRes, 'm');
xl = xline(endDate, 'k', 'End of Training Data', 'LineWidth', 2, 'LabelHorizontalAlignment', 'left');
legend('DHR Residuals', 'Naive Residuals', 'Seasonal Naive', 'Location', 'NorthWest');
grid on; set(gca, 'FontWeight', 'Bold', 'FontSize', 12);
xlabel('Date'); ylabel('Residuals')



% performance during extrapolation
daysPast = datenum(fluDates(fluDates>endDate) - endDate);

figure;
plot(daysPast, dhrRes(fluDates>endDate), 'b'); hold on;
plot(daysPast, sesRes(fluDates>endDate), 'r');
plot(daysPast, seasonalRes(fluDates>endDate), 'm');
legend('DHR Residuals', 'Naive Residuals', 'Location', 'southeast');
grid on; xlim([0 365])
set(gca, 'FontWeight', 'Bold', 'FontSize', 12);
xlabel({'Days Since Start of Extrapolation'; '(1 October 2018)'}); ylabel('Residuals')


%% mean squared error for each model

% during period of training data
naiveMSE = mean((sesRes(fluDates<=endDate)).^2) % 4.4997e+03
% for seasonal, also exclude first year since model doesn't have any results yet
seasonalMSE = mean((seasonalRes(fluDates<=endDate & fluDates>fluDates(52))).^2) % 2.7406e+04
dhrMSE = mean((dhrRes(fluDates<=endDate)).^2) % 1.9546e+03

% MSE just during extrapolation period
naiveMSE_extrap = mean((sesRes(fluDates>endDate)).^2) % 6.4404e+04
seasonalMSE_extrap = mean((seasonalRes(fluDates>endDate)).^2) % 8.4528e+03
dhrMSE_extrap = mean((dhrRes(fluDates>endDate)).^2) % 3.8686e+04

